import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uae_topup_app/features/topup/domain/entities/topup_transaction.dart';
import 'package:uae_topup_app/features/topup/domain/repositories/topup_repository.dart';
import 'package:uae_topup_app/features/topup/domain/usecases/get_transactions_usecase.dart';

@GenerateMocks([TopupRepository])
import 'get_transactions_usecase_test.mocks.dart';

void main() {
  late GetTransactionsUseCase useCase;
  late MockTopupRepository mockRepository;

  setUp(() {
    mockRepository = MockTopupRepository();
    useCase = GetTransactionsUseCase(mockRepository);
  });

  final tTransactions = [
    TopupTransaction(
      id: '1',
      beneficiaryId: 'ben1',
      amount: 100.0,
      charge: 3.0,
      timestamp: DateTime(2025, 1, 15),
      status: 'success',
    ),
    TopupTransaction(
      id: '2',
      beneficiaryId: 'ben2',
      amount: 200.0,
      charge: 3.0,
      timestamp: DateTime(2025, 1, 20),
      status: 'success',
    ),
    TopupTransaction(
      id: '3',
      beneficiaryId: 'ben1',
      amount: 50.0,
      charge: 3.0,
      timestamp: DateTime(2025, 2, 5),
      status: 'success',
    ),
  ];

  group('GetTransactionsUseCase', () {
    test('should return all transactions', () async {
      // Arrange
      when(mockRepository.getTransactions()).thenAnswer((_) async => tTransactions);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(tTransactions));
      verify(mockRepository.getTransactions()).called(1);
    });

    test('should get transactions by month', () async {
      // Arrange
      final month = DateTime(2025, 1, 1);
      final expectedTransactions = tTransactions
          .where((t) => t.timestamp.year == month.year && t.timestamp.month == month.month)
          .toList();

      when(mockRepository.getTransactionsByMonth(any)).thenAnswer((_) async => expectedTransactions);

      // Act
      final result = await useCase.getByMonth(month);

      // Assert
      expect(result.length, equals(2));
      expect(result, equals(expectedTransactions));
      verify(mockRepository.getTransactionsByMonth(month)).called(1);
    });

    test('should get transactions by beneficiary', () async {
      // Arrange
      const beneficiaryId = 'ben1';
      final expectedTransactions = tTransactions.where((t) => t.beneficiaryId == beneficiaryId).toList();

      when(mockRepository.getTransactionsByBeneficiary(any)).thenAnswer((_) async => expectedTransactions);

      // Act
      final result = await useCase.getByBeneficiary(beneficiaryId);

      // Assert
      expect(result.length, equals(2));
      expect(result, equals(expectedTransactions));
      verify(mockRepository.getTransactionsByBeneficiary(beneficiaryId)).called(1);
    });

    test('should calculate monthly total for beneficiary correctly', () async {
      // Arrange
      const beneficiaryId = 'ben1';
      final month = DateTime(2025, 1, 1);
      final monthTransactions = tTransactions
          .where(
            (t) =>
                t.beneficiaryId == beneficiaryId &&
                t.timestamp.year == month.year &&
                t.timestamp.month == month.month &&
                t.status == 'success',
          )
          .toList();

      when(mockRepository.getTransactionsByMonth(any)).thenAnswer((_) async => monthTransactions);

      // Act
      final result = await useCase.getMonthlyTotalForBeneficiary(beneficiaryId: beneficiaryId, month: month);

      // Assert
      expect(result, equals(100.0));
    });

    test('should return 0.0 when no transactions for beneficiary in month', () async {
      // Arrange
      const beneficiaryId = 'ben-nonexistent';
      final month = DateTime(2025, 1, 1);

      when(mockRepository.getTransactionsByMonth(any)).thenAnswer((_) async => []);

      // Act
      final result = await useCase.getMonthlyTotalForBeneficiary(beneficiaryId: beneficiaryId, month: month);

      // Assert
      expect(result, equals(0.0));
    });

    test('should exclude failed transactions from monthly total', () async {
      // Arrange
      const beneficiaryId = 'ben1';
      final month = DateTime(2025, 1, 1);
      final transactionsWithFailed = [
        ...tTransactions,
        TopupTransaction(
          id: '4',
          beneficiaryId: beneficiaryId,
          amount: 300.0,
          charge: 3.0,
          timestamp: DateTime(2025, 1, 25),
          status: 'failed',
        ),
      ];

      // Filter to only January transactions
      final januaryTransactions = transactionsWithFailed
          .where((t) => t.timestamp.year == month.year && t.timestamp.month == month.month)
          .toList();

      when(mockRepository.getTransactionsByMonth(any)).thenAnswer((_) async => januaryTransactions);

      // Act
      final result = await useCase.getMonthlyTotalForBeneficiary(beneficiaryId: beneficiaryId, month: month);

      // Assert
      expect(result, equals(100.0)); // Only successful transaction
    });

    test('should calculate monthly total for user correctly', () async {
      // Arrange
      final month = DateTime(2025, 1, 1);
      final monthTransactions = tTransactions
          .where((t) => t.timestamp.year == month.year && t.timestamp.month == month.month && t.status == 'success')
          .toList();

      when(mockRepository.getTransactionsByMonth(any)).thenAnswer((_) async => monthTransactions);

      // Act
      final result = await useCase.getMonthlyTotalForUser(month);

      // Assert
      expect(result, equals(300.0)); // 100 + 200
    });

    test('should return 0.0 when no transactions for user in month', () async {
      // Arrange
      final month = DateTime(2025, 3, 1);

      when(mockRepository.getTransactionsByMonth(any)).thenAnswer((_) async => []);

      // Act
      final result = await useCase.getMonthlyTotalForUser(month);

      // Assert
      expect(result, equals(0.0));
    });

    test('should exclude failed transactions from user monthly total', () async {
      // Arrange
      final month = DateTime(2025, 1, 1);
      final transactionsWithFailed = [
        ...tTransactions,
        TopupTransaction(
          id: '4',
          beneficiaryId: 'ben3',
          amount: 500.0,
          charge: 3.0,
          timestamp: DateTime(2025, 1, 25),
          status: 'failed',
        ),
      ];

      // Filter to only January transactions
      final januaryTransactions = transactionsWithFailed
          .where((t) => t.timestamp.year == month.year && t.timestamp.month == month.month)
          .toList();

      when(mockRepository.getTransactionsByMonth(any)).thenAnswer((_) async => januaryTransactions);

      // Act
      final result = await useCase.getMonthlyTotalForUser(month);

      // Assert
      expect(result, equals(300.0)); // Only successful transactions
    });
  });
}
