<?php
// Login simulator - mendapatkan OTP token
require __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\User;

// Get or create user 1
$user = User::find(1);
if (!$user) {
    echo "User 1 tidak ditemukan!\n";
    exit;
}

// Create a personal access token for user 1
$token = $user->createToken('login-token')->plainTextToken;

echo "=== User Login Simulation ===\n";
echo "User ID: " . $user->id . "\n";
echo "Phone: " . $user->phone_number . "\n";
echo "Token: " . $token . "\n\n";

// Save token to file for use in Flutter
file_put_contents(__DIR__ . '/auth_token.txt', $token);
echo "Token saved to auth_token.txt\n";

// Test the API with token
echo "\n=== Testing API with Token ===\n";
$ch = curl_init();
curl_setopt_array($ch, [
    CURLOPT_URL => 'http://127.0.0.1:8000/api/chat/list',
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER => [
        'Authorization: Bearer ' . $token,
        'Content-Type: application/json'
    ]
]);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo "Status: " . $httpCode . "\n";
echo "Response:\n";
echo $response . "\n";
?>
