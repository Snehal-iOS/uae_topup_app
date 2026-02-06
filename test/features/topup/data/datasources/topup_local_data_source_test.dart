import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uae_topup_app/features/topup/data/datasources/topup_local_data_source.dart';
import 'package:uae_topup_app/features/topup/domain/entities/topup_transaction.dart';

void main() {
  late TopupLocalDataSource dataSource;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    dataSource = TopupLocalDataSource(sharedPreferences);
  });

  group('TopupLocalDataSource', () {
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

    test('should cache transactions successfully', () async {
      // Act
      await dataSource.cacheTransactions(tTransactions);

      // Assert
      final result = dataSource.getCachedTransactions();
      expect(result.length, equals(3));
      expect(result, equals(tTransactions));
    });

    test('should return empty list when no cached transactions exist', () {
      // Act
      final result = dataSource.getCachedTransactions();

      // Assert
      expect(result, isEmpty);
    });

    test('should add transaction successfully', () async {
      // Arrange
      await dataSource.cacheTransactions([tTransactions[0]]);
      final newTransaction = tTransactions[1];

      // Act
      await dataSource.addTransaction(newTransaction);

      // Assert
      final result = dataSource.getCachedTransactions();
      expect(result.length, equals(2));
      expect(result.last, equals(newTransaction));
    });

    test('should get transactions by month correctly', () async {
      // Arrange
      await dataSource.cacheTransactions(tTransactions);

      // Act
      final result = dataSource.getTransactionsByMonth(DateTime(2025, 1, 1));

      // Assert
      expect(result.length, equals(2));
      expect(result[0].id, equals('1'));
      expect(result[1].id, equals('2'));
    });

    test('should return empty list when no transactions for month', () async {
      // Arrange
      await dataSource.cacheTransactions(tTransactions);

      // Act
      final result = dataSource.getTransactionsByMonth(DateTime(2025, 3, 1));

      // Assert
      expect(result, isEmpty);
    });

    test('should get transactions by beneficiary correctly', () async {
      // Arrange
      await dataSource.cacheTransactions(tTransactions);

      // Act
      final result = dataSource.getTransactionsByBeneficiary('ben1');

      // Assert
      expect(result.length, equals(2));
      expect(result[0].id, equals('1'));
      expect(result[1].id, equals('3'));
    });

    test('should return empty list when no transactions for beneficiary',
        () async {
      // Arrange
      await dataSource.cacheTransactions(tTransactions);

      // Act
      final result = dataSource.getTransactionsByBeneficiary('nonexistent');

      // Assert
      expect(result, isEmpty);
    });

    test('should clear cache successfully', () async {
      // Arrange
      await dataSource.cacheTransactions(tTransactions);
      expect(dataSource.getCachedTransactions().isNotEmpty, isTrue);

      // Act
      await dataSource.clearCache();

      // Assert
      expect(dataSource.getCachedTransactions(), isEmpty);
    });
  });
}
