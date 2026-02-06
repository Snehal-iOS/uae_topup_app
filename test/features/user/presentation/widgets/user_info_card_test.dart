import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uae_topup_app/core/constants/app_strings.dart';
import 'package:uae_topup_app/features/user/domain/entities/user.dart';
import 'package:uae_topup_app/features/user/presentation/widgets/user_info_card.dart';

void main() {
  group('UserInfoCard Widget Tests', () {
    testWidgets('displays user name and balance correctly',
        (WidgetTester tester) async {
      final user = User(
        id: '1',
        name: 'John Doe',
        balance: 1500.0,
        isVerified: true,
        monthlyTopupTotal: 500.0,
        monthlyResetDate: DateTime(2025, 2, 1),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserInfoCard(user: user),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('1500'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('shows correct verification status for unverified user',
        (WidgetTester tester) async {
      final user = User(
        id: '1',
        name: 'Jane Doe',
        balance: 500.0,
        isVerified: false,
        monthlyTopupTotal: 100.0,
        monthlyResetDate: DateTime(2025, 2, 1),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserInfoCard(user: user),
          ),
        ),
      );

      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('500'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('displays monthly usage correctly',
        (WidgetTester tester) async {
      final user = User(
        id: '1',
        name: 'Test User',
        balance: 1000.0,
        isVerified: true,
        monthlyTopupTotal: 1200.0,
        monthlyResetDate: DateTime(2025, 2, 1),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserInfoCard(user: user),
          ),
        ),
      );

      expect(find.text(AppStrings.monthlyLimitUsed), findsOneWidget);
      expect(find.text(AppStrings.allBeneficiaries), findsOneWidget);
      expect(find.text('1200 / '), findsOneWidget);
      expect(find.text('3000'), findsOneWidget);
      expect(find.text(AppStrings.remainingLabel), findsOneWidget);
      expect(find.text('1800.00'), findsOneWidget);
    });
  });
}
