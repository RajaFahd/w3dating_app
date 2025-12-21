<?php
require __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\User;
use App\Models\Swipe;
use App\Models\UserMatch;
use App\Models\Message;

echo "Testing auto-message on match...\n\n";

// Get first two users
$user1 = User::find(1);
$user2 = User::find(2);

if (!$user1 || !$user2) {
    echo "Users not found!\n";
    exit;
}

echo "User 1: {$user1->id} - {$user1->phone_number}\n";
echo "User 2: {$user2->id} - {$user2->phone_number}\n\n";

// Clear existing swipes and messages between these users
Swipe::where('user_id', $user1->id)->where('target_user_id', $user2->id)->delete();
Swipe::where('user_id', $user2->id)->where('target_user_id', $user1->id)->delete();
UserMatch::where('user_id', $user1->id)->where('matched_user_id', $user2->id)->delete();
UserMatch::where('user_id', $user2->id)->where('matched_user_id', $user1->id)->delete();
Message::where('sender_id', $user1->id)->where('receiver_id', $user2->id)->where('message', 'Hello')->delete();
Message::where('sender_id', $user2->id)->where('receiver_id', $user1->id)->where('message', 'Hello')->delete();

echo "Cleared previous test data\n\n";

// Simulate: User 2 likes User 1 first
echo "Step 1: User 2 likes User 1\n";
Swipe::create([
    'user_id' => $user2->id,
    'target_user_id' => $user1->id,
    'type' => 'like',
]);
echo "✓ Swipe created (no match yet)\n\n";

// Check messages (should be 0)
$msgCount = Message::where('sender_id', $user2->id)->where('receiver_id', $user1->id)->where('message', 'Hello')->count();
echo "Messages from User 2 to User 1: $msgCount (expected: 0)\n\n";

// Simulate: User 1 likes User 2 back (this should create a match!)
echo "Step 2: User 1 likes User 2 back\n";
Swipe::create([
    'user_id' => $user1->id,
    'target_user_id' => $user2->id,
    'type' => 'like',
]);
echo "✓ Swipe created (should trigger match)\n\n";

// Check matches
$match1 = UserMatch::where('user_id', $user1->id)->where('matched_user_id', $user2->id)->first();
$match2 = UserMatch::where('user_id', $user2->id)->where('matched_user_id', $user1->id)->first();
echo "Match User 1 -> User 2: " . ($match1 ? "✓ EXISTS" : "✗ NOT FOUND") . "\n";
echo "Match User 2 -> User 1: " . ($match2 ? "✓ EXISTS" : "✗ NOT FOUND") . "\n\n";

// Check auto-message
$autoMsg = Message::where('sender_id', $user1->id)
    ->where('receiver_id', $user2->id)
    ->where('message', 'Hello')
    ->first();

if ($autoMsg) {
    echo "✓ AUTO-MESSAGE SENT!\n";
    echo "  From: User {$autoMsg->sender_id}\n";
    echo "  To: User {$autoMsg->receiver_id}\n";
    echo "  Message: '{$autoMsg->message}'\n";
    echo "  Created: {$autoMsg->created_at}\n";
} else {
    echo "✗ NO AUTO-MESSAGE FOUND\n";
}

echo "\nDone.\n";
