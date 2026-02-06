import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  Future<User> call() async {
    final user = await repository.getUser();

    if (DateTime.now().isAfter(user.monthlyResetDate)) {
      final nextResetDate = DateTime(
        DateTime.now().year,
        DateTime.now().month + 1,
        1,
      );

      return repository.updateUser(
        user.copyWith(
          monthlyTopupTotal: 0.0,
          monthlyResetDate: nextResetDate,
        ),
      );
    }

    return user;
  }
}
