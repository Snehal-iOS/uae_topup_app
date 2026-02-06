import 'package:flutter_test/flutter_test.dart';
import 'package:uae_topup_app/features/user/domain/entities/user.dart';

void main() {
  group('User', () {
    test('monthlyLimit should be 1000 for verified user', () {
      final user = User(
        id: '1',
        name: 'Test User',
        balance: 1000.0,
        isVerified: true,
        monthlyTopupTotal: 500.0,
        monthlyResetDate: DateTime(2026, 3, 1),
      );

      expect(user.monthlyLimit, equals(1000.0));
    });

    test('monthlyLimit should be 500 for unverified user', () {
      final user = User(
        id: '1',
        name: 'Test User',
        balance: 1000.0,
        isVerified: false,
        monthlyTopupTotal: 500.0,
        monthlyResetDate: DateTime(2026, 3, 1),
      );

      expect(user.monthlyLimit, equals(500.0));
    });

    test('totalMonthlyLimit should always be 3000', () {
      final verifiedUser = User(
        id: '1',
        name: 'Test User',
        balance: 1000.0,
        isVerified: true,
        monthlyTopupTotal: 500.0,
        monthlyResetDate: DateTime(2026, 3, 1),
      );

      final unverifiedUser = User(
        id: '2',
        name: 'Test User 2',
        balance: 1000.0,
        isVerified: false,
        monthlyTopupTotal: 500.0,
        monthlyResetDate: DateTime(2026, 3, 1),
      );

      expect(verifiedUser.totalMonthlyLimit, equals(3000.0));
      expect(unverifiedUser.totalMonthlyLimit, equals(3000.0));
    });

    test('copyWith should preserve unchanged fields', () {
      final user = User(
        id: '1',
        name: 'Test User',
        balance: 1000.0,
        isVerified: true,
        monthlyTopupTotal: 500.0,
        monthlyResetDate: DateTime(2026, 3, 1),
      );

      final updatedUser = user.copyWith(balance: 800.0);

      expect(updatedUser.id, equals('1'));
      expect(updatedUser.name, equals('Test User'));
      expect(updatedUser.balance, equals(800.0));
      expect(updatedUser.isVerified, equals(true));
      expect(updatedUser.monthlyTopupTotal, equals(500.0));
      expect(updatedUser.monthlyResetDate, equals(DateTime(2026, 3, 1)));
    });

    test('toJson should serialize user correctly', () {
      final user = User(
        id: '1',
        name: 'Test User',
        balance: 1000.0,
        isVerified: true,
        monthlyTopupTotal: 500.0,
        monthlyResetDate: DateTime(2026, 3, 1),
      );

      final json = user.toJson();

      expect(json['id'], equals('1'));
      expect(json['name'], equals('Test User'));
      expect(json['balance'], equals(1000.0));
      expect(json['isVerified'], equals(true));
      expect(json['monthlyTopupTotal'], equals(500.0));
      expect(json['monthlyResetDate'], equals('2026-03-01T00:00:00.000'));
    });

    test('fromJson should deserialize user correctly', () {
      final json = {
        'id': '1',
        'name': 'Test User',
        'balance': 1000.0,
        'isVerified': true,
        'monthlyTopupTotal': 500.0,
        'monthlyResetDate': '2026-03-01T00:00:00.000',
      };

      final user = User.fromJson(json);

      expect(user.id, equals('1'));
      expect(user.name, equals('Test User'));
      expect(user.balance, equals(1000.0));
      expect(user.isVerified, equals(true));
      expect(user.monthlyTopupTotal, equals(500.0));
      expect(user.monthlyResetDate, equals(DateTime(2026, 3, 1)));
    });

    test('fromJson should default monthlyTopupTotal to 0 if not provided', () {
      final json = {
        'id': '1',
        'name': 'Test User',
        'balance': 1000.0,
        'isVerified': true,
        'monthlyResetDate': '2026-03-01T00:00:00.000',
      };

      final user = User.fromJson(json);

      expect(user.monthlyTopupTotal, equals(0.0));
    });

    test('props should contain all fields', () {
      final user = User(
        id: '1',
        name: 'Test User',
        balance: 1000.0,
        isVerified: true,
        monthlyTopupTotal: 500.0,
        monthlyResetDate: DateTime(2026, 3, 1),
      );

      expect(
        user.props,
        equals([
          '1',
          'Test User',
          1000.0,
          true,
          500.0,
          DateTime(2026, 3, 1),
        ]),
      );
    });

    test('two instances with same values should be equal', () {
      final user1 = User(
        id: '1',
        name: 'Test User',
        balance: 1000.0,
        isVerified: true,
        monthlyTopupTotal: 500.0,
        monthlyResetDate: DateTime(2026, 3, 1),
      );

      final user2 = User(
        id: '1',
        name: 'Test User',
        balance: 1000.0,
        isVerified: true,
        monthlyTopupTotal: 500.0,
        monthlyResetDate: DateTime(2026, 3, 1),
      );

      expect(user1, equals(user2));
    });

    test('two instances with different values should not be equal', () {
      final user1 = User(
        id: '1',
        name: 'Test User',
        balance: 1000.0,
        isVerified: true,
        monthlyTopupTotal: 500.0,
        monthlyResetDate: DateTime(2026, 3, 1),
      );

      final user2 = User(
        id: '2',
        name: 'Test User 2',
        balance: 800.0,
        isVerified: false,
        monthlyTopupTotal: 300.0,
        monthlyResetDate: DateTime(2026, 4, 1),
      );

      expect(user1, isNot(equals(user2)));
    });
  });
}
