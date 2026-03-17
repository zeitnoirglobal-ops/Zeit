# ZEITNOIR - Premium Flutter Dashboard App

A luxury mobile application providing secure access to the ZEITNOIR elite private dashboard with biometric authentication, push notifications, and elegant UI.

## Features ✨

- **🔐 Biometric Authentication**: Fingerprint and Face ID support
- **📱 WebView Integration**: Seamless dashboard access via secure WebView
- **🔔 Push Notifications**: Firebase Cloud Messaging integration
- **💾 Session Management**: Automatic last-page memory and user preferences
- **🎨 Luxury UI**: Premium dark theme with gold accents
- **⚡ Smooth Animations**: Elegant loading states and transitions
- **🌙 Dark-First Design**: OLED-optimized interface

## Project Structure

```
lib/
├── main.dart                          # App entry point & core screens
├── firebase_options.dart              # Firebase configuration
├── services/
│   ├── notification_service.dart      # Firebase Messaging service
│   ├── biometric_service.dart         # Biometric authentication
│   └── session_service.dart           # User session & preferences
├── constants/
│   └── app_constants.dart             # All constants (colors, strings, URLs)
└── utils/
    └── app_utils.dart                 # Utility functions
```

## Setup Instructions

### 1. Prerequisites

- Flutter SDK: ≥ 3.9.2
- Android SDK or iOS SDK
- Firebase account

### 2. Firebase Setup

#### Firebase Console Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use an existing one
3. Register your app (Android + iOS)
4. Download configuration files:
   - **Android**: `google-services.json`
   - **iOS**: `GoogleService-Info.plist`

#### Android Setup

1. Place `google-services.json` at: `android/app/google-services.json`
2. Ensure your `android/build.gradle` includes Firebase plugin:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

3. In `android/app/build.gradle`, add at the end:

```gradle
apply plugin: 'com.google.gms.google-services'
```

#### iOS Setup

1. Place `GoogleService-Info.plist` at: `ios/Runner/GoogleService-Info.plist`
2. Ensure it's added to Xcode project (File → Add Files)
3. In `ios/Podfile`, ensure `platform :ios, '11.0'` or higher

### 3. Update Firebase Configuration

Edit `lib/firebase_options.dart` with your Firebase project credentials:

```dart
// Get these from Firebase Console → Project Settings
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  appId: 'YOUR_APP_ID',
  messagingSenderId: 'YOUR_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  // ... other fields
);
```

### 4. Add Assets

Create asset folders and add files:

```bash
mkdir -p assets/images assets/fonts assets/animations

# Add your logo
cp zeitnoir_logo.png assets/images/

# Add custom fonts to assets/fonts/
# - Montserrat-Regular.ttf
# - Montserrat-Bold.ttf
# - Montserrat-Light.ttf
```

### 5. Install Dependencies

```bash
flutter pub get
```

### 6. Platform-Specific Configuration

#### Android Biometric Setup

In `android/app/src/main/AndroidManifest.xml`, add:

```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
<uses-permission android:name="android.permission.INTERNET" />
```

#### iOS Biometric Setup

In `ios/Runner/Info.plist`, add:

```xml
<key>NSFaceIDUsageDescription</key>
<string>We need Face ID to secure your ZEITNOIR account</string>

<key>NSBiometricsUsageDescription</key>
<string>We need biometric authentication to secure your ZEITNOIR account</string>
```

### 7. Run the App

```bash
# Development
flutter run

# Release
flutter run --release
```

## Configuration

### Firebase Messaging Setup

#### Enable Notifications in Firebase Console

1. Go to Firebase Console → Cloud Messaging
2. Configure your server key
3. Create test notifications from the console
4. Or send programmatically from your backend

#### Android Notification Channel

Notifications use the configured channel:
- **ID**: `zeitnoir_notifications`
- **Name**: `ZEITNOIR Alerts`
- **Importance**: High (4)

### Customize Dashboard URL

Edit in `lib/main.dart`:

```dart
String _lastUrl = 'https://zeitnoir.com/login'; // Change this URL
```

Or update in `.env` if using provider package.

## Usage Examples

### Get Session Information

```dart
import 'package:zeitnoir_app/services/session_service.dart';

final session = SessionService();
await session.initialize();

String? userId = session.getUserId();
String lastUrl = session.getLastVisitedPage();
```

### Check Biometric Availability

```dart
import 'package:zeitnoir_app/services/biometric_service.dart';

final biometric = BiometricService();
bool isAvailable = await biometric.isBiometricAvailable();
List<BiometricType> types = await biometric.getAvailableBiometrics();
```

### Handle Push Notifications

```dart
import 'package:zeitnoir_app/services/notification_service.dart';

final notifications = NotificationService();
await notifications.initializeNotifications();

// Get FCM token
String? token = await notifications.getFCMToken();

// Setup message handlers
notifications.setupForegroundMessageHandler((message) {
  print('Message: ${message.notification?.title}');
});
```

### Use Utility Functions

```dart
import 'package:zeitnoir_app/utils/app_utils.dart';

// String utilities
bool isEmail = StringUtils.isEmail('user@example.com');
String capitalized = StringUtils.capitalize('hello');

// Date utilities
String formatted = DateTimeUtils.formatDate(DateTime.now());
String timeAgo = DateTimeUtils.getTimeAgo(someDate);

// Number utilities
String formatted = NumberUtils.formatNumber(1000); // "1,000"
String currency = NumberUtils.formatCurrency(99.99); // "$99.99"
```

## Authentication Flow

```
┌─────────────────┐
│  App Launch     │
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│  Splash Screen (2 sec)  │ ◄── Show biometric prompt
└────────┬────────────────┘
         │
         ▼
┌──────────────────────────────┐
│  Check Biometric Available   │
└────────┬──────────────────┬──┘
         │                  │
      YES│                  │NO
         │                  │
         ▼                  ▼
┌──────────────────┐  ┌──────────────┐
│ Authenticate     │  │ Go to        │
│ with Biometric   │  │ Dashboard    │
└────────┬─────────┘  └──────────────┘
         │
    ┌────┴────┐
    │          │
  YES│          │NO
    ▼          ▼
┌────────┐  ┌──────────┐
│Success │  │   Error  │
└───┬────┘  └────┬─────┘
    │            │
    ▼            ▼
┌──────────────┐┌──────────────┐
│Go Dashboard  ││Show Retry    │
└──────────────┘└──────────────┘
```

## Notification Types

### Foreground Notifications
- Displayed as snackbar in app
- Auto-dismiss after 5 seconds
- User can dismiss manually

### Background/Terminated Notifications
- Handled by `_handleBackgroundMessage()`
- Stored for later retrieval
- Can trigger specific actions

## Security Features

- ✅ Biometric-gated access
- ✅ HTTPS-only WebView communication
- ✅ Automatic session storage
- ✅ Secure token handling
- ✅ Session expiration (24 hours)
- ✅ User agent masking

## Build for Production

### Android Release Build

```bash
# Build AAB (Google Play)
flutter build appbundle

# Build APK
flutter build apk --release
```

### iOS Release Build

```bash
# Build for TestFlight/App Store
flutter build ios --release

# Or use Xcode
open ios/Runner.xcworkspace
```

## Troubleshooting

### Issue: Firebase initialization fails

**Solution**: Verify credentials in `firebase_options.dart`:

```bash
# Check google-services.json (Android)
cat android/app/google-services.json | grep -i "project_id"

# Check GoogleService-Info.plist (iOS)
file ios/Runner/GoogleService-Info.plist
```

### Issue: Biometric not prompting

**Solution**: Ensure device has biometric capability and permissions:

```bash
# Android Logcat
adb logcat | grep -i biometric

# Check manifest permissions
grep -i biometric android/app/src/main/AndroidManifest.xml
```

### Issue: WebView shows blank page

**Solution**: Check URL and internet connectivity:

```dart
// In WebViewController setup
..setNavigationDelegate(NavigationDelegate(
  onWebResourceError: (error) {
    debugPrint('WebView Error: ${error.description}');
  },
))
```

### Issue: Notifications not received

**Solution**: Verify Firebase setup and permissions:

```bash
# Check notification permissions (Android)
adb shell cmd appops get com.example.zeitnoirApp

# Check FCM token is being saved
adb logcat | grep -i "FCM Token"
```

## Environment Variables

Create `.env` file (optional):

```
DASHBOARD_URL=https://zeitnoir.com/login
FIREBASE_PROJECT_ID=zeitnoir-xxxxx
ENABLE_DEBUG_LOGGING=true
```

Load with `flutter_dotenv`:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dashboardUrl = dotenv.env['DASHBOARD_URL']!;
```

## Performance Optimization

### WebView Performance

```dart
// Already optimized in code, but you can add:
controller.setOnConsoleMessage((JavaScriptConsoleMessage message) {
  debugPrint('JS: ${message.message}');
});
```

### Animation Performance

Disable on low-end devices:

```dart
final isLowEndDevice = MediaQuery.of(context).boldText == true;
if (!isLowEndDevice) {
  // Show animations
}
```

## Testing

### Unit Tests

```bash
flutter test
```

### Widget Tests

```bash
flutter test test/widget_test.dart
```

### Integration Tests

```bash
flutter test integration_test/
```

## Updates & Maintenance

### Update Dependencies

```bash
flutter pub upgrade
flutter pub upgrade --major-versions
```

### Version Bumping

Edit `pubspec.yaml`:

```yaml
version: 1.0.0+1  # Major.Minor.Patch+BuildNumber
```

## License

Copyright © 2024 ZEITNOIR. All rights reserved.

## Support

For issues and support, contact: support@zeitnoir.com

---

**Made with ❤️ for the elite** | Last Updated: 2024
