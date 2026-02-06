import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('ERROR: $message');
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
      debugPrint('INFO: $message');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('WARNING: $message');
    }
  }

  static void debug(String message) {
    if (kDebugMode) {
      debugPrint('DEBUG: $message');
    }
  }
}
