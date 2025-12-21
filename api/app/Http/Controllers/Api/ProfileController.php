<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\UserProfile;
use App\Models\UserPhoto;
use App\Models\UserFilter;
use App\Models\Interest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ProfileController extends Controller
{
    public function createProfile(Request $request)
    {
        $request->validate([
            'first_name' => 'required|string|max:100',
            'birth_date' => 'required|date|before:today',
            'gender' => 'required|in:Men,Women,Other',
            'sexual_orientation' => 'required|string|max:50',
            'interested_in' => 'required|array',
            'looking_for' => 'required|string',
            'bio' => 'nullable|string',
            'interest' => 'nullable|array',
            'language' => 'nullable|string|max:50',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'city' => 'nullable|string|max:100',
        ]);

        $user = $request->user();

        $profile = UserProfile::updateOrCreate(
            ['user_id' => $user->id],
            $request->only([
                'first_name', 'birth_date', 'gender', 'sexual_orientation',
                'interested_in', 'looking_for', 'bio', 'interest',
                'language', 'latitude', 'longitude', 'city'
            ])
        );

        $profile->calculateProfileCompletion();

        // Create default filter
        UserFilter::firstOrCreate(
            ['user_id' => $user->id],
            [
                'show_men' => in_array('Men', $request->interested_in ?? []),
                'show_women' => in_array('Women', $request->interested_in ?? []),
                'show_nonbinary' => in_array('Other', $request->interested_in ?? []),
                'age_min' => 18,
                'age_max' => 50,
                'distance_max' => 50,
            ]
        );

        return response()->json([
            'success' => true,
            'message' => 'Profile created successfully',
            'data' => $profile,
        ]);
    }

    public function updateProfile(Request $request)
    {
        $request->validate([
            'first_name' => 'sometimes|string|max:100',
            'birth_date' => 'sometimes|date|before:today',
            'gender' => 'sometimes|in:Men,Women,Other',
            'sexual_orientation' => 'sometimes|string|max:50',
            'interested_in' => 'sometimes|array',
            'looking_for' => 'sometimes|string',
            'bio' => 'nullable|string',
            'interest' => 'nullable|array',
            'language' => 'sometimes|string|max:50',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'city' => 'nullable|string|max:100',
        ]);

        $user = $request->user();
        $profile = $user->profile;

        if (!$profile) {
            return response()->json([
                'success' => false,
                'message' => 'Profile not found',
            ], 404);
        }

        $profile->update($request->only([
            'first_name', 'birth_date', 'gender', 'sexual_orientation',
            'interested_in', 'looking_for', 'bio', 'interest',
            'language', 'latitude', 'longitude', 'city'
        ]));

        $profile->calculateProfileCompletion();

        return response()->json([
            'success' => true,
            'message' => 'Profile updated successfully',
            'data' => $profile,
        ]);
    }

    public function uploadPhotos(Request $request)
    {
        $request->validate([
            'photos' => 'required|array|max:6',
            'photos.*' => 'required|image|mimes:jpeg,png,jpg|max:5120',
        ]);

        $user = $request->user();
        $uploadedPhotos = [];

        foreach ($request->file('photos') as $index => $photo) {
            $path = $photo->store('profiles', 'public');
            
            $userPhoto = UserPhoto::create([
                'user_id' => $user->id,
                'photo_url' => Storage::url($path),
                'order' => $index + 1,
                'is_primary' => $index === 0,
            ]);

            $uploadedPhotos[] = $userPhoto;
        }

        if ($user->profile) {
            $user->profile->calculateProfileCompletion();
        }

        return response()->json([
            'success' => true,
            'message' => 'Photos uploaded successfully',
            'data' => $uploadedPhotos,
        ]);
    }

    public function deletePhoto(Request $request, $photoId)
    {
        $user = $request->user();
        $photo = UserPhoto::where('id', $photoId)
            ->where('user_id', $user->id)
            ->first();

        if (!$photo) {
            return response()->json([
                'success' => false,
                'message' => 'Photo not found',
            ], 404);
        }

        // Delete file from storage
        $photoPath = str_replace('/storage', 'public', $photo->photo_url);
        Storage::delete($photoPath);

        $photo->delete();

        if ($user->profile) {
            $user->profile->calculateProfileCompletion();
        }

        return response()->json([
            'success' => true,
            'message' => 'Photo deleted successfully',
        ]);
    }

    public function updateInterests(Request $request)
    {
        $request->validate([
            'interest_ids' => 'required|array|max:10',
            'interest_ids.*' => 'required|exists:interests,id',
        ]);

        $user = $request->user();
        $user->interests()->sync($request->interest_ids);

        if ($user->profile) {
            $user->profile->calculateProfileCompletion();
        }

        return response()->json([
            'success' => true,
            'message' => 'Interests updated successfully',
            'data' => $user->interests,
        ]);
    }

    public function getInterests()
    {
        $interests = Interest::all();

        return response()->json([
            'success' => true,
            'data' => $interests,
        ]);
    }

    public function getMyProfile(Request $request)
    {
        $user = $request->user();
        $profile = $user->profile;
        $photos = $user->photos()->orderBy('order')->get();
        $interests = $user->interests;

        if (!$profile) {
            return response()->json([
                'success' => false,
                'message' => 'Profile not found',
            ], 404);
        }

        // Calculate age
        $age = null;
        if ($profile->birth_date) {
            $birthDate = new \DateTime($profile->birth_date);
            $today = new \DateTime();
            $age = $today->diff($birthDate)->y;
        }

        return response()->json([
            'success' => true,
            'data' => [
                'id' => $user->id,
                'phone_number' => $user->phone_number,
                'profile' => $profile,
                'age' => $age,
                'photos' => $photos,
                'interests' => $interests,
                'profile_completion' => $profile->profile_completion ?? 0,
            ],
        ]);
    }
}
