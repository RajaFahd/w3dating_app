<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('user_filters', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->boolean('show_men')->default(false);
            $table->boolean('show_women')->default(true);
            $table->boolean('show_nonbinary')->default(false);
            $table->integer('age_min')->default(18);
            $table->integer('age_max')->default(50);
            $table->integer('distance_max')->default(50);
            $table->timestamps();

            $table->index('user_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('user_filters');
    }
};
