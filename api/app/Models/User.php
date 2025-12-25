<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'phone_number',
        'country_code',
        'password',
        'is_active',
        'last_active_at',
    ];

    protected $hidden = [
        'password',
    ];

    protected $casts = [
        'last_active_at' => 'datetime',
        'is_active' => 'boolean',
    ];

    public function profile()
    {
        return $this->hasOne(UserProfile::class);
    }

    public function photos()
    {
        return $this->hasMany(UserPhoto::class);
    }

    public function interests()
    {
        return $this->belongsToMany(Interest::class, 'user_interests');
    }

    public function filter()
    {
        return $this->hasOne(UserFilter::class);
    }

    public function subscription()
    {
        return $this->hasOne(Subscription::class);
    }

    public function swipesGiven()
    {
        return $this->hasMany(Swipe::class, 'user_id');
    }

    public function swipesReceived()
    {
        return $this->hasMany(Swipe::class, 'target_user_id');
    }

    public function matches()
    {
        return $this->belongsToMany(User::class, 'matches', 'user_id', 'matched_user_id')
            ->withTimestamps();
    }

    public function sentMessages()
    {
        return $this->hasMany(Message::class, 'sender_id');
    }

    public function receivedMessages()
    {
        return $this->hasMany(Message::class, 'receiver_id');
    }

    public function events()
    {
        return $this->hasMany(Event::class, 'user_id');
    }

    public function eventParticipations()
    {
        return $this->belongsToMany(Event::class, 'event_participants', 'user_id', 'event_id')
            ->withTimestamps();
    }

    public function hasActiveSubscription()
    {
        return $this->subscription && 
               $this->subscription->status === 'active' &&
               $this->subscription->expires_at > now();
    }
}
