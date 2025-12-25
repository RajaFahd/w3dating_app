<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\UserProfile;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validated = $request->validate([
            'phone_number' => 'required|string|max:20',
            'country_code' => 'required|string|max:5',
            'password' => 'required|string|min:6|confirmed',
        ]);

        // Check if user with this phone_number + country_code combination already exists
        $exists = User::where('phone_number', $validated['phone_number'])
            ->where('country_code', $validated['country_code'])
            ->exists();

        if ($exists) {
            return response()->json([
                'success' => false,
                'message' => 'Phone number already registered',
                'errors' => ['phone_number' => ['This phone number is already registered for this country']],
            ], 422);
        }

        $user = User::create([
            'phone_number' => $validated['phone_number'],
            'country_code' => $validated['country_code'],
            'password' => Hash::make($validated['password']),
            'is_active' => true,
            'last_active_at' => now(),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Registration successful',
            'token' => $token,
            'user' => $user,
            'has_profile' => $user->profile !== null,
        ], 201);
    }

    public function login(Request $request)
    {
        $validated = $request->validate([
            'phone_number' => 'required|string|max:20',
            'country_code' => 'required|string|max:5',
            'password' => 'required|string',
        ]);

        $user = User::where('phone_number', $validated['phone_number'])
            ->where('country_code', $validated['country_code'])
            ->first();

        if (!$user || !Hash::check($validated['password'], $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid phone number, country code, or password',
            ], 401);
        }

        $user->update([
            'last_active_at' => now(),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login successful',
            'token' => $token,
            'user' => $user,
            'has_profile' => $user->profile !== null,
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logged out successfully',
        ]);
    }

    public function me(Request $request)
    {
        $user = $request->user()->load(['profile', 'photos', 'interests', 'filter', 'subscription']);

        return response()->json([
            'success' => true,
            'data' => $user,
        ]);
    }
}
