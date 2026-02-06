import '../constants/app_strings.dart';

/// This is the Base exception class for all custom exceptions in the app.
abstract class CustomException implements Exception {
  final String message;
  final String? code;

  const CustomException(this.message, {this.code});

  @override
  String toString() => message;
}

// Exception for validation errors
class ValidationException extends CustomException {
  const ValidationException(super.message, {super.code});
}

// Exception for business logic errors
class BusinessLogicException extends CustomException {
  const BusinessLogicException(super.message, {super.code});
}

// Exception for network/API errors
class NetworkException extends CustomException {
  const NetworkException(super.message, {super.code});
}

// Exception for not found errors
class NotFoundException extends CustomException {
  const NotFoundException(super.message, {super.code});
}

// Exception for insufficient balance
class InsufficientBalanceException extends BusinessLogicException {
  final double required;
  final double available;

  InsufficientBalanceException({
    required this.required,
    required this.available,
  }) : super(
          AppStrings.format(
            AppStrings.insufficientBalanceFormat,
            [
              required.toStringAsFixed(2),
              available.toStringAsFixed(2),
            ],
          ),
          code: 'INSUFFICIENT_BALANCE',
        );
}

// Exception for limit exceeded
class LimitExceededException extends BusinessLogicException {
  final String limitType;
  final double limit;
  final double current;

  LimitExceededException({
    required this.limitType,
    required this.limit,
    required this.current,
  }) : super(
          AppStrings.format(
            AppStrings.limitExceededFormat,
            [
              limitType,
              limit.toStringAsFixed(0),
              current.toStringAsFixed(2),
            ],
          ),
          code: 'LIMIT_EXCEEDED',
        );
}

// Exception for maximum beneficiaries reached
class MaxBeneficiariesException extends BusinessLogicException {
  const MaxBeneficiariesException()
      : super(
          AppStrings.cannotActivateMaxReached,
          code: 'MAX_BENEFICIARIES',
        );
}
