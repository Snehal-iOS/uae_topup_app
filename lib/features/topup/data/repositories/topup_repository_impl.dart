import '../../../../core/errors/custom_exception.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../data/datasources/mock_http_client.dart';
import '../../domain/entities/topup_transaction.dart';
import '../../domain/repositories/topup_repository.dart';
import '../datasources/topup_local_data_source.dart';

class TopupRepositoryImpl implements TopupRepository {
  final MockHttpClient httpClient;
  final TopupLocalDataSource localDataSource;

  TopupRepositoryImpl({
    required this.httpClient,
    required this.localDataSource,
  });

  @override
  Future<TopupTransaction> performTopup({
    required String beneficiaryId,
    required double amount,
  }) async {
    try {
      final response = await httpClient.post('/api/topup', {
        'beneficiaryId': beneficiaryId,
        'amount': amount,
      });

      final transaction = TopupTransaction.fromJson(response);
      // Store transaction in history
      await localDataSource.addTransaction(transaction);

      return transaction;
    } catch (e) {
      if (e is CustomException) {  // Re-throw with more context for better error handling
        rethrow;
      }
      throw NetworkException(
        AppStrings.format(AppStrings.failedToPerformTopup, [e.toString()]),
      );
    }
  }

  @override
  Future<List<TopupTransaction>> getTransactions() async {
    return localDataSource.getCachedTransactions();
  }

  @override
  Future<List<TopupTransaction>> getTransactionsByMonth(DateTime month) async {
    return localDataSource.getTransactionsByMonth(month);
  }

  @override
  Future<List<TopupTransaction>> getTransactionsByBeneficiary(
    String beneficiaryId,
  ) async {
    return localDataSource.getTransactionsByBeneficiary(beneficiaryId);
  }
}
