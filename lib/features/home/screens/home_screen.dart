import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/color_palette.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../topup/presentation/widgets/empty_state_card.dart';
import '../../../core/widgets/common_app_bar.dart';
import 'add_beneficiary_button.dart';
import '../../beneficiary/presentation/bloc/beneficiary_bloc.dart';
import '../../beneficiary/presentation/bloc/beneficiary_event.dart' as beneficiary_events;
import '../../beneficiary/presentation/bloc/beneficiary_event.dart';
import '../../beneficiary/presentation/bloc/beneficiary_state.dart';
import '../../beneficiary/presentation/screens/add_beneficiary_screen.dart';
import '../../topup/presentation/screens/topup_transaction_screen.dart';
import '../../beneficiary/domain/entities/beneficiary.dart';
import '../../beneficiary/presentation/widgets/beneficiary_card.dart';
import '../../user/domain/entities/user.dart';
import '../../user/presentation/bloc/user_bloc.dart';
import '../../user/presentation/bloc/user_event.dart';
import '../../user/presentation/bloc/user_state.dart';
import '../../user/presentation/widgets/user_info_card.dart';
import '../../topup/presentation/bloc/topup_bloc.dart';
import '../../topup/presentation/bloc/topup_event.dart' as topup_events;
import '../../topup/presentation/bloc/topup_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onNavigateToManageBeneficiaries});
  final VoidCallback? onNavigateToManageBeneficiaries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: AppStrings.dashboard),
      body: MultiBlocListener(
        listeners: [
          BlocListener<BeneficiaryBloc, BeneficiaryState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                AppSnackBar.showError(context, state.errorMessage!);
                if (context.mounted) {
                  context.read<BeneficiaryBloc>().add(const beneficiary_events.ClearMessages());
                }
              }
              if (state.successMessage != null) {
                AppSnackBar.showSuccess(context, state.successMessage!);
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (context.mounted) {
                    context.read<BeneficiaryBloc>().add(const beneficiary_events.ClearMessages());
                  }
                });
              }
            },
          ),
          BlocListener<TopupBloc, TopupState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                AppSnackBar.showError(context, state.errorMessage!);
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (context.mounted) {
                    context.read<TopupBloc>().add(const topup_events.ClearMessages());
                  }
                });
              }
              if (state.successMessage != null) {
                AppSnackBar.showSuccess(context, state.successMessage!);
                final userBloc = context.read<UserBloc>();
                final beneficiaryBloc = context.read<BeneficiaryBloc>();
                userBloc.add(const RefreshUser(silent: true));
                beneficiaryBloc.add(const RefreshBeneficiaries(silent: true));
                if (context.mounted) {
                  context.read<TopupBloc>().add(const topup_events.ClearMessages());
                }
              }
            },
          ),
        ],
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            if (userState.status == UserStatus.loading && userState.user == null) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator(), SizedBox(height: 16), Text(AppStrings.loading)],
                ),
              );
            }

            if (userState.status == UserStatus.error && userState.user == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: ColorPalette.error),
                    const SizedBox(height: 16),
                    Text(
                      userState.errorMessage ?? AppStrings.somethingWentWrong,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<UserBloc>().add(const LoadUser());
                      },
                      child: const Text(AppStrings.retry),
                    ),
                  ],
                ),
              );
            }

            return BlocBuilder<BeneficiaryBloc, BeneficiaryState>(
              builder: (context, beneficiaryState) {
                final canAddMore = beneficiaryState.activeBeneficiaries.length < AppConstants.maxActiveBeneficiaries;
                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<UserBloc>().add(const RefreshUser());
                          context.read<BeneficiaryBloc>().add(const beneficiary_events.RefreshBeneficiaries());
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (userState.user != null)
                                UserInfoCard(
                                  key: ValueKey('user_${userState.user!.balance}_${userState.user!.monthlyTopupTotal}'),
                                  user: userState.user!,
                                ),
                              const SizedBox(height: 15),
                              BlocBuilder<BeneficiaryBloc, BeneficiaryState>(
                                builder: (context, beneficiaryState) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                AppStrings.activeBeneficiaries,
                                                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '(${beneficiaryState.activeBeneficiaries.length}/${AppConstants.maxActiveBeneficiaries})',
                                                style: AppTextStyles.labelMedium.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorPalette.greyDark600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (onNavigateToManageBeneficiaries != null)
                                            TextButton(
                                              onPressed: onNavigateToManageBeneficiaries,
                                              style: TextButton.styleFrom(
                                                foregroundColor: Theme.of(context).colorScheme.primary,
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                minimumSize: Size.zero,
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              ),
                                              child: Text(
                                                AppStrings.seeAll,
                                                style: AppTextStyles.labelMedium.copyWith(
                                                  color: Theme.of(context).colorScheme.primary,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      if (beneficiaryState.activeBeneficiaries.isEmpty)
                                        const EmptyStateCard.noBeneficiaries()
                                      else if (userState.user != null)
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: beneficiaryState.activeBeneficiaries.length,
                                          itemBuilder: (context, index) {
                                            final beneficiary = beneficiaryState.activeBeneficiaries[index];
                                            return BeneficiaryCard(
                                              key: ValueKey(beneficiary.id),
                                              beneficiary: beneficiary,
                                              user: userState.user!,
                                              isLoading: beneficiaryState.status == BeneficiaryStatus.loading,
                                              isActive: beneficiary.isActive,
                                              showManagementActions: false,
                                              onTap: (b, u) => _navigateToTopUp(context, b, u),
                                            );
                                          },
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Add Beneficiary button fixed above the bottom nav bar
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        child: AddBeneficiaryButton(
                          onPressed: canAddMore ? () => _navigateToAddBeneficiary(context) : null,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _navigateToAddBeneficiary(BuildContext context) {
    final beneficiaryBloc = context.read<BeneficiaryBloc>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(value: beneficiaryBloc, child: const AddBeneficiaryScreen()),
      ),
    );
  }

  void _navigateToTopUp(BuildContext context, Beneficiary beneficiary, User user) {
    final topupBloc = context.read<TopupBloc>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: topupBloc,
          child: TopUpTransactionScreen(beneficiary: beneficiary, user: user),
        ),
      ),
    );
  }
}
