import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uae_topup_app/features/beneficiary/domain/repositories/beneficiary_repository.dart';
import 'package:uae_topup_app/features/beneficiary/domain/usecases/delete_beneficiary_usecase.dart';

import 'add_beneficiary_usecase_test.mocks.dart';
@GenerateMocks([BeneficiaryRepository])

void main() {
  late DeleteBeneficiaryUseCase useCase;
  late MockBeneficiaryRepository mockRepository;

  setUp(() {
    mockRepository = MockBeneficiaryRepository();
    useCase = DeleteBeneficiaryUseCase(mockRepository);
  });

  group('DeleteBeneficiaryUseCase', () {
    test('should delete beneficiary successfully', () async {
      // Arrange
      const beneficiaryId = '1';
      when(mockRepository.deleteBeneficiary(any))
          .thenAnswer((_) async => {});

      // Act
      await useCase(beneficiaryId);

      // Assert
      verify(mockRepository.deleteBeneficiary(beneficiaryId)).called(1);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      const beneficiaryId = '1';
      when(mockRepository.deleteBeneficiary(any))
          .thenThrow(Exception('Repository error'));

      // Act & Assert
      expect(
        () => useCase(beneficiaryId),
        throwsException,
      );
      verify(mockRepository.deleteBeneficiary(beneficiaryId)).called(1);
    });
  });
}
