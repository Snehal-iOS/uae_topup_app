import '../repositories/beneficiary_repository.dart';

class DeleteBeneficiaryUseCase {
  final BeneficiaryRepository repository;
  DeleteBeneficiaryUseCase(this.repository);

  Future<void> call(String beneficiaryId) async {
    await repository.deleteBeneficiary(beneficiaryId);
  }
}
