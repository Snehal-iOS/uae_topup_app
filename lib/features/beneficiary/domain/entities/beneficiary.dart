import 'package:equatable/equatable.dart';

class Beneficiary extends Equatable {
  final String id;
  final String phoneNumber;
  final String nickname;
  final double monthlyTopupAmount;
  final DateTime monthlyResetDate;
  final bool isActive;

  const Beneficiary({
    required this.id,
    required this.phoneNumber,
    required this.nickname,
    this.monthlyTopupAmount = 0.0,
    required this.monthlyResetDate,
    this.isActive = true,
  });

  Beneficiary copyWith({
    String? id,
    String? phoneNumber,
    String? nickname,
    double? monthlyTopupAmount,
    DateTime? monthlyResetDate,
    bool? isActive,
  }) {
    return Beneficiary(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nickname: nickname ?? this.nickname,
      monthlyTopupAmount: monthlyTopupAmount ?? this.monthlyTopupAmount,
      monthlyResetDate: monthlyResetDate ?? this.monthlyResetDate,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'nickname': nickname,
      'monthlyTopupAmount': monthlyTopupAmount,
      'monthlyResetDate': monthlyResetDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Beneficiary.fromJson(Map<String, dynamic> json) {
    return Beneficiary(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      nickname: json['nickname'] as String,
      monthlyTopupAmount:
          (json['monthlyTopupAmount'] as num?)?.toDouble() ?? 0.0,
      monthlyResetDate: DateTime.parse(json['monthlyResetDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => [
        id,
        phoneNumber,
        nickname,
        monthlyTopupAmount,
        monthlyResetDate,
        isActive,
      ];
}
