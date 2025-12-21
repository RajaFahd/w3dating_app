# 🏗️ ERD (Entity Relationship Diagram) - W3Dating Database

## Visual Database Structure

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         W3DATING DATABASE SCHEMA                         │
└─────────────────────────────────────────────────────────────────────────┘

┌──────────────────┐
│      USERS       │
├──────────────────┤
│ 🔑 id            │
│ 📱 phone_number  │──┐
│    country_code  │  │
│    otp_code      │  │ 1:1
│    is_active     │  │
│    last_active   │  ▼
└──────────────────┘  ┌─────────────────────┐
        │             │   USER_PROFILES     │
        │             ├─────────────────────┤
        │ 1:N         │ 🔑 id               │
        │             │ 🔗 user_id          │
        ▼             │    first_name       │
┌──────────────────┐ │    birth_date       │
│   USER_PHOTOS    │ │    gender           │
├──────────────────┤ │    sexual_orient... │
│ 🔑 id            │ │    interested_in[]  │
│ 🔗 user_id       │ │    looking_for      │
│    photo_url     │ │    bio              │
│    order         │ │    occupation       │
│    is_primary    │ │    📍 latitude      │
└──────────────────┘ │    📍 longitude     │
                     │    city             │
                     │    profile_compl... │
                     └─────────────────────┘

┌──────────────────┐
│    INTERESTS     │
├──────────────────┤         N:M
│ 🔑 id            │◄──────────────┐
│    name          │               │
│    icon          │         ┌─────┴────────────┐
└──────────────────┘         │  USER_INTERESTS  │
                             ├──────────────────┤
                             │ 🔑 id            │
                             │ 🔗 user_id       │
                             │ 🔗 interest_id   │
                             └──────────────────┘
                                       ▲
                                       │
                              ┌────────┘
                              │
┌──────────────────┐          │
│      USERS       │──────────┘
└──────────────────┘


┌──────────────────┐         ┌─────────────────┐
│      USERS       │─────┬──►│     SWIPES      │
└──────────────────┘  1:N│   ├─────────────────┤
                         │   │ 🔑 id           │
                         │   │ 🔗 user_id      │
                         │   │ 🔗 target_user  │
                         │   │    type         │
                         │   └─────────────────┘
                         │           │
                         │           │ auto create on mutual
                         │           ▼
                         │   ┌─────────────────┐
                         └──►│     MATCHES     │
                             ├─────────────────┤
                             │ 🔑 id           │
                             │ 🔗 user_id      │
                             │ 🔗 matched_user │
                             └─────────────────┘
                                     │
                                     │ 1:N
                                     ▼
                             ┌─────────────────┐
                             │    MESSAGES     │
                             ├─────────────────┤
                             │ 🔑 id           │
                             │ 🔗 sender_id    │
                             │ 🔗 receiver_id  │
                             │    message      │
                             │    is_read      │
                             │    read_at      │
                             └─────────────────┘


┌──────────────────┐         ┌──────────────────┐
│      USERS       │────1:1──│  USER_FILTERS    │
└──────────────────┘         ├──────────────────┤
                             │ 🔑 id            │
                             │ 🔗 user_id       │
                             │    show_men      │
                             │    show_women    │
                             │    show_nonbinary│
                             │    age_min       │
                             │    age_max       │
                             │    distance_max  │
                             └──────────────────┘


┌──────────────────┐         ┌──────────────────┐
│      USERS       │────1:1──│  SUBSCRIPTIONS   │
└──────────────────┘         ├──────────────────┤
                             │ 🔑 id            │
                             │ 🔗 user_id       │
                             │    plan_type     │
                             │    status        │
                             │    started_at    │
                             │    expires_at    │
                             │    amount        │
                             │    currency      │
                             └──────────────────┘
```

---

## Relationships Detail

### 1. **USER → USER_PROFILE** (1:1)
```
users.id → user_profiles.user_id
One user has one profile
```

### 2. **USER → USER_PHOTOS** (1:N)
```
users.id → user_photos.user_id
One user has many photos (max 6)
```

### 3. **USER ↔ INTERESTS** (N:M via USER_INTERESTS)
```
users.id → user_interests.user_id
interests.id → user_interests.interest_id
Many users can have many interests
```

### 4. **USER → SWIPES** (1:N)
```
users.id → swipes.user_id
users.id → swipes.target_user_id
One user can swipe many users
```

### 5. **USER → MATCHES** (1:N)
```
users.id → matches.user_id
users.id → matches.matched_user_id
One user has many matches
```

### 6. **MATCH → MESSAGES** (1:N)
```
Implicit relationship:
Messages between matched users
sender_id + receiver_id form the match
```

### 7. **USER → USER_FILTER** (1:1)
```
users.id → user_filters.user_id
One user has one filter preference
```

### 8. **USER → SUBSCRIPTION** (1:1)
```
users.id → subscriptions.user_id
One user has one active subscription
```

---

## Data Flow Diagram

### Registration Flow:
```
1. Phone Input
   ↓
2. Send OTP → users (otp_code)
   ↓
3. Verify OTP → users (otp_verified_at)
   ↓
4. Create Profile → user_profiles
   ↓
5. Upload Photos → user_photos
   ↓
6. Select Interests → user_interests
   ↓
7. Set Filter → user_filters
   ↓
8. Ready to Swipe!
```

### Swipe & Match Flow:
```
1. Get Profiles (filtered by user_filters)
   ↓
2. User A swipes User B → swipes
   ↓
3. Check if User B already swiped User A
   ↓
4. IF mutual LIKE:
   ├─► Create match (A→B) → matches
   ├─► Create match (B→A) → matches
   └─► Return match notification
```

### Chat Flow:
```
1. Get Matches → matches
   ↓
2. Select Match → Get Messages
   ↓
3. Display conversation → messages
   ↓
4. Send Message → messages (new)
   ↓
5. Mark as read → messages (is_read = true)
```

---

## Indexes for Performance

```sql
-- High-traffic queries optimization

users:
  - PRIMARY KEY (id)
  - UNIQUE INDEX (phone_number)
  - INDEX (is_active)

user_profiles:
  - PRIMARY KEY (id)
  - INDEX (user_id)
  - INDEX (gender)
  - SPATIAL INDEX (latitude, longitude)

swipes:
  - PRIMARY KEY (id)
  - UNIQUE INDEX (user_id, target_user_id)
  - INDEX (user_id)
  - INDEX (target_user_id)
  - INDEX (type)

matches:
  - PRIMARY KEY (id)
  - UNIQUE INDEX (user_id, matched_user_id)
  - INDEX (user_id)
  - INDEX (matched_user_id)

messages:
  - PRIMARY KEY (id)
  - INDEX (sender_id, receiver_id)
  - INDEX (is_read)
  - INDEX (created_at)
```

---

## Cascade Delete Rules

```
users → DELETE CASCADE:
  ├─► user_profiles
  ├─► user_photos
  ├─► user_interests
  ├─► swipes
  ├─► matches
  ├─► messages
  ├─► user_filters
  └─► subscriptions

When user deleted, all related data automatically removed.
```

---

## JSON Fields

```json
user_profiles.interested_in:
["Men", "Women", "Other"]

Example profile:
{
  "first_name": "John",
  "gender": "Men",
  "interested_in": ["Women"],
  "latitude": -6.2088,
  "longitude": 106.8456
}
```

---

## Enum Values

```sql
user_profiles.gender:
  - 'Men'
  - 'Women'
  - 'Other'

swipes.type:
  - 'like'
  - 'dislike'
  - 'super_like'

subscriptions.plan_type:
  - 'plus'
  - 'gold'
  - 'platinum'

subscriptions.status:
  - 'active'
  - 'expired'
  - 'cancelled'
```

---

## Calculated Fields

### profile_completion (%)
```php
= (filled_fields / total_fields) * 70%
+ (photos_count / 6) * 30%
```

### age (years)
```sql
= YEAR(CURDATE()) - YEAR(birth_date)
```

### distance (km)
```php
Haversine Formula:
d = 2R × sin⁻¹(√[sin²(Δlat/2) + cos(lat1)×cos(lat2)×sin²(Δlon/2)])
R = 6371 km (Earth radius)
```

---

## Database Size Estimation

Based on 10,000 active users:

```
users:           10,000 × 200 bytes  = 2 MB
user_profiles:   10,000 × 500 bytes  = 5 MB
user_photos:     60,000 × 150 bytes  = 9 MB (6 per user)
interests:       50 × 100 bytes      = 5 KB
user_interests:  50,000 × 50 bytes   = 2.5 MB (5 per user avg)
swipes:          500,000 × 100 bytes = 50 MB (50 per user avg)
matches:         50,000 × 100 bytes  = 5 MB (5 per user avg)
messages:        1M × 200 bytes      = 200 MB (100 per user avg)
user_filters:    10,000 × 150 bytes  = 1.5 MB
subscriptions:   2,000 × 200 bytes   = 400 KB (20% premium)

TOTAL: ~275 MB (excluding photos)
Photos stored in storage/ (~50GB for 60K photos @ 1MB each)
```

---

## Backup Strategy

```bash
# Daily backup
mysqldump -u root -p w3dating > backup_$(date +%Y%m%d).sql

# Backup with photos
tar -czf backup_$(date +%Y%m%d).tar.gz backup.sql storage/app/public/profiles/
```

---

## Migration Order (Important!)

```
1. users              ← Base table
2. user_profiles      ← References users
3. user_photos        ← References users
4. interests          ← Standalone
5. user_interests     ← References users + interests
6. swipes             ← References users
7. matches            ← References users
8. messages           ← References users
9. user_filters       ← References users
10. subscriptions     ← References users
```

**Run in order to avoid foreign key errors!**

---

This ERD represents a complete, production-ready dating app database structure! 🎉
