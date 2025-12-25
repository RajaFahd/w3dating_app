<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Event extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'title',
        'description',
        'location',
        'event_date',
        'contact',
        'image',
    ];

    protected $casts = [
        'event_date' => 'datetime',
    ];

    public function creator()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function participants()
    {
        return $this->belongsToMany(User::class, 'event_participants', 'event_id', 'user_id')
            ->withTimestamps();
    }

    public function hasUserJoined($userId)
    {
        return $this->participants()->where('user_id', $userId)->exists();
    }
}
