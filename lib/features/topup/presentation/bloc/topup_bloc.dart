import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/error_helper.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../user/domain/entities/user.dart';
import '../../../beneficiary/domain/entities/beneficiary.dart';
import '../../domain/usecases/check_topup_eligibility_usecase.dart';
import '../../domain/usecases/perform_topup_usecase.dart';
import '../../domain/usecases/get_transactions_usecase.dart';
import 'topup_event.dart';
import 'topup_state.dart';

class TopupBloc extends Bloc<TopupEvent, TopupState> {
  final PerformTopupUseCase performTopupUseCase;
  final GetTransactionsUseCase getTransactionsUseCase;
  final CheckTopupEligibilityUseCase checkTopupEligibilityUseCase;

  // service charges AED 3 per transaction
  static double get topupCharge => PerformTopupUseCase.topupCharge;

  TopupBloc({
    required this.performTopupUseCase,
    required this.getTransactionsUseCase,
    required this.checkTopupEligibilityUseCase,
  }) : super(const TopupState()) {
    on<PerformTopup>(_onPerformTopup);
    on<LoadTransactions>(_onLoadTransactions);
    on<ClearMessages>(_onClearMessages);
  }

  Future<void> _onPerformTopup(PerformTopup event, Emitter<TopupState> emit) async {
    emit(state.copyWith(status: TopupStatus.loading));
    AppLogger.info('Performing top-up: ${event.amount} AED to ${event.beneficiary.nickname} (${event.beneficiary.id})');

    try {
      await performTopupUseCase(user: event.user, beneficiary: event.beneficiary, amount: event.amount);

      AppLogger.info('Top-up successful: ${event.amount} AED to ${event.beneficiary.nickname}');

      emit(
        state.copyWith(
          status: TopupStatus.success,
          successMessage: AppStrings.format(AppStrings.topupSuccessful, [
            event.amount.toStringAsFixed(0),
            event.beneficiary.nickname,
          ]),
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to perform top-up', e, stackTrace);
      final errorMessage = ErrorHelper.extractErrorMessage(e);
      emit(
        state.copyWith(
          status: TopupStatus.error,
          errorMessage: AppStrings.format(AppStrings.failedToPerformTopup, [errorMessage]),
        ),
      );
    }
  }

  Future<bool> canPerformTopup({required User user, required Beneficiary beneficiary, required double amount}) async {
    return checkTopupEligibilityUseCase(user: user, beneficiary: beneficiary, amount: amount);
  }

  Future<void> _onLoadTransactions(LoadTransactions event, Emitter<TopupState> emit) async {
    emit(state.copyWith(status: TopupStatus.loading));
    AppLogger.info('Loading transactions');

    try {
      final transactions = await getTransactionsUseCase();
      AppLogger.info('Successfully loaded ${transactions.length} transactions');
      emit(state.copyWith(status: TopupStatus.success, transactions: transactions));
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load transactions', e, stackTrace);
      final errorMessage = ErrorHelper.extractErrorMessage(e);
      emit(
        state.copyWith(
          status: TopupStatus.error,
          errorMessage: AppStrings.format(AppStrings.failedToLoadData, [errorMessage]),
        ),
      );
    }
  }

  void _onClearMessages(ClearMessages event, Emitter<TopupState> emit) {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }
}
