import 'package:flutter_test/flutter_test.dart';
import 'package:uae_topup_app/core/errors/custom_exception.dart';

void main() {
  group('CustomException', () {
    test('should create exception with message', () {
      const exception = ValidationException('Test message');

      expect(exception.message, equals('Test message'));
      expect(exception.toString(), equals('Test message'));
    });

    test('should create exception with message and code', () {
      const exception = ValidationException('Test message', code: 'TEST_CODE');

      expect(exception.message, equals('Test message'));
      expect(exception.code, equals('TEST_CODE'));
    });
  });

  group('ValidationException', () {
    test('should be instance of CustomException', () {
      const exception = ValidationException('Validation error');

      expect(exception, isA<CustomException>());
    });
  });

  group('BusinessLogicException', () {
    test('should be instance of CustomException', () {
      const exception = BusinessLogicException('Business logic error');

      expect(exception, isA<CustomException>());
    });
  });

  group('NetworkException', () {
    test('should be instance of CustomException', () {
      const exception = NetworkException('Network error');

      expect(exception, isA<CustomException>());
    });
  });

  group('NotFoundException', () {
    test('should be instance of CustomException', () {
      // Arrange & Act
      const exception = NotFoundException('Not found');

      // Assert
      expect(exception, isA<CustomException>());
    });
  });

  group('InsufficientBalanceException', () {
    test('should create exception with required and available amounts', () {
      // Arrange & Act
      final exception = InsufficientBalanceException(amount: 100.0, available: 50.0);

      // Assert
      expect(exception.amount, equals(100.0));
      expect(exception.available, equals(50.0));
      expect(exception.code, equals('INSUFFICIENT_BALANCE'));
      expect(exception, isA<BusinessLogicException>());
      expect(exception.message, contains('100.00'));
      expect(exception.message, contains('50.00'));
    });
  });

  group('LimitExceededException', () {
    test('should create exception with limit details', () {
      // Arrange & Act
      final exception = LimitExceededException(limitType: 'Test limit', limit: 1000.0, current: 1200.0);

      // Assert
      expect(exception.limitType, equals('Test limit'));
      expect(exception.limit, equals(1000.0));
      expect(exception.current, equals(1200.0));
      expect(exception.code, equals('LIMIT_EXCEEDED'));
      expect(exception, isA<BusinessLogicException>());
      expect(exception.message, contains('Test limit'));
      expect(exception.message, contains('1000'));
      expect(exception.message, contains('1200.00'));
    });
  });

  group('MaxBeneficiariesException', () {
    test('should create exception with correct message', () {
      // Arrange & Act
      const exception = MaxBeneficiariesException();

      // Assert
      expect(exception.code, equals('MAX_BENEFICIARIES'));
      expect(exception, isA<BusinessLogicException>());
      expect(exception.message, isNotEmpty);
    });
  });
}
