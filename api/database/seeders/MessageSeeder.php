<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Message;
use App\Models\UserMatch;

class MessageSeeder extends Seeder
{
    public function run(): void
    {
        // Get first two users to create a match
        $user1 = User::first(); // Login user
        $user2 = User::skip(1)->first(); // Second user
        $user3 = User::skip(2)->first(); // Third user
        
        if (!$user1 || !$user2 || !$user3) {
            $this->command->warn('Not enough users to create dummy messages');
            return;
        }

        // Create matches if not exist
        $match1 = UserMatch::firstOrCreate(
            ['user_id' => $user1->id, 'matched_user_id' => $user2->id],
            ['matched_user_id' => $user2->id]
        );

        $match2 = UserMatch::firstOrCreate(
            ['user_id' => $user1->id, 'matched_user_id' => $user3->id],
            ['matched_user_id' => $user3->id]
        );

        // Create reverse matches if needed
        UserMatch::firstOrCreate(
            ['user_id' => $user2->id, 'matched_user_id' => $user1->id],
            ['matched_user_id' => $user1->id]
        );

        UserMatch::firstOrCreate(
            ['user_id' => $user3->id, 'matched_user_id' => $user1->id],
            ['matched_user_id' => $user1->id]
        );

        // Delete existing messages to avoid duplicates
        Message::where('sender_id', $user1->id)
            ->orWhere('receiver_id', $user1->id)
            ->delete();

        // Create dummy messages between user1 and user2
        $messagesUser2 = [
            ['sender_id' => $user2->id, 'receiver_id' => $user1->id, 'message' => 'Halo! 👋 Apa kabar?', 'is_read' => true],
            ['sender_id' => $user1->id, 'receiver_id' => $user2->id, 'message' => 'Halo juga! Baik baik aja. Kamu gimana?', 'is_read' => true],
            ['sender_id' => $user2->id, 'receiver_id' => $user1->id, 'message' => 'Aku juga baik 😊 Mau kenalan?', 'is_read' => true],
            ['sender_id' => $user1->id, 'receiver_id' => $user2->id, 'message' => 'Tentu dong! Kamu dari mana?', 'is_read' => true],
            ['sender_id' => $user2->id, 'receiver_id' => $user1->id, 'message' => 'Aku dari Jakarta, work di startup. Kamu?', 'is_read' => true],
            ['sender_id' => $user1->id, 'receiver_id' => $user2->id, 'message' => 'Aku juga dari Jakarta! Apa yang kamu kerjakan?', 'is_read' => true],
            ['sender_id' => $user2->id, 'receiver_id' => $user1->id, 'message' => 'Aku photographer freelance 📸 Hobi traveling. Kamu ada hobby apa?', 'is_read' => true],
            ['sender_id' => $user1->id, 'receiver_id' => $user2->id, 'message' => 'Wow keren! Aku suka coding dan basketball 🏀', 'is_read' => false],
        ];

        foreach ($messagesUser2 as $index => $msgData) {
            Message::create([
                'sender_id' => $msgData['sender_id'],
                'receiver_id' => $msgData['receiver_id'],
                'message' => $msgData['message'],
                'is_read' => $msgData['is_read'],
                'read_at' => $msgData['is_read'] ? now()->subHours($index) : null,
                'created_at' => now()->subHours(8 - $index),
            ]);
        }

        // Create dummy messages between user1 and user3
        $messagesUser3 = [
            ['sender_id' => $user1->id, 'receiver_id' => $user3->id, 'message' => 'Hi! Senang berkenalan 😄', 'is_read' => true],
            ['sender_id' => $user3->id, 'receiver_id' => $user1->id, 'message' => 'Halo! Terima kasih 🙂', 'is_read' => true],
            ['sender_id' => $user1->id, 'receiver_id' => $user3->id, 'message' => 'Apa kabar hari ini?', 'is_read' => true],
            ['sender_id' => $user3->id, 'receiver_id' => $user1->id, 'message' => 'Baik baik aja, habis dari yoga session 🧘‍♀️', 'is_read' => true],
            ['sender_id' => $user1->id, 'receiver_id' => $user3->id, 'message' => 'Keren! Aku juga suka olahraga, tapi basketball 😄', 'is_read' => false],
        ];

        foreach ($messagesUser3 as $index => $msgData) {
            Message::create([
                'sender_id' => $msgData['sender_id'],
                'receiver_id' => $msgData['receiver_id'],
                'message' => $msgData['message'],
                'is_read' => $msgData['is_read'],
                'read_at' => $msgData['is_read'] ? now()->subHours($index + 2) : null,
                'created_at' => now()->subHours(6 - $index),
            ]);
        }

        $this->command->info('Created dummy messages for testing!');
    }
}
