import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/shared_prefs_keys.dart';
import '../../domain/entities/beneficiary.dart';

class BeneficiaryLocalDataSource {
  final SharedPreferences sharedPreferences;
  BeneficiaryLocalDataSource(this.sharedPreferences);

  Future<void> cacheBeneficiaries(List<Beneficiary> beneficiaries) async {
    final jsonList = beneficiaries.map((b) => b.toJson()).toList();
    await sharedPreferences.setString(SharedPrefsKeys.beneficiaries, jsonEncode(jsonList));
  }

  List<Beneficiary>? getCachedBeneficiaries() {
    final jsonString = sharedPreferences.getString(SharedPrefsKeys.beneficiaries);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => Beneficiary.fromJson(json as Map<String, dynamic>)).toList();
    }
    return null;
  }

  Future<void> clearCache() async {
    await sharedPreferences.remove(SharedPrefsKeys.beneficiaries);
  }
}
