import '../entities/topup_transaction.dart';
import '../repositories/topup_repository.dart';

class GetTransactionsUseCase {
  final TopupRepository repository;
  GetTransactionsUseCase(this.repository);

  Future<List<TopupTransaction>> call() async {
    return repository.getTransactions();
  }

  Future<List<TopupTransaction>> getByMonth(DateTime month) async {
    return repository.getTransactionsByMonth(month);
  }

  Future<List<TopupTransaction>> getByBeneficiary(String beneficiaryId) async {
    return repository.getTransactionsByBeneficiary(beneficiaryId);
  }

  Future<double> getMonthlyTotalForBeneficiary({required String beneficiaryId, required DateTime month}) async {
    final transactions = await repository.getTransactionsByMonth(month);
    final beneficiaryTransactions = transactions
        .where((t) => t.beneficiaryId == beneficiaryId && t.status == 'success')
        .toList();

    if (beneficiaryTransactions.isEmpty) {
      return 0.0;
    }

    return beneficiaryTransactions.fold<double>(0.0, (double sum, transaction) => sum + transaction.amount);
  }

  Future<double> getMonthlyTotalForUser(DateTime month) async {
    final transactions = await repository.getTransactionsByMonth(month);

    final successfulTransactions = transactions.where((t) => t.status == 'success').toList();

    if (successfulTransactions.isEmpty) {
      return 0.0;
    }

    return successfulTransactions.fold<double>(0.0, (double sum, transaction) => sum + transaction.amount);
  }
}
