import '../errors/custom_exception.dart';

/// Utility class for extracting and formatting error messages
/// Provides consistent error message extraction across the application.
/// Handles both custom exceptions and generic exceptions.
class ErrorHelper {
  ErrorHelper._(); // Private constructor to prevent instantiation

  static String extractErrorMessage(Object? error) {
    if (error is CustomException) {
      return error.message;
    }

    // Remove common exception prefixes for cleaner error messages
    final message = error?.toString() ?? '';
    return message.replaceAll(RegExp(r'^Exception:\s*'), '');
  }

  /// Returns the extracted error message, or [fallback] if extraction fails.
  static String extractErrorMessageOrFallback(
    Object? error,
    String fallback,
  ) {
    try {
      return extractErrorMessage(error);
    } catch (e) {
      return fallback;
    }
  }
}
