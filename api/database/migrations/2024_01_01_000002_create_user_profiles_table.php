<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('user_profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('first_name', 100);
            $table->date('birth_date');
            $table->enum('gender', ['Men', 'Women', 'Other']);
            $table->string('sexual_orientation', 50);
            $table->json('interested_in')->nullable();
            $table->string('looking_for')->nullable();
            $table->text('bio')->nullable();
            $table->string('interest')->nullable();
            $table->string('language', 50)->default('English');
            $table->decimal('latitude', 10, 8)->nullable();
            $table->decimal('longitude', 11, 8)->nullable();
            $table->string('city', 100)->nullable();
            $table->integer('profile_completion')->default(0);
            $table->timestamps();

            $table->index('user_id');
            $table->index('gender');
            $table->index(['latitude', 'longitude']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('user_profiles');
    }
};
