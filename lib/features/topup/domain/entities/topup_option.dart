import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_constants.dart';

class TopupOption extends Equatable {
  final double amount;
  const TopupOption({required this.amount});

  static List<TopupOption> get availableOptions =>
      AppConstants.topupPresetAmounts.map((a) => TopupOption(amount: a)).toList();

  @override
  List<Object?> get props => [amount];
}
