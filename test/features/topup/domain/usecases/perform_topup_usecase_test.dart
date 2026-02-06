import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uae_topup_app/core/errors/custom_exception.dart';
import 'package:uae_topup_app/features/beneficiary/domain/entities/beneficiary.dart';
import 'package:uae_topup_app/features/beneficiary/domain/repositories/beneficiary_repository.dart';
import 'package:uae_topup_app/features/topup/domain/entities/topup_transaction.dart';
import 'package:uae_topup_app/features/topup/domain/repositories/topup_repository.dart';
import 'package:uae_topup_app/features/topup/domain/usecases/perform_topup_usecase.dart';
import 'package:uae_topup_app/features/user/domain/entities/user.dart';
import 'package:uae_topup_app/features/user/domain/repositories/user_repository.dart';

@GenerateMocks([
  TopupRepository,
  UserRepository,
  BeneficiaryRepository,
])
import 'perform_topup_usecase_test.mocks.dart';

void main() {
  late PerformTopupUseCase useCase;
  late MockTopupRepository mockTopupRepository;
  late MockUserRepository mockUserRepository;
  late MockBeneficiaryRepository mockBeneficiaryRepository;

  setUp(() {
    mockTopupRepository = MockTopupRepository();
    mockUserRepository = MockUserRepository();
    mockBeneficiaryRepository = MockBeneficiaryRepository();
    useCase = PerformTopupUseCase(
      topupRepository: mockTopupRepository,
      userRepository: mockUserRepository,
      beneficiaryRepository: mockBeneficiaryRepository,
    );
  });

  final tUser = User(
    id: '1',
    name: 'Test User',
    balance: 1000.0,
    isVerified: true,
    monthlyTopupTotal: 0.0,
    monthlyResetDate: DateTime(2025, 2, 1),
  );

  final tBeneficiary = Beneficiary(
    id: '1',
    phoneNumber: '+971501234567',
    nickname: 'Test Beneficiary',
    monthlyTopupAmount: 0.0,
    monthlyResetDate: DateTime(2025, 2, 1),
    isActive: true,
  );

  final tTransaction = TopupTransaction(
    id: '1',
    beneficiaryId: '1',
    amount: 100.0,
    charge: 3.0,
    timestamp: DateTime(2025, 1, 15),
    status: 'completed',
  );

  group('PerformTopupUseCase', () {
    test('should perform top-up successfully for verified user', () async {
      // Arrange
      const amount = 100.0;
      when(mockUserRepository.getUser()).thenAnswer((_) async => tUser);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [tBeneficiary]);
      when(mockTopupRepository.performTopup(
        beneficiaryId: anyNamed('beneficiaryId'),
        amount: anyNamed('amount'),
      ),).thenAnswer((_) async => tTransaction);
      when(mockUserRepository.updateUser(any))
          .thenAnswer((_) async => tUser.copyWith(balance: 897.0));
      when(mockBeneficiaryRepository.updateBeneficiaryMonthlyAmount(
        any,
        any,
      ),).thenAnswer((_) async => tBeneficiary.copyWith(monthlyTopupAmount: amount));

      // Act
      await useCase(
        user: tUser,
        beneficiary: tBeneficiary,
        amount: amount,
      );

      // Assert
      verify(mockUserRepository.getUser()).called(1);
      verify(mockBeneficiaryRepository.getBeneficiaries()).called(1);
      verify(mockTopupRepository.performTopup(
        beneficiaryId: tBeneficiary.id,
        amount: amount,
      ),).called(1);
      verify(mockUserRepository.updateUser(any)).called(1);
      verify(mockBeneficiaryRepository.updateBeneficiaryMonthlyAmount(
        tBeneficiary.id,
        amount,
      ),).called(1);
    });

    test('should throw ValidationException when amount is zero', () async {
      // Arrange
      when(mockUserRepository.getUser()).thenAnswer((_) async => tUser);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [tBeneficiary]);

      // Act & Assert
      expect(
        () => useCase(
          user: tUser,
          beneficiary: tBeneficiary,
          amount: 0.0,
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('should throw ValidationException when amount is negative', () async {
      // Arrange
      when(mockUserRepository.getUser()).thenAnswer((_) async => tUser);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [tBeneficiary]);

      // Act & Assert
      expect(
        () => useCase(
          user: tUser,
          beneficiary: tBeneficiary,
          amount: -10.0,
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('should throw InsufficientBalanceException when balance is insufficient',
        () async {
      // Arrange
      const amount = 1000.0;
      final userWithLowBalance = tUser.copyWith(balance: 50.0);
      when(mockUserRepository.getUser())
          .thenAnswer((_) async => userWithLowBalance);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [tBeneficiary]);

      // Act & Assert
      expect(
        () => useCase(
          user: userWithLowBalance,
          beneficiary: tBeneficiary,
          amount: amount,
        ),
        throwsA(isA<InsufficientBalanceException>()),
      );
    });

    test('should throw LimitExceededException when beneficiary monthly limit exceeded',
        () async {
      // Arrange
      const amount = 600.0;
      final beneficiaryWithHighAmount = tBeneficiary.copyWith(
        monthlyTopupAmount: 500.0,
      );
      when(mockUserRepository.getUser()).thenAnswer((_) async => tUser);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [beneficiaryWithHighAmount]);

      // Act & Assert
      expect(
        () => useCase(
          user: tUser,
          beneficiary: beneficiaryWithHighAmount,
          amount: amount,
        ),
        throwsA(isA<LimitExceededException>()),
      );
    });

    test('should throw LimitExceededException when total monthly limit exceeded',
        () async {
      // Arrange
      const amount = 100.0;
      final userWithHighMonthlyTotal = tUser.copyWith(
        monthlyTopupTotal: 2950.0,
      );
      when(mockUserRepository.getUser())
          .thenAnswer((_) async => userWithHighMonthlyTotal);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [tBeneficiary]);

      // Act & Assert
      expect(
        () => useCase(
          user: userWithHighMonthlyTotal,
          beneficiary: tBeneficiary,
          amount: amount,
        ),
        throwsA(isA<LimitExceededException>()),
      );
    });

    test('should use correct beneficiary limit for unverified user', () async {
      // Arrange
      const amount = 600.0;
      final unverifiedUser = tUser.copyWith(isVerified: false);
      final beneficiaryWithHighAmount = tBeneficiary.copyWith(
        monthlyTopupAmount: 100.0,
      );
      when(mockUserRepository.getUser())
          .thenAnswer((_) async => unverifiedUser);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [beneficiaryWithHighAmount]);

      // Act & Assert
      expect(
        () => useCase(
          user: unverifiedUser,
          beneficiary: beneficiaryWithHighAmount,
          amount: amount,
        ),
        throwsA(isA<LimitExceededException>()),
      );
    });

    test('should deduct amount plus charge from user balance', () async {
      // Arrange
      const amount = 100.0;
      const expectedBalance = 897.0; // 1000 - 100 - 3
      when(mockUserRepository.getUser()).thenAnswer((_) async => tUser);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [tBeneficiary]);
      when(mockTopupRepository.performTopup(
        beneficiaryId: anyNamed('beneficiaryId'),
        amount: anyNamed('amount'),
      ),).thenAnswer((_) async => tTransaction);
      when(mockUserRepository.updateUser(any))
          .thenAnswer((_) async => tUser.copyWith(balance: expectedBalance));
      when(mockBeneficiaryRepository.updateBeneficiaryMonthlyAmount(
        any,
        any,
      ),).thenAnswer((_) async => tBeneficiary.copyWith(monthlyTopupAmount: amount));

      // Act
      await useCase(
        user: tUser,
        beneficiary: tBeneficiary,
        amount: amount,
      );

      // Assert
      final captured = verify(mockUserRepository.updateUser(captureAny))
          .captured
          .single as User;
      expect(captured.balance, equals(expectedBalance));
      expect(captured.monthlyTopupTotal, equals(amount));
    });

    test('should update beneficiary monthly amount correctly', () async {
      // Arrange
      const amount = 100.0;
      final beneficiaryWithExistingAmount = tBeneficiary.copyWith(
        monthlyTopupAmount: 200.0,
      );
      when(mockUserRepository.getUser()).thenAnswer((_) async => tUser);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [beneficiaryWithExistingAmount]);
      when(mockTopupRepository.performTopup(
        beneficiaryId: anyNamed('beneficiaryId'),
        amount: anyNamed('amount'),
      ),).thenAnswer((_) async => tTransaction);
      when(mockUserRepository.updateUser(any))
          .thenAnswer((_) async => tUser);
      when(mockBeneficiaryRepository.updateBeneficiaryMonthlyAmount(
        any,
        any,
      ),).thenAnswer((_) async => beneficiaryWithExistingAmount.copyWith(monthlyTopupAmount: 300.0));

      // Act
      await useCase(
        user: tUser,
        beneficiary: beneficiaryWithExistingAmount,
        amount: amount,
      );

      // Assert
      verify(mockBeneficiaryRepository.updateBeneficiaryMonthlyAmount(
        beneficiaryWithExistingAmount.id,
        amount,
      ),).called(1);
    });

    test('should use latest user data from repository', () async {
      // Arrange
      const amount = 100.0;
      final updatedUser = tUser.copyWith(balance: 500.0);
      when(mockUserRepository.getUser())
          .thenAnswer((_) async => updatedUser);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [tBeneficiary]);
      when(mockTopupRepository.performTopup(
        beneficiaryId: anyNamed('beneficiaryId'),
        amount: anyNamed('amount'),
      ),).thenAnswer((_) async => tTransaction);
      when(mockUserRepository.updateUser(any))
          .thenAnswer((_) async => updatedUser);
      when(mockBeneficiaryRepository.updateBeneficiaryMonthlyAmount(
        any,
        any,
      ),).thenAnswer((_) async => tBeneficiary.copyWith(monthlyTopupAmount: amount));

      // Act
      await useCase(
        user: tUser, // Old user data
        beneficiary: tBeneficiary,
        amount: amount,
      );

      // Assert - should use updatedUser's balance (500.0), not tUser's (1000.0)
      final captured = verify(mockUserRepository.updateUser(captureAny))
          .captured
          .single as User;
      expect(captured.balance, equals(397.0)); // 500 - 100 - 3
    });

    test('should use latest beneficiary data from repository', () async {
      // Arrange
      const amount = 100.0;
      final updatedBeneficiary = tBeneficiary.copyWith(
        monthlyTopupAmount: 400.0,
      );
      when(mockUserRepository.getUser()).thenAnswer((_) async => tUser);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [updatedBeneficiary]);
      when(mockTopupRepository.performTopup(
        beneficiaryId: anyNamed('beneficiaryId'),
        amount: anyNamed('amount'),
      ),).thenAnswer((_) async => tTransaction);
      when(mockUserRepository.updateUser(any))
          .thenAnswer((_) async => tUser);
      when(mockBeneficiaryRepository.updateBeneficiaryMonthlyAmount(
        any,
        any,
      ),).thenAnswer((_) async => updatedBeneficiary.copyWith(monthlyTopupAmount: 500.0));

      // Act
      await useCase(
        user: tUser,
        beneficiary: tBeneficiary, // Old beneficiary data
        amount: amount,
      );

      // Assert - should use updatedBeneficiary's monthlyTopupAmount (400.0)
      verify(mockBeneficiaryRepository.updateBeneficiaryMonthlyAmount(
        updatedBeneficiary.id,
        amount,
      ),).called(1);
    });
  });
}
