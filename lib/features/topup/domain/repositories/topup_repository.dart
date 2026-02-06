import '../entities/topup_transaction.dart';

abstract class TopupRepository {
  Future<TopupTransaction> performTopup({required String beneficiaryId, required double amount});
  Future<List<TopupTransaction>> getTransactions();
  Future<List<TopupTransaction>> getTransactionsByMonth(DateTime month);
  Future<List<TopupTransaction>> getTransactionsByBeneficiary(String beneficiaryId);
}
