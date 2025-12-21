<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Subscription;
use Illuminate\Http\Request;

class SubscriptionController extends Controller
{
    public function getPlans()
    {
        $plans = [
            [
                'type' => 'plus',
                'name' => 'W3Dating Plus',
                'price' => 9.99,
                'currency' => 'USD',
                'duration' => '1 month',
                'features' => [
                    'Unlimited Likes',
                    'See who likes you',
                    '5 Super Likes per day',
                    'No ads',
                    'Boost your profile once a month',
                ],
            ],
            [
                'type' => 'gold',
                'name' => 'W3Dating Gold',
                'price' => 19.99,
                'currency' => 'USD',
                'duration' => '1 month',
                'features' => [
                    'All Plus features',
                    'Unlimited Super Likes',
                    'See who likes you before matching',
                    'Priority likes',
                    'Boost your profile 2x per month',
                    'Free monthly Top Picks',
                ],
            ],
            [
                'type' => 'platinum',
                'name' => 'W3Dating Platinum',
                'price' => 29.99,
                'currency' => 'USD',
                'duration' => '1 month',
                'features' => [
                    'All Gold features',
                    'Message before matching',
                    'Priority likes & Super Likes',
                    'See your recent visitors',
                    'Boost your profile 4x per month',
                    'Exclusive badges',
                ],
            ],
        ];

        return response()->json([
            'success' => true,
            'data' => $plans,
        ]);
    }

    public function subscribe(Request $request)
    {
        $request->validate([
            'plan_type' => 'required|in:plus,gold,platinum',
            'payment_method' => 'required|string',
        ]);

        $user = $request->user();

        $prices = [
            'plus' => 9.99,
            'gold' => 19.99,
            'platinum' => 29.99,
        ];

        // TODO: Implement actual payment processing (Stripe, PayPal, etc.)

        $subscription = Subscription::create([
            'user_id' => $user->id,
            'plan_type' => $request->plan_type,
            'status' => 'active',
            'started_at' => now(),
            'expires_at' => now()->addMonth(),
            'amount' => $prices[$request->plan_type],
            'currency' => 'USD',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Subscription created successfully',
            'data' => $subscription,
        ]);
    }

    public function getMySubscription(Request $request)
    {
        $user = $request->user();
        $subscription = $user->subscription;

        return response()->json([
            'success' => true,
            'data' => $subscription,
        ]);
    }

    public function cancelSubscription(Request $request)
    {
        $user = $request->user();
        $subscription = $user->subscription;

        if (!$subscription) {
            return response()->json([
                'success' => false,
                'message' => 'No active subscription found',
            ], 404);
        }

        $subscription->update([
            'status' => 'cancelled',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Subscription cancelled successfully',
        ]);
    }
}
