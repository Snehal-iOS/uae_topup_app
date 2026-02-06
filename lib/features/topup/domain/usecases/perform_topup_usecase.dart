import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/custom_exception.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../beneficiary/domain/entities/beneficiary.dart';
import '../../../beneficiary/domain/repositories/beneficiary_repository.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/domain/repositories/user_repository.dart';
import '../repositories/topup_repository.dart';

class PerformTopupUseCase {
  final TopupRepository topupRepository;
  final UserRepository userRepository;
  final BeneficiaryRepository beneficiaryRepository;

  static double get topupCharge => AppConstants.topupServiceCharge;

  PerformTopupUseCase({
    required this.topupRepository,
    required this.userRepository,
    required this.beneficiaryRepository,
  });

  Future<void> call({
    required User user,
    required Beneficiary beneficiary,
    required double amount,
  }) async {
    AppLogger.debug('PerformTopupUseCase: Starting top-up of $amount AED to ${beneficiary.nickname}');
    
    final currentUser = await userRepository.getUser();
    
    final beneficiaries = await beneficiaryRepository.getBeneficiaries();
    final currentBeneficiary = beneficiaries.firstWhere(
      (b) => b.id == beneficiary.id,
      orElse: () => beneficiary,
    );

    if (amount <= 0) {
      AppLogger.warning('Invalid top-up amount: $amount');
      throw const ValidationException(AppStrings.topupAmountMustBePositive);
    }

    final totalCost = amount + topupCharge;

    if (currentUser.balance < totalCost) {
      AppLogger.warning(
        'Insufficient balance: Required $totalCost, Available ${currentUser.balance}',
      );
      throw InsufficientBalanceException(
        amount: totalCost,
        available: currentUser.balance,
      );
    }

    final beneficiaryNewTotal = currentBeneficiary.monthlyTopupAmount + amount;
    final beneficiaryLimit = currentUser.monthlyLimit;

    if (beneficiaryNewTotal > beneficiaryLimit) {
      AppLogger.warning(
        'Beneficiary monthly limit exceeded: Limit $beneficiaryLimit, Current ${currentBeneficiary.monthlyTopupAmount}, Attempted $amount',
      );
      throw LimitExceededException(
        limitType: 'Beneficiary monthly',
        limit: beneficiaryLimit,
        current: currentBeneficiary.monthlyTopupAmount,
      );
    }

    final userNewTotal = currentUser.monthlyTopupTotal + amount;
    final totalMonthlyLimit = currentUser.totalMonthlyLimit;

    if (userNewTotal > totalMonthlyLimit) {
      AppLogger.warning(
        'Total monthly limit exceeded: Limit $totalMonthlyLimit, Current ${currentUser.monthlyTopupTotal}, Attempted $amount',
      );
      throw LimitExceededException(
        limitType: 'Total monthly',
        limit: totalMonthlyLimit,
        current: currentUser.monthlyTopupTotal,
      );
    }

    AppLogger.debug('Executing top-up transaction via repository');
    await topupRepository.performTopup(
      beneficiaryId: currentBeneficiary.id,
      amount: amount,
    );

    final updatedUser = currentUser.copyWith(
      balance: currentUser.balance - totalCost,
      monthlyTopupTotal: currentUser.monthlyTopupTotal + amount,
    );
    await userRepository.updateUser(updatedUser);
    AppLogger.debug('User balance updated: ${updatedUser.balance} AED');

    await beneficiaryRepository.updateBeneficiaryMonthlyAmount(
      currentBeneficiary.id,
      amount,
    );
    AppLogger.info(
      'Top-up completed successfully: $amount AED to ${currentBeneficiary.nickname}',
    );
  }
}
