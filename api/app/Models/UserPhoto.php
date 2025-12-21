<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserPhoto extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'photo_url',
        'order',
        'is_primary',
    ];

    protected $casts = [
        'order' => 'integer',
        'is_primary' => 'boolean',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    protected static function booted()
    {
        static::creating(function ($photo) {
            if (is_null($photo->order)) {
                $maxOrder = static::where('user_id', $photo->user_id)->max('order');
                $photo->order = $maxOrder ? $maxOrder + 1 : 1;
            }
        });
    }
}
