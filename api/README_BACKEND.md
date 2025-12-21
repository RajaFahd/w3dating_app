# W3Dating App - Backend API Documentation

## 📋 Struktur Database

### **Tabel dan Relasi:**

1. **users** - Data pengguna utama
   - phone_number, country_code, otp_code, is_active

2. **user_profiles** - Detail profil lengkap
   - first_name, birth_date, gender, sexual_orientation
   - interested_in (JSON), looking_for, bio, occupation
   - latitude, longitude, city (untuk distance matching)
   - profile_completion (persentase kelengkapan profil)

3. **user_photos** - Foto profil (max 6)
   - photo_url, order, is_primary

4. **interests** - Master data interest/hobi
   - name, icon

5. **user_interests** - Pivot table (many-to-many)

6. **swipes** - Riwayat swipe (like/dislike/super_like)
   - Otomatis create match jika mutual like

7. **matches** - Data match yang berhasil
   - Dibuat otomatis ketika 2 user saling like

8. **messages** - Pesan chat
   - sender_id, receiver_id, message, is_read

9. **user_filters** - Preferensi filter pencarian
   - show_men, show_women, show_nonbinary
   - age_min, age_max, distance_max

10. **subscriptions** - Langganan premium
    - plan_type (plus/gold/platinum)
    - status (active/expired/cancelled)

---

## 🚀 Setup Backend

### 1. Install Dependencies
```bash
cd api
composer install
```

### 2. Konfigurasi Environment
```bash
cp .env.example .env
```

Edit `.env`:
```
APP_NAME="W3Dating API"
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=w3dating
DB_USERNAME=root
DB_PASSWORD=

FILESYSTEM_DISK=public
```

### 3. Generate Key & Link Storage
```bash
php artisan key:generate
php artisan storage:link
```

### 4. Jalankan Migration & Seeder
```bash
php artisan migrate:fresh
php artisan db:seed --class=InterestSeeder
```

### 5. Install Sanctum (API Authentication)
```bash
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
```

### 6. Jalankan Server
```bash
php artisan serve
```

API akan berjalan di: `http://localhost:8000`

---

## 📡 API Endpoints

### **Authentication**

#### 1. Send OTP
```
POST /api/auth/send-otp
```
**Body:**
```json
{
  "phone_number": "812345678",
  "country_code": "+61"
}
```
**Response:**
```json
{
  "success": true,
  "message": "OTP sent successfully",
  "otp": "123456"
}
```

#### 2. Verify OTP
```
POST /api/auth/verify-otp
```
**Body:**
```json
{
  "phone_number": "812345678",
  "otp_code": "123456"
}
```
**Response:**
```json
{
  "success": true,
  "token": "1|abc123...",
  "user": {...},
  "has_profile": false
}
```

#### 3. Get Current User
```
GET /api/auth/me
Authorization: Bearer {token}
```

#### 4. Logout
```
POST /api/auth/logout
Authorization: Bearer {token}
```

---

### **Profile Management**

#### 1. Create Profile
```
POST /api/profile/create
Authorization: Bearer {token}
```
**Body:**
```json
{
  "first_name": "John",
  "birth_date": "1995-05-20",
  "gender": "Men",
  "sexual_orientation": "Straight",
  "interested_in": ["Women"],
  "looking_for": "Long-term partner",
  "bio": "Love traveling and coding",
  "occupation": "Software Engineer",
  "language": "English",
  "latitude": -6.2088,
  "longitude": 106.8456,
  "city": "Jakarta"
}
```

#### 2. Update Profile
```
PUT /api/profile/update
Authorization: Bearer {token}
```

#### 3. Upload Photos
```
POST /api/profile/photos
Authorization: Bearer {token}
Content-Type: multipart/form-data
```
**Body:**
```
photos[]: [file1.jpg, file2.jpg, ...]
```

#### 4. Delete Photo
```
DELETE /api/profile/photos/{photoId}
Authorization: Bearer {token}
```

#### 5. Update Interests
```
POST /api/profile/interests
Authorization: Bearer {token}
```
**Body:**
```json
{
  "interest_ids": [1, 5, 8, 12]
}
```

#### 6. Get All Interests
```
GET /api/interests
Authorization: Bearer {token}
```

---

### **Swipe & Discovery**

#### 1. Get Profiles to Swipe
```
GET /api/swipe/profiles
Authorization: Bearer {token}
```
**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 5,
      "profile": {...},
      "photos": [...],
      "interests": [...],
      "distance": "5.2 km"
    }
  ]
}
```

#### 2. Swipe (Like/Dislike)
```
POST /api/swipe
Authorization: Bearer {token}
```
**Body:**
```json
{
  "target_user_id": 5,
  "type": "like"
}
```
**Types:** `like`, `dislike`, `super_like`

**Response:**
```json
{
  "success": true,
  "is_match": true,
  "match_data": {...}
}
```

---

### **Matches**

#### 1. Get My Matches
```
GET /api/matches
Authorization: Bearer {token}
```

#### 2. Get Users Who Liked Me
```
GET /api/matches/liked-me
Authorization: Bearer {token}
```

#### 3. Get Match Detail
```
GET /api/matches/{userId}
Authorization: Bearer {token}
```

---

### **Chat**

#### 1. Get Chat List
```
GET /api/chat/list
Authorization: Bearer {token}
```

#### 2. Get Messages with User
```
GET /api/chat/{userId}/messages
Authorization: Bearer {token}
```

#### 3. Send Message
```
POST /api/chat/{userId}/send
Authorization: Bearer {token}
```
**Body:**
```json
{
  "message": "Hello! How are you?"
}
```

---

### **Filter**

#### 1. Get My Filter
```
GET /api/filter
Authorization: Bearer {token}
```

#### 2. Update Filter
```
PUT /api/filter
Authorization: Bearer {token}
```
**Body:**
```json
{
  "show_men": true,
  "show_women": false,
  "show_nonbinary": false,
  "age_min": 22,
  "age_max": 35,
  "distance_max": 30
}
```

---

### **Subscription**

#### 1. Get Plans
```
GET /api/subscription/plans
Authorization: Bearer {token}
```

#### 2. Subscribe
```
POST /api/subscription/subscribe
Authorization: Bearer {token}
```
**Body:**
```json
{
  "plan_type": "gold",
  "payment_method": "credit_card"
}
```

#### 3. Get My Subscription
```
GET /api/subscription/my
Authorization: Bearer {token}
```

#### 4. Cancel Subscription
```
POST /api/subscription/cancel
Authorization: Bearer {token}
```

---

## 🔐 Authentication

Semua endpoint kecuali `send-otp` dan `verify-otp` memerlukan authentication token.

**Header:**
```
Authorization: Bearer {token}
```

Token didapat dari response `verify-otp`.

---

## 📝 Alur Aplikasi

1. **Login/Register:**
   - User input nomor HP → Send OTP
   - Verify OTP → Dapat token

2. **Onboarding (First Time):**
   - Create profile (nama, tanggal lahir, gender, dll)
   - Upload 6 foto
   - Pilih interests
   - Set filter preferences

3. **Home Screen:**
   - Get profiles to swipe
   - Swipe like/dislike
   - Jika match → Show match screen

4. **Chat:**
   - Get chat list (semua matches)
   - Open chat → Get messages
   - Send message

5. **Wishlist:**
   - Get users who liked me

6. **Profile:**
   - View/edit profile
   - Manage photos
   - Update interests
   - Subscription management

---

## 🎯 Fitur Utama Backend

✅ **Authentication dengan OTP**
✅ **Profile Management dengan foto multiple**
✅ **Swipe Logic dengan auto-matching**
✅ **Distance-based filtering (GPS)**
✅ **Real-time chat messaging**
✅ **Interest-based matching**
✅ **Filter preferences**
✅ **Subscription management**

---

## 📦 Package yang Digunakan

- **Laravel Sanctum** - API Authentication
- **Laravel Storage** - File upload management
- **MySQL** - Database
- **Carbon** - Date handling

---

## 🔧 Customize

### Tambah Interest Baru
Edit `database/seeders/InterestSeeder.php`

### Ubah Harga Subscription
Edit `app/Http/Controllers/Api/SubscriptionController.php`

### Implementasi Payment Gateway
Edit method `subscribe()` di `SubscriptionController`

### Implementasi SMS Gateway
Edit method `sendOTP()` di `AuthController`

---

## 📱 Integrasi dengan Flutter

Di Flutter, gunakan package:
- `http` atau `dio` untuk API calls
- `shared_preferences` untuk simpan token
- `provider` atau `bloc` untuk state management

Contoh:
```dart
final response = await http.post(
  Uri.parse('http://localhost:8000/api/auth/verify-otp'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'phone_number': phoneNumber,
    'otp_code': otpCode,
  }),
);
```

---

## 🐛 Troubleshooting

1. **Error 500:** Check `.env` configuration
2. **Token tidak valid:** Pastikan header Authorization benar
3. **CORS Error:** Install `fruitcake/laravel-cors`
4. **Storage link error:** Run `php artisan storage:link`

---

## 👨‍💻 Development

Created for W3Dating App Flutter Project
Backend: Laravel 11
Database: MySQL
