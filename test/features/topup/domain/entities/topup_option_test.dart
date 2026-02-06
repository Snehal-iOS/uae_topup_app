import 'package:flutter_test/flutter_test.dart';
import 'package:uae_topup_app/features/topup/domain/entities/topup_option.dart';

void main() {
  group('TopupOption', () {
    test('availableOptions should contain 7 predefined amounts', () {
      expect(TopupOption.availableOptions.length, equals(7));
    });

    test('availableOptions should contain correct amounts', () {
      final amounts = TopupOption.availableOptions.map((o) => o.amount).toList();
      expect(amounts, equals([5.0, 10.0, 20.0, 30.0, 50.0, 75.0, 100.0]));
    });

    test('props should contain amount', () {
      const option = TopupOption(amount: 50.0);
      expect(option.props, equals([50.0]));
    });

    test('two instances with same amount should be equal', () {
      const option1 = TopupOption(amount: 50.0);
      const option2 = TopupOption(amount: 50.0);
      expect(option1, equals(option2));
    });

    test('two instances with different amounts should not be equal', () {
      const option1 = TopupOption(amount: 50.0);
      const option2 = TopupOption(amount: 100.0);
      expect(option1, isNot(equals(option2)));
    });
  });
}
