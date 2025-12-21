<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\UserMatch;
use App\Models\User;
use Illuminate\Http\Request;

class MatchController extends Controller
{
    public function getMatches(Request $request)
    {
        $user = $request->user();

        $matches = UserMatch::where('user_id', $user->id)
            ->with(['matchedUser.profile', 'matchedUser.photos' => function ($q) {
                $q->orderBy('order')->limit(1);
            }])
            ->orderBy('created_at', 'desc')
            ->get();

        $matchesData = $matches->map(function ($match) {
            return [
                'match_id' => $match->id,
                'user_id' => $match->matched_user_id,
                'name' => $match->matchedUser->profile->first_name ?? '',
                'age' => $match->matchedUser->profile->age ?? null,
                'photo' => $match->matchedUser->photos->first()->photo_url ?? null,
                'city' => $match->matchedUser->profile->city ?? null,
                'matched_at' => $match->created_at->diffForHumans(),
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $matchesData,
        ]);
    }

    public function getLikedUsers(Request $request)
    {
        $user = $request->user();

        // Get users who liked current user but not matched yet
        $likedByUsers = User::whereHas('swipesGiven', function ($q) use ($user) {
            $q->where('target_user_id', $user->id)
              ->whereIn('type', ['like', 'super_like']);
        })
        ->whereDoesntHave('matches', function ($q) use ($user) {
            $q->where('matched_user_id', $user->id);
        })
        ->with(['profile', 'photos' => function ($q) {
            $q->orderBy('order')->limit(1);
        }])
        ->get();

        $likedData = $likedByUsers->map(function ($likedUser) {
            return [
                'user_id' => $likedUser->id,
                'name' => $likedUser->profile->first_name ?? '',
                'age' => $likedUser->profile->age ?? null,
                'photo' => $likedUser->photos->first()->photo_url ?? null,
                'bio' => $likedUser->profile->bio ?? '',
                'occupation' => $likedUser->profile->occupation ?? '',
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $likedData,
        ]);
    }

    public function getMatchDetail(Request $request, $userId)
    {
        $user = $request->user();

        // Check if matched
        $match = UserMatch::where('user_id', $user->id)
            ->where('matched_user_id', $userId)
            ->first();

        if (!$match) {
            return response()->json([
                'success' => false,
                'message' => 'Not matched with this user',
            ], 404);
        }

        $matchedUser = User::with(['profile', 'photos' => function ($q) {
            $q->orderBy('order');
        }, 'interests'])
        ->find($userId);

        $distance = null;
        if ($user->profile->latitude && $user->profile->longitude &&
            $matchedUser->profile->latitude && $matchedUser->profile->longitude) {
            
            $distance = $this->calculateDistance(
                $user->profile->latitude,
                $user->profile->longitude,
                $matchedUser->profile->latitude,
                $matchedUser->profile->longitude
            );
        }

        return response()->json([
            'success' => true,
            'data' => [
                'user_id' => $matchedUser->id,
                'profile' => $matchedUser->profile,
                'photos' => $matchedUser->photos,
                'interests' => $matchedUser->interests,
                'distance' => $distance ? round($distance, 1) . ' km' : null,
                'matched_at' => $match->created_at->diffForHumans(),
            ],
        ]);
    }

    private function calculateDistance($lat1, $lon1, $lat2, $lon2)
    {
        $earthRadius = 6371;

        $dLat = deg2rad($lat2 - $lat1);
        $dLon = deg2rad($lon2 - $lon1);

        $a = sin($dLat / 2) * sin($dLat / 2) +
             cos(deg2rad($lat1)) * cos(deg2rad($lat2)) *
             sin($dLon / 2) * sin($dLon / 2);

        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        return $earthRadius * $c;
    }
}
