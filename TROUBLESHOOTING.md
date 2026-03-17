## 🔧 ZEITNOIR - Troubleshooting Quick Guide

Fast solutions to common issues. For detailed help, see IMPLEMENTATION_GUIDE.md.

---

## 🚨 Critical Issues

### App Won't Launch

```
Error: "Firebase not initialized" or "null run_app"
```

**Solution:**
1. Check Firebase credentials in `lib/firebase_options.dart`
2. Verify `google-services.json` in `android/app/`
3. Verify `GoogleService-Info.plist` in `ios/Runner/`
4. Run `flutter clean && flutter pub get`
5. Run `flutter run` again

**Check Logs:**
```bash
flutter logs | grep -i firebase
```

---

### Gradle Build Fails (Android)

```
Error: "com.google.gms:google-services" not found
```

**Solution:**
1. Open `android/build.gradle`
2. Add/verify in `buildscript` → `dependencies`:
   ```gradle
   classpath 'com.google.gms:google-services:4.3.15'
   ```
3. Open `android/app/build.gradle`
4. Add at the end:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```
5. Run `./gradlew clean`
6. Run `flutter pub get`

**Verify:**
```bash
grep -i "google-services" android/app/build.gradle
```

---

### Cocoapods Issues (iOS)

```
Error: "CocoaPods could not find compatible versions"
```

**Solution:**
```bash
cd ios
rm -rf Pods
rm -rf Podfile.lock
pod install --repo-update
cd ..
flutter clean
flutter pub get
flutter run
```

**Or use:**
```bash
flutter run -v  # Verbose to see detailed errors
```

---

## 📱 Biometric Issues

### Biometric Not Prompting

**Problem:** App skips to dashboard without biometric prompt

**Causes & Solutions:**

**1. Device doesn't support biometric:**
```bash
# Android: Check if device has biometric capability
adb shell getprop ro.hardware.fingerprint
adb shell getprop ro.opengles.version  # For Face ID equivalent

# iOS: Device must be iPhone X or newer
# Check Settings > Face ID & Passcode
```

**2. First run or disabled:**
- App skips biometric on first run
- Biometric disabled in preferences
- Check `SharedPreferences` with app inspection

**3. Permissions not granted:**
```xml
<!-- Android: Verify in AndroidManifest.xml -->
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
```

```xml
<!-- iOS: Verify in Info.plist -->
<key>NSBiometricsUsageDescription</key>
<string>Description needed</string>
```

**Debug:**
```dart
// In _SplashScreenState._authenticate()
final bool available = await auth.canCheckBiometrics;
final bool supported = await auth.isDeviceSupported();
print('Biometric available: $available, supported: $supported');

final bios = await auth.getAvailableBiometrics();
print('Available biometrics: $bios');
```

---

### Biometric Prompts With Wrong Settings

**Problem:** Prompt says "use passcode" or multiple biometric options

**Solution:**
1. Verify `AuthenticationOptions` in `main.dart` line ~114:
   ```dart
   options: const AuthenticationOptions(
     stickyAuth: true,        // Keep prompt open
     biometricOnly: true,     // Don't show passcode fallback
   ),
   ```
2. Rebuild and test:
   ```bash
   flutter clean
   flutter run
   ```

---

## 🔔 Firebase / Notifications Issues

### Firebase Initialization Fails

```
Error: "Firebase not initialized" or "defaultTargetPlatform == null"
```

**Solution:**
1. Ensure `WidgetsFlutterBinding.ensureInitialized()` is first in `main()`
2. Check `Firebase.initializeApp()` is called before `runApp()`
3. Verify credentials in `firebase_options.dart`:
   ```bash
   grep -i "apiKey\|appId\|projectId" lib/firebase_options.dart
   ```

**Fix:**
```dart
void main() async {
  // FIRST: Initialize bindings
  WidgetsFlutterBinding.ensureInitialized();
  
  // SECOND: Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // THIRD: Run app
  runApp(const ZeitnoirApp());
}
```

---

### FCM Token Not Saved

**Problem:** `getFCMToken()` returns null

**Solution:**
1. Verify permissions in `AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.INTERNET" />
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
   ```

2. Check notification permission requested:
   ```dart
   await FirebaseMessaging.instance.requestPermission();
   ```

3. Verify SharedPreferences saving:
   ```dart
   String? token = await FirebaseMessaging.instance.getToken();
   print('FCM Token: $token');  // Should not be null
   
   // Save it
   final prefs = await SharedPreferences.getInstance();
   await prefs.setString('fcm_token', token ?? '');
   ```

**Debug:**
```bash
flutter logs | grep -i "FCM Token"
```

---

### Notifications Not Received

**Problem:** Firebase console test notification doesn't arrive

**Solutions:**

**1. Check app permissions:**
```bash
# Android
adb shell cmd appops get com.example.zeitnoirapp MANAGE_EXTERNAL_STORAGE
adb shell dumpsys package com.example.zeitnoirapp | grep POST_NOTIFICATIONS
```

**2. Verify Firebase Cloud Messaging enabled:**
- Go to Firebase Console → Cloud Messaging
- Check Service is enabled
- Verify your app's FCM token appears

**3. Test with code instead:**
```dart
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('Message received: ${message.notification?.title}');
  print('Data: ${message.data}');
});
```

**4. Check manifest (Android):**
```xml
<service android:name="com.google.firebase.messaging.FirebaseMessagingService"
    android:exported="false">
    <intent-filter>
        <action android:name="com.google.firebase.MESSAGING_EVENT" />
    </intent-filter>
</service>
```

---

### Notification Channel Issues (Android)

**Problem:** "Notification channel not created"

**Solution:**
The app creates channel automatically, but you can verify:

```dart
// In notification_service.dart, it's already configured:
static const String notificationChannelId = 'zeitnoir_notifications';
static const String notificationChannelName = 'ZEITNOIR Alerts';
```

To manually create/update:
```dart
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'zeitnoir_notifications',
  'ZEITNOIR Alerts',
  description: 'Notifications from ZEITNOIR Dashboard',
  importance: Importance.high,
);

// Create in service initialization
await FirebaseMessaging.instance.requestPermission();
```

---

## 🌐 WebView Issues

### WebView Shows Blank/White Screen

**Problem:** Dashboard doesn't load in WebView

**Solutions:**

**1. Check URL:**
```dart
// In DashboardScreen._initializeWebView()
..loadRequest(Uri.parse('https://zeitnoir.com/login'))
// Change URL if needed
```

**2. Check internet connectivity:**
```bash
# Device can reach URL
adb shell
ping zeitnoir.com
exit
```

**3. Enable JavaScript:**
```dart
// Already enabled in code:
..setJavaScriptMode(JavaScriptMode.unrestricted)
```

**4. Check WebView errors:**
```dart
..setNavigationDelegate(NavigationDelegate(
  onWebResourceError: (WebResourceError error) {
    debugPrint('WebView error: ${error.description}');
    debugPrint('Error code: ${error.errorCode}');
    debugPrint('Failed URL: ${error.failingUrl}');
  },
))
```

**5. Verify network permissions (Android):**
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

---

### WebView Loads but Dashboard Broken

**Problem:** WebView shows something but dashboard is broken

**Solutions:**
1. Check URL is correct (with `https://`)
2. Test URL in browser first
3. Check if website blocks WebView user agents:
   ```dart
   // Already set, but check:
   ..setUserAgent('Mozilla/5.0...')
   ```

4. Check browser console for errors:
   ```dart
   // Add logging
   ..setJavaScriptMode(JavaScriptMode.unrestricted)
   ```

5. Try disabling JavaScript temporarily:
   ```dart
   ..setJavaScriptMode(JavaScriptMode.disabled)  // Test
   ```

---

### Navigation Back Button Not Working

**Problem:** Hardware back button doesn't go back in WebView

**Solution:**
Already implemented in `_DashboardScreenState.build()`:
```dart
WillPopScope(
  onWillPop: () async {
    if (await _webViewController.canGoBack()) {
      await _webViewController.goBack();
      return false;
    }
    return true;
  },
  // ...
)
```

**Verify:**
- [ ] Code is in place in `main.dart`
- [ ] Test with back button
- [ ] Check logs for errors

---

## 💾 Session & Storage Issues

### Last Page Not Saved

**Problem:** App doesn't remember where you were

**Solution:**
1. Check `session_service.dart` is initialized:
   ```dart
   final session = SessionService();
   await session.initialize();
   ```

2. Verify save is called:
   ```dart
   // In DashboardScreen
   _saveLastVisitedPage(url);
   ```

3. Check SharedPreferences granted:
   ```xml
   <!-- Android: Already has permission -->
   <!-- iOS: Check Info.plist has read/write access -->
   ```

4. Test storage manually:
   ```dart
   final prefs = await SharedPreferences.getInstance();
   await prefs.setString('test_key', 'test_value');
   String? test = prefs.getString('test_key');
   print('Storage test: $test');  // Should print "test_value"
   ```

---

### Session Data Lost on Reinstall

**Problem:** App clears all data when reinstalled

**Solution:**
This is expected behavior. For persistent login:
- Use Firebase Auth
- Or implement backend authentication
- Or use `flutter_secure_storage` for tokens

Current implementation uses ephemeral storage suitable for WebView dashboard.

---

## 🎨 UI/Design Issues

### Splash Screen Too Fast/Slow

**Problem:** Splash appears for wrong duration

**Solution:**
Edit `_SplashScreenState.initState()` in `main.dart`:
```dart
// Change this line (currently 2000ms):
duration: const Duration(milliseconds: 2000),

// Adjust animation delay:
Future.delayed(const Duration(seconds: 2), _authenticateUser);

// Change both to match. Examples:
// const Duration(milliseconds: 1000)  // 1 second
// const Duration(milliseconds: 3000)  // 3 seconds
```

---

### Colors Not Matching Brand

**Problem:** Gold/black colors look different

**Solution:**
1. Edit `lib/constants/app_constants.dart`:
   ```dart
   class AppColors {
     static const Color gold = Color(0xFFD4AF37);  // Change hex
     static const Color primaryBlack = Color(0xFF0F0F0F);  // Change hex
   }
   ```

2. Test on real device (emulator colors differ)
3. Verify phone display settings (brightness/contrast)

---

### Fonts Not Loading

**Problem:** Text shows in default font, not Montserrat

**Solution:**
1. Verify assets in `pubspec.yaml`:
   ```yaml
   fonts:
     - family: Montserrat
       fonts:
         - asset: assets/fonts/Montserrat-Regular.ttf
   ```

2. Verify files exist:
   ```bash
   ls -la assets/fonts/Montserrat-*.ttf
   ```

3. Rebuild:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

4. Check font family used:
   ```dart
   fontFamily: 'Montserrat'  // In TextStyle
   ```

---

## 🐛 Debug & Logging

### Enable Detailed Logging

```bash
# Flutter logs with colors
flutter logs

# Filter by tag
flutter logs | grep ZEITNOIR

# Follow specific package
flutter logs -l | grep firebase
```

### Check App Data

```bash
# Android: View app storage
adb shell
run-as com.example.zeitnoirapp
ls -la /data/data/com.example.zeitnoirapp/

# iOS: Use Xcode
# Products → Scheme → Run → Arguments
# Set OS_ACTIVITY_MODE = DEBUG
```

### Memory Profiling

```bash
# Check memory usage
flutter run
# In another terminal
adb logcat | grep -i memory

# Use Dart DevTools
dart devtools
# Visit http://localhost:9100 in browser
```

---

## ✅ Verification Checklist

Before declaring issue fixed:

- [ ] App launches without errors
- [ ] Splash screen shows for 2 seconds
- [ ] Biometric prompt appears
- [ ] Dashboard loads
- [ ] Can navigate within dashboard
- [ ] Push notification can be received
- [ ] App state preserved on close/reopen
- [ ] No Firebase errors in logs
- [ ] No memory leaks after 5 min use
- [ ] Back button works correctly

---

## 📞 When to Seek Help

If issue persists after these steps:

1. **Collect Information:**
   - [ ] Device model & OS version
   - [ ] Flutter version: `flutter --version`
   - [ ] App version from `pubspec.yaml`
   - [ ] Error message/stack trace
   - [ ] `flutter logs` output
   - [ ] Steps to reproduce

2. **Reference Documentation:**
   - [ ] IMPLEMENTATION_GUIDE.md troubleshooting
   - [ ] COMPLETE_SUMMARY.md technical details
   - [ ] API_REFERENCE.md code examples

3. **Contact Support:**
   - Email: support@zeitnoir.com
   - Include all information from step 1

---

## 🔍 Common Error Messages

| Error | Meaning | Fix |
|-------|---------|-----|
| `PlatformException: play_service_not_available` | Google Play Services not installed | Install on Android device |
| `LAError 1` | No biometric enrolled | User needs to setup fingerprint/Face ID |
| `The connection times out` | WebView can't reach URL | Check internet and URL |
| `NoSuchMethodError: 'map missing key 'apiKey'` | Firebase config bad | Check firebase_options.dart |
| `403 Forbidden` | WebView blocked by website | Check CORS and user agent |

---

**Last Updated:** March 2024  
**Version:** 1.0.0

**Pro Tip:** Most issues are fixed with `flutter clean && flutter pub get && flutter run` 🚀
