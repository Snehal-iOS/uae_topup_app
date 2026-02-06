import 'package:equatable/equatable.dart';

abstract class BeneficiaryEvent extends Equatable {
  const BeneficiaryEvent();

  @override
  List<Object?> get props => [];
}

class LoadBeneficiaries extends BeneficiaryEvent {
  const LoadBeneficiaries();
}

class AddBeneficiary extends BeneficiaryEvent {
  final String phoneNumber;
  final String nickname;

  const AddBeneficiary({
    required this.phoneNumber,
    required this.nickname,
  });

  @override
  List<Object?> get props => [phoneNumber, nickname];
}

class DeleteBeneficiary extends BeneficiaryEvent {
  final String beneficiaryId;

  const DeleteBeneficiary(this.beneficiaryId);

  @override
  List<Object?> get props => [beneficiaryId];
}

class ToggleBeneficiaryStatus extends BeneficiaryEvent {
  final String beneficiaryId;
  final bool activate;

  const ToggleBeneficiaryStatus({
    required this.beneficiaryId,
    required this.activate,
  });

  @override
  List<Object?> get props => [beneficiaryId, activate];
}

class UpdateBeneficiaryMonthlyAmount extends BeneficiaryEvent {
  final String beneficiaryId;
  final double amount;

  const UpdateBeneficiaryMonthlyAmount({
    required this.beneficiaryId,
    required this.amount,
  });

  @override
  List<Object?> get props => [beneficiaryId, amount];
}

class RefreshBeneficiaries extends BeneficiaryEvent {
  final bool silent;

  const RefreshBeneficiaries({this.silent = false});

  @override
  List<Object?> get props => [silent];
}

class ClearMessages extends BeneficiaryEvent {
  const ClearMessages();
}
