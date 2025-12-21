# Database Seeder

Seeder untuk mengisi database dengan data testing.

## Isi Seeder

### InterestSeeder
Mengisi table `interests` dengan 30+ kategori minat seperti Photography, Travel, Cooking, Basketball, dll.

### UserSeeder
Membuat 10 user demo dengan data lengkap:
- **Users**: 10 akun dengan nomor telepon dan password
- **Profiles**: Data profil lengkap (nama, tanggal lahir, gender, bio, pekerjaan, lokasi)
- **Photos**: 2 foto per user (menggunakan URL dari Pexels)
- **Interests**: 4 minat per user
- **Filters**: Default filter preferences untuk setiap user

## Demo Users

| Phone          | Name    | Gender | Age | City       | Occupation       |
|----------------|---------|--------|-----|------------|------------------|
| 081234567890   | Sarah   | Women  | 26  | Jakarta    | Photographer     |
| 081234567891   | Amanda  | Women  | 29  | Jakarta    | Artist           |
| 081234567892   | Jessica | Women  | 27  | Jakarta    | Yoga Instructor  |
| 081234567893   | Alex    | Men    | 28  | Yogyakarta | Software Dev     |
| 081234567894   | Michael | Men    | 25  | Bandung    | Tour Guide       |
| 081234567895   | David   | Men    | 30  | Jakarta    | Entrepreneur     |
| 081234567896   | Rachel  | Women  | 28  | Jakarta    | Fashion Designer |
| 081234567897   | Ryan    | Men    | 26  | Surabaya   | Musician         |
| 081234567898   | Emma    | Women  | 27  | Jakarta    | Writer           |
| 081234567899   | Kevin   | Men    | 29  | Bali       | Chef             |

**Default Password**: `password123`

## Cara Menjalankan Seeder

### 1. Fresh Migration + Seed (Hapus semua data lama)
```bash
cd api
php artisan migrate:fresh --seed
```

### 2. Run Seeder Saja (Tanpa hapus data)
```bash
cd api
php artisan db:seed
```

### 3. Run Seeder Tertentu
```bash
# Hanya run InterestSeeder
php artisan db:seed --class=InterestSeeder

# Hanya run UserSeeder
php artisan db:seed --class=UserSeeder
```

## Testing Login

Setelah run seeder, Anda bisa login dengan salah satu nomor telepon di atas:

1. Buka aplikasi Flutter
2. Masukkan nomor: `081234567890`
3. Country code: `+62`
4. Untuk OTP development, backend akan generate kode OTP yang bisa dicek di log atau database

## Catatan

- Semua foto menggunakan URL dari [Pexels](https://www.pexels.com/) yang free to use
- Lokasi menggunakan koordinat real dari kota-kota di Indonesia
- Setiap user sudah punya filter preferences default
- Data dirancang untuk testing fitur swipe, match, dan chat

## Troubleshooting

**Error: Foreign key constraint fails**
```bash
# Pastikan migration sudah jalan
php artisan migrate:fresh

# Lalu run seeder
php artisan db:seed
```

**Error: Class not found**
```bash
# Composer dump autoload
composer dump-autoload

# Run seeder lagi
php artisan db:seed
```

**Foto tidak muncul di app**
- Pastikan device/emulator punya koneksi internet
- URL foto dari Pexels harus bisa diakses
- Check `android:usesCleartextTraffic="true"` di AndroidManifest.xml
