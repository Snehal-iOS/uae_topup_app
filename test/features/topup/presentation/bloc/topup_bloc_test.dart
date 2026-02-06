import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uae_topup_app/core/errors/custom_exception.dart';
import 'package:uae_topup_app/features/beneficiary/domain/entities/beneficiary.dart';
import 'package:uae_topup_app/features/topup/domain/entities/topup_transaction.dart';
import 'package:uae_topup_app/features/topup/domain/usecases/check_topup_eligibility_usecase.dart';
import 'package:uae_topup_app/features/topup/domain/usecases/get_transactions_usecase.dart';
import 'package:uae_topup_app/features/topup/domain/usecases/perform_topup_usecase.dart';
import 'package:uae_topup_app/features/topup/presentation/bloc/topup_bloc.dart';
import 'package:uae_topup_app/features/topup/presentation/bloc/topup_event.dart';
import 'package:uae_topup_app/features/topup/presentation/bloc/topup_state.dart';
import 'package:uae_topup_app/features/user/domain/entities/user.dart';

@GenerateMocks([PerformTopupUseCase, GetTransactionsUseCase, CheckTopupEligibilityUseCase])
import 'topup_bloc_test.mocks.dart';

void main() {
  late TopupBloc bloc;
  late MockPerformTopupUseCase mockPerformTopupUseCase;
  late MockGetTransactionsUseCase mockGetTransactionsUseCase;
  late MockCheckTopupEligibilityUseCase mockCheckTopupEligibilityUseCase;

  final tUser = User(
    id: '1',
    name: 'Test User',
    balance: 1000.0,
    isVerified: true,
    monthlyTopupTotal: 0.0,
    monthlyResetDate: DateTime(2025, 2, 1),
  );

  final tBeneficiary = Beneficiary(
    id: '1',
    phoneNumber: '+971501234567',
    nickname: 'Test Beneficiary',
    monthlyTopupAmount: 0.0,
    monthlyResetDate: DateTime(2025, 2, 1),
    isActive: true,
  );

  setUp(() {
    mockPerformTopupUseCase = MockPerformTopupUseCase();
    mockGetTransactionsUseCase = MockGetTransactionsUseCase();
    mockCheckTopupEligibilityUseCase = MockCheckTopupEligibilityUseCase();
    bloc = TopupBloc(
      performTopupUseCase: mockPerformTopupUseCase,
      getTransactionsUseCase: mockGetTransactionsUseCase,
      checkTopupEligibilityUseCase: mockCheckTopupEligibilityUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('TopupBloc', () {
    test('initial state should be TopupState.initial', () {
      expect(bloc.state, equals(const TopupState()));
    });

    blocTest<TopupBloc, TopupState>(
      'should emit loading then success when PerformTopup succeeds',
      build: () {
        when(
          mockPerformTopupUseCase(
            user: anyNamed('user'),
            beneficiary: anyNamed('beneficiary'),
            amount: anyNamed('amount'),
          ),
        ).thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) =>
          bloc.add(PerformTopup(beneficiaryId: tBeneficiary.id, amount: 100.0, user: tUser, beneficiary: tBeneficiary)),
      expect: () => [
        const TopupState(status: TopupStatus.loading),
        const TopupState(
          status: TopupStatus.success,
          successMessage: 'Top-up successful! AED 100 sent to Test Beneficiary',
        ),
      ],
    );

    blocTest<TopupBloc, TopupState>(
      'should emit loading then error when PerformTopup fails',
      build: () {
        when(
          mockPerformTopupUseCase(
            user: anyNamed('user'),
            beneficiary: anyNamed('beneficiary'),
            amount: anyNamed('amount'),
          ),
        ).thenThrow(const ValidationException('Invalid amount'));
        return bloc;
      },
      act: (bloc) =>
          bloc.add(PerformTopup(beneficiaryId: tBeneficiary.id, amount: -10.0, user: tUser, beneficiary: tBeneficiary)),
      expect: () => [
        const TopupState(status: TopupStatus.loading),
        const TopupState(status: TopupStatus.error, errorMessage: 'Failed to perform top-up: Invalid amount'),
      ],
    );

    blocTest<TopupBloc, TopupState>(
      'should emit loading then success when LoadTransactions succeeds',
      build: () {
        final timestamp = DateTime(2025, 1, 15);
        final transactions = [
          TopupTransaction(
            id: '1',
            beneficiaryId: '1',
            amount: 100.0,
            charge: 3.0,
            timestamp: timestamp,
            status: 'success',
          ),
        ];
        when(mockGetTransactionsUseCase()).thenAnswer((_) async => transactions);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadTransactions()),
      expect: () => [
        const TopupState(status: TopupStatus.loading),
        TopupState(
          status: TopupStatus.success,
          transactions: [
            TopupTransaction(
              id: '1',
              beneficiaryId: '1',
              amount: 100.0,
              charge: 3.0,
              timestamp: DateTime(2025, 1, 15),
              status: 'success',
            ),
          ],
        ),
      ],
    );

    blocTest<TopupBloc, TopupState>(
      'should emit loading then error when LoadTransactions fails',
      build: () {
        when(mockGetTransactionsUseCase()).thenThrow(Exception('Failed to load'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadTransactions()),
      expect: () => [
        const TopupState(status: TopupStatus.loading),
        const TopupState(status: TopupStatus.error, errorMessage: 'Failed to load data: Failed to load'),
      ],
    );

    blocTest<TopupBloc, TopupState>(
      'should clear messages when ClearMessages is called',
      build: () => bloc,
      seed: () => const TopupState(errorMessage: 'Error', successMessage: 'Success'),
      act: (bloc) => bloc.add(const ClearMessages()),
      expect: () => [const TopupState(errorMessage: null, successMessage: null)],
    );

    group('canPerformTopup', () {
      test('should return true when CheckTopupEligibilityUseCase returns true', () async {
        when(
          mockCheckTopupEligibilityUseCase(
            user: anyNamed('user'),
            beneficiary: anyNamed('beneficiary'),
            amount: anyNamed('amount'),
          ),
        ).thenAnswer((_) async => true);

        final result = await bloc.canPerformTopup(user: tUser, beneficiary: tBeneficiary, amount: 100.0);

        expect(result, isTrue);
      });

      test('should return false when amount is zero', () async {
        when(
          mockCheckTopupEligibilityUseCase(
            user: anyNamed('user'),
            beneficiary: anyNamed('beneficiary'),
            amount: anyNamed('amount'),
          ),
        ).thenAnswer((_) async => false);

        final result = await bloc.canPerformTopup(user: tUser, beneficiary: tBeneficiary, amount: 0.0);

        expect(result, isFalse);
      });

      test('should return false when balance is insufficient', () async {
        when(
          mockCheckTopupEligibilityUseCase(
            user: anyNamed('user'),
            beneficiary: anyNamed('beneficiary'),
            amount: anyNamed('amount'),
          ),
        ).thenAnswer((_) async => false);

        final userWithLowBalance = tUser.copyWith(balance: 50.0);
        final result = await bloc.canPerformTopup(user: userWithLowBalance, beneficiary: tBeneficiary, amount: 100.0);

        expect(result, isFalse);
      });

      test('should return false when beneficiary monthly limit exceeded', () async {
        when(
          mockCheckTopupEligibilityUseCase(
            user: anyNamed('user'),
            beneficiary: anyNamed('beneficiary'),
            amount: anyNamed('amount'),
          ),
        ).thenAnswer((_) async => false);

        final beneficiaryWithHighAmount = tBeneficiary.copyWith(monthlyTopupAmount: 500.0);
        final result = await bloc.canPerformTopup(user: tUser, beneficiary: beneficiaryWithHighAmount, amount: 600.0);

        expect(result, isFalse);
      });

      test('should return false when total monthly limit exceeded', () async {
        when(
          mockCheckTopupEligibilityUseCase(
            user: anyNamed('user'),
            beneficiary: anyNamed('beneficiary'),
            amount: anyNamed('amount'),
          ),
        ).thenAnswer((_) async => false);

        final userWithHighMonthlyTotal = tUser.copyWith(monthlyTopupTotal: 2950.0);
        final result = await bloc.canPerformTopup(
          user: userWithHighMonthlyTotal,
          beneficiary: tBeneficiary,
          amount: 100.0,
        );

        expect(result, isFalse);
      });

      test('should delegate to CheckTopupEligibilityUseCase with user', () async {
        when(
          mockCheckTopupEligibilityUseCase(
            user: anyNamed('user'),
            beneficiary: anyNamed('beneficiary'),
            amount: anyNamed('amount'),
          ),
        ).thenAnswer((_) async => true);

        final updatedUser = tUser.copyWith(balance: 500.0);
        final result = await bloc.canPerformTopup(user: updatedUser, beneficiary: tBeneficiary, amount: 100.0);

        expect(result, isTrue);
        verify(mockCheckTopupEligibilityUseCase(user: updatedUser, beneficiary: tBeneficiary, amount: 100.0)).called(1);
      });

      test('should delegate to CheckTopupEligibilityUseCase with beneficiary', () async {
        when(
          mockCheckTopupEligibilityUseCase(
            user: anyNamed('user'),
            beneficiary: anyNamed('beneficiary'),
            amount: anyNamed('amount'),
          ),
        ).thenAnswer((_) async => true);

        final updatedBeneficiary = tBeneficiary.copyWith(monthlyTopupAmount: 400.0);
        final result = await bloc.canPerformTopup(user: tUser, beneficiary: updatedBeneficiary, amount: 100.0);

        expect(result, isTrue);
        verify(mockCheckTopupEligibilityUseCase(user: tUser, beneficiary: updatedBeneficiary, amount: 100.0)).called(1);
      });
    });
  });
}
