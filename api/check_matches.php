<?php
require __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\User;
use App\Models\UserMatch;
use App\Models\Message;

echo "Checking recent matches and messages...\n\n";

// Get all recent matches (last 10)
$recentMatches = UserMatch::orderBy('created_at', 'desc')->limit(10)->get();

echo "=== Recent Matches (last 10) ===\n";
foreach ($recentMatches as $match) {
    $user1 = User::find($match->user_id);
    $user2 = User::find($match->matched_user_id);
    echo "Match: User {$match->user_id} ({$user1->phone_number}) <-> User {$match->matched_user_id} ({$user2->phone_number})\n";
    echo "  Created: {$match->created_at}\n";
    
    // Check if there's a "Hello" message
    $helloMsg = Message::where(function($q) use ($match) {
            $q->where('sender_id', $match->user_id)->where('receiver_id', $match->matched_user_id);
        })
        ->orWhere(function($q) use ($match) {
            $q->where('sender_id', $match->matched_user_id)->where('receiver_id', $match->user_id);
        })
        ->where('message', 'Hello')
        ->first();
    
    if ($helloMsg) {
        echo "  ✓ Has 'Hello' message: User {$helloMsg->sender_id} -> User {$helloMsg->receiver_id}\n";
    } else {
        echo "  ✗ NO 'Hello' message found\n";
    }
    echo "\n";
}

echo "\n=== Recent Messages (last 10) ===\n";
$recentMessages = Message::orderBy('created_at', 'desc')->limit(10)->get();
foreach ($recentMessages as $msg) {
    echo "From User {$msg->sender_id} to User {$msg->receiver_id}: \"{$msg->message}\"\n";
    echo "  Created: {$msg->created_at}, Read: " . ($msg->is_read ? 'Yes' : 'No') . "\n";
}
