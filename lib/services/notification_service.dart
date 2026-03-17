/// Notification Service
/// Handles all Firebase Cloud Messaging operations for push notifications
/// This service manages:
/// - FCM token retrieval and storage
/// - Permission handling
/// - Message listeners setup
/// - Notification display logic
library;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Initialize notifications service
  /// Call this in main.dart after Firebase initialization
  Future<void> initializeNotifications() async {
    try {
      // Request notification permissions (iOS)
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

      debugPrint('User granted permission: ${settings.authorizationStatus}');

      // Get FCM token for this device
      final String? token = await _firebaseMessaging.getToken();
      debugPrint('FCM Token: $token');

      // Save token to SharedPreferences for later use
      if (token != null) {
        await _saveFCMToken(token);
      }

      // Listen for token refresh (token may change periodically)
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        debugPrint('Token refreshed: $newToken');
        _saveFCMToken(newToken);
      });
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  /// Save FCM token to local storage
  Future<void> _saveFCMToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
    } catch (e) {
      debugPrint('Error saving FCM token: $e');
    }
  }

  /// Retrieve saved FCM token
  Future<String?> getFCMToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }

  /// Handle notifications received in foreground
  /// This will be called when the app is open
  void setupForegroundMessageHandler(
    Function(RemoteMessage) onMessageReceived,
  ) {
    FirebaseMessaging.onMessage.listen(onMessageReceived);
  }

  /// Handle notifications when app is opened from background
  /// This is called when user taps on a notification
  void setupNotificationOpenedHandler(
    Function(RemoteMessage) onNotificationOpened,
  ) {
    FirebaseMessaging.onMessageOpenedApp.listen(onNotificationOpened);
  }

  /// Get initial message (if app was launched by tapping a notification)
  Future<RemoteMessage?> getInitialMessage() {
    return _firebaseMessaging.getInitialMessage();
  }
}
