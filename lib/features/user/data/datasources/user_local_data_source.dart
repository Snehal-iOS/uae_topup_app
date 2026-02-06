import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/shared_prefs_keys.dart';
import '../../domain/entities/user.dart';

class UserLocalDataSource {
  final SharedPreferences sharedPreferences;
  UserLocalDataSource(this.sharedPreferences);

  Future<void> cacheUser(User user) async {
    await sharedPreferences.setString(SharedPrefsKeys.user, jsonEncode(user.toJson()));
  }

  User? getCachedUser() {
    final jsonString = sharedPreferences.getString(SharedPrefsKeys.user);
    if (jsonString != null) {
      return User.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> clearCache() async {
    await sharedPreferences.remove(SharedPrefsKeys.user);
  }
}
