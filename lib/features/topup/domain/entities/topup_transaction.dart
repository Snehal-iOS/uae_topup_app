import 'package:equatable/equatable.dart';

class TopupTransaction extends Equatable {
  final String id;
  final String beneficiaryId;
  final double amount;
  final double charge;
  final DateTime timestamp;
  final String status;

  const TopupTransaction({
    required this.id,
    required this.beneficiaryId,
    required this.amount,
    required this.charge,
    required this.timestamp,
    required this.status,
  });

  double get totalAmount => amount + charge;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'beneficiaryId': beneficiaryId,
      'amount': amount,
      'charge': charge,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }

  factory TopupTransaction.fromJson(Map<String, dynamic> json) {
    return TopupTransaction(
      id: json['id'] as String,
      beneficiaryId: json['beneficiaryId'] as String,
      amount: (json['amount'] as num).toDouble(),
      charge: (json['charge'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String,
    );
  }

  @override
  List<Object?> get props => [id, beneficiaryId, amount, charge, timestamp, status];
}
