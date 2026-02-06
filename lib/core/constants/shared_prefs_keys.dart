/// This file contains all the keys for SharedPreferences.
/// Use these constants instead of string literals to avoid typos and simplify changes.
class SharedPrefsKeys {
  SharedPrefsKeys._();

  static const String user = 'CACHED_USER'; // Cached user (JSON)
  static const String beneficiaries = 'CACHED_BENEFICIARIES';  // Cached beneficiaries list (JSON array)
  static const String transactions = 'CACHED_TRANSACTIONS';  // Cached top-up transactions list (JSON array)
}
