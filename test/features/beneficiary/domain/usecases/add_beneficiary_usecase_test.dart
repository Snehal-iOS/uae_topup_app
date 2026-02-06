import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uae_topup_app/core/errors/custom_exception.dart';
import 'package:uae_topup_app/features/beneficiary/domain/entities/beneficiary.dart';
import 'package:uae_topup_app/features/beneficiary/domain/repositories/beneficiary_repository.dart';
import 'package:uae_topup_app/features/beneficiary/domain/usecases/add_beneficiary_usecase.dart';

@GenerateMocks([BeneficiaryRepository])
import 'add_beneficiary_usecase_test.mocks.dart';

void main() {
  late AddBeneficiaryUseCase useCase;
  late MockBeneficiaryRepository mockRepository;

  setUp(() {
    mockRepository = MockBeneficiaryRepository();
    useCase = AddBeneficiaryUseCase(mockRepository);
  });

  group('AddBeneficiaryUseCase', () {
    test('should add beneficiary successfully when less than 5 active', () async {
      // Arrange
      const phoneNumber = '+971501234567';
      const nickname = 'Test Beneficiary';
      final existingBeneficiaries = List.generate(
        3,
        (i) => Beneficiary(
          id: '$i',
          phoneNumber: '+97150123456$i',
          nickname: 'Beneficiary $i',
          monthlyResetDate: DateTime(2025, 2, 1),
          isActive: true,
        ),
      );

      when(mockRepository.getBeneficiaries()).thenAnswer((_) async => existingBeneficiaries);
      when(mockRepository.addBeneficiary(any)).thenAnswer(
        (_) async => Beneficiary(
          id: 'new',
          phoneNumber: phoneNumber,
          nickname: nickname,
          monthlyResetDate: DateTime(2025, 2, 1),
          isActive: true,
        ),
      );

      // Act
      final result = await useCase(phoneNumber: phoneNumber, nickname: nickname);

      // Assert
      expect(result.isActive, isTrue);
      verify(mockRepository.getBeneficiaries()).called(1);
      verify(mockRepository.addBeneficiary(any)).called(1);
    });

    test('should add beneficiary as inactive when 5 active beneficiaries exist', () async {
      // Arrange
      const phoneNumber = '+971501234567';
      const nickname = 'Test Beneficiary';
      final existingBeneficiaries = List.generate(
        5,
        (i) => Beneficiary(
          id: '$i',
          phoneNumber: '+97150123456$i',
          nickname: 'Beneficiary $i',
          monthlyResetDate: DateTime(2025, 2, 1),
          isActive: true,
        ),
      );

      when(mockRepository.getBeneficiaries()).thenAnswer((_) async => existingBeneficiaries);
      when(mockRepository.addBeneficiary(any)).thenAnswer(
        (_) async => Beneficiary(
          id: 'new',
          phoneNumber: phoneNumber,
          nickname: nickname,
          monthlyResetDate: DateTime(2025, 2, 1),
          isActive: false,
        ),
      );

      // Act
      final result = await useCase(phoneNumber: phoneNumber, nickname: nickname);

      // Assert
      expect(result.isActive, isFalse);
      verify(mockRepository.getBeneficiaries()).called(1);
      verify(mockRepository.addBeneficiary(any)).called(1);
    });

    test('should throw ValidationException when nickname is empty', () async {
      // Arrange
      const phoneNumber = '+971501234567';
      const nickname = '';

      // Act & Assert
      expect(() => useCase(phoneNumber: phoneNumber, nickname: nickname), throwsA(isA<ValidationException>()));
      verifyNever(mockRepository.addBeneficiary(any));
    });

    test('should throw ValidationException when nickname is whitespace only', () async {
      // Arrange
      const phoneNumber = '+971501234567';
      const nickname = '   ';

      // Act & Assert
      expect(() => useCase(phoneNumber: phoneNumber, nickname: nickname), throwsA(isA<ValidationException>()));
      verifyNever(mockRepository.addBeneficiary(any));
    });

    test('should throw ValidationException when nickname exceeds 20 characters', () async {
      // Arrange
      const phoneNumber = '+971501234567';
      final nickname = 'A' * 21;

      // Act & Assert
      expect(() => useCase(phoneNumber: phoneNumber, nickname: nickname), throwsA(isA<ValidationException>()));
      verifyNever(mockRepository.addBeneficiary(any));
    });

    test('should accept nickname with exactly 20 characters', () async {
      // Arrange
      const phoneNumber = '+971501234567';
      final nickname = 'A' * 20;
      when(mockRepository.getBeneficiaries()).thenAnswer((_) async => []);
      when(mockRepository.addBeneficiary(any)).thenAnswer(
        (_) async => Beneficiary(
          id: 'new',
          phoneNumber: phoneNumber,
          nickname: nickname,
          monthlyResetDate: DateTime(2025, 2, 1),
        ),
      );

      // Act
      await useCase(phoneNumber: phoneNumber, nickname: nickname);

      // Assert
      verify(mockRepository.addBeneficiary(any)).called(1);
    });

    test('should throw ValidationException for invalid phone number format', () async {
      // Arrange
      const phoneNumber = '12345';
      const nickname = 'Test';

      // Act & Assert
      expect(() => useCase(phoneNumber: phoneNumber, nickname: nickname), throwsA(isA<ValidationException>()));
      verifyNever(mockRepository.addBeneficiary(any));
    });

    test('should accept valid UAE phone number with +971 prefix', () async {
      // Arrange
      const phoneNumber = '+971501234567';
      const nickname = 'Test';
      when(mockRepository.getBeneficiaries()).thenAnswer((_) async => []);
      when(mockRepository.addBeneficiary(any)).thenAnswer(
        (_) async => Beneficiary(
          id: 'new',
          phoneNumber: phoneNumber,
          nickname: nickname,
          monthlyResetDate: DateTime(2025, 2, 1),
        ),
      );

      // Act
      await useCase(phoneNumber: phoneNumber, nickname: nickname);

      // Assert
      verify(mockRepository.addBeneficiary(any)).called(1);
    });

    test('should accept valid UAE phone number with 05 prefix', () async {
      // Arrange
      const phoneNumber = '0501234567';
      const nickname = 'Test';
      when(mockRepository.getBeneficiaries()).thenAnswer((_) async => []);
      when(mockRepository.addBeneficiary(any)).thenAnswer(
        (_) async => Beneficiary(
          id: 'new',
          phoneNumber: phoneNumber,
          nickname: nickname,
          monthlyResetDate: DateTime(2025, 2, 1),
        ),
      );

      // Act
      await useCase(phoneNumber: phoneNumber, nickname: nickname);

      // Assert
      verify(mockRepository.addBeneficiary(any)).called(1);
    });

    test('should accept phone number with spaces and dashes', () async {
      // Arrange
      const phoneNumber = '+971 50 123 4567';
      const nickname = 'Test';
      when(mockRepository.getBeneficiaries()).thenAnswer((_) async => []);
      when(mockRepository.addBeneficiary(any)).thenAnswer(
        (_) async => Beneficiary(
          id: 'new',
          phoneNumber: phoneNumber,
          nickname: nickname,
          monthlyResetDate: DateTime(2025, 2, 1),
        ),
      );

      // Act
      await useCase(phoneNumber: phoneNumber, nickname: nickname);

      // Assert
      verify(mockRepository.addBeneficiary(any)).called(1);
    });

    test('should throw ValidationException for duplicate phone number', () async {
      // Arrange
      const phoneNumber = '+971501234567';
      const nickname = 'Test';
      final existingBeneficiaries = [
        Beneficiary(id: '1', phoneNumber: phoneNumber, nickname: 'Existing', monthlyResetDate: DateTime(2025, 2, 1)),
      ];

      when(mockRepository.getBeneficiaries()).thenAnswer((_) async => existingBeneficiaries);

      // Act & Assert
      expect(() => useCase(phoneNumber: phoneNumber, nickname: nickname), throwsA(isA<ValidationException>()));
      verifyNever(mockRepository.addBeneficiary(any));
    });

    test('should check duplicate against all beneficiaries, not just active', () async {
      // Arrange
      const phoneNumber = '+971501234567';
      const nickname = 'Test';
      final existingBeneficiaries = [
        Beneficiary(
          id: '1',
          phoneNumber: phoneNumber,
          nickname: 'Existing',
          monthlyResetDate: DateTime(2025, 2, 1),
          isActive: false, // Inactive but still duplicate
        ),
      ];

      when(mockRepository.getBeneficiaries()).thenAnswer((_) async => existingBeneficiaries);

      // Act & Assert
      expect(() => useCase(phoneNumber: phoneNumber, nickname: nickname), throwsA(isA<ValidationException>()));
      verifyNever(mockRepository.addBeneficiary(any));
    });
  });
}
