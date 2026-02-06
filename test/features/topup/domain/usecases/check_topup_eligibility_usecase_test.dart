import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uae_topup_app/features/beneficiary/domain/entities/beneficiary.dart';
import 'package:uae_topup_app/features/beneficiary/domain/repositories/beneficiary_repository.dart';
import 'package:uae_topup_app/features/topup/domain/usecases/check_topup_eligibility_usecase.dart';
import 'package:uae_topup_app/features/user/domain/entities/user.dart';
import 'package:uae_topup_app/features/user/domain/repositories/user_repository.dart';

@GenerateMocks([UserRepository, BeneficiaryRepository])
import 'check_topup_eligibility_usecase_test.mocks.dart';

void main() {
  late CheckTopupEligibilityUseCase useCase;
  late MockUserRepository mockUserRepository;
  late MockBeneficiaryRepository mockBeneficiaryRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockBeneficiaryRepository = MockBeneficiaryRepository();
    useCase = CheckTopupEligibilityUseCase(
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

  group('CheckTopupEligibilityUseCase', () {
    test('should return true when balance and limits allow top-up', () async {
      when(mockUserRepository.getUser()).thenAnswer((_) async => tUser);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [tBeneficiary]);

      final result = await useCase(
        user: tUser,
        beneficiary: tBeneficiary,
        amount: 100.0,
      );

      expect(result, isTrue);
    });

    test('should return false when amount is zero', () async {
      when(mockUserRepository.getUser()).thenAnswer((_) async => tUser);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [tBeneficiary]);

      final result = await useCase(
        user: tUser,
        beneficiary: tBeneficiary,
        amount: 0.0,
      );

      expect(result, isFalse);
    });

    test('should return false when amount is negative', () async {
      when(mockUserRepository.getUser()).thenAnswer((_) async => tUser);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [tBeneficiary]);

      final result = await useCase(
        user: tUser,
        beneficiary: tBeneficiary,
        amount: -10.0,
      );

      expect(result, isFalse);
    });

    test('should return false when balance is insufficient', () async {
      final userWithLowBalance = tUser.copyWith(balance: 50.0);
      when(mockUserRepository.getUser())
          .thenAnswer((_) async => userWithLowBalance);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [tBeneficiary]);

      final result = await useCase(
        user: userWithLowBalance,
        beneficiary: tBeneficiary,
        amount: 100.0,
      );

      expect(result, isFalse);
    });

    test('should return false when beneficiary monthly limit would be exceeded',
        () async {
      final beneficiaryNearLimit =
          tBeneficiary.copyWith(monthlyTopupAmount: 900.0);
      when(mockUserRepository.getUser()).thenAnswer((_) async => tUser);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [beneficiaryNearLimit]);

      final result = await useCase(
        user: tUser,
        beneficiary: beneficiaryNearLimit,
        amount: 200.0,
      );

      expect(result, isFalse);
    });

    test('should return false when user total monthly limit would be exceeded',
        () async {
      final userNearTotalLimit = tUser.copyWith(monthlyTopupTotal: 2950.0);
      when(mockUserRepository.getUser())
          .thenAnswer((_) async => userNearTotalLimit);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [tBeneficiary]);

      final result = await useCase(
        user: userNearTotalLimit,
        beneficiary: tBeneficiary,
        amount: 100.0,
      );

      expect(result, isFalse);
    });

    test('should use latest user and beneficiary from repositories', () async {
      when(mockUserRepository.getUser()).thenAnswer((_) async => tUser);
      when(mockBeneficiaryRepository.getBeneficiaries())
          .thenAnswer((_) async => [tBeneficiary]);

      final result = await useCase(
        user: tUser.copyWith(balance: 0),
        beneficiary: tBeneficiary,
        amount: 100.0,
      );

      expect(result, isTrue);
      verify(mockUserRepository.getUser()).called(1);
      verify(mockBeneficiaryRepository.getBeneficiaries()).called(1);
    });
  });
}
