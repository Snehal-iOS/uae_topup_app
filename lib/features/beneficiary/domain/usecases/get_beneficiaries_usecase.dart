import '../entities/beneficiary.dart';
import '../repositories/beneficiary_repository.dart';

class GetBeneficiariesUseCase {
  final BeneficiaryRepository repository;
  GetBeneficiariesUseCase(this.repository);

  Future<List<Beneficiary>> call() async {
    final beneficiaries = await repository.getBeneficiaries();

    final now = DateTime.now();
    bool needsReset = false;
    final updatedBeneficiaries = beneficiaries.map((beneficiary) {
      if (now.isAfter(beneficiary.monthlyResetDate)) {
        needsReset = true;
        return beneficiary.copyWith(
          monthlyTopupAmount: 0.0,
          monthlyResetDate: DateTime(now.year, now.month + 1, 1),
        );
      }
      return beneficiary;
    }).toList();

    if (needsReset) {
      await repository.cacheBeneficiaries(updatedBeneficiaries);
    }

    return updatedBeneficiaries;
  }
}
