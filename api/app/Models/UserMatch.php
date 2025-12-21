<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserMatch extends Model
{
    use HasFactory;

    protected $table = 'matches';

    protected $fillable = [
        'user_id',
        'matched_user_id',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function matchedUser()
    {
        return $this->belongsTo(User::class, 'matched_user_id');
    }

    public function messages()
    {
        return Message::where(function ($query) {
            $query->where('sender_id', $this->user_id)
                  ->where('receiver_id', $this->matched_user_id);
        })->orWhere(function ($query) {
            $query->where('sender_id', $this->matched_user_id)
                  ->where('receiver_id', $this->user_id);
        })->orderBy('created_at', 'asc');
    }
}
