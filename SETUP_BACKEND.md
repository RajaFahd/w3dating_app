# 🚀 Setup W3Dating Backend

## Langkah-langkah Setup:

### 1️⃣ Masuk ke Folder API
```bash
cd api
```

### 2️⃣ Install Dependencies
```bash
composer install
```

### 3️⃣ Setup Environment
```bash
copy .env.example .env
```

### 4️⃣ Generate Application Key
```bash
php artisan key:generate
```

### 5️⃣ Edit .env File
Buka file `.env` dan sesuaikan konfigurasi database:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=w3dating
DB_USERNAME=root
DB_PASSWORD=
```

### 6️⃣ Buat Database
Buat database baru di MySQL:
```sql
CREATE DATABASE w3dating;
```

### 7️⃣ Jalankan Migration
```bash
php artisan migrate:fresh
```

### 8️⃣ Jalankan Seeder
```bash
php artisan db:seed --class=InterestSeeder
```

### 9️⃣ Link Storage
```bash
php artisan storage:link
```

### 🔟 Jalankan Server
```bash
php artisan serve
```

API akan berjalan di: **http://localhost:8000**

---

## ✅ Verifikasi Setup

Test API dengan Postman atau browser:
```
GET http://localhost:8000/api/interests
```

Jika berhasil, akan muncul list interests.

---

## 🐛 Troubleshooting

**Error: No such file .env**
```bash
copy .env.example .env
php artisan key:generate
```

**Error: Database connection**
- Pastikan MySQL sudah running
- Cek kredensial database di `.env`
- Buat database: `CREATE DATABASE w3dating;`

**Error: Storage link**
```bash
php artisan storage:link
```

**Error: Migration failed**
```bash
php artisan migrate:fresh --force
```

---

## 📝 Next Steps

Setelah backend running, update API base URL di Flutter:
```dart
class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
}
```

---

## 🔐 Testing Authentication

1. **Send OTP:**
```bash
POST http://localhost:8000/api/auth/send-otp
Content-Type: application/json

{
  "phone_number": "812345678",
  "country_code": "+61"
}
```

2. **Verify OTP:**
```bash
POST http://localhost:8000/api/auth/verify-otp
Content-Type: application/json

{
  "phone_number": "812345678",
  "otp_code": "123456"
}
```

Copy token dari response, gunakan untuk endpoint lain.
