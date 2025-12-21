<?php
require __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\User;
use App\Models\UserMatch;
use App\Models\Message;

echo "=== Chat Debug Info ===\n";
echo "Total Users: " . User::count() . "\n";
echo "Total Matches: " . UserMatch::count() . "\n";
echo "Total Messages: " . Message::count() . "\n";

echo "\n=== Matches for User 1 ===\n";
$user1Matches = UserMatch::where('user_id', 1)->get();
if ($user1Matches->isEmpty()) {
    echo "No matches found for user 1!\n";
} else {
    foreach ($user1Matches as $match) {
        echo "User 1 -> User " . $match->matched_user_id . "\n";
    }
}

echo "\n=== Reverse Matches (to User 1) ===\n";
$reverseMatches = UserMatch::where('matched_user_id', 1)->get();
if ($reverseMatches->isEmpty()) {
    echo "No reverse matches found!\n";
} else {
    foreach ($reverseMatches as $match) {
        echo "User " . $match->user_id . " -> User 1\n";
    }
}

echo "\n=== Sample Messages ===\n";
$messages = Message::limit(5)->get();
foreach ($messages as $msg) {
    echo "From User " . $msg->sender_id . " to User " . $msg->receiver_id . ": " . substr($msg->message, 0, 30) . "...\n";
}
?>
