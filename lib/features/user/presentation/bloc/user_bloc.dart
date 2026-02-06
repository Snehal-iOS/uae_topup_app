import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/error_helper.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserUseCase getUserUseCase;
  final UpdateUserUseCase updateUserUseCase;

  UserBloc({required this.getUserUseCase, required this.updateUserUseCase}) : super(const UserState()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUserBalance>(_onUpdateUserBalance);
    on<RefreshUser>(_onRefreshUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading));
    AppLogger.info('Loading user data');

    try {
      final user = await getUserUseCase();
      AppLogger.info('User data loaded successfully: ${user.name}');
      emit(state.copyWith(status: UserStatus.success, user: user));
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load user data', e, stackTrace);
      final errorMessage = ErrorHelper.extractErrorMessage(e);
      emit(
        state.copyWith(
          status: UserStatus.error,
          errorMessage: AppStrings.format(AppStrings.failedToLoadData, [errorMessage]),
        ),
      );
    }
  }

  Future<void> _onUpdateUserBalance(UpdateUserBalance event, Emitter<UserState> emit) async {
    if (state.user == null) {
      AppLogger.warning('Cannot update balance: user is null');
      return;
    }

    AppLogger.debug('Updating user balance: ${event.newBalance} (top-up: ${event.topupAmount})');

    try {
      final updatedUser = state.user!.copyWith(
        balance: event.newBalance,
        monthlyTopupTotal: state.user!.monthlyTopupTotal + event.topupAmount,
      );

      await updateUserUseCase(updatedUser);

      AppLogger.info('User balance updated successfully');
      emit(state.copyWith(status: UserStatus.success, user: updatedUser));
    } catch (e, stackTrace) {
      AppLogger.error('Failed to update user balance', e, stackTrace);
      final errorMessage = ErrorHelper.extractErrorMessage(e);
      emit(state.copyWith(status: UserStatus.error, errorMessage: errorMessage));
    }
  }

  Future<void> _onRefreshUser(RefreshUser event, Emitter<UserState> emit) async {
    AppLogger.debug('Refreshing user data (silent: ${event.silent})');

    try {
      final user = await getUserUseCase();
      AppLogger.info('User data refreshed successfully');
      emit(
        state.copyWith(
          status: UserStatus.success,
          user: user,
          successMessage: event.silent ? null : AppStrings.dataRefreshed,
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to refresh user data', e, stackTrace);
      final errorMessage = ErrorHelper.extractErrorMessage(e);
      emit(
        state.copyWith(
          status: UserStatus.error,
          errorMessage: AppStrings.format(AppStrings.failedToRefresh, [errorMessage]),
        ),
      );
    }
  }
}
