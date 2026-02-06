import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uae_topup_app/core/constants/app_strings.dart';
import 'package:uae_topup_app/features/beneficiary/domain/entities/beneficiary.dart';
import 'package:uae_topup_app/features/beneficiary/presentation/bloc/beneficiary_bloc.dart';
import 'package:uae_topup_app/features/beneficiary/presentation/bloc/beneficiary_state.dart';
import 'package:uae_topup_app/features/beneficiary/presentation/widgets/beneficiary_card.dart';
import 'package:uae_topup_app/features/topup/presentation/bloc/topup_bloc.dart';
import 'package:uae_topup_app/features/topup/presentation/bloc/topup_state.dart';
import 'package:uae_topup_app/features/user/domain/entities/user.dart';
import 'package:uae_topup_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:uae_topup_app/features/user/presentation/bloc/user_state.dart';

@GenerateMocks([BeneficiaryBloc, UserBloc, TopupBloc])
import 'beneficiary_card_test.mocks.dart';

void main() {
  late MockBeneficiaryBloc mockBeneficiaryBloc;
  late MockUserBloc mockUserBloc;
  late MockTopupBloc mockTopupBloc;

  setUp(() {
    mockBeneficiaryBloc = MockBeneficiaryBloc();
    mockUserBloc = MockUserBloc();
    mockTopupBloc = MockTopupBloc();
  });

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
    nickname: 'Test Beneficiary',
    monthlyTopupAmount: 100.0,
    isActive: true,
    monthlyResetDate: DateTime(2026, 3, 1),
  );

  Widget createWidgetUnderTest({required Beneficiary beneficiary, required User user, bool isLoading = false}) {
    // Set up default bloc behavior
    when(mockBeneficiaryBloc.stream).thenAnswer(
      (_) => Stream.value(BeneficiaryState(status: BeneficiaryStatus.success, beneficiaries: [beneficiary])),
    );
    when(
      mockBeneficiaryBloc.state,
    ).thenReturn(BeneficiaryState(status: BeneficiaryStatus.success, beneficiaries: [beneficiary]));

    when(mockUserBloc.stream).thenAnswer((_) => Stream.value(UserState(status: UserStatus.success, user: user)));
    when(mockUserBloc.state).thenReturn(UserState(status: UserStatus.success, user: user));

    when(mockTopupBloc.stream).thenAnswer((_) => Stream.value(const TopupState()));
    when(mockTopupBloc.state).thenReturn(const TopupState());

    return MaterialApp(
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<BeneficiaryBloc>.value(value: mockBeneficiaryBloc),
            BlocProvider<UserBloc>.value(value: mockUserBloc),
            BlocProvider<TopupBloc>.value(value: mockTopupBloc),
          ],
          child: BeneficiaryCard(
            beneficiary: beneficiary,
            user: user,
            isLoading: isLoading,
            isActive: true,
            showManagementActions: false,
          ),
        ),
      ),
    );
  }

  group('BeneficiaryCard', () {
    testWidgets('displays beneficiary information correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(beneficiary: tBeneficiary, user: tUser));

      // Check nickname is displayed
      expect(find.text('Test Beneficiary'), findsOneWidget);

      // Check phone number is displayed
      expect(find.text('+971501234567'), findsOneWidget);

      // Check limit used label and monthly usage are displayed
      expect(find.text(AppStrings.limitUsed), findsOneWidget);
      expect(find.text('AED 100 / 1000'), findsOneWidget);

      // Check avatar shows first letter of nickname (initials when image fails in test)
      expect(find.text('T'), findsOneWidget);
    });

    testWidgets('displays active status correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(beneficiary: tBeneficiary, user: tUser));

      // Check active badge is displayed
      expect(find.text('Active'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('displays inactive status correctly', (tester) async {
      final inactiveBeneficiary = tBeneficiary.copyWith(isActive: false);

      when(mockBeneficiaryBloc.stream).thenAnswer(
        (_) => Stream.value(BeneficiaryState(status: BeneficiaryStatus.success, beneficiaries: [inactiveBeneficiary])),
      );
      when(
        mockBeneficiaryBloc.state,
      ).thenReturn(BeneficiaryState(status: BeneficiaryStatus.success, beneficiaries: [inactiveBeneficiary]));

      await tester.pumpWidget(createWidgetUnderTest(beneficiary: inactiveBeneficiary, user: tUser));

      // Check inactive badge is displayed
      expect(find.text('Inactive'), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('calculates beneficiary limit correctly for verified user', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(beneficiary: tBeneficiary, user: tUser));

      // Verified user should have 1000 AED limit per beneficiary
      expect(find.text('AED 100 / 1000'), findsOneWidget);
    });

    testWidgets('calculates beneficiary limit correctly for unverified user', (tester) async {
      final unverifiedUser = tUser.copyWith(isVerified: false);

      when(
        mockUserBloc.stream,
      ).thenAnswer((_) => Stream.value(UserState(status: UserStatus.success, user: unverifiedUser)));
      when(mockUserBloc.state).thenReturn(UserState(status: UserStatus.success, user: unverifiedUser));

      await tester.pumpWidget(createWidgetUnderTest(beneficiary: tBeneficiary, user: unverifiedUser));

      // Unverified user should have 500 AED limit per beneficiary
      expect(find.text('AED 100 / 500'), findsOneWidget);
    });
  });
}
