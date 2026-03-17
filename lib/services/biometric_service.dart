/// Biometric Authentication Service
/// Handles all biometric operations (fingerprint, Face ID)
/// This service provides:
/// - Availability checking
/// - Authentication handling
/// - Error management
/// - User preference storage
library;

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  static final BiometricService _instance = BiometricService._internal();

  factory BiometricService() {
    return _instance;
  }

  BiometricService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if biometric authentication is available on device
  Future<bool> isBiometricAvailable() async {
    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
      return false;
    }
  }

  /// Get list of available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Authenticate user with biometric
  /// Returns true if authentication is successful
  Future<bool> authenticate({
    required String localizedReason,
    required String dialogTitle,
    required String dialogSubtitle,
  }) async {
    try {
      final bool isAvailable = await isBiometricAvailable();

      if (!isAvailable) {
        debugPrint('Biometric authentication not available');
        return false;
      }

      final bool authenticated = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          stickyAuth: true, // Keep auth dialog open until success or failure
          biometricOnly: true, // Only use biometric, not PIN/password
          useErrorDialogs: true, // Show system error dialogs
        ),
      );

      return authenticated;
    } catch (e) {
      debugPrint('Biometric authentication error: $e');
      return false;
    }
  }

  /// Check if user has enabled biometric login
  Future<bool> isBiometricEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('biometric_enabled') ?? false;
    } catch (e) {
      debugPrint('Error reading biometric preference: $e');
      return false;
    }
  }

  /// Enable biometric login for this device
  Future<bool> enableBiometric() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('biometric_enabled', true);
      debugPrint('Biometric authentication enabled');
      return true;
    } catch (e) {
      debugPrint('Error enabling biometric: $e');
      return false;
    }
  }

  /// Disable biometric login for this device
  Future<bool> disableBiometric() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('biometric_enabled', false);
      debugPrint('Biometric authentication disabled');
      return true;
    } catch (e) {
      debugPrint('Error disabling biometric: $e');
      return false;
    }
  }

  /// Get user-friendly biometric type name
  String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.iris:
        return 'Iris Scan';
      case BiometricType.strong:
        return 'Strong Biometric';
      case BiometricType.weak:
        return 'Weak Biometric';
    }
  }
}
