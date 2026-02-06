import 'package:equatable/equatable.dart';
import '../../../beneficiary/domain/entities/beneficiary.dart';
import '../../../user/domain/entities/user.dart';

abstract class TopupEvent extends Equatable {
  const TopupEvent();

  @override
  List<Object?> get props => [];
}

class PerformTopup extends TopupEvent {
  final String beneficiaryId;
  final double amount;
  final User user;
  final Beneficiary beneficiary;

  const PerformTopup({
    required this.beneficiaryId,
    required this.amount,
    required this.user,
    required this.beneficiary,
  });

  @override
  List<Object?> get props => [beneficiaryId, amount, user, beneficiary];
}

class LoadTransactions extends TopupEvent {
  const LoadTransactions();
}

class ClearMessages extends TopupEvent {
  const ClearMessages();
}
