# 💕 Romantic Dating App

A beautiful Flutter dating application with a romantic theme, featuring phone number authentication, profile management, and a coin-based interaction system.

## 🌟 Features

### 🔐 Authentication
- **Phone Number Login**: Secure phone number-based authentication
- **Romantic UI**: Beautiful gradient backgrounds and smooth animations
- **Form Validation**: Real-time phone number validation

### 👥 Profile Management
- **User Profiles**: Comprehensive profile editing with multiple fields
- **Settings Screen**: Complete profile customization options
- **Profile Picture**: Change profile picture functionality
- **Preferences**: Notification and location sharing settings

### 💰 Coin System
- **Dual Earning Methods**:
  - **Watch Ads**: Free coin earning through video advertisements
  - **Purchase Coins**: Premium coin packages with real money
- **Cost Management**: 
  - Call interactions: 10 coins
  - Chat interactions: 5 coins
  - Ad rewards: 5 coins per ad
- **Balance Tracking**: Real-time coin balance display

### 💬 Interaction Features
- **Romantic Profiles**: Beautiful glass-morphism profile cards
- **Call & Chat**: Coin-based communication with other users
- **Online Status**: Real-time online/offline indicators
- **Location Display**: User location information

### 🎨 UI/UX
- **Romantic Theme**: Pink gradient backgrounds and romantic styling
- **Smooth Animations**: Fade and slide transitions
- **Glass Morphism**: Modern glass effect design
- **Responsive Design**: Works on all screen sizes

## 📁 Project Structure

```
lib/
├── models/                    # Data models
│   ├── user_profile.dart     # User profile data structure
│   └── coin_package.dart     # Coin package data structure
├── services/                  # Business logic services
│   ├── coin_service.dart     # Coin management logic
│   └── ad_service.dart       # Ad watching functionality
├── data/                     # Sample and static data
│   └── sample_data.dart      # Mock user profiles
├── widgets/                   # Reusable UI components
│   ├── romantic_profile_card.dart  # Profile card widget
│   └── coin_dialogs.dart     # Coin-related dialogs
├── screens/                   # App screens
│   ├── login_screen.dart     # Phone number login
│   ├── dashboard_screen.dart # Main dashboard
│   └── settings_screen.dart  # Profile settings
└── main.dart                 # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (2.17 or higher)
- Android Studio / VS Code
- Android Emulator or Physical Device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd romantic-dating-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  intl_phone_field: ^3.2.0      # Phone number input
  flutter_svg: ^2.0.9          # SVG support
  google_fonts: ^6.1.0         # Custom fonts
```

## 🎯 Key Components

### Models
- **UserProfile**: Structured user data with type safety
- **CoinPackage**: Coin purchase package definitions

### Services
- **CoinService**: Centralized coin management logic
- **AdService**: Ad watching and reward system

### Widgets
- **RomanticProfileCard**: Reusable profile display component
- **CoinDialogs**: Modular dialog system for coin operations

### Screens
- **LoginScreen**: Phone number authentication
- **DashboardScreen**: Main app interface with organized structure
- **SettingsScreen**: Profile management interface

## 🔧 Code Organization Benefits

### ✅ Maintainability
- **Separation of Concerns**: Each file has a single responsibility
- **Modular Design**: Easy to modify individual components
- **Type Safety**: Strong typing with model classes

### ✅ Scalability
- **Service Layer**: Business logic separated from UI
- **Reusable Components**: Widgets can be used across screens
- **Data Models**: Structured data handling

### ✅ Readability
- **Clear Structure**: Logical file organization
- **Consistent Naming**: Descriptive file and class names
- **Documented Code**: Well-commented functionality

### ✅ Testing
- **Isolated Components**: Easy to unit test individual parts
- **Service Testing**: Business logic can be tested separately
- **Widget Testing**: UI components can be tested independently

## 🎨 Customization

### Colors
The app uses a romantic pink theme. To customize:
```dart
// In main.dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.pink,  // Change this color
  brightness: Brightness.light,
),
```

### Fonts
Google Fonts Poppins is used throughout. To change:
```dart
// In any screen
style: GoogleFonts.poppins(  // Change to desired font
  fontSize: 16,
  fontWeight: FontWeight.w600,
),
```

### Animations
Animation durations and curves can be modified in:
```dart
// In dashboard_screen.dart
duration: const Duration(milliseconds: 1200),  // Adjust timing
curve: Curves.easeInOut,  // Change animation curve
```

## 🚀 Future Enhancements

### Planned Features
- [ ] **Real-time Chat**: Implement actual messaging functionality
- [ ] **Video Calls**: Add video calling capabilities
- [ ] **Push Notifications**: Real-time notification system
- [ ] **User Matching**: Algorithm-based user matching
- [ ] **Photo Gallery**: Multiple photo upload support
- [ ] **Location Services**: Real-time location tracking
- [ ] **Payment Integration**: Real payment processing
- [ ] **Analytics**: User behavior tracking

### Technical Improvements
- [ ] **State Management**: Implement Provider/Riverpod
- [ ] **API Integration**: Connect to backend services
- [ ] **Database**: Local storage with SQLite/Hive
- [ ] **Caching**: Image and data caching
- [ ] **Error Handling**: Comprehensive error management
- [ ] **Unit Tests**: Complete test coverage
- [ ] **CI/CD**: Automated testing and deployment

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team**: For the amazing framework
- **Google Fonts**: For beautiful typography
- **Material Design**: For design inspiration
- **Open Source Community**: For various packages and tools

---

**Made with ❤️ for romantic connections**
