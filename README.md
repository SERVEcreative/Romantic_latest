# Romantic App - Full Stack Project

A complete dating application with Flutter frontend and Node.js/Express backend.

## 🏗️ Project Structure

```
D:\Affair/
├── frontend/          # Flutter Mobile App
│   ├── lib/          # Flutter source code
│   ├── android/      # Android configuration
│   ├── ios/          # iOS configuration
│   ├── pubspec.yaml  # Flutter dependencies
│   └── ...
├── backend/          # Node.js/Express API Server
│   ├── src/          # Source code
│   ├── package.json  # Node.js dependencies
│   ├── .env          # Environment variables
│   └── ...
├── assets/           # Shared assets
└── README.md         # This file
```

## 🚀 Quick Start

### Frontend (Flutter App)

   ```bash
cd frontend
   flutter pub get
   flutter run
   ```

### Backend (Node.js API)

```bash
cd backend
npm install
npm start
```

## 📱 Frontend Features

- **Phone Authentication**: OTP-based login with Twilio integration
- **User Profiles**: Create and manage dating profiles
- **Matching System**: Like/pass profiles and get matches
- **Messaging**: Real-time chat with matches
- **Video Calls**: Agora.io integration for video calls
- **Coin System**: Earn coins by watching ads
- **Modern UI**: Beautiful, responsive design

## 🔧 Backend Features

- **RESTful API**: Complete CRUD operations
- **Authentication**: JWT-based auth with phone verification
- **Database**: Supabase PostgreSQL integration
- **Real-time**: WebSocket support for messaging
- **File Upload**: Image upload to Supabase Storage
- **Video Calls**: Agora.io token generation
- **SMS**: Twilio integration for OTP
- **Security**: Rate limiting, CORS, Helmet

## 🛠️ Tech Stack

### Frontend
- **Framework**: Flutter
- **State Management**: Provider
- **HTTP Client**: http package
- **Ads**: Google Mobile Ads (AdMob)
- **Video Calls**: Agora Flutter SDK

### Backend
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: Supabase (PostgreSQL)
- **Authentication**: JWT
- **SMS**: Twilio
- **Video Calls**: Agora.io
- **File Storage**: Supabase Storage
- **Logging**: Winston
- **Validation**: Joi

## 📋 API Endpoints

### Authentication
- `POST /api/auth/send-otp` - Send OTP
- `POST /api/auth/verify-otp` - Verify OTP
- `POST /api/auth/register` - Register user
- `POST /api/auth/login` - Login user

### Users
- `GET /api/users/discover` - Get discover profiles
- `POST /api/users/like` - Like a profile
- `POST /api/users/pass` - Pass a profile
- `GET /api/users/matches` - Get matches

### Messaging
- `GET /api/messages/conversations` - Get conversations
- `POST /api/messages/send` - Send message

### Video Calls
- `POST /api/calls/initiate` - Start call
- `POST /api/calls/:callId/accept` - Accept call

### Coins
- `GET /api/coins/balance` - Get balance
- `POST /api/coins/earn` - Earn coins

## 🔐 Environment Variables

### Backend (.env)
```env
# Server
NODE_ENV=development
PORT=3000

# JWT
JWT_SECRET=your-jwt-secret
JWT_REFRESH_SECRET=your-refresh-secret

# Supabase
SUPABASE_URL=your-supabase-url
SUPABASE_ANON_KEY=your-supabase-anon-key

# Twilio
TWILIO_ACCOUNT_SID=your-twilio-sid
TWILIO_AUTH_TOKEN=your-twilio-token
TWILIO_PHONE_NUMBER=your-twilio-number

# Agora
AGORA_APP_ID=your-agora-app-id
AGORA_APP_CERTIFICATE=your-agora-certificate
```

## 🚀 Deployment

### Frontend
- Build APK: `flutter build apk`
- Build iOS: `flutter build ios`
- Deploy to stores via Flutter

### Backend
- Deploy to Railway/Render/Heroku
- Set environment variables
- Connect to Supabase production

## 📝 Development

### Adding New Features
1. **Frontend**: Add screens in `frontend/lib/screens/`
2. **Backend**: Add routes in `backend/src/routes/`
3. **Database**: Update schema in Supabase
4. **API**: Update controllers in `backend/src/controllers/`

### Code Style
- **Frontend**: Follow Flutter conventions
- **Backend**: Use ESLint and Prettier
- **Git**: Conventional commits

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For support, email support@romanticapp.com or create an issue.

---

**Built with ❤️ using Flutter and Node.js**
