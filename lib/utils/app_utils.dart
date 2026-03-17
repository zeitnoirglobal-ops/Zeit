/// App Utilities
/// Common utility functions used throughout the application
/// Includes:
/// - Validation helpers
/// - String formatting
/// - Date/time formatting
/// - Device information
/// - Network checking
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Authentication Utilities
class AuthUtils {
  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate password strength
  static bool isStrongPassword(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) && // Has uppercase
        password.contains(RegExp(r'[a-z]')) && // Has lowercase
        password.contains(RegExp(r'[0-9]')); // Has number
  }

  /// Get password strength indicator (weak, medium, strong)
  static String getPasswordStrength(String password) {
    if (password.isEmpty) return 'Empty';
    if (password.length < 6) return 'Weak';
    if (password.length < 8) return 'Medium';
    if (isStrongPassword(password)) return 'Strong';
    return 'Medium';
  }
}

/// String Utilities
class StringUtils {
  /// Capitalize first letter of string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Capitalize all words in string
  static String capitalizeAllWords(String text) {
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  /// Truncate string to max length with ellipsis
  static String truncate(String text, {int maxLength = 20}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Check if string is email
  static bool isEmail(String text) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(text);
  }

  /// Check if string is phone number
  static bool isPhoneNumber(String text) {
    return RegExp(r'^[\d\s\-\+\(\)]{10,}$').hasMatch(text);
  }

  /// Remove all whitespace
  static String removeWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+'), '');
  }

  /// Check if string contains numbers
  static bool hasNumbers(String text) {
    return RegExp(r'\d').hasMatch(text);
  }

  /// Check if string contains special characters
  static bool hasSpecialCharacters(String text) {
    return RegExp(
      r"[!@#$%^&*()_+\-=\[\]{};:'"
      r'",.<>?/\\|`~]',
    ).hasMatch(text);
  }
}

/// Date and Time Utilities
class DateTimeUtils {
  /// Format DateTime to readable string
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }

  /// Format DateTime to date only
  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  /// Format DateTime to time only
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Get time difference in readable format (e.g., "2 hours ago")
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatDate(dateTime);
    }
  }

  /// Check if date is today
  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime dateTime) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day;
  }

  /// Get date with time removed (midnight)
  static DateTime getDateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}

/// Device and System Utilities
class DeviceUtils {
  /// Get device type (mobile, tablet, desktop)
  static String getDeviceType(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (size.width < 600) {
      return 'mobile';
    } else if (size.width < 1200) {
      return 'tablet';
    } else {
      return 'desktop';
    }
  }

  /// Check if device is landscape
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Check if device is in dark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get screen size
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /// Get device pixel ratio (for handling retina displays)
  static double getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  /// Get screen padding (notch, status bar, etc.)
  static EdgeInsets getScreenPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Get safe area padding (accounting for notches and safe areas)
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).viewPadding;
  }
}

/// Number and Currency Utilities
class NumberUtils {
  /// Format number with thousand separators
  static String formatNumber(num number) {
    return NumberFormat('#,##0').format(number);
  }

  /// Format currency
  static String formatCurrency(num amount, {String symbol = '\$'}) {
    return '$symbol${NumberFormat('#,##0.00').format(amount)}';
  }

  /// Format bytes to human readable size
  static String formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  /// Format percentage
  static String formatPercentage(double value, {int decimals = 2}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  /// Clamp number between min and max
  static num clamp(num value, num min, num max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}

/// URL and Navigation Utilities
class UrlUtils {
  /// Check if URL is valid
  static bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get domain from URL
  static String? getDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return null;
    }
  }

  /// Check if URL is secure (HTTPS)
  static bool isSecureUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == 'https';
    } catch (e) {
      return false;
    }
  }

  /// Add query parameters to URL
  static String addQueryParams(String url, Map<String, String> params) {
    try {
      final uri = Uri.parse(url);
      final newUri = uri.replace(
        queryParameters: {...uri.queryParameters, ...params},
      );
      return newUri.toString();
    } catch (e) {
      return url;
    }
  }

  /// Get query parameter from URL
  static String? getQueryParameter(String url, String paramName) {
    try {
      final uri = Uri.parse(url);
      return uri.queryParameters[paramName];
    } catch (e) {
      return null;
    }
  }
}

/// Console Logging Utilities
class LogUtils {
  static const String _prefix = '[ZEITNOIR]';

  /// Log info message
  static void logInfo(String message) {
    debugPrint('$_prefix [INFO] $message');
  }

  /// Log debug message
  static void logDebug(String message) {
    debugPrint('$_prefix [DEBUG] $message');
  }

  /// Log warning message
  static void logWarning(String message) {
    debugPrint('$_prefix [WARNING] $message');
  }

  /// Log error message
  static void logError(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    debugPrint('$_prefix [ERROR] $message');
    if (error != null) {
      debugPrint('Error details: $error');
    }
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
  }
}
