# W3Dating App — Setup & Running
## Ringkas: Apa yang Harus Dijalankan
- Jalankan MySQL/DB lokal Anda.
- Jalankan server API Laravel di folder `api/` dengan `php artisan serve`.
- Atur base URL di [lib/config/api_config.dart](lib/config/api_config.dart) sesuai perangkat (dev/emulator/prod).
- Jalankan aplikasi Flutter dengan `flutter run`.

Jika menggunakan Android emulator: gunakan `10.0.2.2` sebagai host backend.

---

## Prasyarat
- Flutter 3.x dan Dart 3.x
- PHP 8.2+, Composer
- MySQL 8.0+
- Android SDK/Emulator (opsional) atau perangkat fisik

Struktur utama:
- Backend (Laravel): folder `api/`
- Frontend (Flutter): folder `lib/`

---

## Setup Backend (Laravel)
Jalankan dari folder `api/`:

```bash
cd api
composer install
copy .env.example .env
php artisan key:generate

# Edit .env (DB_* sesuai lokal Anda)
# Contoh:
# DB_CONNECTION=mysql
# DB_HOST=127.0.0.1
# DB_PORT=3306
# DB_DATABASE=w3dating
# DB_USERNAME=root
# DB_PASSWORD=

php artisan migrate:fresh
php artisan db:seed --class=InterestSeeder
php artisan storage:link
php artisan serve
```

Backend berjalan di `http://127.0.0.1:8000`.

### Perintah Singkat (Windows)
```bash
cd api
composer install
copy .env.example .env
php artisan key:generate
php artisan migrate:fresh && php artisan db:seed --class=InterestSeeder
php artisan storage:link
php artisan serve
```

---

## Setup Frontend (Flutter)
Di root proyek:

```bash
flutter pub get
```

Konfigurasi koneksi ke backend di `ApiConfig` (file `lib/config/api_config.dart`):

```dart
class ApiConfig {
  static const String devUrl = 'http://127.0.0.1:8000/api';
  static const String androidEmulatorUrl = 'http://10.0.2.2:8000/api';
  static const Environment currentEnv = Environment.androidEmulator; // ganti sesuai perangkat
}
```

- Gunakan `androidEmulatorUrl` jika testing di Android emulator.
- Gunakan `devUrl` untuk desktop/web lokal.
- Untuk production, set `prodUrl` ke domain API Anda.

Menjalankan aplikasi:

```bash
flutter run
```

### Quick Start (Ringkas)
```bash
# 1) Jalankan backend
cd api
composer install
copy .env.example .env
php artisan key:generate
php artisan migrate:fresh
php artisan db:seed --class=InterestSeeder
php artisan storage:link
php artisan serve

# 2) Jalankan frontend
flutter pub get
flutter run
```

---

## Tes Cepat API
Setelah backend aktif, uji endpoint dasar:

```bash
# Register
POST http://127.0.0.1:8000/api/auth/register
{
  "phone_number": "812345678",
  "country_code": "+62",
  "password": "secret123",
  "password_confirmation": "secret123"
}

# Login
POST http://127.0.0.1:8000/api/auth/login
{
  "phone_number": "812345678",
  "country_code": "+62",
  "password": "secret123"
}
```

Gunakan token dari login sebagai header: `Authorization: Bearer {token}` untuk endpoint yang terlindungi.

Contoh cek profil (butuh token):
```bash
GET http://127.0.0.1:8000/api/auth/me
Authorization: Bearer {token}
```

---

## Tips & Troubleshooting
- Android emulator tidak bisa mengakses `localhost`; gunakan `10.0.2.2`.
- Pastikan `php artisan storage:link` berhasil agar foto dapat disajikan.
- Jika migrasi gagal, cek kredensial `.env` dan pastikan DB aktif.
- Beberapa endpoint membutuhkan token; lakukan login terlebih dahulu.
- Jika Flutter tidak bisa memuat foto, pastikan URL foto menggunakan base URL tanpa `/api` saat mengakses `public/storage` (beberapa layar memetakan `ApiConfig.baseUrl.replaceAll('/api', '')`).

---