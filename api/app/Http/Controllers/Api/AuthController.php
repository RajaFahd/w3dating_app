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
    public function sendOTP(Request $request)
    {
        $request->validate([
            'phone_number' => 'required|string|max:20',
            'country_code' => 'required|string|max:5',
        ]);

        $otpCode = str_pad(rand(0, 999999), 6, '0', STR_PAD_LEFT);

        $user = User::updateOrCreate(
            [
                'phone_number' => $request->phone_number,
                'country_code' => $request->country_code,
            ],
            [
                'otp_code' => $otpCode,
            ]
        );

        // TODO: Implement actual SMS sending via Twilio, Nexmo, etc.
        // For now, return OTP in response (ONLY FOR DEVELOPMENT)
        
        return response()->json([
            'success' => true,
            'message' => 'OTP sent successfully',
            'otp' => $otpCode, // Remove in production
        ]);
    }

    public function verifyOTP(Request $request)
    {
        $request->validate([
            'phone_number' => 'required|string|max:20',
            'otp_code' => 'required|string|size:6',
        ]);

        $user = User::where('phone_number', $request->phone_number)
            ->where('otp_code', $request->otp_code)
            ->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid OTP',
            ], 400);
        }

        $user->update([
            'otp_verified_at' => now(),
            'otp_code' => null,
            'last_active_at' => now(),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'OTP verified successfully',
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
