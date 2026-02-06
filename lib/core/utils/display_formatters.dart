class DisplayFormatters {
  DisplayFormatters._();

  static String formatBalance(double balance) {
    final decimalPart = balance - balance.truncateToDouble();
    if (decimalPart.abs() < 0.001) {
      return balance.toInt().toString();
    }
    return balance.toStringAsFixed(2);
  }
}
