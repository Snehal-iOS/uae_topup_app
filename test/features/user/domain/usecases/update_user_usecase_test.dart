import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uae_topup_app/features/user/domain/entities/user.dart';
import 'package:uae_topup_app/features/user/domain/repositories/user_repository.dart';
import 'package:uae_topup_app/features/user/domain/usecases/update_user_usecase.dart';

@GenerateMocks([UserRepository])
import 'update_user_usecase_test.mocks.dart';

void main() {
  late UpdateUserUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = UpdateUserUseCase(mockRepository);
  });

  final tUser = User(
    id: '1',
    name: 'Test User',
    balance: 500.0,
    isVerified: true,
    monthlyTopupTotal: 100.0,
    monthlyResetDate: DateTime(2025, 2, 1),
  );

  group('UpdateUserUseCase', () {
    test('should update user successfully', () async {
      // Arrange
      final updatedUser = tUser.copyWith(balance: 600.0);
      when(mockRepository.updateUser(any))
          .thenAnswer((_) async => updatedUser);

      // Act
      final result = await useCase(tUser);

      // Assert
      expect(result, equals(updatedUser));
      verify(mockRepository.updateUser(tUser)).called(1);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      when(mockRepository.updateUser(any))
          .thenThrow(Exception('Repository error'));

      // Act & Assert
      expect(
        () => useCase(tUser),
        throwsException,
      );
      verify(mockRepository.updateUser(tUser)).called(1);
    });
  });
}
