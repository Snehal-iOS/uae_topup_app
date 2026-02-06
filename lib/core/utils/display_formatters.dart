/// This file helps to format balance across the app.
class DisplayFormatters {
  DisplayFormatters._();

  /// Balance for display: whole number when decimal part is effectively zero, otherwise 2 decimals.
  static String formatBalance(double balance) {
    final decimalPart = balance - balance.truncateToDouble();
    if (decimalPart.abs() < 0.001) {
      return balance.toInt().toString();
    }
    return balance.toStringAsFixed(2);
  }
}
