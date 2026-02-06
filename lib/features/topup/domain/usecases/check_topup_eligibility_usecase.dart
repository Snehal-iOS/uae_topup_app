import '../../../../core/constants/app_constants.dart';
import '../../../beneficiary/domain/entities/beneficiary.dart';
import '../../../beneficiary/domain/repositories/beneficiary_repository.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/domain/repositories/user_repository.dart';

class CheckTopupEligibilityUseCase {
  final UserRepository userRepository;
  final BeneficiaryRepository beneficiaryRepository;

  CheckTopupEligibilityUseCase({
    required this.userRepository,
    required this.beneficiaryRepository,
  });

  Future<bool> call({
    required User user,
    required Beneficiary beneficiary,
    required double amount,
  }) async {
    final currentUser = await userRepository.getUser();
    final beneficiaries = await beneficiaryRepository.getBeneficiaries();
    final currentBeneficiary = beneficiaries.firstWhere(
      (b) => b.id == beneficiary.id,
      orElse: () => beneficiary,
    );

    if (amount <= 0) return false;
    final totalCost = amount + AppConstants.topupServiceCharge;
    if (currentUser.balance < totalCost) return false;
    final beneficiaryNewTotal = currentBeneficiary.monthlyTopupAmount + amount;
    if (beneficiaryNewTotal > currentUser.monthlyLimit) return false;
    final userNewTotal = currentUser.monthlyTopupTotal + amount;
    if (userNewTotal > currentUser.totalMonthlyLimit) return false;
    return true;
  }
}
