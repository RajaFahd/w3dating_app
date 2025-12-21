# W3 Dating App - Project Documentation

## 📱 Project Overview

**W3 Dating App** adalah aplikasi kencan mobile yang dibangun dengan Flutter (frontend) dan Laravel (backend). Aplikasi ini menyediakan fitur swipe, matching, chat real-time, dan manajemen profil lengkap.

### 🎯 Tujuan Project
- Memberikan platform kencan modern dengan UI/UX yang intuitif
- Mendukung sistem matching berbasis preferensi dan lokasi
- Menyediakan komunikasi real-time antar pengguna yang matched
- Sistem authentication yang aman menggunakan OTP
- Multi-language dan multi-country support

---

## 🏗️ Arsitektur Sistem

### Technology Stack

#### Frontend
- **Framework**: Flutter SDK
- **State Management**: Provider Pattern
- **Networking**: HTTP package
- **Image Caching**: CachedNetworkImage
- **Local Storage**: SharedPreferences
- **UI Components**: Material Design

#### Backend
- **Framework**: Laravel 11
- **API**: RESTful API
- **Authentication**: Laravel Sanctum (Token-based)
- **Database**: MySQL
- **Real-time**: Polling (3 detik interval untuk chat)

### Arsitektur Layer
```
┌─────────────────────────────────────┐
│        Flutter Mobile App           │
│  (UI/UX Layer - Cross Platform)     │
└─────────────────┬───────────────────┘
                  │ HTTP/JSON API
┌─────────────────▼───────────────────┐
│      Laravel REST API Server        │
│  (Business Logic & Controllers)     │
└─────────────────┬───────────────────┘
                  │ Eloquent ORM
┌─────────────────▼───────────────────┐
│         MySQL Database              │
│    (Data Persistence Layer)         │
└─────────────────────────────────────┘
```

---

## ✨ Fitur Utama

### 1. Authentication & Onboarding
- **Phone Number Login**: Login menggunakan nomor telepon + OTP
- **Multi-Country Support**: 200+ negara dengan bendera dan kode negara
- **Verification**: OTP 6 digit untuk verifikasi
- **Onboarding Flow**: 
  - Enter phone number
  - OTP verification
  - First name
  - Birth date
  - Gender selection
  - Sexual orientation
  - Interested in (gender preference)
  - Looking for (relationship type)
  - Photo upload (multiple photos)

### 2. Profile Management
- **Profile Creation**: Lengkap dengan bio, city, language, interests
- **Multi-Photo Upload**: Support multiple profile photos dengan ordering
- **Interests Selection**: Pilih interest dari kategori predefined
- **Profile Editing**: Update semua informasi profil
- **Profile Completion**: Tracking kelengkapan profil

### 3. Discover & Swipe
- **Smart Matching Algorithm**:
  - Filter berdasarkan gender preference
  - Filter berdasarkan age range (min-max)
  - Filter berdasarkan distance (radius dalam km)
  - Calculate real distance menggunakan Haversine formula
- **Swipe Actions**:
  - Swipe Right (Like)
  - Swipe Left (Dislike)
  - Super Like
- **Match Detection**: Auto-detect mutual likes dan create match
- **Match Celebration**: Pop-up saat terjadi match baru
- **Auto Hello Message**: Kirim pesan "Hello" otomatis saat match

### 4. Matches & Likes
- **My Matches**: List semua mutual matches
- **Wishlist**: List profile yang sudah di-like
- **Unlike Feature**: Hapus like dari wishlist
- **Profile Detail**: View detail lengkap profile dengan bio, interests, language

### 5. Chat System
- **Real-time Messaging**: Chat dengan matches
- **Message Status**: Read/unread indicators
- **Online Status**: Show online/offline status
- **Message Polling**: Auto-refresh setiap 3 detik
- **Chat List**: List semua conversations dengan last message
- **Unread Badge**: Notification badge untuk unread messages

### 6. Filter & Preferences
- **Advanced Filters**:
  - Age range (18-99)
  - Distance range (1-500 km)
  - Gender preferences (Men, Women, Non-binary)
- **Save Preferences**: Persist filter settings

### 7. Explore
- **Browse Profiles**: Explore mode untuk lihat profile
- **Grid/List View**: Multiple view modes

---

## 📂 Struktur Project

### Frontend (Flutter)
```
lib/
├── main.dart                    # Entry point
├── config/
│   └── api_config.dart         # API base URL & timeout config
├── services/
│   └── api_service.dart        # HTTP client & API calls
├── providers/
│   ├── profile_provider.dart   # Profile state management
│   ├── swipe_provider.dart     # Swipe state management
│   └── chat_provider.dart      # Chat state management
├── welcome/                     # Onboarding & Auth screens
│   ├── onboarding_page.dart
│   ├── login_page.dart
│   ├── otp_page.dart
│   ├── first_name_page.dart
│   ├── birth_date_page.dart
│   ├── your_gender_page.dart
│   ├── orientation_page.dart
│   ├── interested_page.dart
│   ├── looking_for_page.dart
│   └── recent_pics_page.dart
├── home/
│   ├── home_screen.dart        # Main swipe screen
│   └── match_screen_page.dart  # Match popup
├── explore/
│   └── explore_screen.dart     # Explore profiles
├── chat/
│   ├── chat_list.dart          # Chat list
│   └── chat_screen.dart        # Chat conversation
├── wishlist/
│   ├── wishlist_screen.dart    # Liked profiles
│   └── profile_detail.dart     # Profile detail view
├── profile/
│   ├── profile_screen.dart     # Own profile
│   ├── edit_profile.dart       # Edit profile
│   ├── profile_filter_page.dart # Filter settings
│   ├── setting_page.dart       # App settings
│   └── subscription_page.dart  # Premium features
├── template/
│   └── app_bottom_navigation.dart # Bottom nav bar
└── theme/
    └── app_theme.dart          # App theming
```

### Backend (Laravel)
```
api/
├── app/
│   ├── Http/Controllers/Api/
│   │   ├── AuthController.php      # OTP login & verification
│   │   ├── ProfileController.php   # Profile CRUD
│   │   ├── SwipeController.php     # Swipe & matching logic
│   │   ├── MatchController.php     # Match management
│   │   ├── ChatController.php      # Chat messaging
│   │   └── FilterController.php    # User preferences
│   └── Models/
│       ├── User.php                # User model
│       ├── UserProfile.php         # Profile data
│       ├── Photo.php               # Photo uploads
│       ├── Interest.php            # Interest categories
│       ├── Swipe.php               # Swipe records
│       ├── UserMatch.php           # Match records
│       ├── Message.php             # Chat messages
│       └── Filter.php              # User filters
├── database/
│   ├── migrations/                 # Database schema
│   └── seeders/
│       └── UserSeeder.php          # Demo data
├── routes/
│   └── api.php                     # API routes
└── storage/
    └── app/public/                 # Uploaded photos
```

---

## 🗄️ Database Schema

### Users Table
```sql
- id (PK)
- phone_number (string, 20)
- country_code (string, 5)
- otp_code (string, 6, nullable)
- otp_verified_at (timestamp, nullable)
- is_active (boolean)
- last_active_at (timestamp)
- created_at, updated_at
UNIQUE: (phone_number, country_code)
```

### User Profiles Table
```sql
- id (PK)
- user_id (FK -> users.id)
- first_name (string)
- birth_date (date)
- gender (enum: Men, Women, Other)
- bio (text, nullable)
- city (string, nullable)
- language (string, nullable)
- interest (JSON array, nullable)
- latitude, longitude (decimal, nullable)
- created_at, updated_at
```

### Photos Table
```sql
- id (PK)
- user_id (FK -> users.id)
- photo_url (string)
- order (integer)
- created_at, updated_at
```

### Interests Table
```sql
- id (PK)
- name (string, unique)
- created_at, updated_at
```

### User Interests (Pivot)
```sql
- user_id (FK)
- interest_id (FK)
PRIMARY KEY: (user_id, interest_id)
```

### Swipes Table
```sql
- id (PK)
- user_id (FK -> users.id)
- target_user_id (FK -> users.id)
- type (enum: like, dislike, super_like)
- created_at, updated_at
UNIQUE: (user_id, target_user_id)
```

### User Matches Table
```sql
- id (PK)
- user_id (FK -> users.id)
- matched_user_id (FK -> users.id)
- created_at, updated_at
```

### Messages Table
```sql
- id (PK)
- sender_id (FK -> users.id)
- receiver_id (FK -> users.id)
- message (text)
- is_read (boolean)
- created_at, updated_at
INDEX: (sender_id, receiver_id)
```

### Filters Table
```sql
- id (PK)
- user_id (FK -> users.id)
- age_min, age_max (integer)
- distance_max (integer)
- show_men, show_women, show_nonbinary (boolean)
- created_at, updated_at
```

---

## 🔌 API Endpoints

### Authentication
```
POST   /api/auth/send-otp        # Send OTP to phone
POST   /api/auth/verify-otp      # Verify OTP & get token
POST   /api/auth/logout          # Logout user
GET    /api/auth/me              # Get current user
```

### Profile
```
GET    /api/profile/me           # Get my profile
POST   /api/profile/create       # Create new profile
PUT    /api/profile/update       # Update profile
POST   /api/profile/photos       # Upload photos
DELETE /api/profile/photos/{id}  # Delete photo
GET    /api/interests            # Get all interests
POST   /api/profile/interests    # Update user interests
```

### Swipe & Match
```
GET    /api/swipe/profiles       # Get profiles to swipe
POST   /api/swipe                # Record swipe action
GET    /api/swipes/my-likes      # Get profiles I liked
DELETE /api/swipes/unlike        # Remove like from wishlist
POST   /api/swipes/reset         # Reset dislikes
```

### Matches
```
GET    /api/matches              # Get my matches
GET    /api/matches/liked-me     # Get users who liked me
GET    /api/matches/{userId}     # Get match detail
```

### Chat
```
GET    /api/chat/list            # Get chat conversations
GET    /api/chat/{userId}/messages # Get messages with user
POST   /api/chat/{userId}/send   # Send message
```

### Filter
```
GET    /api/filter               # Get my filter settings
PUT    /api/filter               # Update filter settings
```

---

## 🎨 UI/UX Features

### Design System
- **Color Scheme**: Dark theme dengan pink accent (#FF3F80)
- **Typography**: Clean, modern fonts
- **Spacing**: Consistent 8px grid system
- **Animations**: Smooth transitions dan micro-interactions

### Key UI Components
1. **Swipe Cards**: Draggable cards dengan feedback overlay
2. **Bottom Navigation**: 5 tabs (Home, Explore, Wishlist, Chat, Profile)
3. **Match Popup**: Celebration screen saat match
4. **Country Picker**: Dialog dengan flag icons
5. **Photo Upload**: Multi-select dengan preview
6. **Interest Chips**: Multi-select chips untuk interests
7. **Chat Bubbles**: Differentiated sent/received messages
8. **Profile Cards**: Grid/list view dengan photo + basic info

---

## 🚀 Setup & Installation

### Prerequisites
- Flutter SDK (latest stable)
- PHP 8.1+
- Composer
- MySQL 8.0+
- Android Studio / Xcode (untuk emulator)

### Backend Setup
```bash
cd api

# Install dependencies
composer install

# Copy environment file
cp .env.example .env

# Generate app key
php artisan key:generate

# Configure database in .env
# DB_DATABASE=w3dating
# DB_USERNAME=root
# DB_PASSWORD=

# Run migrations
php artisan migrate

# Seed demo data (optional)
php artisan db:seed

# Create storage symlink
php artisan storage:link

# Start server
php artisan serve
```

### Frontend Setup
```bash
# Install dependencies
flutter pub get

# Configure API endpoint in lib/config/api_config.dart
# static const String baseUrl = 'http://127.0.0.1:8000/api';

# Run app
flutter run
```

---

## 📊 Key Features Implementation

### 1. Smart Matching Algorithm
```
Level 1: Filter by preferred gender + age + distance
Level 2: If no results, show other genders
Level 3: If still no results, show previously liked profiles
```

### 2. Distance Calculation
Menggunakan **Haversine Formula** untuk menghitung jarak real antara 2 koordinat GPS:
```php
$distance = 6371 * acos(
    cos(radians($lat1)) * cos(radians($lat2)) * 
    cos(radians($lon2) - radians($lon1)) + 
    sin(radians($lat1)) * sin(radians($lat2))
);
```

### 3. Auto-Match Detection
Menggunakan **Eloquent Model Events** (Observer pattern):
```php
// Saat user A like user B
// Check: apakah B sudah like A?
// Jika yes: Create match + Send auto "Hello" message
```

### 4. Multi-Country Support
- 200+ negara dengan flag icons (flagcdn.com)
- Composite unique constraint: (phone_number, country_code)
- Support untuk nomor yang sama di negara berbeda

---

## 🔄 User Flow

### Onboarding Flow
```
Launch App
    ↓
Splash Screen
    ↓
Onboarding (3 slides)
    ↓
Login (Phone + Country Code)
    ↓
OTP Verification
    ↓
First Name
    ↓
Birth Date
    ↓
Gender Selection
    ↓
Sexual Orientation
    ↓
Interested In
    ↓
Looking For
    ↓
Upload Photos
    ↓
Create Profile + Redirect to Home
```

### Main App Flow
```
Home Screen (Swipe)
    ├─ Like → Check Match → Show Match Popup → Send Auto Message
    ├─ Dislike → Next Profile
    └─ Super Like → Same as Like (dengan badge special)

Wishlist
    ├─ View Liked Profiles
    ├─ Tap Profile → Profile Detail
    └─ Unlike → Remove from Wishlist

Matches
    ├─ View All Matches
    ├─ Tap Match → Chat Screen
    └─ Chat → Send/Receive Messages

Profile
    ├─ View Own Profile
    ├─ Edit Profile
    ├─ Settings (Filter, Subscription, Logout)
    └─ Logout → Back to Login
```

---

## 🎯 Demo Login Credentials

### Demo Users (After Seeding)
```
User 1: +62 811111111 (OTP: any 6 digits)
User 2: +62 822222222
User 3: +62 833333333
User 4: +62 844444444
User 5: +62 855555555
```

**Note**: Dalam development mode, OTP apapun akan diterima untuk testing.

---

## 📈 Performance Optimizations

### Frontend
1. **Image Caching**: CachedNetworkImage untuk cache gambar profile
2. **Lazy Loading**: ListView.builder untuk efficient rendering
3. **State Management**: Provider untuk reactive state
4. **API Throttling**: Debounce untuk prevent spam requests

### Backend
1. **Eager Loading**: with() untuk reduce N+1 queries
2. **Database Indexing**: Index pada foreign keys dan search fields
3. **Query Optimization**: whereHas() dengan subquery optimization
4. **Distance Filtering**: Direct SQL calculation untuk speed

---

## 🔐 Security Features

1. **Token-based Auth**: Laravel Sanctum dengan Bearer token
2. **OTP Verification**: 6-digit OTP untuk phone verification
3. **Input Validation**: Request validation di semua endpoints
4. **SQL Injection Protection**: Eloquent ORM dengan parameterized queries
5. **CORS Protection**: Configured CORS headers
6. **Rate Limiting**: API throttling untuk prevent abuse

---

## 🐛 Known Issues & Future Improvements

### Current Limitations
1. OTP sending belum terintegrasi dengan SMS gateway (development mode)
2. Real-time chat menggunakan polling (belum WebSocket/Pusher)
3. Photo compression belum diimplementasikan
4. Belum ada moderation system untuk photos/messages

### Future Enhancements
1. **Real-time Chat**: Implement WebSocket/Pusher
2. **Video Calls**: Integrate WebRTC
3. **Stories Feature**: Instagram-like stories
4. **Premium Features**: Super likes limit, see who liked you
5. **AI Matching**: ML-based recommendation system
6. **Social Login**: Google, Facebook, Apple sign-in
7. **Multi-language UI**: i18n support
8. **Push Notifications**: FCM integration
9. **Photo Verification**: Face verification untuk autentikasi
10. **Report & Block**: Safety features

---

## 📝 Testing

### Manual Testing Checklist
- [ ] Login dengan phone number baru
- [ ] Complete onboarding flow
- [ ] Upload multiple photos
- [ ] Swipe profiles (like/dislike)
- [ ] Create match dengan mutual like
- [ ] Send/receive messages
- [ ] Edit profile information
- [ ] Update filter preferences
- [ ] View wishlist
- [ ] Unlike from wishlist
- [ ] Logout dan login kembali

---

## 📞 Support & Documentation

### File Dokumentasi
- `README.md` - General project info
- `QUICK_START.md` - Quick setup guide
- `API_INTEGRATION_STATUS.md` - API endpoint status
- `BACKEND_SUMMARY.md` - Backend architecture
- `DATABASE_STRUCTURE.md` - Database schema details
- `PROJECT_PRESENTATION.md` - This file

---

## 👥 Team & Credits

### Technologies Used
- **Flutter** - UI framework
- **Laravel** - Backend framework
- **MySQL** - Database
- **Flagcdn.com** - Country flags API
- **CachedNetworkImage** - Image caching
- **Provider** - State management

---

## 🎓 Kesimpulan

W3 Dating App adalah aplikasi kencan modern yang lengkap dengan fitur-fitur essential:
- ✅ Smart matching algorithm
- ✅ Real-time messaging
- ✅ Multi-country support
- ✅ Advanced filtering
- ✅ Intuitive UI/UX
- ✅ Secure authentication

Project ini mendemonstrasikan implementasi full-stack application dengan Flutter & Laravel, mencakup REST API design, database schema optimization, state management, dan user experience design.

---

**Last Updated**: December 22, 2025
**Version**: 1.0.0
**Status**: Development/MVP Complete
