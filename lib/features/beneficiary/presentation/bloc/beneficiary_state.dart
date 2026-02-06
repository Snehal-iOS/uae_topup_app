import 'package:equatable/equatable.dart';
import '../../domain/entities/beneficiary.dart';

enum BeneficiaryStatus { initial, loading, success, error }

class BeneficiaryState extends Equatable {
  final BeneficiaryStatus status;
  final List<Beneficiary> beneficiaries;
  final String? errorMessage;
  final String? successMessage;

  const BeneficiaryState({
    this.status = BeneficiaryStatus.initial,
    this.beneficiaries = const [],
    this.errorMessage,
    this.successMessage,
  });

  BeneficiaryState copyWith({
    BeneficiaryStatus? status,
    List<Beneficiary>? beneficiaries,
    String? errorMessage,
    String? successMessage,
  }) {
    return BeneficiaryState(
      status: status ?? this.status,
      beneficiaries: beneficiaries ?? this.beneficiaries,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  List<Beneficiary> get activeBeneficiaries => beneficiaries.where((b) => b.isActive).toList();

  List<Beneficiary> get inactiveBeneficiaries => beneficiaries.where((b) => !b.isActive).toList();

  int get inactiveCount => inactiveBeneficiaries.length;

  double get totalMonthlyAmount => beneficiaries.fold(0.0, (sum, beneficiary) => sum + beneficiary.monthlyTopupAmount);

  @override
  List<Object?> get props => [status, beneficiaries, errorMessage, successMessage];
}
