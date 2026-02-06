import 'package:equatable/equatable.dart';
import '../../domain/entities/topup_transaction.dart';

enum TopupStatus { initial, loading, success, error }

class TopupState extends Equatable {
  final TopupStatus status;
  final List<TopupTransaction> transactions;
  final String? errorMessage;
  final String? successMessage;

  const TopupState({
    this.status = TopupStatus.initial,
    this.transactions = const [],
    this.errorMessage,
    this.successMessage,
  });

  TopupState copyWith({
    TopupStatus? status,
    List<TopupTransaction>? transactions,
    String? errorMessage,
    String? successMessage,
  }) {
    return TopupState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, transactions, errorMessage, successMessage];
}
