# ZEITNOIR - Premium Mobile Dashboard App

A luxury Flutter application providing secure, authenticated access to the ZEITNOIR elite private dashboard platform.

## 📋 Overview

ZEITNOIR is a premium mobile application that delivers an exclusive, secure experience for accessing the Zeitnoir.com dashboard. Built with Flutter, it features:

- **🔐 Biometric Security** - Fingerprint and Face ID authentication
- **📱 WebView Integration** - Seamless dashboard access
- **🔔 Push Notifications** - Real-time alerts via Firebase
- **💾 Smart Memory** - Remembers last visited page
- **🎨 Luxury Design** - Premium dark theme with gold accents
- **⚡ Smooth UX** - Elegant animations and transitions

## 🚀 Quick Start

### Prerequisites
- Flutter 3.9.2+
- iOS 11.0+ or Android 6.0+
- Firebase account

### Installation

```bash
# Clone and setup
git clone <repo>
cd zeitnoir_app
flutter pub get

# Configure Firebase (see IMPLEMENTATION_GUIDE.md)
# Add your credentials to lib/firebase_options.dart

# Run
flutter run
```

For detailed setup instructions, see [**IMPLEMENTATION_GUIDE.md**](IMPLEMENTATION_GUIDE.md).

## 📚 Documentation

- **[IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)** - Complete setup, configuration, and troubleshooting
- **[API_REFERENCE.md](API_REFERENCE.md)** - Quick reference for common tasks and code examples

## 🏗️ Project Structure

```
lib/
├── main.dart                  # App entry point & core screens
├── firebase_options.dart      # Firebase configuration
├── services/                  # Business logic
│   ├── notification_service.dart
│   ├── biometric_service.dart
│   └── session_service.dart
├── constants/                 # Constants & theme
│   └── app_constants.dart
└── utils/                     # Utility functions
    └── app_utils.dart
```

## 🔧 Key Features Implementation

### Biometric Authentication
```dart
final biometric = BiometricService();
bool authenticated = await biometric.authenticate(
  localizedReason: 'Unlock ZEITNOIR',
  dialogTitle: 'Security Verification',
  dialogSubtitle: 'Please authenticate',
);
```

### Session Management
```dart
// Automatically remembers last visited page
final session = SessionService();
String lastPage = session.getLastVisitedPage();
await session.saveLastVisitedPage(newUrl);
```

### Push Notifications
```dart
final notifications = NotificationService();
await notifications.initializeNotifications();
notifications.setupForegroundMessageHandler((message) {
  // Handle notification
});
```

## 🎨 Design System

**Color Palette:**
- Primary: Deep Black (`#0F0F0F`)
- Accent: Luxury Gold (`#D4AF37`)
- Text: White & Light Gray

**Typography:**
- Font: Montserrat (primary), Luxurious (accent)
- Theme: Material 3 Dark

**Animation:**
- Loading: Ripple effect in gold
- Splash: 2-second fade + scale
- Dashboard: Smooth fade overlays

## ⚙️ Configuration

### Firebase Setup
1. Create Firebase project
2. Register Android & iOS apps
3. Download configuration files
4. Update `lib/firebase_options.dart`

### Dashboard URL
Change in `lib/main.dart` line 254:
```dart
String _lastUrl = 'https://your-dashboard.com/login';
```

## 📱 Platform Support

- ✅ **Android** 6.0+ (API 21+)
- ✅ **iOS** 11.0+
- ✅ **Web** (via WebView compatibility)
- ✅ **Windows/Linux** (WebView available)

## 📦 Dependencies

Key packages:
- `firebase_core` & `firebase_messaging` - Push notifications
- `webview_flutter` - Dashboard integration
- `local_auth` - Biometric authentication
- `shared_preferences` - Local storage
- `flutter_spinkit` - Loading animations
- `intl` - Date/number formatting

See `pubspec.yaml` for complete list.

## 🔐 Security Features

- ✅ Biometric-gated access
- ✅ HTTPS-only WebView
- ✅ Automatic session management
- ✅ 24-hour session expiration
- ✅ Secure token storage
- ✅ User agent masking

## 🐛 Troubleshooting

### Firebase Not Initializing?
1. Check `google-services.json` (Android)
2. Check `GoogleService-Info.plist` (iOS)
3. Verify project ID matches in `firebase_options.dart`

### Biometric Not Working?
1. Check device has biometric capability
2. Verify Android/iOS permissions added
3. Test with `adb logcat | grep biometric`

### Notifications Not Received?
1. Check Firebase Cloud Messaging is enabled
2. Verify FCM token is saved
3. Test with Firebase Console notification

See [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md#troubleshooting) for more.

## 📚 Code Examples

Quick snippets available in [API_REFERENCE.md](API_REFERENCE.md):
- Session management
- Biometric authentication
- Push notifications
- WebView operations
- Utility functions

## 🔄 Development Workflow

```bash
# Run with hot reload
flutter run

# Run tests
flutter test

# Build for production
flutter build apk --release      # Android
flutter build ios --release      # iOS

# View logs
flutter logs
```

## 📊 Performance

- **App Size:** ~50-80 MB (depending on platform)
- **Start Time:** <2 seconds
- **Memory:** ~100-150 MB typical
- **Battery:** Optimized with efficient WebView

## 🤝 Contributing

This is a private premium app. For modifications:
1. Create feature branch
2. Make changes
3. Test thoroughly
4. Submit for review

## 📄 License

Copyright © 2024 ZEITNOIR. All rights reserved.

Private and Confidential - For authorized users only.

## 📞 Support

For technical support: support@zeitnoir.com

---

**Documentation:**
- 📖 [Full Implementation Guide](IMPLEMENTATION_GUIDE.md)
- 🔍 [API Reference & Examples](API_REFERENCE.md)

**Made with ❤️ for the elite** | v1.0.0 | Updated March 2024

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
