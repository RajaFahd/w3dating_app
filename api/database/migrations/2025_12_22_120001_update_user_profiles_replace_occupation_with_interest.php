<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('user_profiles', function (Blueprint $table) {
            if (Schema::hasColumn('user_profiles', 'occupation')) {
                $table->dropColumn('occupation');
            }
            if (!Schema::hasColumn('user_profiles', 'interest')) {
                $table->json('interest')->nullable();
            }
        });
    }

    public function down(): void
    {
        Schema::table('user_profiles', function (Blueprint $table) {
            if (Schema::hasColumn('user_profiles', 'interest')) {
                $table->dropColumn('interest');
            }
            if (!Schema::hasColumn('user_profiles', 'occupation')) {
                $table->string('occupation')->nullable();
            }
        });
    }
};
