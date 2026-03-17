## 📋 ZEITNOIR Setup Checklist

Complete this checklist to get your premium ZEITNOIR app up and running.

---

## Phase 1: Project Preparation

- [ ] **Read Documentation**
  - [ ] Review README.md (overview)
  - [ ] Review COMPLETE_SUMMARY.md (what was created)
  - [ ] Review IMPLEMENTATION_GUIDE.md (detailed setup)

- [ ] **Environment Setup**
  - [ ] Flutter SDK installed (3.9.2+)
  - [ ] Android SDK/NDK installed
  - [ ] iOS deployment target ≥ 11.0
  - [ ] Xcode installed (for iOS)
  - [ ] Android Studio installed

- [ ] **Project Initialization**
  - [ ] Run `flutter pub get` (install dependencies)
  - [ ] No errors in `flutter doctor`
  - [ ] All dependencies resolved

---

## Phase 2: Firebase Setup

### 2.1 Firebase Console Configuration

- [ ] **Create Firebase Project**
  - [ ] Go to [Firebase Console](https://console.firebase.google.com/)
  - [ ] Click "Create Project"
  - [ ] Name: "zeitnoir"
  - [ ] Enable Google Analytics (optional)
  - [ ] Create project

- [ ] **Register Android App**
  - [ ] In Firebase, click "Add App" → Android
  - [ ] Package name: `com.example.zeitnoirapp` (or your domain)
  - [ ] SHA-1 certificate fingerprint:
    ```bash
    # Get SHA-1
    keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
    ```
  - [ ] Download `google-services.json`
  - [ ] Place at: `android/app/google-services.json`

- [ ] **Register iOS App**
  - [ ] In Firebase, click "Add App" → iOS
  - [ ] Bundle ID: `com.example.zeitnoirApp`
  - [ ] Download `GoogleService-Info.plist`
  - [ ] Place at: `ios/Runner/GoogleService-Info.plist`
  - [ ] Add to Xcode project

### 2.2 Update Firebase Credentials

- [ ] **Edit firebase_options.dart**
  - [ ] Copy API Key from Firebase Console
  - [ ] Copy App ID for Android
  - [ ] Copy App ID for iOS
  - [ ] Copy Messaging Sender ID
  - [ ] Copy Project ID
  - [ ] Copy Database URL
  - [ ] Copy Storage Bucket
  - [ ] Paste all into `lib/firebase_options.dart`
  - [ ] Verify no "YOUR_XXX" placeholders remain

- [ ] **Android Firebase Setup**
  - [ ] Verify `google-services.json` in `android/app/`
  - [ ] Check `android/build.gradle` has Firebase plugin:
    ```gradle
    classpath 'com.google.gms:google-services:4.3.15'
    ```
  - [ ] Check `android/app/build.gradle` ends with:
    ```gradle
    apply plugin: 'com.google.gms.google-services'
    ```

- [ ] **iOS Firebase Setup**
  - [ ] Verify `GoogleService-Info.plist` in `ios/Runner/`
  - [ ] Added to Xcode project (check File → "GoogleService-Info.plist")
  - [ ] Ensure `ios/Podfile` has `platform :ios, '11.0'` or higher

### 2.3 Enable Firebase Services

- [ ] **Cloud Messaging**
  - [ ] Go to Firebase Console → Cloud Messaging
  - [ ] Note the Sender ID (for notifications)
  - [ ] Server key is generated (keep secret)

---

## Phase 3: App Configuration

### 3.1 Android Configuration

- [ ] **Permissions - AndroidManifest.xml**
  - [ ] Open `android/app/src/main/AndroidManifest.xml`
  - [ ] Add inside `<manifest>` tag:
    ```xml
    <uses-permission android:name="android.permission.USE_BIOMETRIC" />
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    ```
  - [ ] Save file

- [ ] **Build Configuration**
  - [ ] Open `android/app/build.gradle`
  - [ ] Check `minSdkVersion` is at least 21
  - [ ] Check `targetSdkVersion` is at least 33
  - [ ] Run build:
    ```bash
    ./gradlew clean
    ./gradlew build
    ```

### 3.2 iOS Configuration

- [ ] **Info.plist Setup**
  - [ ] Open `ios/Runner/Info.plist`
  - [ ] Add these keys:
    ```xml
    <key>NSFaceIDUsageDescription</key>
    <string>We need Face ID to secure your ZEITNOIR account</string>
    
    <key>NSBiometricsUsageDescription</key>
    <string>We need biometric authentication to secure your ZEITNOIR account</string>
    ```
  - [ ] Save file

- [ ] **Minimum iOS Version**
  - [ ] Verify `ios/Podfile` has `platform :ios, '11.0'` or higher
  - [ ] Update if needed (minimum 11.0)
  - [ ] Run: `cd ios && pod update && cd ..`

- [ ] **Build Settings**
  - [ ] Open `ios/Runner.xcworkspace` in Xcode
  - [ ] Select Runner → Build Settings
  - [ ] Search "IPHONEOS_DEPLOYMENT_TARGET"
  - [ ] Set to 11.0 or higher
  - [ ] Save

---

## Phase 4: Assets & Resources

- [ ] **Create Asset Directories**
  ```bash
  mkdir -p assets/images
  mkdir -p assets/fonts
  mkdir -p assets/animations
  ```

- [ ] **Add Your Logo**
  - [ ] Create/prepare `zeitnoir_logo.png` (180×180 px recommended)
  - [ ] Place at: `assets/images/zeitnoir_logo.png`
  - [ ] Also create `zeitnoir_icon.png` for other uses

- [ ] **Add Custom Fonts (Optional)**
  - [ ] Download Montserrat font files:
    - [ ] Montserrat-Regular.ttf
    - [ ] Montserrat-Bold.ttf
    - [ ] Montserrat-Light.ttf
  - [ ] Place in: `assets/fonts/`
  - [ ] Download optional Luxurious font
  - [ ] Place in: `assets/fonts/`

- [ ] **Verify pubspec.yaml Assets**
  - [ ] Check `pubspec.yaml` has:
    ```yaml
    flutter:
      assets:
        - assets/images/zeitnoir_logo.png
        - assets/images/zeitnoir_icon.png
        (more as needed)
      
      fonts:
        - family: Montserrat
          fonts:
            - asset: assets/fonts/Montserrat-Regular.ttf
            - asset: assets/fonts/Montserrat-Bold.ttf
              weight: 700
            - asset: assets/fonts/Montserrat-Light.ttf
              weight: 300
    ```

- [ ] **Verify Assets Load**
  ```bash
  flutter clean
  flutter pub get
  ```

---

## Phase 5: Code Customization

- [ ] **Update Dashboard URL**
  - [ ] Open `lib/main.dart`
  - [ ] Find line ~254: `String _lastUrl = 'https://zeitnoir.com/login';`
  - [ ] Change URL if different
  - [ ] Save

- [ ] **Customize App Strings (Optional)**
  - [ ] Open `lib/constants/app_constants.dart`
  - [ ] Update `AppStrings` class values as needed
  - [ ] Update `AppUrls` with your URLs
  - [ ] Update `AppColors` if design changes
  - [ ] Save

- [ ] **Verify Constants**
  - [ ] Check `AppColors` match your brand
  - [ ] Check `AppDimensions` for layout preferences
  - [ ] Check `FeatureFlags` to enable/disable features
  - [ ] Save

---

## Phase 6: Testing

- [ ] **Build APK (Android)**
  ```bash
  flutter build apk --debug
  ```
  - [ ] Command completes successfully
  - [ ] Output: `build/app/outputs/apk/debug/app-debug.apk`

- [ ] **Build IPA (iOS)**
  ```bash
  flutter build ios
  ```
  - [ ] Command completes successfully
  - [ ] Can open in Xcode for testing

- [ ] **Run App in Debug Mode**
  ```bash
  flutter run
  ```
  - [ ] App launches
  - [ ] Splash screen appears (2 seconds)
  - [ ] No Firebase errors in console
  - [ ] Biometric prompt appears (if device supports it)

- [ ] **Test Biometric**
  - [ ] Allow biometric authentication prompt
  - [ ] Successfully authenticates (or skips if not available)
  - [ ] Navigates to Dashboard
  - [ ] No error dialogs appear

- [ ] **Test WebView Dashboard**
  - [ ] Dashboard loads in WebView
  - [ ] Can navigate within dashboard
  - [ ] Back button works correctly
  - [ ] URLs update properly

- [ ] **Test Push Notifications**
  - [ ] Open Firebase Console → Cloud Messaging
  - [ ] Send test notification
  - [ ] App in foreground: notification appears as snackbar
  - [ ] App in background: notification received
  - [ ] Tap notification: app opens/navigates correctly

- [ ] **Test Session Memory**
  - [ ] Navigate to different dashboard page
  - [ ] Close app completely
  - [ ] Reopen app
  - [ ] App restores to last visited page
  - [ ] Check SharedPreferences has saved URL

---

## Phase 7: Performance & Optimization

- [ ] **Check App Size**
  ```bash
  flutter build apk --release
  ls -lh build/app/outputs/apk/release/
  ```
  - [ ] App size is reasonable (~50-80 MB)

- [ ] **Profile App Performance**
  ```bash
  flutter run --profile
  ```
  - [ ] Splash screen: < 2 seconds
  - [ ] Dashboard load: < 5 seconds
  - [ ] Memory usage: < 200 MB

- [ ] **Check Console Logs**
  ```bash
  flutter logs
  ```
  - [ ] No red errors
  - [ ] Firebase initialization success
  - [ ] No memory leaks
  - [ ] All services initialized

---

## Phase 8: Release Build

- [ ] **Android Release**
  - [ ] Create keystore (if not exists):
    ```bash
    keytool -genkey -v -keystore ~/.android/release-key.jks \
      -alias release-key -keyalg RSA -keysize 2048 -validity 10000
    ```
  - [ ] Create `android/key.properties` with keystore info
  - [ ] Build AAB for Google Play:
    ```bash
    flutter build appbundle --release
    ```
  - [ ] Output: `build/app/outputs/bundle/release/app-release.aab`

- [ ] **iOS Release**
  - [ ] Open `ios/Runner.xcworkspace` in Xcode
  - [ ] Select "Generic iOS Device" or device
  - [ ] Product → Archive
  - [ ] Validate and export
  - [ ] Can upload to App Store / TestFlight

- [ ] **Code Signing**
  - [ ] Android: Review signing configuration
  - [ ] iOS: Review provisioning profiles
  - [ ] Both: Verify signatures are valid

---

## Phase 9: Pre-Launch Checklist

- [ ] **Functionality**
  - [ ] All features working as expected
  - [ ] No crashes or errors
  - [ ] Performance acceptable
  - [ ] User experience smooth

- [ ] **Security**
  - [ ] Biometric working correctly
  - [ ] Session tokens secure
  - [ ] HTTPS enforced in WebView
  - [ ] Firebase setup secure

- [ ] **Content**
  - [ ] Dashboard URL correct
  - [ ] All strings reviewed
  - [ ] Logo and branding present
  - [ ] Colors match brand guidelines

- [ ] **Analytics**
  - [ ] FCM token saved
  - [ ] Session tracking works
  - [ ] Launch counter working
  - [ ] Can receive test notifications

- [ ] **Documentation**
  - [ ] Users know how to access
  - [ ] Password recovery documented
  - [ ] Support contact available
  - [ ] FAQ prepared

---

## Phase 10: Deployment

- [ ] **Google Play Console**
  - [ ] Create app listing
  - [ ] Upload AAB file
  - [ ] Add screenshots and description
  - [ ] Set pricing and distribution
  - [ ] Submit for review

- [ ] **Apple App Store**
  - [ ] Create app in App Store Connect
  - [ ] Upload IPA file
  - [ ] Add screenshots and description
  - [ ] Set pricing and distribution
  - [ ] Submit for review

- [ ] **Monitoring**
  - [ ] Setup Firebase Analytics
  - [ ] Monitor crash reports
  - [ ] Track user engagement
  - [ ] Monitor push notification delivery

---

## Phase 11: Post-Launch

- [ ] **User Feedback**
  - [ ] Collect user reviews
  - [ ] Monitor app ratings
  - [ ] Respond to feedback
  - [ ] Track bug reports

- [ ] **Updates**
  - [ ] Plan features/improvements
  - [ ] Fix reported bugs
  - [ ] Update dependencies monthly
  - [ ] Test new Flutter versions

- [ ] **Maintenance**
  - [ ] Monitor Firebase quota usage
  - [ ] Update Firebase configuration if needed
  - [ ] Review security logs
  - [ ] Update certificates annually

---

## 📱 Device Testing Matrix

| Platform | Device/OS | Biometric | Firebase | WebView |
|----------|-----------|-----------|----------|---------|
| Android  | Android 6+ | ✅ | ✅ | ✅ |
| iOS      | iOS 11+   | ✅ | ✅ | ✅ |
| Web      | Chrome    | N/A | ✅ | ✅ |

**Recommended Test Devices:**
- Android: Pixel 4+ (has biometric)
- iOS: iPhone 12+ (has Face ID)
- Testing: Also test on older devices without biometric

---

## ⚠️ Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Firebase credentials invalid | Double-check `firebase_options.dart` values |
| Biometric not prompting | Device may not support biometric |
| WebView shows blank | Check URL is correct and internet working |
| Notifications not received | Verify FCM token is saved and permissions granted |
| App crashes on launch | Check Flutter version >= 3.9.2 |
| Build fails | Run `flutter clean` and `flutter pub get` |
| Assets not found | Verify paths in `pubspec.yaml` match actual files |

See **IMPLEMENTATION_GUIDE.md** for detailed troubleshooting.

---

## 📞 Support Checklist

- [ ] Document all customizations made
- [ ] Keep Firebase credentials secure (never commit to git)
- [ ] Backup firebase_options.dart separately
- [ ] Save keystore file and password securely
- [ ] Document app store credentials location
- [ ] Setup issue tracking system
- [ ] Create support email address
- [ ] Prepare FAQ documentation

---

## ✅ Final Sign-Off

- [ ] ✅ All phases completed
- [ ] ✅ App tested on multiple devices
- [ ] ✅ Performance verified
- [ ] ✅ Security reviewed
- [ ] ✅ Documentation complete
- [ ] ✅ Ready for production

**App Status:** **READY TO DEPLOY** 🚀

---

**Last Updated:** March 2024  
**Version:** 1.0.0  
**Status:** Production Ready

Good luck with your ZEITNOIR premium app! 🎉
