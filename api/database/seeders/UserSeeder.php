<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\UserProfile;
use App\Models\UserPhoto;
use App\Models\UserFilter;
use Illuminate\Support\Facades\DB;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        // Sample user data
        $users = [
            [
                'phone_number' => '081234567890',
                'country_code' => '+62',
                'profile' => [
                    'first_name' => 'Sarah',
                    'birth_date' => '1998-05-15',
                    'gender' => 'Women',
                    'sexual_orientation' => 'Straight',
                    'interested_in' => ['Men'],
                    'looking_for' => 'Long-term partner',
                    'bio' => 'Love traveling and photography. Looking for someone to explore the world with! 📸✈️',
                    'interest' => ['Photography','Travel','Art'],
                    'city' => 'Jakarta',
                    'latitude' => -6.2088,
                    'longitude' => 106.8456,
                ],
                'interests' => ['Photography', 'Travel', 'Art', 'Music'],
                'photos' => [
                    'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
                    'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
                ],
            ],
            [
                'phone_number' => '081234567891',
                'country_code' => '+62',
                'profile' => [
                    'first_name' => 'Amanda',
                    'birth_date' => '1995-08-22',
                    'gender' => 'Women',
                    'sexual_orientation' => 'Straight',
                    'interested_in' => ['Men'],
                    'looking_for' => 'Long-term, open to short',
                    'bio' => 'Artist and coffee lover ☕ Let\'s grab a cup and talk about life!',
                    'interest' => ['Art','Coffee','Music'],
                    'city' => 'Jakarta',
                    'latitude' => -6.2215,
                    'longitude' => 106.8321,
                ],
                'interests' => ['Art', 'Coffee', 'Music', 'Movies'],
                'photos' => [
                    'https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg',
                    'https://images.pexels.com/photos/1181690/pexels-photo-1181690.jpeg',
                ],
            ],
            [
                'phone_number' => '081234567892',
                'country_code' => '+62',
                'profile' => [
                    'first_name' => 'Jessica',
                    'birth_date' => '1997-03-10',
                    'gender' => 'Women',
                    'sexual_orientation' => 'Straight',
                    'interested_in' => ['Men'],
                    'looking_for' => 'New friends',
                    'bio' => 'Fitness enthusiast 💪 Yoga instructor by day, foodie by night!',
                    'interest' => ['Fitness','Yoga','Food'],
                    'city' => 'Jakarta',
                    'latitude' => -6.1944,
                    'longitude' => 106.8229,
                ],
                'interests' => ['Fitness', 'Yoga', 'Food', 'Travel'],
                'photos' => [
                    'https://images.pexels.com/photos/1858175/pexels-photo-1858175.jpeg',
                    'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg',
                ],
            ],
            [
                'phone_number' => '081234567893',
                'country_code' => '+62',
                'profile' => [
                    'first_name' => 'Alex',
                    'birth_date' => '1996-11-08',
                    'gender' => 'Men',
                    'sexual_orientation' => 'Straight',
                    'interested_in' => ['Women'],
                    'looking_for' => 'Long-term partner',
                    'bio' => 'Software developer who loves coding and basketball 🏀 Looking for my player 2!',
                    'interest' => ['Code','Basketball','Gaming'],
                    'city' => 'Yogyakarta',
                    'latitude' => -7.7956,
                    'longitude' => 110.3695,
                ],
                'interests' => ['Code', 'Basketball', 'Gaming', 'Movies'],
                'photos' => [
                    'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg',
                    'https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg',
                ],
            ],
            [
                'phone_number' => '081234567894',
                'country_code' => '+62',
                'profile' => [
                    'first_name' => 'Michael',
                    'birth_date' => '1999-01-20',
                    'gender' => 'Men',
                    'sexual_orientation' => 'Straight',
                    'interested_in' => ['Women'],
                    'looking_for' => 'Short-term fun',
                    'bio' => 'Adventure seeker 🏔️ Hiking, camping, and exploring nature!',
                    'interest' => ['Hike','Camping','Travel'],
                    'city' => 'Bandung',
                    'latitude' => -6.9175,
                    'longitude' => 107.6191,
                ],
                'interests' => ['Hike', 'Camping', 'Travel', 'Photography'],
                'photos' => [
                    'https://images.pexels.com/photos/1933873/pexels-photo-1933873.jpeg',
                    'https://images.pexels.com/photos/1391498/pexels-photo-1391498.jpeg',
                ],
            ],
            [
                'phone_number' => '081234567895',
                'country_code' => '+62',
                'profile' => [
                    'first_name' => 'David',
                    'birth_date' => '1994-07-12',
                    'gender' => 'Men',
                    'sexual_orientation' => 'Straight',
                    'interested_in' => ['Women'],
                    'looking_for' => 'Long-term, open to short',
                    'bio' => 'Entrepreneur and tech enthusiast. Building the future one startup at a time 🚀',
                    'interest' => ['IT','Work','Reading'],
                    'city' => 'Jakarta',
                    'latitude' => -6.2297,
                    'longitude' => 106.8190,
                ],
                'interests' => ['IT', 'Work', 'Travel', 'Reading'],
                'photos' => [
                    'https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg',
                    'https://images.pexels.com/photos/1065084/pexels-photo-1065084.jpeg',
                ],
            ],
            [
                'phone_number' => '081234567896',
                'country_code' => '+62',
                'profile' => [
                    'first_name' => 'Rachel',
                    'birth_date' => '1996-09-05',
                    'gender' => 'Women',
                    'sexual_orientation' => 'Straight',
                    'interested_in' => ['Men'],
                    'looking_for' => 'Still figuring it out',
                    'bio' => 'Fashion designer with a passion for creativity. Life is my runway! 👗✨',
                    'interest' => ['Fashion','Art','Shopping'],
                    'city' => 'Jakarta',
                    'latitude' => -6.2615,
                    'longitude' => 106.7810,
                ],
                'interests' => ['Fashion', 'Art', 'Shopping', 'Music'],
                'photos' => [
                    'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg',
                    'https://images.pexels.com/photos/1468379/pexels-photo-1468379.jpeg',
                ],
            ],
            [
                'phone_number' => '081234567897',
                'country_code' => '+62',
                'profile' => [
                    'first_name' => 'Ryan',
                    'birth_date' => '1998-04-18',
                    'gender' => 'Men',
                    'sexual_orientation' => 'Straight',
                    'interested_in' => ['Women'],
                    'looking_for' => 'New friends',
                    'bio' => 'Musician and songwriter 🎸 Music is my language, let\'s create beautiful melodies together!',
                    'interest' => ['Music','Singing','Art'],
                    'city' => 'Surabaya',
                    'latitude' => -7.2575,
                    'longitude' => 112.7521,
                ],
                'interests' => ['Music', 'Singing', 'Art', 'Movies'],
                'photos' => [
                    'https://images.pexels.com/photos/1516680/pexels-photo-1516680.jpeg',
                    'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg',
                ],
            ],
            [
                'phone_number' => '081234567898',
                'country_code' => '+62',
                'profile' => [
                    'first_name' => 'Emma',
                    'birth_date' => '1997-12-25',
                    'gender' => 'Women',
                    'sexual_orientation' => 'Straight',
                    'interested_in' => ['Men'],
                    'looking_for' => 'Long-term partner',
                    'bio' => 'Book lover and writer 📚 Always looking for the next great story to read or write!',
                    'interest' => ['Reading','Writing','Tea'],
                    'city' => 'Jakarta',
                    'latitude' => -6.1751,
                    'longitude' => 106.8650,
                ],
                'interests' => ['Reading', 'Writing', 'Tea', 'Movies'],
                'photos' => [
                    'https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg',
                    'https://images.pexels.com/photos/1310522/pexels-photo-1310522.jpeg',
                ],
            ],
            [
                'phone_number' => '081234567899',
                'country_code' => '+62',
                'profile' => [
                    'first_name' => 'Kevin',
                    'birth_date' => '1995-06-30',
                    'gender' => 'Men',
                    'sexual_orientation' => 'Straight',
                    'interested_in' => ['Women'],
                    'looking_for' => 'Short-term, open to long',
                    'bio' => 'Chef and food explorer 🍳 Let me cook you the best meal you\'ve ever had!',
                    'interest' => ['Cooking','Food','Travel'],
                    'city' => 'Bali',
                    'latitude' => -8.3405,
                    'longitude' => 115.0920,
                ],
                'interests' => ['Cooking', 'Food', 'Travel', 'Wine'],
                'photos' => [
                    'https://images.pexels.com/photos/1820770/pexels-photo-1820770.jpeg',
                    'https://images.pexels.com/photos/1024311/pexels-photo-1024311.jpeg',
                ],
            ],
        ];

        foreach ($users as $userData) {
            // Create user
            $user = User::create([
                'phone_number' => $userData['phone_number'],
                'country_code' => $userData['country_code'],
                'otp_verified_at' => now(),
            ]);

            // Create profile
            $profile = UserProfile::create(array_merge(
                $userData['profile'],
                ['user_id' => $user->id]
            ));

            // Create default filter
            UserFilter::create([
                'user_id' => $user->id,
                'age_min' => 18,
                'age_max' => 50,
                'distance_max' => 50,
                'show_men' => in_array('Men', $userData['profile']['interested_in']),
                'show_women' => in_array('Women', $userData['profile']['interested_in']),
                'show_nonbinary' => in_array('Other', $userData['profile']['interested_in']),
            ]);

            // Add photos
            foreach ($userData['photos'] as $index => $photoUrl) {
                UserPhoto::create([
                    'user_id' => $user->id,
                    'photo_url' => $photoUrl,
                    'order' => $index + 1,
                ]);
            }

            // Add interests
            $interestIds = DB::table('interests')
                ->whereIn('name', $userData['interests'])
                ->pluck('id')
                ->toArray();
            
            $user->interests()->attach($interestIds);
        }

        $this->command->info('Created ' . count($users) . ' demo users with profiles, photos, and interests!');
    }
}
