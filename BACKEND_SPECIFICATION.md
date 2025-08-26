# Romantic App - Backend Specification

## 📊 **Total APIs: 49 Endpoints**

## 🏗️ **Technology Stack Recommendation**

### **Core Technologies:**
- **Runtime**: Node.js (v18+)
- **Framework**: Express.js
- **Database**: PostgreSQL (with Supabase or AWS RDS)
- **Authentication**: JWT + Redis for session management
- **File Storage**: AWS S3 or Supabase Storage
- **OTP**: WhatsApp Business API (Meta/Facebook)
- **Video Calls**: WebRTC + Socket.io for signaling
- **Real-time**: Socket.io
- **Payment**: Stripe
- **Email**: SendGrid or AWS SES

### **Additional Services:**
- **Caching**: Redis
- **Queue**: Bull (Redis-based)
- **Monitoring**: Winston + Sentry
- **Validation**: Joi
- **Security**: Helmet, CORS, Rate Limiting
- **WhatsApp**: Meta WhatsApp Business API SDK
- **WebRTC**: Socket.io for signaling server

---

## 🗄️ **Database Schema**

### **1. Users Table**
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    age INTEGER NOT NULL CHECK (age >= 18),
    gender VARCHAR(10) NOT NULL CHECK (gender IN ('male', 'female', 'other')),
    bio TEXT,
    location VARCHAR(100),
    profile_image_url TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    is_super_lover BOOLEAN DEFAULT FALSE,
    super_lover_status VARCHAR(20) DEFAULT 'offline' CHECK (super_lover_status IN ('online', 'ready', 'offline')),
    super_lover_bio TEXT,
    super_lover_rating DECIMAL(3,2) DEFAULT 0.0,
    super_lover_call_count INTEGER DEFAULT 0,
    coins_balance INTEGER DEFAULT 50,
    last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_online BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **2. OTP Table**
```sql
CREATE TABLE otp_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number VARCHAR(20) NOT NULL,
    otp_code VARCHAR(6) NOT NULL,
    delivery_method VARCHAR(20) DEFAULT 'whatsapp' CHECK (delivery_method IN ('whatsapp', 'sms', 'email')),
    whatsapp_message_id VARCHAR(100), -- Store WhatsApp message ID for tracking
    delivery_status VARCHAR(20) DEFAULT 'pending' CHECK (delivery_status IN ('pending', 'sent', 'delivered', 'failed')),
    expires_at TIMESTAMP NOT NULL,
    is_used BOOLEAN DEFAULT FALSE,
    attempts_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **3. User Sessions Table**
```sql
CREATE TABLE user_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    access_token TEXT NOT NULL,
    refresh_token TEXT NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **4. Coin Transactions Table**
```sql
CREATE TABLE coin_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('earn', 'spend', 'purchase', 'refund')),
    amount INTEGER NOT NULL,
    description TEXT,
    reference_id UUID, -- For linking to specific actions (calls, ads, etc.)
    reference_type VARCHAR(20), -- 'call', 'chat', 'ad_watch', 'purchase'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **5. Coin Packages Table**
```sql
CREATE TABLE coin_packages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) NOT NULL,
    coins INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **6. Calls Table**
```sql
CREATE TABLE calls (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    caller_id UUID REFERENCES users(id) ON DELETE CASCADE,
    receiver_id UUID REFERENCES users(id) ON DELETE CASCADE,
    call_type VARCHAR(10) NOT NULL CHECK (call_type IN ('audio', 'video')),
    status VARCHAR(20) NOT NULL CHECK (status IN ('initiated', 'ringing', 'answered', 'ended', 'missed', 'rejected')),
    duration_seconds INTEGER DEFAULT 0,
    coins_spent INTEGER DEFAULT 0,
    webrtc_room_id VARCHAR(100), -- WebRTC room identifier
    webrtc_offer TEXT, -- Store WebRTC offer SDP
    webrtc_answer TEXT, -- Store WebRTC answer SDP
    started_at TIMESTAMP,
    ended_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **7. Messages Table**
```sql
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
    receiver_id UUID REFERENCES users(id) ON DELETE CASCADE,
    message_text TEXT NOT NULL,
    message_type VARCHAR(20) DEFAULT 'text' CHECK (message_type IN ('text', 'image', 'audio', 'video')),
    media_url TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    coins_spent INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **8. User Interactions Table**
```sql
CREATE TABLE user_interactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    target_user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    interaction_type VARCHAR(20) NOT NULL CHECK (interaction_type IN ('like', 'pass', 'block', 'report')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, target_user_id, interaction_type)
);
```

### **9. User Preferences Table**
```sql
CREATE TABLE user_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE,
    notifications_push BOOLEAN DEFAULT TRUE,
    notifications_email BOOLEAN DEFAULT FALSE,
    notifications_sms BOOLEAN DEFAULT TRUE,
    privacy_profile_visibility VARCHAR(20) DEFAULT 'public',
    privacy_show_online_status BOOLEAN DEFAULT TRUE,
    privacy_show_last_seen BOOLEAN DEFAULT TRUE,
    app_theme VARCHAR(10) DEFAULT 'light',
    app_language VARCHAR(5) DEFAULT 'en',
    app_auto_play_videos BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **10. Reports Table**
```sql
CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id UUID REFERENCES users(id) ON DELETE CASCADE,
    reported_user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    reason VARCHAR(100) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'investigating', 'resolved', 'dismissed')),
    admin_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **11. Ad Views Table**
```sql
CREATE TABLE ad_views (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    ad_type VARCHAR(20) NOT NULL CHECK (ad_type IN ('rewarded', 'interstitial', 'banner')),
    coins_earned INTEGER DEFAULT 0,
    ad_provider VARCHAR(20) DEFAULT 'admob',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 🔌 **API Endpoints Specification**

### **1. Authentication APIs (6 endpoints)**

#### **1.1 Send OTP via WhatsApp**
```
POST /api/auth/send-otp
Content-Type: application/json

Request:
{
    "phoneNumber": "+1234567890",
    "deliveryMethod": "whatsapp" // Optional: defaults to "whatsapp"
}

Response:
{
    "success": true,
    "data": {
        "phoneNumber": "+1234567890",
        "deliveryMethod": "whatsapp",
        "whatsappMessageId": "wamid.xxx",
        "expiresAt": "2024-01-15T10:30:00Z",
        "estimatedDeliveryTime": "30 seconds"
    },
    "message": "OTP sent via WhatsApp successfully"
}
```

#### **1.2 Verify OTP**
```
POST /api/auth/verify-otp
Content-Type: application/json

Request:
{
    "phoneNumber": "+1234567890",
    "otpCode": "123456",
    "whatsappMessageId": "wamid.xxx" // Optional: for additional verification
}

Response:
{
    "success": true,
    "data": {
        "phoneNumber": "+1234567890",
        "isNewUser": true,
        "verificationMethod": "whatsapp",
        "accessToken": "jwt_token_here",
        "refreshToken": "refresh_token_here"
    },
    "message": "OTP verified successfully"
}
```

#### **1.3 Register User**
```
POST /api/auth/register
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "phoneNumber": "+1234567890",
    "fullName": "John Doe",
    "age": 25,
    "gender": "male",
    "bio": "Love traveling and coffee!",
    "location": "New York, NY"
}

Response:
{
    "success": true,
    "data": {
        "user": {
            "id": "uuid",
            "phoneNumber": "+1234567890",
            "fullName": "John Doe",
            "age": 25,
            "gender": "male",
            "bio": "Love traveling and coffee!",
            "location": "New York, NY",
            "coins": 50,
            "createdAt": "2024-01-15T10:30:00Z"
        },
        "accessToken": "jwt_token_here"
    },
    "message": "User registered successfully"
}
```

#### **1.4 Login User**
```
POST /api/auth/login
Content-Type: application/json

Request:
{
    "phoneNumber": "+1234567890"
}

Response:
{
    "success": true,
    "data": {
        "user": {
            "id": "uuid",
            "phoneNumber": "+1234567890",
            "fullName": "John Doe",
            "age": 25,
            "gender": "male",
            "bio": "Love traveling and coffee!",
            "location": "New York, NY",
            "coins": 150,
            "createdAt": "2024-01-15T10:30:00Z"
        },
        "accessToken": "jwt_token_here"
    },
    "message": "Login successful"
}
```

#### **1.5 Get User Profile**
```
GET /api/auth/profile
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "id": "uuid",
        "phoneNumber": "+1234567890",
        "fullName": "John Doe",
        "age": 25,
        "gender": "male",
        "bio": "Love traveling and coffee!",
        "location": "New York, NY",
        "profileImageUrl": "https://...",
        "isVerified": true,
        "isSuperLover": false,
        "coins": 150,
        "lastSeen": "2024-01-15T10:30:00Z",
        "isOnline": true,
        "createdAt": "2024-01-15T10:30:00Z"
    },
    "message": "Profile retrieved successfully"
}
```

#### **1.6 Logout**
```
POST /api/auth/logout
Authorization: Bearer <token>

Response:
{
    "success": true,
    "message": "Logged out successfully"
}
```

### **2. User Management APIs (8 endpoints)**

#### **2.1 Update Profile**
```
PUT /api/users/profile
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "fullName": "John Michael Doe",
    "age": 26,
    "gender": "male",
    "bio": "Updated bio",
    "location": "Los Angeles, CA"
}

Response:
{
    "success": true,
    "data": {
        "user": {
            "id": "uuid",
            "fullName": "John Michael Doe",
            "age": 26,
            "gender": "male",
            "bio": "Updated bio",
            "location": "Los Angeles, CA",
            "updatedAt": "2024-01-15T10:30:00Z"
        }
    },
    "message": "Profile updated successfully"
}
```

#### **2.2 Upload Profile Image**
```
POST /api/users/profile-image
Authorization: Bearer <token>
Content-Type: multipart/form-data

Request:
FormData with 'image' file

Response:
{
    "success": true,
    "data": {
        "imageUrl": "https://storage.example.com/profile-images/uuid.jpg"
    },
    "message": "Profile image uploaded successfully"
}
```

#### **2.3 Get Discover Profiles**
```
GET /api/users/discover?page=1&limit=10&gender=male&ageMin=20&ageMax=30
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "profiles": [
            {
                "id": "uuid",
                "fullName": "Sarah Johnson",
                "age": 25,
                "gender": "female",
                "bio": "Love adventure!",
                "location": "New York, NY",
                "profileImageUrl": "https://...",
                "isVerified": true,
                "isSuperLover": true,
                "superLoverStatus": "ready",
                "superLoverBio": "Professional Super Lover",
                "superLoverRating": 4.8,
                "superLoverCallCount": 127,
                "lastSeen": "2 min ago",
                "isOnline": true
            }
        ],
        "pagination": {
            "page": 1,
            "limit": 10,
            "total": 150,
            "hasNext": true
        }
    },
    "message": "Profiles retrieved successfully"
}
```

#### **2.4 Like User**
```
POST /api/users/like
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "targetUserId": "uuid"
}

Response:
{
    "success": true,
    "data": {
        "isMatch": true,
        "matchUser": {
            "id": "uuid",
            "fullName": "Sarah Johnson",
            "profileImageUrl": "https://..."
        }
    },
    "message": "It's a match! 🎉"
}
```

#### **2.5 Pass User**
```
POST /api/users/pass
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "targetUserId": "uuid"
}

Response:
{
    "success": true,
    "message": "User passed"
}
```

#### **2.6 Get Matches**
```
GET /api/users/matches
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "matches": [
            {
                "id": "uuid",
                "fullName": "Sarah Johnson",
                "profileImageUrl": "https://...",
                "lastMessage": "Hey there! 👋",
                "lastMessageTime": "2024-01-15T10:30:00Z",
                "unreadCount": 2
            }
        ]
    },
    "message": "Matches retrieved successfully"
}
```

#### **2.7 Block User**
```
POST /api/users/block
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "targetUserId": "uuid"
}

Response:
{
    "success": true,
    "message": "User blocked successfully"
}
```

#### **2.8 Report User**
```
POST /api/users/report
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "targetUserId": "uuid",
    "reason": "Inappropriate behavior",
    "description": "User sent inappropriate messages"
}

Response:
{
    "success": true,
    "message": "User reported successfully"
}
```

### **3. Super Lover APIs (8 endpoints)**

#### **3.1 Become Super Lover**
```
POST /api/super-lover/become
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "superLoverBio": "Professional Super Lover with 5+ years experience"
}

Response:
{
    "success": true,
    "data": {
        "user": {
            "id": "uuid",
            "isSuperLover": true,
            "superLoverBio": "Professional Super Lover with 5+ years experience",
            "coinsBalance": 0
        }
    },
    "message": "Congratulations! You are now a Super Lover!"
}
```

#### **3.2 Update Super Lover Status**
```
PUT /api/super-lover/status
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "status": "ready"
}

Response:
{
    "success": true,
    "data": {
        "status": "ready"
    },
    "message": "Status updated to: READY"
}
```

#### **3.3 Update Super Lover Bio**
```
PUT /api/super-lover/bio
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "bio": "Updated Super Lover bio"
}

Response:
{
    "success": true,
    "data": {
        "bio": "Updated Super Lover bio"
    },
    "message": "Bio updated successfully"
}
```

#### **3.4 Get Super Lover Statistics**
```
GET /api/super-lover/stats
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "rating": 4.8,
        "totalCalls": 127,
        "totalEarnings": 6350,
        "totalDuration": 2540,
        "averageCallDuration": 20,
        "monthlyEarnings": 1250
    },
    "message": "Statistics retrieved successfully"
}
```

#### **3.5 Get Available Super Lovers**
```
GET /api/super-lover/available?status=ready&page=1&limit=10
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "superLovers": [
            {
                "id": "uuid",
                "fullName": "Sarah Johnson",
                "age": 25,
                "gender": "female",
                "superLoverBio": "Professional Super Lover",
                "superLoverRating": 4.8,
                "superLoverCallCount": 127,
                "superLoverStatus": "ready",
                "profileImageUrl": "https://...",
                "isVerified": true
            }
        ],
        "pagination": {
            "page": 1,
            "limit": 10,
            "total": 45,
            "hasNext": true
        }
    },
    "message": "Super Lovers retrieved successfully"
}
```

#### **3.6 Check Can Become Super Lover**
```
GET /api/super-lover/can-become
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "canBecome": true,
        "requirements": {
            "isVerified": true,
            "minimumAge": 18,
            "userAge": 25,
            "coinsRequired": 1000,
            "userCoins": 1500
        }
    },
    "message": "Requirements checked successfully"
}
```

#### **3.7 Get Super Lover Requirements**
```
GET /api/super-lover/requirements
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "coinsRequired": 1000,
        "verificationRequired": true,
        "minimumAge": 18,
        "description": "Become a Super Lover to receive calls and earn coins!"
    },
    "message": "Requirements retrieved successfully"
}
```

#### **3.8 Rate Super Lover**
```
POST /api/super-lover/rate
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "superLoverId": "uuid",
    "rating": 5,
    "comment": "Great conversation!"
}

Response:
{
    "success": true,
    "message": "Rating submitted successfully"
}
```

### **4. Coin System APIs (6 endpoints)**

#### **4.1 Get Coin Balance**
```
GET /api/coins/balance
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "balance": 150,
        "totalEarned": 500,
        "totalSpent": 350
    },
    "message": "Balance retrieved successfully"
}
```

#### **4.2 Get Coin Transactions**
```
GET /api/coins/transactions?page=1&limit=20
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "transactions": [
            {
                "id": "uuid",
                "type": "earn",
                "amount": 5,
                "description": "Watched ad",
                "createdAt": "2024-01-15T10:30:00Z"
            }
        ],
        "pagination": {
            "page": 1,
            "limit": 20,
            "total": 45,
            "hasNext": true
        }
    },
    "message": "Transactions retrieved successfully"
}
```

#### **4.3 Get Coin Packages**
```
GET /api/coins/packages
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "packages": [
            {
                "id": "uuid",
                "name": "50 Coins",
                "coins": 50,
                "price": 4.99,
                "isActive": true
            }
        ]
    },
    "message": "Packages retrieved successfully"
}
```

#### **4.4 Purchase Coins**
```
POST /api/coins/purchase
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "packageId": "uuid",
    "paymentMethod": "stripe"
}

Response:
{
    "success": true,
    "data": {
        "paymentIntent": "pi_...",
        "clientSecret": "pi_..._secret_..."
    },
    "message": "Payment intent created"
}
```

#### **4.5 Earn Coins from Ad**
```
POST /api/coins/earn-ad
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "adType": "rewarded",
    "adProvider": "admob"
}

Response:
{
    "success": true,
    "data": {
        "coinsEarned": 5,
        "newBalance": 155
    },
    "message": "Coins earned successfully"
}
```

#### **4.6 Spend Coins**
```
POST /api/coins/spend
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "amount": 10,
    "action": "call",
    "referenceId": "uuid"
}

Response:
{
    "success": true,
    "data": {
        "coinsSpent": 10,
        "newBalance": 145
    },
    "message": "Coins spent successfully"
}
```

### **5. Messaging APIs (6 endpoints)**

#### **5.1 Get Conversations**
```
GET /api/messages/conversations
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "conversations": [
            {
                "id": "uuid",
                "user": {
                    "id": "uuid",
                    "fullName": "Sarah Johnson",
                    "profileImageUrl": "https://..."
                },
                "lastMessage": "Hey there! 👋",
                "lastMessageTime": "2024-01-15T10:30:00Z",
                "unreadCount": 2
            }
        ]
    },
    "message": "Conversations retrieved successfully"
}
```

#### **5.2 Get Messages**
```
GET /api/messages/conversation/:userId?page=1&limit=50
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "messages": [
            {
                "id": "uuid",
                "senderId": "uuid",
                "receiverId": "uuid",
                "messageText": "Hey there! 👋",
                "messageType": "text",
                "isRead": true,
                "createdAt": "2024-01-15T10:30:00Z"
            }
        ],
        "pagination": {
            "page": 1,
            "limit": 50,
            "total": 150,
            "hasNext": true
        }
    },
    "message": "Messages retrieved successfully"
}
```

#### **5.3 Send Message**
```
POST /api/messages/send
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "receiverId": "uuid",
    "messageText": "Hello! How are you?",
    "messageType": "text"
}

Response:
{
    "success": true,
    "data": {
        "message": {
            "id": "uuid",
            "senderId": "uuid",
            "receiverId": "uuid",
            "messageText": "Hello! How are you?",
            "messageType": "text",
            "isRead": false,
            "createdAt": "2024-01-15T10:30:00Z"
        },
        "coinsSpent": 5,
        "newBalance": 140
    },
    "message": "Message sent successfully"
}
```

#### **5.4 Mark Messages as Read**
```
PUT /api/messages/read/:userId
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "readCount": 5
    },
    "message": "Messages marked as read"
}
```

#### **5.5 Delete Message**
```
DELETE /api/messages/:messageId
Authorization: Bearer <token>

Response:
{
    "success": true,
    "message": "Message deleted successfully"
}
```

#### **5.6 Send Media Message**
```
POST /api/messages/send-media
Authorization: Bearer <token>
Content-Type: multipart/form-data

Request:
FormData with 'media' file and 'receiverId'

Response:
{
    "success": true,
    "data": {
        "message": {
            "id": "uuid",
            "senderId": "uuid",
            "receiverId": "uuid",
            "messageType": "image",
            "mediaUrl": "https://...",
            "isRead": false,
            "createdAt": "2024-01-15T10:30:00Z"
        }
    },
    "message": "Media message sent successfully"
}
```

### **6. Calling APIs (7 endpoints)**

#### **6.1 Initiate Call**
```
POST /api/calls/initiate
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "receiverId": "uuid",
    "callType": "video"
}

Response:
{
    "success": true,
    "data": {
        "callId": "uuid",
        "roomId": "room_uuid",
        "coinsSpent": 50,
        "newBalance": 90
    },
    "message": "Call initiated successfully"
}
```

#### **6.2 Accept Call**
```
POST /api/calls/:callId/accept
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "roomId": "room_uuid"
    },
    "message": "Call accepted"
}
```

#### **6.3 Reject Call**
```
POST /api/calls/:callId/reject
Authorization: Bearer <token>

Response:
{
    "success": true,
    "message": "Call rejected"
}
```

#### **6.4 End Call**
```
POST /api/calls/:callId/end
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "duration": 120
}

Response:
{
    "success": true,
    "data": {
        "duration": 120,
        "coinsEarned": 25
    },
    "message": "Call ended successfully"
}
```

#### **6.5 Get Call History**
```
GET /api/calls/history?page=1&limit=20
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "calls": [
            {
                "id": "uuid",
                "callerId": "uuid",
                "receiverId": "uuid",
                "callType": "video",
                "status": "ended",
                "duration": 120,
                "coinsSpent": 50,
                "startedAt": "2024-01-15T10:30:00Z",
                "endedAt": "2024-01-15T10:32:00Z"
            }
        ],
        "pagination": {
            "page": 1,
            "limit": 20,
            "total": 45,
            "hasNext": true
        }
    },
    "message": "Call history retrieved successfully"
}
```

#### **6.6 WebRTC Signaling - Send Offer**
```
POST /api/calls/:callId/webrtc/offer
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "sdp": "v=0\r\no=- 1234567890 2 IN IP4 127.0.0.1\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\na=msid-semantic: WMS\r\nm=video 9 UDP/TLS/RTP/SAVPF 96 97 98 99 100 101 102\r\nc=IN IP4 0.0.0.0\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=ice-ufrag:...",
    "roomId": "room_uuid"
}

Response:
{
    "success": true,
    "message": "Offer sent successfully"
}
```

#### **6.7 WebRTC Signaling - Send Answer**
```
POST /api/calls/:callId/webrtc/answer
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "sdp": "v=0\r\no=- 1234567890 2 IN IP4 127.0.0.1\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\na=msid-semantic: WMS\r\nm=video 9 UDP/TLS/RTP/SAVPF 96 97 98 99 100 101 102\r\nc=IN IP4 0.0.0.0\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=ice-ufrag:...",
    "roomId": "room_uuid"
}

Response:
{
    "success": true,
    "message": "Answer sent successfully"
}
```

### **7. User Preferences APIs (3 endpoints)**

#### **7.1 Get User Preferences**
```
GET /api/preferences
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "notifications": {
            "push": true,
            "email": false,
            "sms": true
        },
        "privacy": {
            "profileVisibility": "public",
            "showOnlineStatus": true,
            "showLastSeen": true
        },
        "app": {
            "theme": "light",
            "language": "en",
            "autoPlayVideos": true
        }
    },
    "message": "Preferences retrieved successfully"
}
```

#### **7.2 Update User Preferences**
```
PUT /api/preferences
Authorization: Bearer <token>
Content-Type: application/json

Request:
{
    "notifications": {
        "push": true,
        "email": false,
        "sms": true
    },
    "privacy": {
        "profileVisibility": "public",
        "showOnlineStatus": true,
        "showLastSeen": true
    }
}

Response:
{
    "success": true,
    "data": {
        "preferences": {
            "notifications": {...},
            "privacy": {...},
            "app": {...}
        }
    },
    "message": "Preferences updated successfully"
}
```

#### **7.3 Get Account Statistics**
```
GET /api/preferences/statistics
Authorization: Bearer <token>

Response:
{
    "success": true,
    "data": {
        "totalMatches": 45,
        "totalLikes": 128,
        "totalViews": 567,
        "accountAge": "30 days",
        "lastActive": "2 min ago",
        "profileCompleteness": 85
    },
    "message": "Statistics retrieved successfully"
}
```

### **8. Webhook APIs (2 endpoints)**

#### **8.1 WhatsApp Webhook Verification**
```
GET /api/webhooks/whatsapp?hub.mode=subscribe&hub.challenge=xxx&hub.verify_token=xxx

Response:
{
    "success": true,
    "data": {
        "challenge": "xxx"
    },
    "message": "Webhook verified successfully"
}
```

#### **8.2 WhatsApp Webhook Events**
```
POST /api/webhooks/whatsapp
Content-Type: application/json

Request:
{
    "object": "whatsapp_business_account",
    "entry": [
        {
            "id": "phone_number_id",
            "changes": [
                {
                    "value": {
                        "messaging_product": "whatsapp",
                        "metadata": {
                            "display_phone_number": "+1234567890",
                            "phone_number_id": "phone_number_id"
                        },
                        "statuses": [
                            {
                                "id": "wamid.xxx",
                                "status": "delivered",
                                "timestamp": "1234567890"
                            }
                        ]
                    },
                    "field": "messages"
                }
            ]
        }
    ]
}

Response:
{
    "success": true,
    "message": "Webhook processed successfully"
}
```

### **9. Admin APIs (3 endpoints)**

#### **8.1 Get Reports**
```
GET /api/admin/reports?status=pending&page=1&limit=20
Authorization: Bearer <admin_token>

Response:
{
    "success": true,
    "data": {
        "reports": [
            {
                "id": "uuid",
                "reporterId": "uuid",
                "reportedUserId": "uuid",
                "reason": "Inappropriate behavior",
                "description": "User sent inappropriate messages",
                "status": "pending",
                "createdAt": "2024-01-15T10:30:00Z"
            }
        ],
        "pagination": {
            "page": 1,
            "limit": 20,
            "total": 45,
            "hasNext": true
        }
    },
    "message": "Reports retrieved successfully"
}
```

#### **8.2 Update Report Status**
```
PUT /api/admin/reports/:reportId
Authorization: Bearer <admin_token>
Content-Type: application/json

Request:
{
    "status": "resolved",
    "adminNotes": "User has been warned"
}

Response:
{
    "success": true,
    "message": "Report status updated successfully"
}
```

#### **8.3 Get System Statistics**
```
GET /api/admin/statistics
Authorization: Bearer <admin_token>

Response:
{
    "success": true,
    "data": {
        "totalUsers": 15000,
        "totalSuperLovers": 500,
        "totalCalls": 25000,
        "totalMessages": 100000,
        "totalRevenue": 50000,
        "activeUsers": 2500
    },
    "message": "System statistics retrieved successfully"
}
```

---

## 🔧 **Implementation Notes**

### **WebRTC Implementation:**

#### **1. WebRTC Architecture:**
- **Signaling Server**: Socket.io server for WebRTC signaling
- **STUN Servers**: Free STUN servers for basic NAT traversal
- **TURN Servers**: Optional TURN servers for complex NAT scenarios
- **Room Management**: Socket.io rooms for call sessions
- **ICE Candidate Exchange**: Real-time ICE candidate sharing

#### **2. Socket.io Events for WebRTC:**
```javascript
// Client to Server Events
socket.emit('join-room', { roomId, userId });
socket.emit('webrtc-offer', { roomId, offer, targetUserId });
socket.emit('webrtc-answer', { roomId, answer, targetUserId });
socket.emit('ice-candidate', { roomId, candidate, targetUserId });
socket.emit('call-end', { roomId, userId });

// Server to Client Events
socket.emit('user-joined', { userId });
socket.emit('webrtc-offer', { offer, fromUserId });
socket.emit('webrtc-answer', { answer, fromUserId });
socket.emit('ice-candidate', { candidate, fromUserId });
socket.emit('user-left', { userId });
socket.emit('call-ended', { roomId });
```

#### **3. Environment Variables for WebRTC:**
```env
# WebRTC Configuration
WEBRTC_STUN_SERVERS=stun:stun.l.google.com:19302,stun:stun1.l.google.com:19302
WEBRTC_TURN_SERVERS=turn:your-turn-server.com:3478
WEBRTC_TURN_USERNAME=your_username
WEBRTC_TURN_CREDENTIAL=your_credential
SOCKET_IO_CORS_ORIGIN=https://your-app.com
```

#### **4. WebRTC Call Flow:**
1. **Call Initiation**: User initiates call via REST API
2. **Room Creation**: Socket.io creates room for the call
3. **Offer Exchange**: Caller sends WebRTC offer via Socket.io
4. **Answer Exchange**: Callee sends WebRTC answer via Socket.io
5. **ICE Candidates**: Both parties exchange ICE candidates
6. **Media Stream**: Direct peer-to-peer connection established
7. **Call Monitoring**: Server monitors call duration and quality
8. **Call End**: Either party ends call, room is cleaned up

### **WhatsApp Business API Integration:**

#### **1. Setup Requirements:**
- **Meta Developer Account**: Create account at developers.facebook.com
- **WhatsApp Business API**: Set up WhatsApp Business API application
- **Phone Number**: Register a business phone number with Meta
- **Webhook**: Configure webhook for delivery status updates
- **Access Token**: Generate permanent access token

#### **2. Environment Variables:**
```env
# WhatsApp Business API Configuration
WHATSAPP_ACCESS_TOKEN=your_permanent_access_token
WHATSAPP_PHONE_NUMBER_ID=your_phone_number_id
WHATSAPP_BUSINESS_ACCOUNT_ID=your_business_account_id
WHATSAPP_WEBHOOK_VERIFY_TOKEN=your_webhook_verify_token
WHATSAPP_API_VERSION=v18.0
```

#### **3. WhatsApp Message Template:**
```json
{
  "messaging_product": "whatsapp",
  "to": "{{phone_number}}",
  "type": "template",
  "template": {
    "name": "otp_verification",
    "language": {
      "code": "en"
    },
    "components": [
      {
        "type": "body",
        "parameters": [
          {
            "type": "text",
            "text": "{{otp_code}}"
          },
          {
            "type": "text",
            "text": "{{app_name}}"
          },
          {
            "type": "text",
            "text": "{{expiry_time}}"
          }
        ]
      }
    ]
  }
}
```

#### **4. Webhook Endpoints:**
```
POST /api/webhooks/whatsapp
GET /api/webhooks/whatsapp?hub.mode=subscribe&hub.challenge=xxx&hub.verify_token=xxx
```

#### **5. Delivery Status Tracking:**
- **sent**: Message sent to WhatsApp servers
- **delivered**: Message delivered to user's device
- **read**: Message read by user
- **failed**: Message delivery failed

### **Security Features:**
1. **Rate Limiting**: Implement rate limiting for all endpoints
2. **Input Validation**: Use Joi for request validation
3. **SQL Injection Prevention**: Use parameterized queries
4. **CORS**: Configure CORS properly
5. **Helmet**: Use Helmet for security headers
6. **JWT Expiration**: Short-lived access tokens with refresh tokens

### **Performance Optimizations:**
1. **Database Indexing**: Index frequently queried columns
2. **Caching**: Use Redis for caching user sessions and frequently accessed data
3. **Pagination**: Implement proper pagination for all list endpoints
4. **Connection Pooling**: Use connection pooling for database connections

### **Real-time Features:**
1. **WebSocket**: Implement Socket.io for real-time messaging and call notifications
2. **Push Notifications**: Integrate with Firebase Cloud Messaging
3. **Online Status**: Real-time online/offline status updates
4. **WebRTC Signaling**: Socket.io for WebRTC offer/answer exchange and ICE candidates

### **File Upload:**
1. **Image Processing**: Resize and compress images before storage
2. **CDN**: Use CDN for serving images
3. **File Validation**: Validate file types and sizes

### **WebRTC Integration:**
1. **Signaling Server**: Socket.io for WebRTC offer/answer exchange
2. **ICE Candidates**: Real-time ICE candidate exchange via WebSocket
3. **STUN/TURN Servers**: Configure STUN/TURN servers for NAT traversal
4. **Call Quality**: Monitor call quality and connection stability
5. **Fallback Handling**: Handle connection failures and reconnection

### **WhatsApp Integration:**
1. **WhatsApp Business API**: Send OTP via WhatsApp messages
2. **Message Templates**: Use pre-approved templates for OTP delivery
3. **Delivery Tracking**: Track message delivery status via webhooks
4. **Fallback Options**: Implement SMS fallback if WhatsApp fails

### **Payment Integration:**
1. **Stripe**: Integrate Stripe for coin purchases
2. **Webhook Handling**: Handle payment webhooks securely
3. **Refund Processing**: Implement refund functionality

### **Monitoring & Logging:**
1. **Winston**: Comprehensive logging
2. **Error Tracking**: Integrate Sentry for error tracking
3. **Health Checks**: Implement health check endpoints
4. **Metrics**: Track API usage and performance metrics

This comprehensive backend specification provides everything needed to build a robust, scalable backend for your romantic app!
