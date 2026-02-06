import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uae_topup_app/core/errors/custom_exception.dart';
import 'package:uae_topup_app/features/beneficiary/domain/entities/beneficiary.dart';
import 'package:uae_topup_app/features/beneficiary/domain/usecases/add_beneficiary_usecase.dart';
import 'package:uae_topup_app/features/beneficiary/domain/usecases/delete_beneficiary_usecase.dart';
import 'package:uae_topup_app/features/beneficiary/domain/usecases/get_beneficiaries_usecase.dart';
import 'package:uae_topup_app/features/beneficiary/domain/usecases/toggle_beneficiary_status_usecase.dart';
import 'package:uae_topup_app/features/beneficiary/domain/usecases/update_beneficiary_monthly_amount_usecase.dart';
import 'package:uae_topup_app/features/beneficiary/presentation/bloc/beneficiary_bloc.dart';
import 'package:uae_topup_app/features/beneficiary/presentation/bloc/beneficiary_event.dart';
import 'package:uae_topup_app/features/beneficiary/presentation/bloc/beneficiary_state.dart';

@GenerateMocks([
  GetBeneficiariesUseCase,
  AddBeneficiaryUseCase,
  DeleteBeneficiaryUseCase,
  ToggleBeneficiaryStatusUseCase,
  UpdateBeneficiaryMonthlyAmountUseCase,
])
import 'beneficiary_bloc_test.mocks.dart';

void main() {
  late BeneficiaryBloc bloc;
  late MockGetBeneficiariesUseCase mockGetBeneficiariesUseCase;
  late MockAddBeneficiaryUseCase mockAddBeneficiaryUseCase;
  late MockDeleteBeneficiaryUseCase mockDeleteBeneficiaryUseCase;
  late MockToggleBeneficiaryStatusUseCase mockToggleBeneficiaryStatusUseCase;
  late MockUpdateBeneficiaryMonthlyAmountUseCase mockUpdateBeneficiaryMonthlyAmountUseCase;

  final tBeneficiaries = [
    Beneficiary(
      id: '1',
      phoneNumber: '+971501234567',
      nickname: 'Test Beneficiary 1',
      monthlyTopupAmount: 100.0,
      monthlyResetDate: DateTime(2025, 2, 1),
      isActive: true,
    ),
    Beneficiary(
      id: '2',
      phoneNumber: '+971501234568',
      nickname: 'Test Beneficiary 2',
      monthlyTopupAmount: 200.0,
      monthlyResetDate: DateTime(2025, 2, 1),
      isActive: false,
    ),
  ];

  setUp(() {
    mockGetBeneficiariesUseCase = MockGetBeneficiariesUseCase();
    mockAddBeneficiaryUseCase = MockAddBeneficiaryUseCase();
    mockDeleteBeneficiaryUseCase = MockDeleteBeneficiaryUseCase();
    mockToggleBeneficiaryStatusUseCase = MockToggleBeneficiaryStatusUseCase();
    mockUpdateBeneficiaryMonthlyAmountUseCase = MockUpdateBeneficiaryMonthlyAmountUseCase();
    bloc = BeneficiaryBloc(
      getBeneficiariesUseCase: mockGetBeneficiariesUseCase,
      addBeneficiaryUseCase: mockAddBeneficiaryUseCase,
      deleteBeneficiaryUseCase: mockDeleteBeneficiaryUseCase,
      toggleBeneficiaryStatusUseCase: mockToggleBeneficiaryStatusUseCase,
      updateBeneficiaryMonthlyAmountUseCase: mockUpdateBeneficiaryMonthlyAmountUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('BeneficiaryBloc', () {
    test('initial state should be BeneficiaryState.initial', () {
      expect(bloc.state, equals(const BeneficiaryState()));
    });

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'should emit loading then success when LoadBeneficiaries succeeds',
      build: () {
        when(mockGetBeneficiariesUseCase()).thenAnswer((_) async => tBeneficiaries);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadBeneficiaries()),
      expect: () => [
        const BeneficiaryState(status: BeneficiaryStatus.loading),
        BeneficiaryState(status: BeneficiaryStatus.success, beneficiaries: tBeneficiaries),
      ],
    );

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'should emit loading then error when LoadBeneficiaries fails',
      build: () {
        when(mockGetBeneficiariesUseCase()).thenThrow(const NetworkException('Network error'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadBeneficiaries()),
      expect: () => [
        const BeneficiaryState(status: BeneficiaryStatus.loading),
        const BeneficiaryState(status: BeneficiaryStatus.error, errorMessage: 'Failed to load data: Network error'),
      ],
    );

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'should add beneficiary successfully as active',
      build: () {
        final newBeneficiary = Beneficiary(
          id: '3',
          phoneNumber: '+971501234569',
          nickname: 'New Beneficiary',
          monthlyResetDate: DateTime(2025, 2, 1),
          isActive: true,
        );
        when(
          mockAddBeneficiaryUseCase(phoneNumber: anyNamed('phoneNumber'), nickname: anyNamed('nickname')),
        ).thenAnswer((_) async => newBeneficiary);
        when(mockGetBeneficiariesUseCase()).thenAnswer((_) async => [...tBeneficiaries, newBeneficiary]);
        return bloc;
      },
      act: (bloc) => bloc.add(const AddBeneficiary(phoneNumber: '+971501234569', nickname: 'New Beneficiary')),
      expect: () => [
        const BeneficiaryState(status: BeneficiaryStatus.loading),
        BeneficiaryState(
          status: BeneficiaryStatus.success,
          beneficiaries: [
            ...tBeneficiaries,
            Beneficiary(
              id: '3',
              phoneNumber: '+971501234569',
              nickname: 'New Beneficiary',
              monthlyResetDate: DateTime(2025, 2, 1),
              isActive: true,
            ),
          ],
          successMessage: 'Beneficiary added successfully',
        ),
      ],
    );

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'should add beneficiary as inactive when 5 active exist',
      build: () {
        final newBeneficiary = Beneficiary(
          id: '3',
          phoneNumber: '+971501234569',
          nickname: 'New Beneficiary',
          monthlyResetDate: DateTime(2025, 2, 1),
          isActive: false,
        );
        when(
          mockAddBeneficiaryUseCase(phoneNumber: anyNamed('phoneNumber'), nickname: anyNamed('nickname')),
        ).thenAnswer((_) async => newBeneficiary);
        when(mockGetBeneficiariesUseCase()).thenAnswer((_) async => [...tBeneficiaries, newBeneficiary]);
        return bloc;
      },
      act: (bloc) => bloc.add(const AddBeneficiary(phoneNumber: '+971501234569', nickname: 'New Beneficiary')),
      expect: () => [
        const BeneficiaryState(status: BeneficiaryStatus.loading),
        BeneficiaryState(
          status: BeneficiaryStatus.success,
          beneficiaries: [
            ...tBeneficiaries,
            Beneficiary(
              id: '3',
              phoneNumber: '+971501234569',
              nickname: 'New Beneficiary',
              monthlyResetDate: DateTime(2025, 2, 1),
              isActive: false,
            ),
          ],
          successMessage:
              'Beneficiary added as inactive (5 active limit reached). Activate it from Manage Beneficiaries.',
        ),
      ],
    );

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'should emit error when AddBeneficiary fails',
      build: () {
        when(
          mockAddBeneficiaryUseCase(phoneNumber: anyNamed('phoneNumber'), nickname: anyNamed('nickname')),
        ).thenThrow(const ValidationException('Invalid phone number'));
        return bloc;
      },
      act: (bloc) => bloc.add(const AddBeneficiary(phoneNumber: 'invalid', nickname: 'Test')),
      expect: () => [
        const BeneficiaryState(status: BeneficiaryStatus.loading),
        const BeneficiaryState(status: BeneficiaryStatus.error, errorMessage: 'Invalid phone number'),
      ],
    );

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'should delete beneficiary successfully',
      build: () {
        when(mockDeleteBeneficiaryUseCase(any)).thenAnswer((_) async {});
        when(mockGetBeneficiariesUseCase()).thenAnswer((_) async => [tBeneficiaries[0]]);
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteBeneficiary('2')),
      expect: () => [
        const BeneficiaryState(status: BeneficiaryStatus.loading),
        BeneficiaryState(
          status: BeneficiaryStatus.success,
          beneficiaries: [tBeneficiaries[0]],
          successMessage: 'Beneficiary removed',
        ),
      ],
    );

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'should toggle beneficiary status successfully',
      build: () {
        final toggledBeneficiary = tBeneficiaries[1].copyWith(isActive: true);
        when(
          mockToggleBeneficiaryStatusUseCase(beneficiaryId: anyNamed('beneficiaryId'), activate: anyNamed('activate')),
        ).thenAnswer((_) async => toggledBeneficiary);
        when(mockGetBeneficiariesUseCase()).thenAnswer((_) async => [tBeneficiaries[0], toggledBeneficiary]);
        return bloc;
      },
      act: (bloc) => bloc.add(const ToggleBeneficiaryStatus(beneficiaryId: '2', activate: true)),
      expect: () => [
        const BeneficiaryState(status: BeneficiaryStatus.loading),
        BeneficiaryState(
          status: BeneficiaryStatus.success,
          beneficiaries: [tBeneficiaries[0], tBeneficiaries[1].copyWith(isActive: true)],
          successMessage: 'Beneficiary activated successfully',
        ),
      ],
    );

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'should update beneficiary monthly amount successfully',
      build: () {
        final updatedBeneficiaries = [tBeneficiaries[0].copyWith(monthlyTopupAmount: 150.0), tBeneficiaries[1]];
        when(
          mockUpdateBeneficiaryMonthlyAmountUseCase(
            beneficiaryId: anyNamed('beneficiaryId'),
            amount: anyNamed('amount'),
          ),
        ).thenAnswer((_) async {});
        when(mockGetBeneficiariesUseCase()).thenAnswer((_) async => updatedBeneficiaries);
        return bloc;
      },
      act: (bloc) => bloc.add(const UpdateBeneficiaryMonthlyAmount(beneficiaryId: '1', amount: 50.0)),
      expect: () => [
        BeneficiaryState(
          status: BeneficiaryStatus.success,
          beneficiaries: [tBeneficiaries[0].copyWith(monthlyTopupAmount: 150.0), tBeneficiaries[1]],
        ),
      ],
    );

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'should refresh beneficiaries successfully with silent flag',
      build: () {
        when(mockGetBeneficiariesUseCase()).thenAnswer((_) async => tBeneficiaries);
        return bloc;
      },
      act: (bloc) => bloc.add(const RefreshBeneficiaries(silent: true)),
      expect: () => [
        BeneficiaryState(
          status: BeneficiaryStatus.success,
          beneficiaries: tBeneficiaries,
          successMessage: null, // Silent refresh
        ),
      ],
    );

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'should refresh beneficiaries successfully without silent flag',
      build: () {
        when(mockGetBeneficiariesUseCase()).thenAnswer((_) async => tBeneficiaries);
        return bloc;
      },
      act: (bloc) => bloc.add(const RefreshBeneficiaries(silent: false)),
      expect: () => [
        BeneficiaryState(
          status: BeneficiaryStatus.success,
          beneficiaries: tBeneficiaries,
          successMessage: 'Data refreshed',
        ),
      ],
    );

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'should clear messages when ClearMessages is called',
      build: () => bloc,
      seed: () => const BeneficiaryState(errorMessage: 'Error', successMessage: 'Success'),
      act: (bloc) => bloc.add(const ClearMessages()),
      expect: () => [const BeneficiaryState(errorMessage: null, successMessage: null)],
    );
  });
}
