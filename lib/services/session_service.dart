/// Session Management Service
/// Handles user session data, preferences, and app state persistence
/// Features:
/// - User session tracking
/// - Last visited page memory
/// - Preference storage
/// - Theme preferences
/// - Device information caching
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static final SessionService _instance = SessionService._internal();

  factory SessionService() {
    return _instance;
  }

  SessionService._internal();

  late SharedPreferences _prefs;

  /// Initialize session service
  /// Must be called before using other methods
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    debugPrint('Session service initialized');
  }

  // ========================
  // USER SESSION MANAGEMENT
  // ========================

  /// Save user authentication state
  Future<bool> saveUserSession({
    required String userId,
    required String userEmail,
    required String accessToken,
  }) async {
    try {
      await _prefs.setString('user_id', userId);
      await _prefs.setString('user_email', userEmail);
      await _prefs.setString('access_token', accessToken);
      await _prefs.setInt(
        'session_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );
      return true;
    } catch (e) {
      debugPrint('Error saving user session: $e');
      return false;
    }
  }

  /// Get current user ID
  String? getUserId() {
    return _prefs.getString('user_id');
  }

  /// Get current user email
  String? getUserEmail() {
    return _prefs.getString('user_email');
  }

  /// Get access token
  String? getAccessToken() {
    return _prefs.getString('access_token');
  }

  /// Check if user is logged in
  bool isUserLoggedIn() {
    return _prefs.containsKey('user_id') && _prefs.containsKey('access_token');
  }

  /// Clear user session (logout)
  Future<bool> clearSession() async {
    try {
      await _prefs.remove('user_id');
      await _prefs.remove('user_email');
      await _prefs.remove('access_token');
      await _prefs.remove('session_timestamp');
      debugPrint('User session cleared');
      return true;
    } catch (e) {
      debugPrint('Error clearing session: $e');
      return false;
    }
  }

  // ========================
  // NAVIGATION STATE
  // ========================

  /// Save the last visited dashboard page
  /// Called when user navigates within the WebView
  Future<bool> saveLastVisitedPage(String url) async {
    try {
      await _prefs.setString('last_visited_url', url);
      await _prefs.setInt(
        'last_visit_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );
      return true;
    } catch (e) {
      debugPrint('Error saving last visited page: $e');
      return false;
    }
  }

  /// Get the last visited page URL
  String? getLastVisitedPage() {
    return _prefs.getString('last_visited_url') ?? 'https://zeitnoir.com/login';
  }

  /// Get timestamp of last visit
  DateTime? getLastVisitTimestamp() {
    final timestamp = _prefs.getInt('last_visit_timestamp');
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  // ========================
  // APP PREFERENCES
  // ========================

  /// Save theme preference (light/dark)
  Future<bool> setThemeMode(bool isDarkMode) async {
    try {
      await _prefs.setBool('dark_mode', isDarkMode);
      return true;
    } catch (e) {
      debugPrint('Error setting theme: $e');
      return false;
    }
  }

  /// Get theme preference
  bool isDarkModeEnabled() {
    return _prefs.getBool('dark_mode') ?? true; // Default to dark
  }

  /// Save language preference
  Future<bool> setLanguage(String languageCode) async {
    try {
      await _prefs.setString('language', languageCode);
      return true;
    } catch (e) {
      debugPrint('Error setting language: $e');
      return false;
    }
  }

  /// Get language preference
  String getLanguage() {
    return _prefs.getString('language') ?? 'en'; // Default to English
  }

  /// Save notification preferences
  Future<bool> setNotificationsEnabled(bool enabled) async {
    try {
      await _prefs.setBool('push_notifications_enabled', enabled);
      return true;
    } catch (e) {
      debugPrint('Error setting notification preference: $e');
      return false;
    }
  }

  /// Check if notifications are enabled
  bool areNotificationsEnabled() {
    return _prefs.getBool('push_notifications_enabled') ?? true;
  }

  // ========================
  // APP STATISTICS
  // ========================

  /// Get number of app launches
  int getAppLaunchCount() {
    return _prefs.getInt('app_launch_count') ?? 0;
  }

  /// Increment app launch counter
  Future<void> incrementAppLaunchCount() async {
    int count = getAppLaunchCount();
    await _prefs.setInt('app_launch_count', count + 1);
  }

  /// Get first launch timestamp
  DateTime? getFirstLaunchTime() {
    final timestamp = _prefs.getInt('first_launch_timestamp');
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Set first launch timestamp
  Future<void> setFirstLaunchTime() async {
    if (!_prefs.containsKey('first_launch_timestamp')) {
      await _prefs.setInt(
        'first_launch_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  // ========================
  // SECURITY
  // ========================

  /// Check if session has expired
  /// Sessions expire after 24 hours by default
  bool isSessionExpired({Duration expiration = const Duration(hours: 24)}) {
    final timestamp = _prefs.getInt('session_timestamp');
    if (timestamp == null) return true;

    final sessionTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    return now.difference(sessionTime) > expiration;
  }

  /// Clear all app data (nuclear option)
  Future<bool> clearAllData() async {
    try {
      await _prefs.clear();
      debugPrint('All app data cleared');
      return true;
    } catch (e) {
      debugPrint('Error clearing all data: $e');
      return false;
    }
  }
}
