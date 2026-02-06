import '../../../../core/errors/custom_exception.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../entities/beneficiary.dart';
import '../repositories/beneficiary_repository.dart';

class AddBeneficiaryUseCase {
  final BeneficiaryRepository repository;
  AddBeneficiaryUseCase(this.repository);

  Future<Beneficiary> call({required String phoneNumber, required String nickname}) async {
    if (nickname.trim().isEmpty) {
      throw const ValidationException(AppStrings.nicknameRequired);
    }
    if (nickname.length > AppConstants.maxNicknameLength) {
      throw const ValidationException(AppStrings.nicknameMaxLengthError);
    }

    if (!_isValidUAEPhoneNumber(phoneNumber)) {
      throw const ValidationException(AppStrings.invalidPhoneFormat);
    }

    final beneficiaries = await repository.getBeneficiaries();
    final activeBeneficiaries = beneficiaries.where((b) => b.isActive).toList();

    final isDuplicate = beneficiaries.any((b) => b.phoneNumber == phoneNumber);

    if (isDuplicate) {
      throw const ValidationException(AppStrings.duplicatePhoneNumber);
    }

    final shouldBeActive = activeBeneficiaries.length < AppConstants.maxActiveBeneficiaries;

    final newBeneficiary = Beneficiary(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      phoneNumber: phoneNumber,
      nickname: nickname,
      monthlyResetDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 1),
      isActive: shouldBeActive, // Set based on active count
    );

    return repository.addBeneficiary(newBeneficiary);
  }

  bool _isValidUAEPhoneNumber(String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleanNumber.startsWith('+971')) {
      return cleanNumber.length == AppConstants.uaePhoneLengthWithCountryCode;
    } else if (cleanNumber.startsWith('05')) {
      return cleanNumber.length == AppConstants.uaePhoneLengthWithLeadingZero;
    }
    return false;
  }
}
