<?php
require __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\User;
use App\Models\UserMatch;
use App\Models\Message;

echo "Bootstrapping demo chats for all users...\n";
$users = User::orderBy('id')->get();

foreach ($users as $user) {
    // pick up to two other users
    $others = User::where('id', '!=', $user->id)->orderBy('id')->limit(2)->get();
    foreach ($others as $other) {
        // ensure matches both directions
        UserMatch::firstOrCreate(['user_id' => $user->id, 'matched_user_id' => $other->id]);
        UserMatch::firstOrCreate(['user_id' => $other->id, 'matched_user_id' => $user->id]);

        // if no messages yet between this pair, create small thread
        $exists = Message::where(function($q) use ($user, $other) {
                $q->where('sender_id', $user->id)->where('receiver_id', $other->id);
            })
            ->orWhere(function($q) use ($user, $other) {
                $q->where('sender_id', $other->id)->where('receiver_id', $user->id);
            })
            ->exists();

        if (!$exists) {
            $now = now();
            Message::create([
                'sender_id' => $other->id,
                'receiver_id' => $user->id,
                'message' => 'Halo! 👋 Apa kabar?',
                'is_read' => true,
                'read_at' => $now->copy()->subMinutes(15),
                'created_at' => $now->copy()->subMinutes(16),
            ]);
            Message::create([
                'sender_id' => $user->id,
                'receiver_id' => $other->id,
                'message' => 'Halo juga! Baik. Kamu?',
                'is_read' => true,
                'read_at' => $now->copy()->subMinutes(12),
                'created_at' => $now->copy()->subMinutes(13),
            ]);
            Message::create([
                'sender_id' => $other->id,
                'receiver_id' => $user->id,
                'message' => 'Aku baik 😊 Senang kenalan!',
                'is_read' => false,
                'created_at' => $now->copy()->subMinutes(8),
            ]);
        }
    }
}

echo "Done.\n";
