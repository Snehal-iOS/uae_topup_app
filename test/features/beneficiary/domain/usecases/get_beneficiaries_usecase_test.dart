import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uae_topup_app/features/beneficiary/domain/entities/beneficiary.dart';
import 'package:uae_topup_app/features/beneficiary/domain/repositories/beneficiary_repository.dart';
import 'package:uae_topup_app/features/beneficiary/domain/usecases/get_beneficiaries_usecase.dart';

import 'add_beneficiary_usecase_test.mocks.dart';
@GenerateMocks([BeneficiaryRepository])

void main() {
  late GetBeneficiariesUseCase useCase;
  late MockBeneficiaryRepository mockRepository;

  setUp(() {
    mockRepository = MockBeneficiaryRepository();
    useCase = GetBeneficiariesUseCase(mockRepository);
  });

  group('GetBeneficiariesUseCase', () {
    test('should return beneficiaries without reset when dates are in future',
        () async {
      // Arrange
      final beneficiaries = [
        Beneficiary(
          id: '1',
          phoneNumber: '+971501234567',
          nickname: 'Test 1',
          monthlyTopupAmount: 100.0,
          monthlyResetDate: DateTime.now().add(const Duration(days: 10)),
          isActive: true,
        ),
        Beneficiary(
          id: '2',
          phoneNumber: '+971501234568',
          nickname: 'Test 2',
          monthlyTopupAmount: 200.0,
          monthlyResetDate: DateTime.now().add(const Duration(days: 20)),
          isActive: true,
        ),
      ];

      when(mockRepository.getBeneficiaries())
          .thenAnswer((_) async => beneficiaries);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(beneficiaries));
      expect(result[0].monthlyTopupAmount, equals(100.0));
      expect(result[1].monthlyTopupAmount, equals(200.0));
      verify(mockRepository.getBeneficiaries()).called(1);
      verifyNever(mockRepository.cacheBeneficiaries(any));
    });

    test('should reset monthly amounts when reset date has passed', () async {
      // Arrange
      final pastDate = DateTime.now().subtract(const Duration(days: 5));
      final beneficiaries = [
        Beneficiary(
          id: '1',
          phoneNumber: '+971501234567',
          nickname: 'Test 1',
          monthlyTopupAmount: 100.0,
          monthlyResetDate: pastDate,
          isActive: true,
        ),
        Beneficiary(
          id: '2',
          phoneNumber: '+971501234568',
          nickname: 'Test 2',
          monthlyTopupAmount: 200.0,
          monthlyResetDate: DateTime.now().add(const Duration(days: 20)),
          isActive: true,
        ),
      ];

      when(mockRepository.getBeneficiaries())
          .thenAnswer((_) async => beneficiaries);
      when(mockRepository.cacheBeneficiaries(any))
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase();

      // Assert
      expect(result.length, equals(2));
      expect(result[0].monthlyTopupAmount, equals(0.0));
      expect(result[1].monthlyTopupAmount, equals(200.0));
      verify(mockRepository.getBeneficiaries()).called(1);
      verify(mockRepository.cacheBeneficiaries(any)).called(1);
    });

    test('should reset multiple beneficiaries when their reset dates have passed',
        () async {
      // Arrange
      final pastDate = DateTime.now().subtract(const Duration(days: 5));
      final beneficiaries = [
        Beneficiary(
          id: '1',
          phoneNumber: '+971501234567',
          nickname: 'Test 1',
          monthlyTopupAmount: 100.0,
          monthlyResetDate: pastDate,
          isActive: true,
        ),
        Beneficiary(
          id: '2',
          phoneNumber: '+971501234568',
          nickname: 'Test 2',
          monthlyTopupAmount: 200.0,
          monthlyResetDate: pastDate,
          isActive: true,
        ),
      ];

      when(mockRepository.getBeneficiaries())
          .thenAnswer((_) async => beneficiaries);
      when(mockRepository.cacheBeneficiaries(any))
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase();

      // Assert
      expect(result.length, equals(2));
      expect(result[0].monthlyTopupAmount, equals(0.0));
      expect(result[1].monthlyTopupAmount, equals(0.0));
      verify(mockRepository.cacheBeneficiaries(any)).called(1);
    });

    test('should set reset date to next month when resetting', () async {
      // Arrange
      final pastDate = DateTime.now().subtract(const Duration(days: 5));
      final beneficiaries = [
        Beneficiary(
          id: '1',
          phoneNumber: '+971501234567',
          nickname: 'Test 1',
          monthlyTopupAmount: 100.0,
          monthlyResetDate: pastDate,
          isActive: true,
        ),
      ];

      when(mockRepository.getBeneficiaries())
          .thenAnswer((_) async => beneficiaries);
      when(mockRepository.cacheBeneficiaries(any))
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase();

      // Assert
      final expectedResetDate = DateTime(
        DateTime.now().year,
        DateTime.now().month + 1,
        1,
      );
      expect(result[0].monthlyResetDate.year, equals(expectedResetDate.year));
      expect(
        result[0].monthlyResetDate.month,
        equals(expectedResetDate.month),
      );
      expect(result[0].monthlyResetDate.day, equals(1));
    });

    test('should not call cacheBeneficiaries when no reset is needed',
        () async {
      // Arrange
      final beneficiaries = [
        Beneficiary(
          id: '1',
          phoneNumber: '+971501234567',
          nickname: 'Test 1',
          monthlyTopupAmount: 100.0,
          monthlyResetDate: DateTime.now().add(const Duration(days: 10)),
          isActive: true,
        ),
      ];

      when(mockRepository.getBeneficiaries())
          .thenAnswer((_) async => beneficiaries);

      // Act
      await useCase();

      // Assert
      verify(mockRepository.getBeneficiaries()).called(1);
      verifyNever(mockRepository.cacheBeneficiaries(any));
    });
  });
}
