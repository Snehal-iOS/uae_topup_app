import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {
  const LoadUser();
}

class UpdateUserBalance extends UserEvent {
  final double newBalance;
  final double topupAmount;

  const UpdateUserBalance({
    required this.newBalance,
    required this.topupAmount,
  });

  @override
  List<Object?> get props => [newBalance, topupAmount];
}

class RefreshUser extends UserEvent {
  final bool silent;
  const RefreshUser({this.silent = false});

  @override
  List<Object?> get props => [silent];
}
