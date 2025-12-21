<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class InterestSeeder extends Seeder
{
    public function run(): void
    {
        $interests = [
            'Photography',
            'Tea',
            'Travel',
            'Acting',
            'Work',
            'Cooking',
            'Basketball',
            'Code',
            'Sleep',
            'IT',
            'Hike',
            'Music',
            'Art',
            'Reading',
            'Gaming',
            'Fitness',
            'Yoga',
            'Dancing',
            'Movies',
            'Food',
            'Fashion',
            'Shopping',
            'Running',
            'Swimming',
            'Cycling',
            'Camping',
            'Photography',
            'Writing',
            'Singing',
            'Painting',
        ];

        foreach ($interests as $interest) {
            DB::table('interests')->insertOrIgnore([
                'name' => $interest,
                'icon' => null,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}
