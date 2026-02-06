import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_constants.dart';

class User extends Equatable {
  final String id;
  final String name;
  final double balance;
  final bool isVerified;
  final double monthlyTopupTotal;
  final DateTime monthlyResetDate;

  const User({
    required this.id,
    required this.name,
    required this.balance,
    required this.isVerified,
    this.monthlyTopupTotal = 0.0,
    required this.monthlyResetDate,
  });

  double get monthlyLimit => isVerified ? AppConstants.monthlyLimitVerified : AppConstants.monthlyLimitUnverified;
  double get totalMonthlyLimit => AppConstants.totalMonthlyLimit;

  double get remainingMonthlyLimit => totalMonthlyLimit - monthlyTopupTotal;

  double get monthlyLimitProgress =>
      totalMonthlyLimit > 0 ? (monthlyTopupTotal / totalMonthlyLimit).clamp(0.0, 1.0) : 0.0;

  User copyWith({
    String? id,
    String? name,
    double? balance,
    bool? isVerified,
    double? monthlyTopupTotal,
    DateTime? monthlyResetDate,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      isVerified: isVerified ?? this.isVerified,
      monthlyTopupTotal: monthlyTopupTotal ?? this.monthlyTopupTotal,
      monthlyResetDate: monthlyResetDate ?? this.monthlyResetDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'isVerified': isVerified,
      'monthlyTopupTotal': monthlyTopupTotal,
      'monthlyResetDate': monthlyResetDate.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      isVerified: json['isVerified'] as bool? ?? false,
      monthlyTopupTotal: (json['monthlyTopupTotal'] as num?)?.toDouble() ?? 0.0,
      monthlyResetDate: DateTime.parse(json['monthlyResetDate'] as String),
    );
  }

  @override
  List<Object?> get props => [id, name, balance, isVerified, monthlyTopupTotal, monthlyResetDate];
}
