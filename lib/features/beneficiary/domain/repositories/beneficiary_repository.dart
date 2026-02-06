import '../entities/beneficiary.dart';

abstract class BeneficiaryRepository {
  Future<List<Beneficiary>> getBeneficiaries();
  Future<Beneficiary> addBeneficiary(Beneficiary beneficiary);
  Future<void> deleteBeneficiary(String id);
  Future<Beneficiary> updateBeneficiary(Beneficiary beneficiary);
  Future<void> cacheBeneficiaries(List<Beneficiary> beneficiaries);
  Future<Beneficiary> updateBeneficiaryMonthlyAmount(String id, double amount);
}
