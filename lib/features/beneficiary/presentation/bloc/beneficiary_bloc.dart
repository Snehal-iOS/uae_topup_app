import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/error_helper.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/add_beneficiary_usecase.dart';
import '../../domain/usecases/delete_beneficiary_usecase.dart';
import '../../domain/usecases/get_beneficiaries_usecase.dart';
import '../../domain/usecases/toggle_beneficiary_status_usecase.dart';
import '../../domain/usecases/update_beneficiary_monthly_amount_usecase.dart';
import 'beneficiary_event.dart';
import 'beneficiary_state.dart';

class BeneficiaryBloc extends Bloc<BeneficiaryEvent, BeneficiaryState> {
  final GetBeneficiariesUseCase getBeneficiariesUseCase;
  final AddBeneficiaryUseCase addBeneficiaryUseCase;
  final DeleteBeneficiaryUseCase deleteBeneficiaryUseCase;
  final ToggleBeneficiaryStatusUseCase toggleBeneficiaryStatusUseCase;
  final UpdateBeneficiaryMonthlyAmountUseCase updateBeneficiaryMonthlyAmountUseCase;

  BeneficiaryBloc({
    required this.getBeneficiariesUseCase,
    required this.addBeneficiaryUseCase,
    required this.deleteBeneficiaryUseCase,
    required this.toggleBeneficiaryStatusUseCase,
    required this.updateBeneficiaryMonthlyAmountUseCase,
  }) : super(const BeneficiaryState()) {
    on<LoadBeneficiaries>(_onLoadBeneficiaries);
    on<AddBeneficiary>(_onAddBeneficiary);
    on<DeleteBeneficiary>(_onDeleteBeneficiary);
    on<ToggleBeneficiaryStatus>(_onToggleBeneficiaryStatus);
    on<UpdateBeneficiaryMonthlyAmount>(_onUpdateBeneficiaryMonthlyAmount);
    on<RefreshBeneficiaries>(_onRefreshBeneficiaries);
    on<ClearMessages>(_onClearMessages);
  }

  Future<void> _onLoadBeneficiaries(LoadBeneficiaries event, Emitter<BeneficiaryState> emit) async {
    emit(state.copyWith(status: BeneficiaryStatus.loading));
    AppLogger.info('Loading beneficiaries');

    try {
      final beneficiaries = await getBeneficiariesUseCase();
      AppLogger.info('Successfully loaded ${beneficiaries.length} beneficiaries');
      emit(state.copyWith(status: BeneficiaryStatus.success, beneficiaries: beneficiaries));
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load beneficiaries', e, stackTrace);
      final errorMessage = ErrorHelper.extractErrorMessage(e);
      emit(
        state.copyWith(
          status: BeneficiaryStatus.error,
          errorMessage: AppStrings.format(AppStrings.failedToLoadData, [errorMessage]),
        ),
      );
    }
  }

  Future<void> _onAddBeneficiary(AddBeneficiary event, Emitter<BeneficiaryState> emit) async {
    emit(state.copyWith(status: BeneficiaryStatus.loading));
    AppLogger.info('Adding beneficiary: ${event.nickname} (${event.phoneNumber})');

    try {
      final newBeneficiary = await addBeneficiaryUseCase(phoneNumber: event.phoneNumber, nickname: event.nickname);

      final beneficiaries = await getBeneficiariesUseCase();

      final message = newBeneficiary.isActive
          ? AppStrings.beneficiaryAddedSuccessfully
          : AppStrings.beneficiaryAddedInactive;

      AppLogger.info('Beneficiary added successfully: ${newBeneficiary.id} (Active: ${newBeneficiary.isActive})');

      emit(state.copyWith(status: BeneficiaryStatus.success, beneficiaries: beneficiaries, successMessage: message));
    } catch (e, stackTrace) {
      AppLogger.error('Failed to add beneficiary', e, stackTrace);
      final errorMessage = ErrorHelper.extractErrorMessage(e);
      emit(state.copyWith(status: BeneficiaryStatus.error, errorMessage: errorMessage));
    }
  }

  Future<void> _onDeleteBeneficiary(DeleteBeneficiary event, Emitter<BeneficiaryState> emit) async {
    emit(state.copyWith(status: BeneficiaryStatus.loading));
    AppLogger.info('Deleting beneficiary: ${event.beneficiaryId}');

    try {
      await deleteBeneficiaryUseCase(event.beneficiaryId);
      final beneficiaries = await getBeneficiariesUseCase();

      AppLogger.info('Beneficiary deleted successfully: ${event.beneficiaryId}');
      emit(
        state.copyWith(
          status: BeneficiaryStatus.success,
          beneficiaries: beneficiaries,
          successMessage: AppStrings.beneficiaryRemoved,
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to delete beneficiary', e, stackTrace);
      final errorMessage = ErrorHelper.extractErrorMessage(e);
      emit(
        state.copyWith(
          status: BeneficiaryStatus.error,
          errorMessage: AppStrings.format(AppStrings.failedToRemoveBeneficiary, [errorMessage]),
        ),
      );
    }
  }

  Future<void> _onToggleBeneficiaryStatus(ToggleBeneficiaryStatus event, Emitter<BeneficiaryState> emit) async {
    emit(state.copyWith(status: BeneficiaryStatus.loading));
    AppLogger.info('Toggling beneficiary status: ${event.beneficiaryId} (activate: ${event.activate})');

    try {
      await toggleBeneficiaryStatusUseCase(beneficiaryId: event.beneficiaryId, activate: event.activate);

      final beneficiaries = await getBeneficiariesUseCase();

      final beneficiary = beneficiaries.firstWhere((b) => b.id == event.beneficiaryId);

      AppLogger.info('Beneficiary status toggled: ${event.beneficiaryId} (now active: ${beneficiary.isActive})');

      emit(
        state.copyWith(
          status: BeneficiaryStatus.success,
          beneficiaries: beneficiaries,
          successMessage: beneficiary.isActive ? AppStrings.beneficiaryActivated : AppStrings.beneficiaryDeactivated,
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to toggle beneficiary status', e, stackTrace);
      final errorMessage = ErrorHelper.extractErrorMessage(e);
      emit(state.copyWith(status: BeneficiaryStatus.error, errorMessage: errorMessage));
    }
  }

  Future<void> _onUpdateBeneficiaryMonthlyAmount(
    UpdateBeneficiaryMonthlyAmount event,
    Emitter<BeneficiaryState> emit,
  ) async {
    AppLogger.debug('Updating beneficiary monthly amount: ${event.beneficiaryId} (+${event.amount})');

    try {
      await updateBeneficiaryMonthlyAmountUseCase(beneficiaryId: event.beneficiaryId, amount: event.amount);

      final beneficiaries = await getBeneficiariesUseCase();

      emit(state.copyWith(status: BeneficiaryStatus.success, beneficiaries: beneficiaries));
    } catch (e, stackTrace) {
      AppLogger.error('Failed to update beneficiary monthly amount', e, stackTrace);
      final errorMessage = ErrorHelper.extractErrorMessage(e);
      emit(state.copyWith(status: BeneficiaryStatus.error, errorMessage: errorMessage));
    }
  }

  Future<void> _onRefreshBeneficiaries(RefreshBeneficiaries event, Emitter<BeneficiaryState> emit) async {
    AppLogger.debug('Refreshing beneficiaries (silent: ${event.silent})');

    try {
      final beneficiaries = await getBeneficiariesUseCase();
      AppLogger.info('Beneficiaries refreshed: ${beneficiaries.length} items');
      emit(
        state.copyWith(
          status: BeneficiaryStatus.success,
          beneficiaries: beneficiaries,
          successMessage: event.silent ? null : AppStrings.dataRefreshed,
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to refresh beneficiaries', e, stackTrace);
      final errorMessage = ErrorHelper.extractErrorMessage(e);
      emit(
        state.copyWith(
          status: BeneficiaryStatus.error,
          errorMessage: AppStrings.format(AppStrings.failedToRefresh, [errorMessage]),
        ),
      );
    }
  }

  void _onClearMessages(ClearMessages event, Emitter<BeneficiaryState> emit) {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }
}
