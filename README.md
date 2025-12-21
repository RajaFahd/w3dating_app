# 💖 W3Dating App

A modern, feature-rich dating application built with **Flutter** (Frontend) and **Laravel** (Backend API).

## 📱 Features

### User Features
- 📱 **OTP-based Authentication** - Secure phone number verification
- 👤 **Complete Profile** - Name, photos, interests, bio, occupation
- 📸 **Multiple Photos** - Upload up to 6 profile photos
- 🎯 **Interest Selection** - Choose from 30+ interests/hobbies
- 🔍 **Smart Matching** - Distance, age, gender-based filtering
- ❤️ **Swipe to Match** - Like, dislike, or super like profiles
- 💬 **Real-time Chat** - Message with your matches
- ⭐ **Wishlist** - See who liked you
- 🔎 **Advanced Filters** - Age range, distance, gender preferences
- 🎨 **Theme Support** - Light and dark mode
- 💎 **Premium Subscriptions** - Plus, Gold, Platinum tiers

### Technical Features
- 🔐 **JWT Authentication** with Laravel Sanctum
- 🗄️ **RESTful API** with 30+ endpoints
- 📊 **Complex Database** with 10 tables and multiple relations
- 🌍 **GPS-based Matching** using Haversine formula
- 📈 **Profile Completion** tracking
- 🔄 **Auto-Match System** on mutual likes
- 💾 **File Upload** handling for photos
- 🎯 **Smart Filtering** with multiple criteria

---

## 🏗️ Tech Stack

### Frontend (Mobile)
- **Flutter** 3.x
- **Dart** 3.x
- Material Design 3
- Image Picker for photo uploads
- HTTP client for API calls

### Backend (API)
- **Laravel** 11.x
- **PHP** 8.2+
- **MySQL** 8.0+
- **Laravel Sanctum** for authentication
- **Storage** for file uploads

---

## 📂 Project Structure

```
w3dating_app/
├── lib/                      # Flutter source code
│   ├── main.dart            # App entry point
│   ├── chat/                # Chat screens
│   ├── explore/             # Explore features
│   ├── home/                # Home & swipe screens
│   ├── profile/             # Profile management
│   ├── welcome/             # Onboarding & auth
│   ├── wishlist/            # Liked users
│   ├── template/            # Reusable widgets
│   └── theme/               # App theming
│
├── api/                      # Laravel backend
│   ├── app/
│   │   ├── Http/
│   │   │   └── Controllers/Api/  # 7 API controllers
│   │   └── Models/               # 9 Eloquent models
│   ├── database/
│   │   ├── migrations/           # 10 database tables
│   │   └── seeders/              # Interest seeder
│   ├── routes/
│   │   └── api.php              # 30+ API endpoints
│   └── storage/                 # Photo uploads
│
└── assets/                   # App assets
    └── images/              # Profile images

```

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.x
- Dart 3.x
- PHP 8.2+
- Composer
- MySQL 8.0+
- VS Code or Android Studio

### 1. Backend Setup

```bash
# Navigate to API folder
cd api

# Install dependencies
composer install

# Setup environment
copy .env.example .env

# Generate application key
php artisan key:generate

# Configure database in .env
DB_DATABASE=w3dating
DB_USERNAME=root
DB_PASSWORD=

# Run migrations
php artisan migrate:fresh

# Seed interests data
php artisan db:seed

# Link storage
php artisan storage:link

# Start server
php artisan serve
```

API will be available at: `http://localhost:8000`

### 2. Flutter Setup

```bash
# Install dependencies
flutter pub get

# Run app
flutter run
```

---

## 📚 Documentation

- 📘 **[Backend Setup Guide](SETUP_BACKEND.md)** - Detailed backend setup instructions
- 📗 **[API Documentation](api/README_BACKEND.md)** - Complete API reference
- 📕 **[Database Structure](DATABASE_STRUCTURE.md)** - Database schema & relations
- 📙 **[ERD Diagram](DATABASE_ERD.md)** - Entity relationship diagram
- 📓 **[Flutter Integration](FLUTTER_INTEGRATION.md)** - Mobile integration guide
- 📔 **[API Testing](API_TESTING.md)** - Postman collection & testing guide
- 📄 **[Production Checklist](PRODUCTION_CHECKLIST.md)** - Pre-launch checklist
- 🎉 **[Backend Summary](BACKEND_SUMMARY.md)** - Complete backend overview

---

## 🔗 API Endpoints

### Authentication
```
POST   /api/auth/send-otp      # Send OTP to phone
POST   /api/auth/verify-otp    # Verify OTP & login
GET    /api/auth/me            # Get current user
POST   /api/auth/logout        # Logout
```

### Profile
```
POST   /api/profile/create     # Create profile
PUT    /api/profile/update     # Update profile
POST   /api/profile/photos     # Upload photos
DELETE /api/profile/photos/:id # Delete photo
POST   /api/profile/interests  # Update interests
GET    /api/interests          # Get all interests
```

### Swipe & Match
```
GET    /api/swipe/profiles     # Get profiles to swipe
POST   /api/swipe              # Swipe like/dislike
GET    /api/matches            # Get my matches
GET    /api/matches/liked-me   # Get who liked me
```

### Chat
```
GET    /api/chat/list          # Get chat list
GET    /api/chat/:id/messages  # Get messages
POST   /api/chat/:id/send      # Send message
```

### Filter & Subscription
```
GET    /api/filter             # Get filter preferences
PUT    /api/filter             # Update filters
GET    /api/subscription/plans # Get subscription plans
POST   /api/subscription/subscribe # Subscribe
```

See full documentation: [API_TESTING.md](API_TESTING.md)

---

## 🗄️ Database Schema

### Main Tables:
- **users** - User accounts with phone authentication
- **user_profiles** - Complete profile information
- **user_photos** - Up to 6 photos per user
- **interests** - Master data for interests
- **user_interests** - User-interest relations
- **swipes** - Like/dislike history
- **matches** - Mutual likes
- **messages** - Chat messages
- **user_filters** - Search preferences
- **subscriptions** - Premium plans

See complete structure: [DATABASE_STRUCTURE.md](DATABASE_STRUCTURE.md)

---

## 🎯 App Flow

### 1. Onboarding
```
Phone Input → OTP Verification → Profile Creation
→ Photo Upload → Interest Selection → Filter Setup → Ready!
```

### 2. Matching
```
Browse Profiles → Swipe → If Mutual Like → Match! → Chat
```

### 3. Chat
```
Matches List → Select Match → View Messages → Send Message
```

---

## 🔐 Authentication

The app uses **OTP-based authentication**:
1. User enters phone number
2. Backend sends OTP (6-digit code)
3. User verifies OTP
4. Backend returns JWT token
5. Token used for all subsequent API requests

**Header format:**
```
Authorization: Bearer {token}
```

---

## 📸 Screenshots

| Onboarding | Home | Profile | Chat |
|------------|------|---------|------|
| Login flow | Swipe cards | User profile | Messages |

---

## 🔧 Configuration

### Backend (.env)
```env
APP_URL=http://localhost:8000
DB_DATABASE=w3dating
FILESYSTEM_DISK=public
```

### Flutter (api_service.dart)
```dart
static const String baseUrl = 'http://localhost:8000/api';
```

---

## 🧪 Testing

### Test API with Postman:
```bash
POST http://localhost:8000/api/auth/send-otp
{
  "phone_number": "812345678",
  "country_code": "+61"
}
```

Full testing guide: [API_TESTING.md](API_TESTING.md)

---

## 🚢 Deployment

### Backend:
1. Choose hosting (DigitalOcean, AWS, etc.)
2. Configure environment variables
3. Set up database
4. Run migrations
5. Configure SSL
6. Set up domain

### Mobile:
1. Update API base URL
2. Build APK/IPA
3. Upload to Play Store/App Store

See checklist: [PRODUCTION_CHECKLIST.md](PRODUCTION_CHECKLIST.md)

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

---

## 👨‍💻 Developer

Created with ❤️ for modern dating experience

---

## 📞 Support

For issues and questions:
- Create an issue on GitHub
- Email: support@w3dating.com
- Documentation: See files above

---

## 🎉 Acknowledgments

- Flutter team for amazing framework
- Laravel team for robust backend
- All open source contributors

---

**Happy Dating! 💕**
