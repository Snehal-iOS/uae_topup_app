import '../repositories/beneficiary_repository.dart';

class UpdateBeneficiaryMonthlyAmountUseCase {
  final BeneficiaryRepository repository;
  UpdateBeneficiaryMonthlyAmountUseCase(this.repository);

  Future<void> call({required String beneficiaryId, required double amount}) async {
    await repository.updateBeneficiaryMonthlyAmount(beneficiaryId, amount);
  }
}
