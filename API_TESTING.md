# 🧪 API Testing Guide - Postman Collection

## Setup Postman Environment

Create environment variables:
```
base_url: http://localhost:8000/api
token: (will be set after login)
user_id: (will be set after login)
target_user_id: (for testing)
```

---

## 1. AUTHENTICATION

### 1.1 Send OTP
```
POST {{base_url}}/auth/send-otp
Content-Type: application/json

Body:
{
  "phone_number": "812345678",
  "country_code": "+61"
}

Response:
{
  "success": true,
  "message": "OTP sent successfully",
  "otp": "123456"
}
```

### 1.2 Verify OTP
```
POST {{base_url}}/auth/verify-otp
Content-Type: application/json

Body:
{
  "phone_number": "812345678",
  "otp_code": "123456"
}

Response:
{
  "success": true,
  "token": "1|abc123xyz...",
  "user": {...},
  "has_profile": false
}

Test Script:
pm.environment.set("token", pm.response.json().token);
pm.environment.set("user_id", pm.response.json().user.id);
```

### 1.3 Get Current User
```
GET {{base_url}}/auth/me
Authorization: Bearer {{token}}

Response:
{
  "success": true,
  "data": {
    "id": 1,
    "phone_number": "812345678",
    "profile": {...},
    "photos": [...],
    "interests": [...]
  }
}
```

### 1.4 Logout
```
POST {{base_url}}/auth/logout
Authorization: Bearer {{token}}

Response:
{
  "success": true,
  "message": "Logged out successfully"
}
```

---

## 2. PROFILE MANAGEMENT

### 2.1 Create Profile
```
POST {{base_url}}/profile/create
Authorization: Bearer {{token}}
Content-Type: application/json

Body:
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

Response:
{
  "success": true,
  "message": "Profile created successfully",
  "data": {...}
}
```

### 2.2 Update Profile
```
PUT {{base_url}}/profile/update
Authorization: Bearer {{token}}
Content-Type: application/json

Body:
{
  "bio": "Updated bio text",
  "occupation": "Senior Developer"
}

Response:
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {...}
}
```

### 2.3 Upload Photos
```
POST {{base_url}}/profile/photos
Authorization: Bearer {{token}}
Content-Type: multipart/form-data

Body (form-data):
photos[]: [file1.jpg]
photos[]: [file2.jpg]
photos[]: [file3.jpg]

Response:
{
  "success": true,
  "message": "Photos uploaded successfully",
  "data": [
    {
      "id": 1,
      "photo_url": "/storage/profiles/abc123.jpg",
      "order": 1
    }
  ]
}
```

### 2.4 Delete Photo
```
DELETE {{base_url}}/profile/photos/1
Authorization: Bearer {{token}}

Response:
{
  "success": true,
  "message": "Photo deleted successfully"
}
```

### 2.5 Get All Interests
```
GET {{base_url}}/interests
Authorization: Bearer {{token}}

Response:
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Photography",
      "icon": null
    },
    {
      "id": 2,
      "name": "Travel",
      "icon": null
    }
  ]
}
```

### 2.6 Update User Interests
```
POST {{base_url}}/profile/interests
Authorization: Bearer {{token}}
Content-Type: application/json

Body:
{
  "interest_ids": [1, 5, 8, 12]
}

Response:
{
  "success": true,
  "message": "Interests updated successfully",
  "data": [...]
}
```

---

## 3. SWIPE & DISCOVERY

### 3.1 Get Profiles to Swipe
```
GET {{base_url}}/swipe/profiles
Authorization: Bearer {{token}}

Response:
{
  "success": true,
  "data": [
    {
      "id": 5,
      "profile": {
        "first_name": "Sarah",
        "age": 25,
        "bio": "Love music",
        "city": "Jakarta"
      },
      "photos": [
        {
          "photo_url": "/storage/profiles/xyz.jpg"
        }
      ],
      "interests": [
        {"name": "Music"},
        {"name": "Travel"}
      ],
      "distance": "5.2 km"
    }
  ]
}

Test Script:
if (pm.response.json().data.length > 0) {
  pm.environment.set("target_user_id", pm.response.json().data[0].id);
}
```

### 3.2 Swipe Like
```
POST {{base_url}}/swipe
Authorization: Bearer {{token}}
Content-Type: application/json

Body:
{
  "target_user_id": 5,
  "type": "like"
}

Response (No Match):
{
  "success": true,
  "message": "Swipe recorded successfully",
  "is_match": false,
  "match_data": null
}

Response (Match!):
{
  "success": true,
  "message": "Swipe recorded successfully",
  "is_match": true,
  "match_data": {
    "id": 5,
    "profile": {...},
    "photos": [...]
  }
}
```

### 3.3 Swipe Dislike
```
POST {{base_url}}/swipe
Authorization: Bearer {{token}}
Content-Type: application/json

Body:
{
  "target_user_id": 6,
  "type": "dislike"
}
```

### 3.4 Super Like
```
POST {{base_url}}/swipe
Authorization: Bearer {{token}}
Content-Type: application/json

Body:
{
  "target_user_id": 7,
  "type": "super_like"
}
```

---

## 4. MATCHES

### 4.1 Get My Matches
```
GET {{base_url}}/matches
Authorization: Bearer {{token}}

Response:
{
  "success": true,
  "data": [
    {
      "match_id": 1,
      "user_id": 5,
      "name": "Sarah",
      "age": 25,
      "photo": "/storage/profiles/xyz.jpg",
      "city": "Jakarta",
      "matched_at": "2 hours ago"
    }
  ]
}
```

### 4.2 Get Users Who Liked Me
```
GET {{base_url}}/matches/liked-me
Authorization: Bearer {{token}}

Response:
{
  "success": true,
  "data": [
    {
      "user_id": 8,
      "name": "Emma",
      "age": 23,
      "photo": "/storage/profiles/abc.jpg",
      "bio": "Love hiking",
      "occupation": "Designer"
    }
  ]
}
```

### 4.3 Get Match Detail
```
GET {{base_url}}/matches/5
Authorization: Bearer {{token}}

Response:
{
  "success": true,
  "data": {
    "user_id": 5,
    "profile": {...},
    "photos": [...],
    "interests": [...],
    "distance": "5.2 km",
    "matched_at": "2 hours ago"
  }
}
```

---

## 5. CHAT

### 5.1 Get Chat List
```
GET {{base_url}}/chat/list
Authorization: Bearer {{token}}

Response:
{
  "success": true,
  "data": [
    {
      "user_id": 5,
      "name": "Sarah",
      "avatar": "/storage/profiles/xyz.jpg",
      "last_message": "Hey! How are you?",
      "last_message_time": "5 minutes ago",
      "is_online": true,
      "unread_count": 2
    }
  ]
}
```

### 5.2 Get Messages with User
```
GET {{base_url}}/chat/5/messages
Authorization: Bearer {{token}}

Response:
{
  "success": true,
  "data": [
    {
      "id": 1,
      "message": "Hey! How are you?",
      "is_mine": false,
      "time": "10:30",
      "is_read": true,
      "created_at": "2024-01-01T10:30:00Z"
    },
    {
      "id": 2,
      "message": "I'm good, thanks!",
      "is_mine": true,
      "time": "10:32",
      "is_read": false,
      "created_at": "2024-01-01T10:32:00Z"
    }
  ]
}
```

### 5.3 Send Message
```
POST {{base_url}}/chat/5/send
Authorization: Bearer {{token}}
Content-Type: application/json

Body:
{
  "message": "Would you like to grab coffee sometime?"
}

Response:
{
  "success": true,
  "message": "Message sent successfully",
  "data": {
    "id": 3,
    "message": "Would you like to grab coffee sometime?",
    "is_mine": true,
    "time": "10:35",
    "created_at": "2024-01-01T10:35:00Z"
  }
}
```

---

## 6. FILTER

### 6.1 Get My Filter
```
GET {{base_url}}/filter
Authorization: Bearer {{token}}

Response:
{
  "success": true,
  "data": {
    "id": 1,
    "user_id": 1,
    "show_men": false,
    "show_women": true,
    "show_nonbinary": false,
    "age_min": 18,
    "age_max": 50,
    "distance_max": 50
  }
}
```

### 6.2 Update Filter
```
PUT {{base_url}}/filter
Authorization: Bearer {{token}}
Content-Type: application/json

Body:
{
  "show_men": false,
  "show_women": true,
  "show_nonbinary": false,
  "age_min": 22,
  "age_max": 35,
  "distance_max": 30
}

Response:
{
  "success": true,
  "message": "Filter updated successfully",
  "data": {...}
}
```

---

## 7. SUBSCRIPTION

### 7.1 Get Plans
```
GET {{base_url}}/subscription/plans
Authorization: Bearer {{token}}

Response:
{
  "success": true,
  "data": [
    {
      "type": "plus",
      "name": "W3Dating Plus",
      "price": 9.99,
      "currency": "USD",
      "duration": "1 month",
      "features": [
        "Unlimited Likes",
        "See who likes you",
        "5 Super Likes per day"
      ]
    },
    {
      "type": "gold",
      "name": "W3Dating Gold",
      "price": 19.99,
      "features": [...]
    },
    {
      "type": "platinum",
      "name": "W3Dating Platinum",
      "price": 29.99,
      "features": [...]
    }
  ]
}
```

### 7.2 Subscribe
```
POST {{base_url}}/subscription/subscribe
Authorization: Bearer {{token}}
Content-Type: application/json

Body:
{
  "plan_type": "gold",
  "payment_method": "credit_card"
}

Response:
{
  "success": true,
  "message": "Subscription created successfully",
  "data": {
    "id": 1,
    "user_id": 1,
    "plan_type": "gold",
    "status": "active",
    "started_at": "2024-01-01T00:00:00Z",
    "expires_at": "2024-02-01T00:00:00Z",
    "amount": "19.99"
  }
}
```

### 7.3 Get My Subscription
```
GET {{base_url}}/subscription/my
Authorization: Bearer {{token}}

Response:
{
  "success": true,
  "data": {
    "id": 1,
    "plan_type": "gold",
    "status": "active",
    "expires_at": "2024-02-01T00:00:00Z"
  }
}
```

### 7.4 Cancel Subscription
```
POST {{base_url}}/subscription/cancel
Authorization: Bearer {{token}}

Response:
{
  "success": true,
  "message": "Subscription cancelled successfully"
}
```

---

## Error Responses

### 400 Bad Request
```json
{
  "success": false,
  "message": "Validation error",
  "errors": {
    "phone_number": ["The phone number field is required."]
  }
}
```

### 401 Unauthorized
```json
{
  "success": false,
  "message": "Unauthenticated"
}
```

### 403 Forbidden
```json
{
  "success": false,
  "message": "This feature requires gold subscription or higher",
  "current_plan": "plus",
  "required_plan": "gold"
}
```

### 404 Not Found
```json
{
  "success": false,
  "message": "Resource not found"
}
```

### 500 Server Error
```json
{
  "success": false,
  "message": "Internal server error"
}
```

---

## Full Test Flow

### Complete User Journey:
```
1. Send OTP → Get OTP code
2. Verify OTP → Get token (save to environment)
3. Get Interests → See available interests
4. Create Profile → Set up profile data
5. Upload Photos → Add 3-6 photos
6. Update Interests → Select 3-5 interests
7. Get Filter → See current filter
8. Update Filter → Set preferences
9. Get Profiles → See candidates
10. Swipe (like user A) → No match yet
11. Swipe (like user B) → MATCH!
12. Get Matches → See all matches
13. Get Chat List → See conversations
14. Get Messages → Load chat with user B
15. Send Message → Chat with match
16. Get Plans → See subscription options
17. Subscribe → Upgrade to premium
18. Logout → End session
```

### Quick Test Sequence:
```bash
# Run in order:
1. Send OTP
2. Verify OTP (save token)
3. Create Profile
4. Get Profiles
5. Swipe
6. Get Matches
7. Send Message
```

---

## Import to Postman

1. Open Postman
2. Click "Import"
3. Copy-paste request examples above
4. Create environment variables
5. Run tests sequentially

---

## Testing Tips

✅ Always set token in environment after login
✅ Use Test Scripts to auto-save variables
✅ Test error cases (invalid token, missing fields)
✅ Test pagination if implemented
✅ Check response times
✅ Verify data types match documentation
✅ Test with different user accounts
✅ Test concurrent requests

---

Happy Testing! 🧪
