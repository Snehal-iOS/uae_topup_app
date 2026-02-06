import 'package:flutter_test/flutter_test.dart';
import 'package:uae_topup_app/core/errors/custom_exception.dart';
import 'package:uae_topup_app/core/utils/error_helper.dart';

void main() {
  group('ErrorHelper', () {
    group('extractErrorMessage', () {
      test('should return message for CustomException', () {
        const e = ValidationException('Invalid input');
        expect(ErrorHelper.extractErrorMessage(e), 'Invalid input');
      });

      test('should return message for NetworkException', () {
        const e = NetworkException('Network error');
        expect(ErrorHelper.extractErrorMessage(e), 'Network error');
      });

      test('should strip Exception: prefix from generic Exception', () {
        expect(
          ErrorHelper.extractErrorMessage(Exception('Something failed')),
          'Something failed',
        );
      });

      test('should handle null', () {
        expect(ErrorHelper.extractErrorMessage(null), '');
      });
    });

    group('extractErrorMessageOrFallback', () {
      test('should return extracted message when extraction succeeds', () {
        const e = ValidationException('Bad value');
        expect(
          ErrorHelper.extractErrorMessageOrFallback(e, 'Fallback'),
          'Bad value',
        );
      });

      test('should return empty string for null error', () {
        expect(
          ErrorHelper.extractErrorMessageOrFallback(null, 'Fallback'),
          '',
        );
      });
    });
  });
}
