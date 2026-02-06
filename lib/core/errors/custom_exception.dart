import '../constants/app_strings.dart';

abstract class CustomException implements Exception {
  final String message;
  final String? code;

  const CustomException(this.message, {this.code});

  @override
  String toString() => message;
}

class ValidationException extends CustomException {
  const ValidationException(super.message, {super.code});
}

class BusinessLogicException extends CustomException {
  const BusinessLogicException(super.message, {super.code});
}

class NetworkException extends CustomException {
  const NetworkException(super.message, {super.code});
}

class NotFoundException extends CustomException {
  const NotFoundException(super.message, {super.code});
}

class InsufficientBalanceException extends BusinessLogicException {
  final double amount;
  final double available;

  InsufficientBalanceException({required this.amount, required this.available})
    : super(
        AppStrings.format(AppStrings.insufficientBalanceFormat, [
          amount.toStringAsFixed(2),
          available.toStringAsFixed(2),
        ]),
        code: 'INSUFFICIENT_BALANCE',
      );
}

class LimitExceededException extends BusinessLogicException {
  final String limitType;
  final double limit;
  final double current;

  LimitExceededException({required this.limitType, required this.limit, required this.current})
    : super(
        AppStrings.format(AppStrings.limitExceededFormat, [
          limitType,
          limit.toStringAsFixed(0),
          current.toStringAsFixed(2),
        ]),
        code: 'LIMIT_EXCEEDED',
      );
}

class MaxBeneficiariesException extends BusinessLogicException {
  const MaxBeneficiariesException() : super(AppStrings.cannotActivateMaxReached, code: 'MAX_BENEFICIARIES');
}
