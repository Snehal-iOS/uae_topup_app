import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uae_topup_app/core/errors/custom_exception.dart';
import 'package:uae_topup_app/features/user/domain/entities/user.dart';
import 'package:uae_topup_app/features/user/domain/usecases/get_user_usecase.dart';
import 'package:uae_topup_app/features/user/domain/usecases/update_user_usecase.dart';
import 'package:uae_topup_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:uae_topup_app/features/user/presentation/bloc/user_event.dart';
import 'package:uae_topup_app/features/user/presentation/bloc/user_state.dart';

@GenerateMocks([GetUserUseCase, UpdateUserUseCase])
import 'user_bloc_test.mocks.dart';

void main() {
  late UserBloc bloc;
  late MockGetUserUseCase mockGetUserUseCase;
  late MockUpdateUserUseCase mockUpdateUserUseCase;

  final tUser = User(
    id: '1',
    name: 'Test User',
    balance: 1000.0,
    isVerified: true,
    monthlyTopupTotal: 0.0,
    monthlyResetDate: DateTime(2025, 2, 1),
  );

  setUp(() {
    mockGetUserUseCase = MockGetUserUseCase();
    mockUpdateUserUseCase = MockUpdateUserUseCase();
    bloc = UserBloc(getUserUseCase: mockGetUserUseCase, updateUserUseCase: mockUpdateUserUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('UserBloc', () {
    test('initial state should be UserState.initial', () {
      expect(bloc.state, equals(const UserState()));
    });

    blocTest<UserBloc, UserState>(
      'should emit loading then success when LoadUser succeeds',
      build: () {
        when(mockGetUserUseCase()).thenAnswer((_) async => tUser);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadUser()),
      expect: () => [const UserState(status: UserStatus.loading), UserState(status: UserStatus.success, user: tUser)],
    );

    blocTest<UserBloc, UserState>(
      'should emit loading then error when LoadUser fails',
      build: () {
        when(mockGetUserUseCase()).thenThrow(const NetworkException('Network error'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadUser()),
      expect: () => [
        const UserState(status: UserStatus.loading),
        const UserState(status: UserStatus.error, errorMessage: 'Failed to load data: Network error'),
      ],
    );

    blocTest<UserBloc, UserState>(
      'should update user balance successfully',
      build: () {
        final updatedUser = tUser.copyWith(balance: 900.0);
        when(mockUpdateUserUseCase(any)).thenAnswer((_) async => updatedUser);
        return bloc;
      },
      seed: () => UserState(status: UserStatus.success, user: tUser),
      act: (bloc) => bloc.add(const UpdateUserBalance(newBalance: 900.0, topupAmount: 100.0)),
      expect: () => [
        UserState(status: UserStatus.success, user: tUser.copyWith(balance: 900.0, monthlyTopupTotal: 100.0)),
      ],
    );

    blocTest<UserBloc, UserState>(
      'should not update balance when user is null',
      build: () => bloc,
      seed: () => const UserState(status: UserStatus.initial),
      act: (bloc) => bloc.add(const UpdateUserBalance(newBalance: 900.0, topupAmount: 100.0)),
      expect: () => [],
    );

    blocTest<UserBloc, UserState>(
      'should emit error when UpdateUserBalance fails',
      build: () {
        when(mockUpdateUserUseCase(any)).thenThrow(const ValidationException('Invalid balance'));
        return bloc;
      },
      seed: () => UserState(status: UserStatus.success, user: tUser),
      act: (bloc) => bloc.add(const UpdateUserBalance(newBalance: 900.0, topupAmount: 100.0)),
      expect: () => [UserState(status: UserStatus.error, user: tUser, errorMessage: 'Invalid balance')],
    );

    blocTest<UserBloc, UserState>(
      'should refresh user successfully',
      build: () {
        final refreshedUser = tUser.copyWith(balance: 1200.0);
        when(mockGetUserUseCase()).thenAnswer((_) async => refreshedUser);
        return bloc;
      },
      seed: () => UserState(status: UserStatus.success, user: tUser),
      act: (bloc) => bloc.add(const RefreshUser()),
      expect: () => [
        UserState(status: UserStatus.success, user: tUser.copyWith(balance: 1200.0), successMessage: 'Data refreshed'),
      ],
    );

    blocTest<UserBloc, UserState>(
      'should emit error when RefreshUser fails',
      build: () {
        when(mockGetUserUseCase()).thenThrow(Exception('Failed to refresh'));
        return bloc;
      },
      act: (bloc) => bloc.add(const RefreshUser()),
      expect: () => [const UserState(status: UserStatus.error, errorMessage: 'Failed to refresh: Failed to refresh')],
    );

    blocTest<UserBloc, UserState>(
      'should handle CustomException in RefreshUser',
      build: () {
        when(mockGetUserUseCase()).thenThrow(const ValidationException('Validation error'));
        return bloc;
      },
      act: (bloc) => bloc.add(const RefreshUser()),
      expect: () => [const UserState(status: UserStatus.error, errorMessage: 'Failed to refresh: Validation error')],
    );
  });
}
