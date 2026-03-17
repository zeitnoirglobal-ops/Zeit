import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

// ========================
// MAIN ENTRY POINT
// ========================
void main() async {
  // Ensure Flutter bindings are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase Messaging foreground message handler
  FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

  runApp(const ZeitnoirApp());
}

// ========================
// BACKGROUND MESSAGE HANDLER
// ========================
/// Handles notifications when app is in background/terminated
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.notification?.title}');
  // Store notification or trigger an action
}

/// Handles notifications when app is in foreground
void _handleForegroundMessage(RemoteMessage message) {
  debugPrint('Got a message whilst in the foreground!');
  debugPrint('Message data: ${message.data}');

  if (message.notification != null) {
    debugPrint(
      'Message also contained a notification: ${message.notification}',
    );
    // You can show an in-app notification here
    // ScaffoldMessenger.of(context).showSnackBar(...)
  }
}

// ========================
// MAIN APP CLASS
// ========================
class ZeitnoirApp extends StatelessWidget {
  const ZeitnoirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZEITNOIR',
      theme: ThemeData(
        // Luxury dark theme
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        primaryColor: const Color(0xFFD4AF37), // Gold accent
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
          titleLarge: TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
          bodyMedium: TextStyle(
            color: Color(0xFFCCCCCC),
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ========================
// SPLASH SCREEN
// ========================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final LocalAuthentication _auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();

    // Setup animations for luxury feel
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    // After splash animation, proceed to biometric auth
    Future.delayed(const Duration(seconds: 2), _authenticateUser);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Authenticates user with biometric if available, otherwise goes to login
  Future<void> _authenticateUser() async {
    try {
      // Check if biometric is available
      final bool isBiometricAvailable = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();

      if (!isBiometricAvailable || !isDeviceSupported) {
        // No biometric available, go directly to dashboard
        if (mounted) {
          _navigateToDashboard();
        }
        return;
      }

      // Retrieve stored authentication preference
      final prefs = await SharedPreferences.getInstance();
      final bool biometricEnabled = prefs.getBool('biometric_enabled') ?? false;

      if (!biometricEnabled) {
        // First time or user disabled biometric, go to dashboard
        if (mounted) {
          _navigateToDashboard();
        }
        return;
      }

      // Perform biometric authentication
      final bool authenticated = await _auth.authenticate(
        localizedReason: 'Unlock ZEITNOIR - Your Elite Dashboard',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated && mounted) {
        _navigateToDashboard();
      } else if (!authenticated && mounted) {
        // Authentication failed, show error and retry
        _showAuthError();
      }
    } catch (e) {
      debugPrint('Biometric auth error: $e');
      if (mounted) {
        _navigateToDashboard();
      }
    }
  }

  /// Shows error dialog for failed authentication
  void _showAuthError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Authentication Failed',
          style: TextStyle(color: Color(0xFFD4AF37)),
        ),
        content: const Text(
          'Please try again to access ZEITNOIR',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _authenticateUser();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Navigate to dashboard screen
  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with luxury styling
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFD4AF37),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Z',
                      style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Brand name with elegant styling
                Text(
                  'ZEITNOIR',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    letterSpacing: 3.0,
                    fontSize: 42,
                  ),
                ),
                const SizedBox(height: 12),
                // Tagline
                Text(
                  'Elite Private Dashboard',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFD4AF37),
                    fontSize: 16,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 60),
                // Loading indicator with luxury styling
                const SpinKitRipple(color: Color(0xFFD4AF37), size: 60.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ========================
// DASHBOARD SCREEN (WEBVIEW)
// ========================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late WebViewController _webViewController;
  bool _isLoading = true;
  String _lastUrl = 'https://zeitnoir.com/login';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    _setupPushNotifications();
    _loadLastVisitedPage();
  }

  /// Initialize WebView with comprehensive settings
  void _initializeWebView() {
    _webViewController = WebViewController()
      // Enable JavaScript for interactive dashboard
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // Load the dashboard URL
      ..loadRequest(Uri.parse(_lastUrl))
      // Set navigation delegate to track page changes
      ..setNavigationDelegate(
        NavigationDelegate(
          // Called when page starts loading
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _lastUrl = url;
            });
            debugPrint('Page started loading: $url');
          },
          // Called when page finishes loading
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            // Save the last visited URL
            _saveLastVisitedPage(url);
            debugPrint('Page finished loading: $url');
          },
          // Handle navigation errors
          onWebResourceError: (WebResourceError error) {
            debugPrint('Web resource error: ${error.description}');
            _showConnectionError();
          },
          // Handle URL changes
          onUrlChange: (UrlChange change) {
            debugPrint('URL changed to: ${change.url}');
            if (change.url != null) {
              _lastUrl = change.url!;
              _saveLastVisitedPage(change.url!);
            }
          },
        ),
      )
      // Set user agent for better compatibility
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
      );
  }

  /// Setup Firebase Push Notifications
  void _setupPushNotifications() async {
    // Request permission for push notifications
    await FirebaseMessaging.instance.requestPermission();

    // Get FCM token for this device
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $fcmToken');

    // Save FCM token to preferences or your backend
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', fcmToken ?? '');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Message received: ${message.notification?.title}');
      _showPushNotificationInApp(message);
    });

    // Handle notification tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Message opened: ${message.notification?.title}');
      // Navigate to specific page if needed
    });
  }

  /// Display push notification in-app
  void _showPushNotificationInApp(RemoteMessage message) {
    if (!mounted) return;

    final snackBar = SnackBar(
      content: Text(message.notification?.title ?? 'New Notification'),
      backgroundColor: const Color(0xFFD4AF37),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.black,
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Load the last visited page from preferences
  Future<void> _loadLastVisitedPage() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUrl = prefs.getString('last_visited_url');

    if (lastUrl != null && lastUrl.isNotEmpty) {
      setState(() {
        _lastUrl = lastUrl;
      });
      // Reload with saved URL
      await _webViewController.loadRequest(Uri.parse(_lastUrl));
    }
  }

  /// Save current page URL to preferences
  Future<void> _saveLastVisitedPage(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_visited_url', url);
    debugPrint('Saved last visited URL: $url');
  }

  /// Show connection error dialog
  void _showConnectionError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Connection Error',
          style: TextStyle(color: Color(0xFFD4AF37)),
        ),
        content: const Text(
          'Unable to load the dashboard. Please check your connection.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _webViewController.reload();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // Allow back navigation in WebView
        if (await _webViewController.canGoBack()) {
          await _webViewController.goBack();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F0F),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A1A1A),
          elevation: 0,
          title: const Text(
            'ZEITNOIR Dashboard',
            style: TextStyle(
              color: Color(0xFFD4AF37),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
          actions: [
            // Refresh button
            IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFFD4AF37)),
              onPressed: () => _webViewController.reload(),
            ),
          ],
        ),
        body: Stack(
          children: [
            // WebView displaying the dashboard
            WebViewWidget(controller: _webViewController),

            // Loading overlay with premium animation
            if (_isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.6),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SpinKitFadingCircle(
                        color: Color(0xFFD4AF37),
                        size: 50.0,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Loading Dashboard',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFD4AF37),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
