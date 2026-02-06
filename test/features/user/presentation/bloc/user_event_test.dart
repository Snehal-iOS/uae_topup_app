import 'package:flutter_test/flutter_test.dart';
import 'package:uae_topup_app/features/user/presentation/bloc/user_event.dart';

void main() {
  group('UserEvent', () {
    group('LoadUser', () {
      test('props should be empty', () {
        const event = LoadUser();
        expect(event.props, equals([]));
      });

      test('two instances should be equal', () {
        const event1 = LoadUser();
        const event2 = LoadUser();
        expect(event1, equals(event2));
      });
    });

    group('UpdateUserBalance', () {
      test('props should contain newBalance and topupAmount', () {
        const event = UpdateUserBalance(
          newBalance: 1000.0,
          topupAmount: 100.0,
        );
        expect(event.props, equals([1000.0, 100.0]));
      });

      test('two instances with same values should be equal', () {
        const event1 = UpdateUserBalance(
          newBalance: 1000.0,
          topupAmount: 100.0,
        );
        const event2 = UpdateUserBalance(
          newBalance: 1000.0,
          topupAmount: 100.0,
        );
        expect(event1, equals(event2));
      });

      test('two instances with different values should not be equal', () {
        const event1 = UpdateUserBalance(
          newBalance: 1000.0,
          topupAmount: 100.0,
        );
        const event2 = UpdateUserBalance(
          newBalance: 900.0,
          topupAmount: 200.0,
        );
        expect(event1, isNot(equals(event2)));
      });
    });

    group('RefreshUser', () {
      test('props should contain silent flag', () {
        const event = RefreshUser(silent: true);
        expect(event.props, equals([true]));
      });

      test('default silent should be false', () {
        const event = RefreshUser();
        expect(event.props, equals([false]));
      });

      test('two instances with same values should be equal', () {
        const event1 = RefreshUser(silent: true);
        const event2 = RefreshUser(silent: true);
        expect(event1, equals(event2));
      });

      test('two instances with different values should not be equal', () {
        const event1 = RefreshUser(silent: true);
        const event2 = RefreshUser(silent: false);
        expect(event1, isNot(equals(event2)));
      });
    });
  });
}
