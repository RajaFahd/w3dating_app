<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserProfile extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'first_name',
        'birth_date',
        'gender',
        'sexual_orientation',
        'interested_in',
        'looking_for',
        'bio',
        'interest',
        'language',
        'latitude',
        'longitude',
        'city',
        'profile_completion',
    ];

    protected $casts = [
        'birth_date' => 'date',
        'latitude' => 'decimal:8',
        'longitude' => 'decimal:8',
        'profile_completion' => 'integer',
        'interested_in' => 'array',
        'interest' => 'array',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function getAgeAttribute()
    {
        return $this->birth_date ? $this->birth_date->age : null;
    }

    public function calculateProfileCompletion()
    {
        $fields = [
            'first_name', 'birth_date', 'gender', 'sexual_orientation',
            'interested_in', 'looking_for', 'bio', 'interest', 'language'
        ];
        
        $filled = 0;
        foreach ($fields as $field) {
            if (!empty($this->$field)) {
                $filled++;
            }
        }
        
        $photosCount = $this->user->photos()->count();
        $photoScore = min($photosCount / 6, 1);
        
        $baseCompletion = ($filled / count($fields)) * 0.7;
        $totalCompletion = ($baseCompletion + ($photoScore * 0.3)) * 100;
        
        $this->profile_completion = round($totalCompletion);
        $this->save();
        
        return $this->profile_completion;
    }
}
