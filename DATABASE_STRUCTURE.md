# 📊 Database Structure - W3Dating App

## ER Diagram (Entity Relationship)

```
┌─────────────┐         ┌──────────────────┐
│   USERS     │────1:1──│  USER_PROFILES   │
└─────────────┘         └──────────────────┘
      │                          │
      │ 1:N                      │
      ▼                          │
┌─────────────┐                 │
│ USER_PHOTOS │                 │
└─────────────┘                 │
                                │
      ┌─────────────────────────┘
      │
      │ N:M (pivot: user_interests)
      ▼
┌─────────────┐
│  INTERESTS  │
└─────────────┘

┌─────────────┐         ┌──────────────────┐
│   USERS     │────1:N──│     SWIPES       │
└─────────────┘         └──────────────────┘
      │                          │
      │                          │ (auto create on mutual like)
      │                          ▼
      │                   ┌──────────────────┐
      └──────────1:N─────│     MATCHES      │
                          └──────────────────┘
                                 │
                                 │ 1:N
                                 ▼
                          ┌──────────────────┐
                          │    MESSAGES      │
                          └──────────────────┘

┌─────────────┐         ┌──────────────────┐
│   USERS     │────1:1──│  USER_FILTERS    │
└─────────────┘         └──────────────────┘

┌─────────────┐         ┌──────────────────┐
│   USERS     │────1:1──│  SUBSCRIPTIONS   │
└─────────────┘         └──────────────────┘
```

## Tabel Details

### 1. **users**
```sql
- id (PK)
- phone_number (unique)
- country_code
- otp_code
- otp_verified_at
- is_active
- last_active_at
- created_at
- updated_at
```

### 2. **user_profiles**
```sql
- id (PK)
- user_id (FK → users.id)
- first_name
- birth_date
- gender (Men/Women/Other)
- sexual_orientation
- interested_in (JSON: ["Men", "Women"])
- looking_for
- bio
- occupation
- language
- latitude (untuk distance matching)
- longitude
- city
- profile_completion (0-100%)
- created_at
- updated_at
```

### 3. **user_photos**
```sql
- id (PK)
- user_id (FK → users.id)
- photo_url
- order (1-6)
- is_primary
- created_at
- updated_at
```

### 4. **interests**
```sql
- id (PK)
- name
- icon
- created_at
- updated_at
```

### 5. **user_interests** (Pivot Table)
```sql
- id (PK)
- user_id (FK → users.id)
- interest_id (FK → interests.id)
- created_at
- updated_at
```

### 6. **swipes**
```sql
- id (PK)
- user_id (FK → users.id)
- target_user_id (FK → users.id)
- type (like/dislike/super_like)
- created_at
- updated_at
```

### 7. **matches**
```sql
- id (PK)
- user_id (FK → users.id)
- matched_user_id (FK → users.id)
- created_at
- updated_at
```

### 8. **messages**
```sql
- id (PK)
- sender_id (FK → users.id)
- receiver_id (FK → users.id)
- message (text)
- is_read
- read_at
- created_at
- updated_at
```

### 9. **user_filters**
```sql
- id (PK)
- user_id (FK → users.id)
- show_men
- show_women
- show_nonbinary
- age_min
- age_max
- distance_max (km)
- created_at
- updated_at
```

### 10. **subscriptions**
```sql
- id (PK)
- user_id (FK → users.id)
- plan_type (plus/gold/platinum)
- status (active/expired/cancelled)
- started_at
- expires_at
- amount
- currency
- created_at
- updated_at
```

---

## Business Logic

### **Swipe & Match Logic:**
1. User A swipe like → create record di `swipes`
2. Cek apakah User B sudah like User A
3. Jika mutual like → auto create 2 records di `matches`:
   - User A → User B
   - User B → User A
4. Return `is_match: true` dengan data User B

### **Profile Completion Logic:**
Dihitung dari:
- 70% dari kelengkapan fields profile
- 30% dari jumlah foto (max 6)

Formula:
```
completion = (filled_fields / total_fields) * 0.7 + (photos_count / 6) * 0.3
```

### **Distance Matching:**
Menggunakan Haversine formula untuk hitung jarak GPS:
```php
distance = 2 * R * asin(sqrt(
  sin²((lat2-lat1)/2) + cos(lat1) * cos(lat2) * sin²((lon2-lon1)/2)
))
```

### **Filter Matching:**
Query kandidat berdasarkan:
1. Gender preferences (show_men, show_women, show_nonbinary)
2. Age range (age_min - age_max)
3. Distance (distance_max dalam km)
4. Exclude yang sudah di-swipe

---

## Indexes untuk Performance

```sql
-- users
INDEX idx_phone (phone_number)
INDEX idx_active (is_active)

-- user_profiles
INDEX idx_user (user_id)
INDEX idx_gender (gender)
INDEX idx_location (latitude, longitude)

-- swipes
INDEX idx_user_target (user_id, target_user_id)
INDEX idx_type (type)

-- matches
INDEX idx_user_matched (user_id, matched_user_id)

-- messages
INDEX idx_sender_receiver (sender_id, receiver_id)
INDEX idx_unread (is_read)
```

---

## Sample Data

### **Interests:**
Photography, Tea, Travel, Acting, Work, Cooking, Basketball, Code, Sleep, IT, Hike, Music, Art, Reading, Gaming, Fitness, Yoga, Dancing, Movies, Food, Fashion, Shopping, Running, Swimming, Cycling, Camping, Writing, Singing, Painting

### **Sexual Orientations:**
Straight, Gay, Lesbian, Bisexual, Asexual, Queer, Demisexual

### **Looking For:**
- Long-term partner
- Long-term, open to short
- Short-term, open to long
- Short-term fun
- New friends
- Still figuring it out

---

## Migration Order

1. users
2. user_profiles
3. user_photos
4. interests
5. user_interests
6. swipes
7. matches
8. messages
9. user_filters
10. subscriptions

Semua migration sudah dibuat dengan foreign key constraints dan cascade delete.
