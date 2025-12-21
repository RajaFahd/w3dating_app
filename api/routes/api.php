<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\SwipeController;
use App\Http\Controllers\Api\MatchController;
use App\Http\Controllers\Api\ChatController;
use App\Http\Controllers\Api\FilterController;
use App\Http\Controllers\Api\SubscriptionController;

// Public routes
Route::post('/auth/send-otp', [AuthController::class, 'sendOTP']);
Route::post('/auth/verify-otp', [AuthController::class, 'verifyOTP']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    
    // Auth
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::get('/auth/me', [AuthController::class, 'me']);

    // Profile
    Route::get('/profile/me', [ProfileController::class, 'getMyProfile']);
    Route::post('/profile/create', [ProfileController::class, 'createProfile']);
    Route::put('/profile/update', [ProfileController::class, 'updateProfile']);
    Route::post('/profile/photos', [ProfileController::class, 'uploadPhotos']);
    Route::delete('/profile/photos/{photoId}', [ProfileController::class, 'deletePhoto']);
    Route::post('/profile/interests', [ProfileController::class, 'updateInterests']);
    Route::get('/interests', [ProfileController::class, 'getInterests']);

    // Swipe
    Route::get('/swipe/profiles', [SwipeController::class, 'getProfiles']);
    Route::post('/swipe', [SwipeController::class, 'swipe']);
    Route::get('/swipes/my-likes', [SwipeController::class, 'getMyLikes']);
    Route::post('/swipes/reset', [SwipeController::class, 'resetSwipes']);
    Route::delete('/swipes/unlike', [SwipeController::class, 'unlikeUser']);

    // Match
    Route::get('/matches', [MatchController::class, 'getMatches']);
    Route::get('/matches/liked-me', [MatchController::class, 'getLikedUsers']);
    Route::get('/matches/{userId}', [MatchController::class, 'getMatchDetail']);

    // Chat
    Route::get('/chat/list', [ChatController::class, 'getChatList']);
    Route::get('/chat/{userId}/messages', [ChatController::class, 'getMessages']);
    Route::post('/chat/{userId}/send', [ChatController::class, 'sendMessage']);
    // Dev-only bootstrap endpoint (local env)
    Route::post('/chat/bootstrap', [ChatController::class, 'bootstrapDemo']);

    // Filter
    Route::get('/filter', [FilterController::class, 'getFilter']);
    Route::put('/filter', [FilterController::class, 'updateFilter']);

    // Subscription
    Route::get('/subscription/plans', [SubscriptionController::class, 'getPlans']);
    Route::post('/subscription/subscribe', [SubscriptionController::class, 'subscribe']);
    Route::get('/subscription/my', [SubscriptionController::class, 'getMySubscription']);
    Route::post('/subscription/cancel', [SubscriptionController::class, 'cancelSubscription']);
});
