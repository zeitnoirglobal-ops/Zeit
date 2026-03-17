/// App Constants
/// Centralized location for all app constants including:
/// - Colors and theme values
/// - URLs and API endpoints
/// - String constants
/// - Animation durations
/// - Layout dimensions
library;

import 'package:flutter/material.dart';

/// Color constants for Zeitnoir luxury theme
class AppColors {
  // Primary colors
  static const Color primaryBlack = Color(0xFF0F0F0F); // Main background
  static const Color darkBlack = Color(0xFF1A1A1A); // Secondary background
  static const Color gold = Color(0xFFD4AF37); // Luxury gold accent

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF); // White text
  static const Color textSecondary = Color(0xFFCCCCCC); // Light gray text
  static const Color textTertiary = Color(0xFF999999); // Medium gray text

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF2196F3);

  // Semi-transparent colors
  static Color blackOverlay = Colors.black.withValues(alpha: 0.6);
  static Color goldOverlay = gold.withValues(alpha: 0.1);
}

/// URL Constants
class AppUrls {
  // Dashboard URLs
  static const String dashboardBaseUrl = 'https://zeitnoir.com';
  static const String loginUrl = '$dashboardBaseUrl/login';
  static const String dashboardUrl = '$dashboardBaseUrl/dashboard';

  // Privacy & Terms
  static const String privacyPolicyUrl = '$dashboardBaseUrl/privacy';
  static const String termsOfServiceUrl = '$dashboardBaseUrl/terms';
}

/// String Constants (UI Text)
class AppStrings {
  // App branding
  static const String appName = 'ZEITNOIR';
  static const String appTagline = 'Elite Private Dashboard';

  // Splash Screen
  static const String splashTitle = 'ZEITNOIR';
  static const String splashSubtitle = 'Elite Private Dashboard';

  // Authentication
  static const String authBiometricReason =
      'Unlock ZEITNOIR - Your Elite Dashboard';
  static const String authBiometricTitle = 'Security Verification';
  static const String authBiometricSubtitle =
      'Please authenticate to access ZEITNOIR';
  static const String authFailedTitle = 'Authentication Failed';
  static const String authFailedMessage = 'Please try again to access ZEITNOIR';
  static const String authRetryButton = 'Retry';

  // Dashboard
  static const String dashboardTitle = 'ZEITNOIR Dashboard';
  static const String loadingDashboard = 'Loading Dashboard';
  static const String connectionErrorTitle = 'Connection Error';
  static const String connectionErrorMessage =
      'Unable to load the dashboard. Please check your connection.';
  static const String retryButton = 'Retry';

  // Notifications
  static const String notificationPermissionTitle = 'Enable Notifications';
  static const String notificationPermissionMessage =
      'Allow notifications to stay updated with ZEITNOIR alerts';
  static const String notificationCloseButton = 'Close';

  // General
  static const String errorTitle = 'Error';
  static const String successTitle = 'Success';
  static const String okButton = 'OK';
  static const String cancelButton = 'Cancel';
}

/// Animation Durations
class AppDurations {
  // Splash screen animations
  static const Duration splashAnimationDuration = Duration(milliseconds: 2000);
  static const Duration splashDelayDuration = Duration(seconds: 2);

  // Loading animations
  static const Duration loadingAnimationDuration = Duration(milliseconds: 1500);
  static const Duration spinnerDuration = Duration(milliseconds: 1200);

  // Transition animations
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration fadeInDuration = Duration(milliseconds: 500);

  // Notification display
  static const Duration notificationDisplayDuration = Duration(seconds: 5);

  // Dialog animations
  static const Duration dialogAnimationDuration = Duration(milliseconds: 200);
}

/// Layout Constants
class AppDimensions {
  // Margins and padding
  static const double marginExtraSmall = 4.0;
  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;
  static const double marginExtraLarge = 32.0;

  // Icon sizes
  static const double iconExtraSmall = 16.0;
  static const double iconSmall = 24.0;
  static const double iconMedium = 32.0;
  static const double iconLarge = 48.0;
  static const double iconExtraLarge = 64.0;

  // Border radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 16.0;
  static const double radiusExtraLarge = 24.0;
  static const double radiusCircle = 50.0;

  // Logo size
  static const double logoSize = 180.0;
  static const double splashLogoSize = 180.0;

  // AppBar height
  static const double appBarHeight = 56.0;

  // Button size
  static const double buttonHeight = 48.0;
  static const double buttonWidth = 120.0;
}

/// Typography Constants
class AppTypography {
  // Font families
  static const String primaryFont = 'Montserrat';
  static const String luxuryFont = 'Luxurious';

  // Font sizes
  static const double fontExtraSmall = 10.0;
  static const double fontSmall = 12.0;
  static const double fontMedium = 14.0;
  static const double fontLarge = 16.0;
  static const double fontExtraLarge = 18.0;
  static const double fontTitle = 24.0;
  static const double fontDisplaySmall = 28.0;
  static const double fontDisplayLarge = 32.0;

  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Letter spacing
  static const double spacingSmall = 0.5;
  static const double spacingMedium = 1.0;
  static const double spacingLarge = 1.5;
  static const double spacingExtraLarge = 2.0;
  static const double spacingHuge = 3.0;
}

/// Feature Flags - Control feature availability
class FeatureFlags {
  // Authentication
  static const bool enableBiometric = true;
  static const bool enablePushNotifications = true;

  // UI Features
  static const bool enableDarkTheme = true;
  static const bool enableAnimations = true;

  // Debug
  static const bool enableDebugLogging = true;
  static const bool showDebugBanner = false;
}

/// Firebase Configuration
class FirebaseConfig {
  // Notification channel settings
  static const String notificationChannelId = 'zeitnoir_notifications';
  static const String notificationChannelName = 'ZEITNOIR Alerts';
  static const String notificationChannelDescription =
      'Notifications from ZEITNOIR Dashboard';

  // Importance level (AndroidNotificationImportance)
  // 4 = high, 3 = default, 2 = low, 1 = min, 0 = none
  static const int notificationChannelImportance = 4;
}

/// Storage Keys - Keys used in SharedPreferences
class StorageKeys {
  // User session
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyAccessToken = 'access_token';
  static const String keySessionTimestamp = 'session_timestamp';

  // Navigation
  static const String keyLastVisitedUrl = 'last_visited_url';
  static const String keyLastVisitTimestamp = 'last_visit_timestamp';

  // Preferences
  static const String keyDarkMode = 'dark_mode';
  static const String keyLanguage = 'language';
  static const String keyPushNotificationsEnabled =
      'push_notifications_enabled';

  // Biometric
  static const String keyBiometricEnabled = 'biometric_enabled';

  // FCM
  static const String keyFcmToken = 'fcm_token';

  // Analytics
  static const String keyAppLaunchCount = 'app_launch_count';
  static const String keyFirstLaunchTimestamp = 'first_launch_timestamp';
}

/// Error Messages
class ErrorMessages {
  static const String biometricNotAvailable =
      'Biometric authentication is not available on this device.';
  static const String biometricFailed =
      'Biometric authentication failed. Please try again.';
  static const String connectionError =
      'Connection error. Please check your internet connection.';
  static const String unknownError =
      'An unknown error occurred. Please try again.';
  static const String timeoutError =
      'The operation timed out. Please try again.';
  static const String firebaseError =
      'Firebase initialization failed. Please restart the app.';
}
