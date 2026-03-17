## ZEITNOIR - Quick API Reference & Common Tasks

This document provides quick examples of common operations in the ZEITNOIR app.

### Table of Contents
1. [Session Management](#session-management)
2. [Biometric Authentication](#biometric-authentication)
3. [Push Notifications](#push-notifications)
4. [WebView Operations](#webview-operations)
5. [Utilities](#utilities)

---

## Session Management

### Get User Information

```dart
import 'package:zeitnoir_app/services/session_service.dart';

final session = SessionService();

// Get user ID
String? userId = session.getUserId();

// Get user email
String? email = session.getUserEmail();

// Get access token
String? token = session.getAccessToken();

// Check if logged in
bool loggedIn = session.isUserLoggedIn();
```

### Save User Session

```dart
await session.saveUserSession(
  userId: 'user_123',
  userEmail: 'user@example.com',
  accessToken: 'token_abc123',
);
```

### Remember Last Visited Page

```dart
// Automatically saved when WebView navigates
// Manual save if needed:
await session.saveLastVisitedPage('https://zeitnoir.com/dashboard/analytics');

// Retrieve on app launch:
String lastUrl = session.getLastVisitedPage();
```

### Logout

```dart
// Clear session
await session.clearSession();

// Navigate to login screen
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => const LoginScreen()),
);
```

### Check Session Expiration

```dart
bool expired = session.isSessionExpired(
  expiration: Duration(hours: 24), // Customize duration
);

if (expired) {
  // Re-authenticate user
}
```

---

## Biometric Authentication

### Check Availability

```dart
import 'package:zeitnoir_app/services/biometric_service.dart';

final biometric = BiometricService();

// Check if device supports biometric
bool available = await biometric.isBiometricAvailable();

if (!available) {
  print('Device does not support biometric authentication');
}
```

### Get Available Biometric Types

```dart
List<BiometricType> types = await biometric.getAvailableBiometrics();

for (var type in types) {
  String name = biometric.getBiometricTypeName(type);
  print('Available: $name');
  // Output: Available: Face ID
  //         Available: Fingerprint
}
```

### Authenticate User

```dart
bool authenticated = await biometric.authenticate(
  localizedReason: 'Verify your identity to continue',
  dialogTitle: 'Biometric Confirmation',
  dialogSubtitle: 'Use your fingerprint or face ID',
);

if (authenticated) {
  print('User authenticated successfully');
} else {
  print('Authentication failed');
}
```

### Enable/Disable Biometric for App

```dart
// Remember user's choice
await biometric.enableBiometric();  // Enable
// or
await biometric.disableBiometric(); // Disable

// Check status
bool isEnabled = await biometric.isBiometricEnabled();
```

### Full Authentication Flow

```dart
Future<void> handleBiometricLogin() async {
  final biometric = BiometricService();
  
  // Step 1: Check availability
  bool available = await biometric.isBiometricAvailable();
  if (!available) {
    _showError('Biometric not available');
    return;
  }
  
  // Step 2: Get types
  List<BiometricType> types = await biometric.getAvailableBiometrics();
  String typeList = types
      .map((t) => biometric.getBiometricTypeName(t))
      .join(', ');
  
  // Step 3: Authenticate
  bool authenticated = await biometric.authenticate(
    localizedReason: 'Login with biometric',
    dialogTitle: 'ZEITNOIR Login',
    dialogSubtitle: 'Available: $typeList',
  );
  
  if (authenticated) {
    _navigateToDashboard();
  }
}
```

---

## Push Notifications

### Initialize Notifications

```dart
import 'package:zeitnoir_app/services/notification_service.dart';

final notifications = NotificationService();

// In main() or app initialization
await notifications.initializeNotifications();

// Get FCM token for sending notifications
String? token = await notifications.getFCMToken();
print('Send notifications to token: $token');
```

### Get Saved FCM Token

```dart
String? token = await notifications.getFCMToken();

if (token != null) {
  // Send to backend to register device
  await registerDeviceOnBackend(token);
}
```

### Handle Foreground Messages

```dart
notifications.setupForegroundMessageHandler((RemoteMessage message) {
  print('Got message: ${message.notification?.title}');
  
  // Show custom notification or dialog
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(message.notification?.title ?? ''),
      content: Text(message.notification?.body ?? ''),
    ),
  );
});
```

### Handle Notification Tap

```dart
notifications.setupNotificationOpenedHandler((RemoteMessage message) {
  print('Notification tapped: ${message.data}');
  
  // Navigate to specific page based on notification data
  if (message.data['page'] == 'orders') {
    Navigator.of(context).pushNamed('/orders');
  }
});
```

### Get Initial Message (App Launched by Notification)

```dart
@override
void initState() {
  super.initState();
  _checkInitialNotification();
}

Future<void> _checkInitialNotification() async {
  final notifications = NotificationService();
  RemoteMessage? message = await notifications.getInitialMessage();
  
  if (message != null) {
    // Handle notification that launched the app
    print('App launched via notification: ${message.notification?.title}');
    _handleNotificationData(message.data);
  }
}
```

### Send Test Notification

In Firebase Console → Cloud Messaging → Send your first message:

```json
{
  "notification": {
    "title": "Hello ZEITNOIR User",
    "body": "This is a test notification"
  },
  "data": {
    "page": "dashboard",
    "action": "refresh"
  }
}
```

---

## WebView Operations

### Navigate to URL

```dart
// In your DashboardScreen
_webViewController.loadRequest(Uri.parse('https://zeitnoir.com/dashboard'));
```

### Go Back/Forward

```dart
// Go back
if (await _webViewController.canGoBack()) {
  await _webViewController.goBack();
}

// Go forward
if (await _webViewController.canGoForward()) {
  await _webViewController.goForward();
}
```

### Reload Page

```dart
await _webViewController.reload();
```

### Inject JavaScript

```dart
await _webViewController.runJavaScript('''
  document.querySelector('h1').innerHTML = 'Updated Title';
''');
```

### Get Current URL

```dart
String currentUrl = 'stored in _lastUrl variable';
// or get from WebView state
```

### Handle Navigation Events

```dart
..setNavigationDelegate(NavigationDelegate(
  onPageStarted: (String url) {
    setState(() => _isLoading = true);
  },
  onPageFinished: (String url) {
    setState(() => _isLoading = false);
  },
  onUrlChange: (UrlChange change) {
    print('URL changed to: ${change.url}');
    session.saveLastVisitedPage(change.url!);
  },
  onWebResourceError: (WebResourceError error) {
    print('Error: ${error.description}');
  },
))
```

---

## Utilities

### String Operations

```dart
import 'package:zeitnoir_app/utils/app_utils.dart';

// Validate email
bool isValid = StringUtils.isEmail('user@example.com');

// Check password strength
String strength = StringUtils.getPasswordStrength('Pass123!');
// Output: "Strong", "Medium", "Weak"

// Validate phone
bool isPhone = StringUtils.isPhoneNumber('+1-555-0123');

// Capitalize
String name = StringUtils.capitalize('john'); // "John"

// Truncate
String short = StringUtils.truncate('Long text here', maxLength: 10);
// "Long text..."

// Remove whitespace
String cleaned = StringUtils.removeWhitespace('hello world'); // "helloworld"
```

### Date & Time

```dart
// Format date
String formatted = DateTimeUtils.formatDate(DateTime.now());
// "Mar 12, 2024"

// Format time
String time = DateTimeUtils.formatTime(DateTime.now());
// "14:30"

// Get "time ago" string
DateTime pastDate = DateTime.now().subtract(Duration(hours: 2));
String ago = DateTimeUtils.getTimeAgo(pastDate);
// "2h ago"

// Check if today
bool isToday = DateTimeUtils.isToday(DateTime.now()); // true
bool isYesterday = DateTimeUtils.isYesterday(someDate);

// Get date only (no time)
DateTime dateOnly = DateTimeUtils.getDateOnly(DateTime.now());
```

### Number Formatting

```dart
// Format number with separators
String num = NumberUtils.formatNumber(1000000);
// "1,000,000"

// Format currency
String price = NumberUtils.formatCurrency(99.99); // "$99.99"

// Format bytes
String size = NumberUtils.formatBytes(1024 * 1024); // "1.00 MB"

// Format percentage
String pct = NumberUtils.formatPercentage(0.85); // "85.00%"

// Clamp number
num clamped = NumberUtils.clamp(150, 0, 100); // 100
```

### Device Info

```dart
// Get device type
String type = DeviceUtils.getDeviceType(context);
// "mobile", "tablet", or "desktop"

// Check orientation
bool landscape = DeviceUtils.isLandscape(context);
bool portrait = !landscape;

// Check dark mode
bool dark = DeviceUtils.isDarkMode(context);

// Get screen dimensions
Size screen = DeviceUtils.getScreenSize(context);
double width = screen.width;
double height = screen.height;

// Get safe area
EdgeInsets padding = DeviceUtils.getSafeAreaPadding(context);
```

### URL Utilities

```dart
// Validate URL
bool valid = UrlUtils.isValidUrl('https://zeitnoir.com');

// Get domain
String domain = UrlUtils.getDomain('https://zeitnoir.com/path');
// "zeitnoir.com"

// Check if HTTPS
bool secure = UrlUtils.isSecureUrl('https://zeitnoir.com'); // true

// Add query parameters
String url = UrlUtils.addQueryParams(
  'https://zeitnoir.com/search',
  {'q': 'dashboard', 'sort': 'date'},
);
// "https://zeitnoir.com/search?q=dashboard&sort=date"

// Get query parameter
String? query = UrlUtils.getQueryParameter(url, 'q');
// "dashboard"
```

### Logging

```dart
LogUtils.logInfo('User logged in successfully');
LogUtils.logDebug('Debug information for development');
LogUtils.logWarning('Session about to expire');
LogUtils.logError('Failed to save session', exception, stackTrace);

// Console output
// [ZEITNOIR] [INFO] User logged in successfully
// [ZEITNOIR] [DEBUG] Debug information for development
// [ZEITNOIR] [WARNING] Session about to expire
// [ZEITNOIR] [ERROR] Failed to save session
```

---

## Complete Example: Setting Up App on Launch

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize services
  final notifications = NotificationService();
  await notifications.initializeNotifications();
  
  final session = SessionService();
  await session.initialize();
  
  // Track app launch
  await session.incrementAppLaunchCount();
  await session.setFirstLaunchTime();
  
  // Setup notification handlers
  notifications.setupForegroundMessageHandler((msg) {
    _showNotification(msg);
  });
  
  LogUtils.logInfo('App initialized successfully');
  
  runApp(const ZeitnoirApp());
}
```

---

## Complete Example: Full Login Flow

```dart
Future<void> fullLoginFlow() async {
  try {
    // 1. Check biometric
    final biometric = BiometricService();
    bool bioAvailable = await biometric.isBiometricAvailable();
    
    if (bioAvailable) {
      // 2. Authenticate
      bool authenticated = await biometric.authenticate(
        localizedReason: 'Login to ZEITNOIR',
        dialogTitle: 'Security Check',
        dialogSubtitle: 'Use your biometric',
      );
      
      if (!authenticated) {
        throw Exception('Biometric authentication failed');
      }
    }
    
    // 3. Save session
    final session = SessionService();
    await session.saveUserSession(
      userId: 'user_123',
      userEmail: 'user@zeitnoir.com',
      accessToken: 'token_xyz',
    );
    
    // 4. Get last page and navigate
    String lastPage = session.getLastVisitedPage();
    _webViewController.loadRequest(Uri.parse(lastPage));
    
    // 5. Setup notifications
    final notifications = NotificationService();
    String? token = await notifications.getFCMToken();
    await registerTokenOnBackend(token);
    
    LogUtils.logInfo('Login successful');
    
  } catch (e) {
    LogUtils.logError('Login failed', e);
    _showErrorDialog(e.toString());
  }
}
```

---

**Pro Tips:**
- Always use `try-catch` for async operations
- Initialize services once in `main()`
- Store tokens securely (consider `flutter_secure_storage`)
- Test on real devices for biometric and notifications
- Check logs with: `flutter logs`

For more details, see `IMPLEMENTATION_GUIDE.md`
