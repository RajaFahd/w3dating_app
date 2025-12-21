<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Swipe extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'target_user_id',
        'type',
    ];

    const TYPE_LIKE = 'like';
    const TYPE_DISLIKE = 'dislike';
    const TYPE_SUPER_LIKE = 'super_like';

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function targetUser()
    {
        return $this->belongsTo(User::class, 'target_user_id');
    }

    protected static function booted()
    {
        static::created(function ($swipe) {
            if ($swipe->type === self::TYPE_LIKE || $swipe->type === self::TYPE_SUPER_LIKE) {
                $reverseSwipe = self::where('user_id', $swipe->target_user_id)
                    ->where('target_user_id', $swipe->user_id)
                    ->whereIn('type', [self::TYPE_LIKE, self::TYPE_SUPER_LIKE])
                    ->first();

                if ($reverseSwipe) {
                    UserMatch::firstOrCreate([
                        'user_id' => $swipe->user_id,
                        'matched_user_id' => $swipe->target_user_id,
                    ]);
                    
                    UserMatch::firstOrCreate([
                        'user_id' => $swipe->target_user_id,
                        'matched_user_id' => $swipe->user_id,
                    ]);
                    
                    // Auto-send "Hello" message from the user who just liked
                    Message::create([
                        'sender_id' => $swipe->user_id,
                        'receiver_id' => $swipe->target_user_id,
                        'message' => 'Hello',
                        'is_read' => false,
                        'created_at' => now(),
                    ]);
                }
            }
        });
    }
}
