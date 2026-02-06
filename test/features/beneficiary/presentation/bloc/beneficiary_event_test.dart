import 'package:flutter_test/flutter_test.dart';
import 'package:uae_topup_app/features/beneficiary/presentation/bloc/beneficiary_event.dart';

void main() {
  group('BeneficiaryEvent', () {
    group('LoadBeneficiaries', () {
      test('props should be empty', () {
        const event = LoadBeneficiaries();
        expect(event.props, equals([]));
      });

      test('two instances should be equal', () {
        const event1 = LoadBeneficiaries();
        const event2 = LoadBeneficiaries();
        expect(event1, equals(event2));
      });
    });

    group('AddBeneficiary', () {
      test('props should contain phoneNumber and nickname', () {
        const event = AddBeneficiary(
          phoneNumber: '+971501234567',
          nickname: 'Test',
        );
        expect(event.props, equals(['+971501234567', 'Test']));
      });

      test('two instances with same values should be equal', () {
        const event1 = AddBeneficiary(
          phoneNumber: '+971501234567',
          nickname: 'Test',
        );
        const event2 = AddBeneficiary(
          phoneNumber: '+971501234567',
          nickname: 'Test',
        );
        expect(event1, equals(event2));
      });

      test('two instances with different values should not be equal', () {
        const event1 = AddBeneficiary(
          phoneNumber: '+971501234567',
          nickname: 'Test1',
        );
        const event2 = AddBeneficiary(
          phoneNumber: '+971501234567',
          nickname: 'Test2',
        );
        expect(event1, isNot(equals(event2)));
      });
    });

    group('DeleteBeneficiary', () {
      test('props should contain beneficiaryId', () {
        const event = DeleteBeneficiary('123');
        expect(event.props, equals(['123']));
      });

      test('two instances with same id should be equal', () {
        const event1 = DeleteBeneficiary('123');
        const event2 = DeleteBeneficiary('123');
        expect(event1, equals(event2));
      });

      test('two instances with different ids should not be equal', () {
        const event1 = DeleteBeneficiary('123');
        const event2 = DeleteBeneficiary('456');
        expect(event1, isNot(equals(event2)));
      });
    });

    group('ToggleBeneficiaryStatus', () {
      test('props should contain beneficiaryId and activate', () {
        const event = ToggleBeneficiaryStatus(
          beneficiaryId: '123',
          activate: true,
        );
        expect(event.props, equals(['123', true]));
      });

      test('two instances with same values should be equal', () {
        const event1 = ToggleBeneficiaryStatus(
          beneficiaryId: '123',
          activate: true,
        );
        const event2 = ToggleBeneficiaryStatus(
          beneficiaryId: '123',
          activate: true,
        );
        expect(event1, equals(event2));
      });

      test('two instances with different values should not be equal', () {
        const event1 = ToggleBeneficiaryStatus(
          beneficiaryId: '123',
          activate: true,
        );
        const event2 = ToggleBeneficiaryStatus(
          beneficiaryId: '123',
          activate: false,
        );
        expect(event1, isNot(equals(event2)));
      });
    });

    group('UpdateBeneficiaryMonthlyAmount', () {
      test('props should contain beneficiaryId and amount', () {
        const event = UpdateBeneficiaryMonthlyAmount(
          beneficiaryId: '123',
          amount: 100.0,
        );
        expect(event.props, equals(['123', 100.0]));
      });

      test('two instances with same values should be equal', () {
        const event1 = UpdateBeneficiaryMonthlyAmount(
          beneficiaryId: '123',
          amount: 100.0,
        );
        const event2 = UpdateBeneficiaryMonthlyAmount(
          beneficiaryId: '123',
          amount: 100.0,
        );
        expect(event1, equals(event2));
      });

      test('two instances with different values should not be equal', () {
        const event1 = UpdateBeneficiaryMonthlyAmount(
          beneficiaryId: '123',
          amount: 100.0,
        );
        const event2 = UpdateBeneficiaryMonthlyAmount(
          beneficiaryId: '123',
          amount: 200.0,
        );
        expect(event1, isNot(equals(event2)));
      });
    });

    group('RefreshBeneficiaries', () {
      test('props should contain silent flag', () {
        const event = RefreshBeneficiaries(silent: true);
        expect(event.props, equals([true]));
      });

      test('default silent should be false', () {
        const event = RefreshBeneficiaries();
        expect(event.props, equals([false]));
      });

      test('two instances with same values should be equal', () {
        const event1 = RefreshBeneficiaries(silent: true);
        const event2 = RefreshBeneficiaries(silent: true);
        expect(event1, equals(event2));
      });

      test('two instances with different values should not be equal', () {
        const event1 = RefreshBeneficiaries(silent: true);
        const event2 = RefreshBeneficiaries(silent: false);
        expect(event1, isNot(equals(event2)));
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
