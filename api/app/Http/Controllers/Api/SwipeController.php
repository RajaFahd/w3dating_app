<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Swipe;
use App\Models\UserMatch;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SwipeController extends Controller
{
    public function getProfiles(Request $request)
    {
        $user = $request->user();
        $profile = $user->profile;
        $filter = $user->filter;

        if (!$profile || !$filter) {
            return response()->json([
                'success' => false,
                'message' => 'Profile or filter not found',
            ], 404);
        }

        // Get user IDs yang sudah di-swipe (ALL types - exclude semua yang sudah pernah di-swipe)
        $swipedUserIds = Swipe::where('user_id', $user->id)
            ->pluck('target_user_id')
            ->toArray();

        $swipedUserIds[] = $user->id; // Exclude current user

        // Get preferred genders
        $preferredGenders = [];
        if ($filter->show_men) $preferredGenders[] = 'Men';
        if ($filter->show_women) $preferredGenders[] = 'Women';
        if ($filter->show_nonbinary) $preferredGenders[] = 'Other';

        // Get other genders (not preferred)
        $allGenders = ['Men', 'Women', 'Other'];
        $otherGenders = array_diff($allGenders, $preferredGenders);

        // Level 1: Try with preferred gender filter
        $query = $this->buildProfileQuery($swipedUserIds, $preferredGenders, $filter, $profile);
        $candidates = $query->limit(20)->get();

        // Level 2: If no candidates, try OTHER genders (yang tidak diminati)
        if ($candidates->isEmpty() && !empty($otherGenders)) {
            $query = $this->buildProfileQuery($swipedUserIds, array_values($otherGenders), $filter, $profile);
            $candidates = $query->limit(20)->get();
        }

        // Level 3: If still no candidates, show profiles user has liked
        if ($candidates->isEmpty()) {
            $likedUserIds = Swipe::where('user_id', $user->id)
                ->whereIn('type', ['like', 'super_like'])
                ->pluck('target_user_id')
                ->toArray();

            if (!empty($likedUserIds)) {
                $candidates = User::whereIn('id', $likedUserIds)
                    ->where('id', '!=', $user->id)
                    ->with(['profile', 'photos' => function ($q) {
                        $q->orderBy('order');
                    }, 'interests'])
                    ->limit(20)
                    ->get();
            }
        }

        // Add distance to each profile
        $result = $candidates->map(function ($candidate) use ($profile) {
            $distance = null;
            if ($profile->latitude && $profile->longitude && 
                $candidate->profile->latitude && $candidate->profile->longitude) {
                
                $distance = $this->calculateDistance(
                    $profile->latitude,
                    $profile->longitude,
                    $candidate->profile->latitude,
                    $candidate->profile->longitude
                );
            }

            return [
                'id' => $candidate->id,
                'profile' => $candidate->profile,
                'photos' => $candidate->photos,
                'interests' => $candidate->interests,
                'distance' => $distance ? round($distance, 1) . ' km' : null,
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $result,
        ]);
    }

    private function buildProfileQuery($excludeUserIds, $genders, $filter, $profile)
    {
        return User::whereNotIn('id', $excludeUserIds)
            ->whereHas('profile', function ($q) use ($filter, $profile, $genders) {
                // Filter by gender
                if (!empty($genders)) {
                    $q->whereIn('gender', $genders);
                }

                // Filter by age
                $q->whereRaw('YEAR(CURDATE()) - YEAR(birth_date) >= ?', [$filter->age_min])
                  ->whereRaw('YEAR(CURDATE()) - YEAR(birth_date) <= ?', [$filter->age_max]);

                // Filter by distance (if user has location)
                if ($profile->latitude && $profile->longitude && $filter->distance_max) {
                    $lat = $profile->latitude;
                    $lng = $profile->longitude;
                    $distance = $filter->distance_max;

                    $q->whereRaw("
                        (6371 * acos(cos(radians(?)) * cos(radians(latitude)) * 
                        cos(radians(longitude) - radians(?)) + 
                        sin(radians(?)) * sin(radians(latitude)))) <= ?
                    ", [$lat, $lng, $lat, $distance]);
                }
            })
            ->with(['profile', 'photos' => function ($q) {
                $q->orderBy('order');
            }, 'interests']);
    }

    public function swipe(Request $request)
    {
        $request->validate([
            'target_user_id' => 'required|exists:users,id',
            'type' => 'required|in:like,dislike,super_like',
        ]);

        $user = $request->user();

        // Check if already swiped
        $existingSwipe = Swipe::where('user_id', $user->id)
            ->where('target_user_id', $request->target_user_id)
            ->first();

        if ($existingSwipe) {
            return response()->json([
                'success' => false,
                'message' => 'Already swiped on this user',
            ], 400);
        }

        // Create swipe
        $swipe = Swipe::create([
            'user_id' => $user->id,
            'target_user_id' => $request->target_user_id,
            'type' => $request->type,
        ]);

        $isMatch = false;
        $matchData = null;

        // Check for match (handled in Swipe model booted method)
        if ($request->type === 'like' || $request->type === 'super_like') {
            $match = UserMatch::where('user_id', $user->id)
                ->where('matched_user_id', $request->target_user_id)
                ->first();

            if ($match) {
                $isMatch = true;
                $matchedUser = User::with(['profile', 'photos'])->find($request->target_user_id);
                $matchData = $matchedUser;
            }
        }

        return response()->json([
            'success' => true,
            'message' => 'Swipe recorded successfully',
            'is_match' => $isMatch,
            'match_data' => $matchData,
        ]);
    }

    private function calculateDistance($lat1, $lon1, $lat2, $lon2)
    {
        $earthRadius = 6371; // km

        $dLat = deg2rad($lat2 - $lat1);
        $dLon = deg2rad($lon2 - $lon1);

        $a = sin($dLat / 2) * sin($dLat / 2) +
             cos(deg2rad($lat1)) * cos(deg2rad($lat2)) *
             sin($dLon / 2) * sin($dLon / 2);

        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        return $earthRadius * $c;
    }

    public function getMyLikes(Request $request)
    {
        $user = $request->user();

        // Get all users that current user has liked
        $likedSwipes = Swipe::where('user_id', $user->id)
            ->whereIn('type', ['like', 'super_like'])
            ->pluck('target_user_id')
            ->toArray();

        if (empty($likedSwipes)) {
            return response()->json([
                'success' => true,
                'data' => [],
            ]);
        }

        // Get profiles of liked users
        $likedUsers = User::whereIn('id', $likedSwipes)
            ->with(['profile', 'photos' => function ($q) {
                $q->orderBy('order');
            }, 'interests'])
            ->get();

        $profiles = $likedUsers->map(function ($likedUser) use ($user) {
            $distance = null;
            if ($user->profile && $user->profile->latitude && $user->profile->longitude && 
                $likedUser->profile && $likedUser->profile->latitude && $likedUser->profile->longitude) {
                
                $distance = $this->calculateDistance(
                    $user->profile->latitude,
                    $user->profile->longitude,
                    $likedUser->profile->latitude,
                    $likedUser->profile->longitude
                );
            }

            return [
                'id' => $likedUser->id,
                'profile' => $likedUser->profile,
                'photos' => $likedUser->photos,
                'interests' => $likedUser->interests,
                'distance' => $distance ? round($distance, 1) . ' km' : null,
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $profiles,
        ]);
    }

    public function resetSwipes(Request $request)
    {
        $user = $request->user();

        // Delete only dislike swipes (keep likes for wishlist)
        Swipe::where('user_id', $user->id)
            ->where('type', 'dislike')
            ->delete();

        return response()->json([
            'success' => true,
            'message' => 'Swipes reset successfully (likes preserved)',
        ]);
    }

    public function unlikeUser(Request $request)
    {
        $request->validate([
            'target_user_id' => 'required|exists:users,id',
        ]);

        $user = $request->user();
        $targetUserId = $request->input('target_user_id') ?? $request->query('target_user_id');

        // Delete the like/super_like swipe record
        $deleted = Swipe::where('user_id', $user->id)
            ->where('target_user_id', $targetUserId)
            ->whereIn('type', ['like', 'super_like'])
            ->delete();

        if ($deleted === 0) {
            return response()->json([
                'success' => false,
                'message' => 'Like not found or already removed',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'User removed from your likes',
        ]);
    }
}
