<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\UserFilter;
use Illuminate\Http\Request;

class FilterController extends Controller
{
    public function getFilter(Request $request)
    {
        $user = $request->user();
        $filter = $user->filter;

        if (!$filter) {
            // Create default filter
            $filter = UserFilter::create([
                'user_id' => $user->id,
                'show_men' => false,
                'show_women' => true,
                'show_nonbinary' => false,
                'age_min' => 18,
                'age_max' => 50,
                'distance_max' => 50,
            ]);
        }

        return response()->json([
            'success' => true,
            'data' => $filter,
        ]);
    }

    public function updateFilter(Request $request)
    {
        $request->validate([
            'show_men' => 'sometimes|boolean',
            'show_women' => 'sometimes|boolean',
            'show_nonbinary' => 'sometimes|boolean',
            'age_min' => 'sometimes|integer|min:18|max:100',
            'age_max' => 'sometimes|integer|min:18|max:100',
            'distance_max' => 'sometimes|integer|min:1|max:500',
        ]);

        $user = $request->user();
        $filter = $user->filter;

        if (!$filter) {
            $filter = UserFilter::create([
                'user_id' => $user->id,
            ]);
        }

        $filter->update($request->only([
            'show_men',
            'show_women',
            'show_nonbinary',
            'age_min',
            'age_max',
            'distance_max',
        ]));

        return response()->json([
            'success' => true,
            'message' => 'Filter updated successfully',
            'data' => $filter,
        ]);
    }
}
