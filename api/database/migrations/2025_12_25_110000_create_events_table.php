<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('events', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('title');
            $table->text('description');
            $table->string('location');
            $table->dateTime('event_date');
            $table->string('contact'); // Auto-filled from creator's phone_number
            $table->longText('image')->nullable(); // Base64 encoded image
            $table->timestamps();

            $table->index('user_id');
            $table->index('event_date');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('events');
    }
};
