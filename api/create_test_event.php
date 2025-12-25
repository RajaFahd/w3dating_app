<?php

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

$user = App\Models\User::first();
if (!$user) {
    echo "No users found!\n";
    exit(1);
}

$event = App\Models\Event::create([
    'user_id' => $user->id,
    'title' => 'Test Event',
    'description' => 'This is a test event for exploring the events feature',
    'location' => 'Jakarta, Indonesia',
    'event_date' => now()->addDays(5)->format('Y-m-d H:i:s'),
    'contact' => $user->phone_number,
]);

echo "Event created successfully!\n";
echo "Event ID: {$event->id}\n";
echo "Title: {$event->title}\n";
echo "Date: {$event->event_date}\n";
