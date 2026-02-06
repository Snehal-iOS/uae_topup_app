import '../errors/custom_exception.dart';

class ErrorHelper {
  ErrorHelper._();

  static String extractErrorMessage(Object? error) {
    if (error is CustomException) {
      return error.message;
    }

    final message = error?.toString() ?? '';
    return message.replaceAll(RegExp(r'^Exception:\s*'), '');
  }

  static String extractErrorMessageOrFallback(Object? error, String fallback) {
    try {
      return extractErrorMessage(error);
    } catch (e) {
      return fallback;
    }
  }
}
