<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // Drop old unique constraint on phone_number only
            $table->dropUnique('users_phone_number_unique');
            
            // Add composite unique constraint on phone_number + country_code
            $table->unique(['phone_number', 'country_code'], 'users_phone_country_unique');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // Drop composite unique constraint
            $table->dropUnique('users_phone_country_unique');
            
            // Restore old unique constraint on phone_number only
            $table->unique('phone_number', 'users_phone_number_unique');
        });
    }
};
