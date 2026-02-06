import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

enum UserStatus { initial, loading, success, error }

class UserState extends Equatable {
  final UserStatus status;
  final User? user;
  final String? errorMessage;
  final String? successMessage;

  const UserState({this.status = UserStatus.initial, this.user, this.errorMessage, this.successMessage});

  UserState copyWith({UserStatus? status, User? user, String? errorMessage, String? successMessage}) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, successMessage];
}
