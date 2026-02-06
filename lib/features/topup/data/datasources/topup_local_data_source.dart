import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/shared_prefs_keys.dart';
import '../../domain/entities/topup_transaction.dart';

class TopupLocalDataSource {
  final SharedPreferences sharedPreferences;
  TopupLocalDataSource(this.sharedPreferences);

  Future<void> cacheTransactions(List<TopupTransaction> transactions) async {
    final transactionsJson = transactions.map((t) => t.toJson()).toList();
    await sharedPreferences.setString(SharedPrefsKeys.transactions, jsonEncode(transactionsJson));
  }

  List<TopupTransaction> getCachedTransactions() {
    final transactionsJson = sharedPreferences.getString(SharedPrefsKeys.transactions);
    if (transactionsJson != null) {
      final List<dynamic> decoded = jsonDecode(transactionsJson) as List;
      return decoded.map((item) => TopupTransaction.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<void> addTransaction(TopupTransaction transaction) async {
    final currentTransactions = getCachedTransactions();
    currentTransactions.add(transaction);
    await cacheTransactions(currentTransactions);
  }

  List<TopupTransaction> getTransactionsByMonth(DateTime month) {
    final transactions = getCachedTransactions();
    return transactions.where((t) {
      return t.timestamp.year == month.year && t.timestamp.month == month.month;
    }).toList();
  }

  List<TopupTransaction> getTransactionsByBeneficiary(String beneficiaryId) {
    final transactions = getCachedTransactions();
    return transactions.where((t) => t.beneficiaryId == beneficiaryId).toList();
  }

  Future<void> clearCache() async {
    await sharedPreferences.remove(SharedPrefsKeys.transactions);
  }
}
