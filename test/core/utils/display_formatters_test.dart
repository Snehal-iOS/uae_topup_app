import 'package:flutter_test/flutter_test.dart';
import 'package:uae_topup_app/core/utils/display_formatters.dart';

void main() {
  group('DisplayFormatters', () {
    group('formatBalance', () {
      test('should return integer string when balance has no decimal part', () {
        expect(DisplayFormatters.formatBalance(1500.0), '1500');
        expect(DisplayFormatters.formatBalance(0.0), '0');
      });

      test('should return two decimals when balance has decimal part', () {
        expect(DisplayFormatters.formatBalance(1500.50), '1500.50');
        expect(DisplayFormatters.formatBalance(99.99), '99.99');
      });

      test('should treat very small decimal part as zero', () {
        expect(DisplayFormatters.formatBalance(100.0001), '100');
      });
    });
  });
}
