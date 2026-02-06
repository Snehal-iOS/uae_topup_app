import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_palette.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../topup/presentation/widgets/empty_state_card.dart';
import '../../../../core/widgets/common_app_bar.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/bloc/user_state.dart';
import '../bloc/beneficiary_bloc.dart';
import '../bloc/beneficiary_event.dart';
import '../bloc/beneficiary_state.dart';
import '../widgets/beneficiary_card.dart';

class ManageBeneficiariesScreen extends StatelessWidget {
  const ManageBeneficiariesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: AppStrings.manageAllBeneficiaries),
      body: BlocBuilder<BeneficiaryBloc, BeneficiaryState>(
        builder: (context, beneficiaryState) {
          if (beneficiaryState.status == BeneficiaryStatus.loading && beneficiaryState.beneficiaries.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final activeBeneficiaries = beneficiaryState.activeBeneficiaries;
          final inactiveBeneficiaries = beneficiaryState.inactiveBeneficiaries;

          return BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<BeneficiaryBloc>().add(const RefreshBeneficiaries());
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Builder(
                        builder: (context) {
                          final theme = Theme.of(context);
                          final colorScheme = theme.colorScheme;
                          final cardColor = theme.cardTheme.color ?? colorScheme.surface;
                          final dividerColor = colorScheme.outlineVariant;
                          return Card(
                            color: cardColor,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      const Icon(Icons.check_circle, color: ColorPalette.success, size: 24),
                                      const SizedBox(height: 4),
                                      Text(
                                        activeBeneficiaries.length.toString(),
                                        style: AppTextStyles.h3.copyWith(color: ColorPalette.success),
                                      ),
                                      Text(
                                        AppStrings.active,
                                        style: AppTextStyles.caption.copyWith(color: ColorPalette.success),
                                      ),
                                    ],
                                  ),
                                  Container(width: 1, height: 40, color: dividerColor),
                                  Column(
                                    children: [
                                      const Icon(Icons.cancel, color: ColorPalette.grey, size: 24),
                                      const SizedBox(height: 4),
                                      Text(
                                        inactiveBeneficiaries.length.toString(),
                                        style: AppTextStyles.h3.copyWith(color: ColorPalette.grey),
                                      ),
                                      Text(
                                        AppStrings.inactive,
                                        style: AppTextStyles.caption.copyWith(color: ColorPalette.grey),
                                      ),
                                    ],
                                  ),
                                  Container(width: 1, height: 40, color: dividerColor),
                                  Builder(
                                    builder: (context) {
                                      final effectiveColor = colorScheme.brightness == Brightness.dark
                                          ? colorScheme.primary
                                          : ColorPalette.primaryDarkAlt;
                                      return Column(
                                        children: [
                                          Icon(Icons.account_balance_wallet, color: effectiveColor, size: 24),
                                          const SizedBox(height: 4),
                                          Text(
                                            beneficiaryState.totalMonthlyAmount.toStringAsFixed(0),
                                            style: AppTextStyles.h3.copyWith(color: effectiveColor),
                                          ),
                                          Text(
                                            AppStrings.totalAed,
                                            style: AppTextStyles.caption.copyWith(color: effectiveColor),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      // Active Beneficiaries Section
                      Row(
                        children: [
                          Text(
                            AppStrings.activeBeneficiaries,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            AppStrings.format(AppStrings.activeCountFormat, [
                              beneficiaryState.activeBeneficiaries.length,
                              AppConstants.maxActiveBeneficiaries,
                            ]),
                            style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.greyDark600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (activeBeneficiaries.isEmpty)
                        const EmptyStateCard.noActiveBeneficiaries()
                      else if (userState.user != null)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: activeBeneficiaries.length,
                          itemBuilder: (context, index) {
                            final beneficiary = activeBeneficiaries[index];
                            return BeneficiaryCard(
                              key: ValueKey(beneficiary.id),
                              beneficiary: beneficiary,
                              user: userState.user!,
                              isLoading: beneficiaryState.status == BeneficiaryStatus.loading,
                              isActive: true,
                              showManagementActions: true,
                            );
                          },
                        ),

                      const SizedBox(height: 5),
                      // Inactive Beneficiaries Section
                      if (inactiveBeneficiaries.isNotEmpty) ...[
                        Text(
                          AppStrings.inactiveBeneficiaries,
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        userState.user != null
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: inactiveBeneficiaries.length,
                                itemBuilder: (context, index) {
                                  final beneficiary = inactiveBeneficiaries[index];
                                  return BeneficiaryCard(
                                    key: ValueKey(beneficiary.id),
                                    beneficiary: beneficiary,
                                    user: userState.user!,
                                    isLoading: beneficiaryState.status == BeneficiaryStatus.loading,
                                    isActive: false,
                                    showManagementActions: true,
                                  );
                                },
                              )
                            : const SizedBox.shrink(),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
