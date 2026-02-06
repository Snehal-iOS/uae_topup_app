import 'package:flutter_test/flutter_test.dart';
import 'package:uae_topup_app/features/beneficiary/domain/entities/beneficiary.dart';
import 'package:uae_topup_app/features/topup/presentation/bloc/topup_event.dart';
import 'package:uae_topup_app/features/user/domain/entities/user.dart';

void main() {
  final tUser = User(
    id: '1',
    name: 'Test User',
    balance: 1000.0,
    isVerified: true,
    monthlyTopupTotal: 500.0,
    monthlyResetDate: DateTime(2026, 3, 1),
  );

  final tBeneficiary = Beneficiary(
    id: '1',
    phoneNumber: '+971501234567',
    nickname: 'Test',
    monthlyTopupAmount: 100.0,
    isActive: true,
    monthlyResetDate: DateTime(2026, 3, 1),
  );

  group('TopupEvent', () {
    group('PerformTopup', () {
      test('props should contain all fields', () {
        final event = PerformTopup(beneficiaryId: '1', amount: 100.0, user: tUser, beneficiary: tBeneficiary);
        expect(event.props, equals(['1', 100.0, tUser, tBeneficiary]));
      });

      test('two instances with same values should be equal', () {
        final event1 = PerformTopup(beneficiaryId: '1', amount: 100.0, user: tUser, beneficiary: tBeneficiary);
        final event2 = PerformTopup(beneficiaryId: '1', amount: 100.0, user: tUser, beneficiary: tBeneficiary);
        expect(event1, equals(event2));
      });

      test('two instances with different amounts should not be equal', () {
        final event1 = PerformTopup(beneficiaryId: '1', amount: 100.0, user: tUser, beneficiary: tBeneficiary);
        final event2 = PerformTopup(beneficiaryId: '1', amount: 200.0, user: tUser, beneficiary: tBeneficiary);
        expect(event1, isNot(equals(event2)));
      });
    });

    group('LoadTransactions', () {
      test('props should be empty', () {
        const event = LoadTransactions();
        expect(event.props, equals([]));
      });

      test('two instances should be equal', () {
        const event1 = LoadTransactions();
        const event2 = LoadTransactions();
        expect(event1, equals(event2));
      });
    });

    group('ClearMessages', () {
      test('props should be empty', () {
        const event = ClearMessages();
        expect(event.props, equals([]));
      });

      test('two instances should be equal', () {
        const event1 = ClearMessages();
        const event2 = ClearMessages();
        expect(event1, equals(event2));
      });
    });
  });
}
