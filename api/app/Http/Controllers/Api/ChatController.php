<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Message;
use App\Models\UserMatch;
use App\Models\User;
use Illuminate\Http\Request;

class ChatController extends Controller
{
    public function getChatList(Request $request)
    {
        $user = $request->user();

        // Include matches both directions so whichever user logs in still sees the conversation
        $matches = UserMatch::where('user_id', $user->id)
            ->orWhere('matched_user_id', $user->id)
            ->get();

        // Preload other users with profile + primary photo
        $otherUserIds = $matches->map(function ($m) use ($user) {
            return $m->user_id === $user->id ? $m->matched_user_id : $m->user_id;
        })->unique()->values();

        $otherUsers = User::whereIn('id', $otherUserIds)
            ->with(['profile', 'photos' => function ($q) {
                $q->where('is_primary', true)
                  ->orWhere('order', 1)
                  ->orderBy('order')
                  ->limit(1);
            }])
            ->get()
            ->keyBy('id');

        $chatList = $otherUserIds->map(function ($otherUserId) use ($user, $otherUsers) {
            $other = $otherUsers[$otherUserId] ?? null;
            if (!$other) {
                return null;
            }

            $lastMessage = Message::where(function ($q) use ($user, $otherUserId) {
                $q->where('sender_id', $user->id)
                  ->where('receiver_id', $otherUserId);
            })->orWhere(function ($q) use ($user, $otherUserId) {
                $q->where('sender_id', $otherUserId)
                  ->where('receiver_id', $user->id);
            })
            ->orderBy('created_at', 'desc')
            ->first();

            $unreadCount = Message::where('sender_id', $otherUserId)
                ->where('receiver_id', $user->id)
                ->where('is_read', false)
                ->count();

            return [
                'user_id' => $otherUserId,
                'name' => $other->profile->first_name ?? '',
                'avatar' => optional($other->photos->first())->photo_url,
                'last_message' => $lastMessage ? $lastMessage->message : '',
                'last_message_time' => $lastMessage ? $lastMessage->created_at->diffForHumans() : '',
                'is_online' => $other->last_active_at && $other->last_active_at->diffInMinutes(now()) < 30,
                'unread_count' => $unreadCount,
            ];
        })->filter()->sortByDesc('last_message_time')->values();

        return response()->json([
            'success' => true,
            'data' => $chatList,
        ]);
    }

    public function getMessages(Request $request, $userId)
    {
        $user = $request->user();

        // Check if matched (any direction)
        $match = UserMatch::where(function ($q) use ($user, $userId) {
                $q->where('user_id', $user->id)->where('matched_user_id', $userId);
            })
            ->orWhere(function ($q) use ($user, $userId) {
                $q->where('user_id', $userId)->where('matched_user_id', $user->id);
            })
            ->first();

        if (!$match) {
            return response()->json([
                'success' => false,
                'message' => 'Not matched with this user',
            ], 404);
        }

        $messages = Message::where(function ($q) use ($user, $userId) {
                $q->where('sender_id', $user->id)
                  ->where('receiver_id', $userId);
            })
            ->orWhere(function ($q) use ($user, $userId) {
                $q->where('sender_id', $userId)
                  ->where('receiver_id', $user->id);
            })
            ->orderBy('created_at', 'asc')
            ->get();

        // Mark messages as read
        Message::where('sender_id', $userId)
            ->where('receiver_id', $user->id)
            ->where('is_read', false)
            ->update([
                'is_read' => true,
                'read_at' => now(),
            ]);

        $messagesData = $messages->map(function ($message) use ($user) {
            return [
                'id' => $message->id,
                'message' => $message->message,
                'is_mine' => $message->sender_id === $user->id,
                'time' => $message->created_at->format('H:i'),
                'is_read' => $message->is_read,
                'created_at' => $message->created_at->toIso8601String(),
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $messagesData,
        ]);
    }

    public function sendMessage(Request $request, $userId)
    {
        $request->validate([
            'message' => 'required|string|max:5000',
        ]);

        $user = $request->user();

        // Check if matched (any direction)
        $match = UserMatch::where(function ($q) use ($user, $userId) {
                $q->where('user_id', $user->id)->where('matched_user_id', $userId);
            })
            ->orWhere(function ($q) use ($user, $userId) {
                $q->where('user_id', $userId)->where('matched_user_id', $user->id);
            })
            ->first();

        if (!$match) {
            return response()->json([
                'success' => false,
                'message' => 'Not matched with this user',
            ], 404);
        }

        $message = Message::create([
            'sender_id' => $user->id,
            'receiver_id' => $userId,
            'message' => $request->message,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Message sent successfully',
            'data' => [
                'id' => $message->id,
                'message' => $message->message,
                'is_mine' => true,
                'time' => $message->created_at->format('H:i'),
                'created_at' => $message->created_at->toIso8601String(),
            ],
        ]);
    }

    // DEV-ONLY: Create demo matches and messages for the logged-in user
    public function bootstrapDemo(Request $request)
    {
        if (!app()->environment('local')) {
            return response()->json(['success' => false, 'message' => 'Forbidden'], 403);
        }

        $user = $request->user();

        // Pick up to 2 other users to match with
        $others = User::where('id', '!=', $user->id)
            ->orderBy('id')
            ->limit(2)
            ->get();

        if ($others->isEmpty()) {
            return response()->json(['success' => false, 'message' => 'No other users to match with']);
        }

        foreach ($others as $other) {
            // Ensure match both directions
            UserMatch::firstOrCreate(['user_id' => $user->id, 'matched_user_id' => $other->id]);
            UserMatch::firstOrCreate(['user_id' => $other->id, 'matched_user_id' => $user->id]);

            // If there are no messages yet, create a small thread
            $hasAny = Message::where(function ($q) use ($user, $other) {
                    $q->where('sender_id', $user->id)->where('receiver_id', $other->id);
                })
                ->orWhere(function ($q) use ($user, $other) {
                    $q->where('sender_id', $other->id)->where('receiver_id', $user->id);
                })
                ->exists();

            if (!$hasAny) {
                $now = now();
                Message::create([
                    'sender_id' => $other->id,
                    'receiver_id' => $user->id,
                    'message' => 'Halo! 👋 Apa kabar?',
                    'is_read' => true,
                    'read_at' => $now->copy()->subMinutes(10),
                    'created_at' => $now->copy()->subMinutes(12),
                ]);
                Message::create([
                    'sender_id' => $user->id,
                    'receiver_id' => $other->id,
                    'message' => 'Halo juga! Baik. Kamu?',
                    'is_read' => true,
                    'read_at' => $now->copy()->subMinutes(8),
                    'created_at' => $now->copy()->subMinutes(9),
                ]);
                Message::create([
                    'sender_id' => $other->id,
                    'receiver_id' => $user->id,
                    'message' => 'Aku baik 😊 Senang kenalan!',
                    'is_read' => false,
                    'created_at' => $now->copy()->subMinutes(5),
                ]);
            }
        }

        return response()->json(['success' => true]);
    }
}
