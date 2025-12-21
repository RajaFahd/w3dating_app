<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserFilter extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'show_men',
        'show_women',
        'show_nonbinary',
        'age_min',
        'age_max',
        'distance_max',
    ];

    protected $casts = [
        'show_men' => 'boolean',
        'show_women' => 'boolean',
        'show_nonbinary' => 'boolean',
        'age_min' => 'integer',
        'age_max' => 'integer',
        'distance_max' => 'integer',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
