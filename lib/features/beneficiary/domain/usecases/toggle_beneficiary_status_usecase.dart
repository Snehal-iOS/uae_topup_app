import '../../../../core/errors/custom_exception.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/beneficiary.dart';
import '../repositories/beneficiary_repository.dart';

class ToggleBeneficiaryStatusUseCase {
  final BeneficiaryRepository repository;
  ToggleBeneficiaryStatusUseCase(this.repository);

  Future<Beneficiary> call({required String beneficiaryId, required bool activate}) async {
    final beneficiaries = await repository.getBeneficiaries();
    final beneficiary = beneficiaries.firstWhere(
      (b) => b.id == beneficiaryId,
      orElse: () => throw const NotFoundException(AppStrings.beneficiaryNotFound),
    );

    if (activate) {
      final activeCount = beneficiaries.where((b) => b.isActive).length;

      if (beneficiary.isActive) {
        AppLogger.debug('Beneficiary ${beneficiary.id} is already active');
        return beneficiary;
      }

      if (activeCount >= AppConstants.maxActiveBeneficiaries) {
        AppLogger.warning(
          'Cannot activate beneficiary ${beneficiary.id}: Max active beneficiaries (${AppConstants.maxActiveBeneficiaries}) reached',
        );
        throw const MaxBeneficiariesException();
      }
    }

    final updatedBeneficiary = beneficiary.copyWith(isActive: activate);
    return repository.updateBeneficiary(updatedBeneficiary);
  }
}
