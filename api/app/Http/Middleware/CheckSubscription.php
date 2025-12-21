<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckSubscription
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, string $plan = null): Response
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 401);
        }

        // Check if user has active subscription
        if (!$user->hasActiveSubscription()) {
            return response()->json([
                'success' => false,
                'message' => 'Active subscription required',
                'required_plan' => $plan,
            ], 403);
        }

        // Check specific plan if required
        if ($plan && $user->subscription->plan_type !== $plan) {
            $planHierarchy = ['plus' => 1, 'gold' => 2, 'platinum' => 3];
            $userPlanLevel = $planHierarchy[$user->subscription->plan_type] ?? 0;
            $requiredPlanLevel = $planHierarchy[$plan] ?? 0;

            if ($userPlanLevel < $requiredPlanLevel) {
                return response()->json([
                    'success' => false,
                    'message' => "This feature requires $plan subscription or higher",
                    'current_plan' => $user->subscription->plan_type,
                    'required_plan' => $plan,
                ], 403);
            }
        }

        return $next($request);
    }
}
