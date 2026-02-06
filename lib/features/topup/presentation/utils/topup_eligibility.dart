import '../../../../../core/constants/app_constants.dart';
import '../../../beneficiary/domain/entities/beneficiary.dart';
import '../../../user/domain/entities/user.dart';

class TopupEligibility {
  TopupEligibility._();

  static double remainingForBeneficiary(User user, Beneficiary beneficiary) {
    return user.monthlyLimit - beneficiary.monthlyTopupAmount;
  }

  static double remainingAfterTopup(User user, Beneficiary beneficiary, double amount) {
    return remainingForBeneficiary(user, beneficiary) - amount;
  }

  static double get serviceCharge => AppConstants.topupServiceCharge;

  static double totalWithFee(double amount) {
    return amount + serviceCharge;
  }

  // User can perform top up if and only if topup amount (with service cherge 3 AED) is less than or equal to main account balance amount.
  static bool canPerformTopup(User user, Beneficiary beneficiary, double amount) {
    if (amount <= 0) return false;
    final totalCost = totalWithFee(amount);
    if (user.balance < totalCost) return false;
    final beneficiaryNewTotal = beneficiary.monthlyTopupAmount + amount;
    if (beneficiaryNewTotal > user.monthlyLimit) return false;
    final userNewTotal = user.monthlyTopupTotal + amount;
    if (userNewTotal > user.totalMonthlyLimit) return false;
    return true;
  }
}
