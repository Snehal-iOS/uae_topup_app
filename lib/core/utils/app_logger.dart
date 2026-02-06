import 'package:flutter/foundation.dart';

/// This file contains logging utility for the application
/// Provides consistent logging across the application with different log levels.
/// In debug mode, logs are printed to console. In production, errors can be sent to crash reporting services.
class AppLogger {
  AppLogger._();

  static void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (kDebugMode) {
      debugPrint('❌ ERROR: $message');
      if (error != null) {
        debugPrint('   Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('   Stack: $stackTrace');
      }
    }
    // TODO: In production, send to crash reporting service (e.g., Firebase Crashlytics or NewRelic etc)
  }

  static void info(String message) {
    if (kDebugMode) {
      debugPrint('ℹ️ INFO: $message');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('⚠️ WARNING: $message');
    }
  }

  static void debug(String message) {
    if (kDebugMode) {
      debugPrint('🐛 DEBUG: $message');
    }
  }
}
