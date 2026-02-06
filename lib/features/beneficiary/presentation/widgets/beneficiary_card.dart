import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_palette.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/limit_progress_bar.dart';
import '../../../../core/widgets/common_icon_button.dart';
import 'status_badge.dart';
import 'beneficiary_avatar.dart';
import '../../../../core/widgets/common_dialog.dart';
import '../../../user/presentation/bloc/user_state.dart';
import '../../domain/entities/beneficiary.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../bloc/beneficiary_bloc.dart';
import '../bloc/beneficiary_event.dart';
import '../bloc/beneficiary_state.dart';

class BeneficiaryCard extends StatefulWidget {
  final Beneficiary beneficiary;
  final User user;
  final bool isLoading;
  final bool isActive;
  final bool showManagementActions;
  final void Function(Beneficiary beneficiary, User user)? onTap;

  const BeneficiaryCard({
    super.key,
    required this.beneficiary,
    required this.user,
    required this.isLoading,
    required this.isActive,
    this.showManagementActions = false,
    this.onTap,
  });

  @override
  State<BeneficiaryCard> createState() => _BeneficiaryCardState();
}

class _BeneficiaryCardState extends State<BeneficiaryCard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BeneficiaryBloc, BeneficiaryState>(
      builder: (context, beneficiaryState) {
        final updatedBeneficiary = beneficiaryState.beneficiaries
            .firstWhere(
              (beneficiary) => beneficiary.id == widget.beneficiary.id,
              orElse: () => widget.beneficiary,
            );

        return BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            final currentUser = userState.user ?? widget.user;
            final beneficiaryLimit = currentUser.monthlyLimit;
            final isBeneficiaryActive = updatedBeneficiary.isActive;
            
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;
            final cardColor = widget.showManagementActions && !isBeneficiaryActive
                ? colorScheme.surfaceContainerHighest
                : (theme.cardTheme.color ?? colorScheme.surface);

            final onTap = widget.showManagementActions ? null : widget.onTap;

            return Card(
              elevation: 0.0,
              color: cardColor,
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: onTap == null
                    ? null
                    : () => onTap(updatedBeneficiary, currentUser),
                borderRadius: BorderRadius.circular(12),
                child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                BeneficiaryAvatar(
                  beneficiary: updatedBeneficiary,
                  showManagementActions: widget.showManagementActions,
                  isActive: isBeneficiaryActive,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                updatedBeneficiary.nickname,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: widget.showManagementActions && !isBeneficiaryActive
                                      ? colorScheme.onSurfaceVariant
                                      : null,
                                ),
                              ),
                              Text(
                                updatedBeneficiary.phoneNumber,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: widget.showManagementActions && !isBeneficiaryActive
                                      ? colorScheme.onSurfaceVariant
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          widget.showManagementActions
                              ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Switch.adaptive(
                                    value: isBeneficiaryActive,
                                    onChanged: widget.isLoading
                                        ? null
                                        : (bool value) => _showToggleDialog(context, value),
                                    activeTrackColor: ColorPalette.success,
                                  ),
                                  const SizedBox(width: 8),
                                  CommonIconButton.sized(
                                    icon: Icons.cancel,
                                    size: 32,
                                    iconColor: ColorPalette.error,
                                    iconSize: 25,
                                    onPressed: widget.isLoading ? null : () => _showDeleteDialog(context),
                                    tooltip: AppStrings.delete,
                                  ),
                                ],
                              )
                              : Container(
                            margin: const EdgeInsets.only(top: 4),
                                child: Row(
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                const SizedBox(height: 4),
                                StatusBadge(
                                  isActive: updatedBeneficiary.isActive,
                                  wrapText: true,
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.arrow_forward_ios_outlined, color: colorScheme.onSurfaceVariant, size: 12),
                                                            ],
                                                          ),
                              ),
                        ],
                      ),

                      if (!widget.showManagementActions) ...[
                        const SizedBox(height: 6),
                        LimitProgressBar(
                          used: updatedBeneficiary.monthlyTopupAmount,
                          limit: beneficiaryLimit,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
      ),
            );
          },
        );
      },
    );
  }

  void _showToggleDialog(BuildContext context, bool willActivate) {
    final beneficiaryBloc = context.read<BeneficiaryBloc>();
    final currentBeneficiary = beneficiaryBloc.state.beneficiaries
        .firstWhere(
          (b) => b.id == widget.beneficiary.id,
          orElse: () => widget.beneficiary,
        );

    CommonDialogs.showWithBlocProvider(
      context: context,
      bloc: beneficiaryBloc,
      dialog: CommonDialog(
        title: willActivate
            ? AppStrings.activateBeneficiary
            : AppStrings.deactivateBeneficiary,
        content: Text(
          willActivate
              ? AppStrings.format(AppStrings.activateConfirm, [currentBeneficiary.nickname])
              : AppStrings.format(AppStrings.deactivateConfirm, [currentBeneficiary.nickname]),
        ),
        confirmText: willActivate ? AppStrings.activate : AppStrings.deactivate,
        confirmButtonStyle: willActivate 
            ? DialogButtonStyle.success 
            : DialogButtonStyle.warning,
        onConfirm: () {
          Navigator.pop(context);
          beneficiaryBloc.add(
                ToggleBeneficiaryStatus(
                  beneficiaryId: currentBeneficiary.id,
                  activate: willActivate,
                ),
              );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final beneficiaryBloc = context.read<BeneficiaryBloc>();
    final currentBeneficiary = beneficiaryBloc.state.beneficiaries
        .firstWhere(
          (b) => b.id == widget.beneficiary.id,
          orElse: () => widget.beneficiary,
        );
    
    CommonDialogs.showWithBlocProvider(
      context: context,
      bloc: beneficiaryBloc,
      dialog: CommonDialog(
        title: AppStrings.deleteBeneficiary,
        content: Text(
          AppStrings.format(AppStrings.deleteBeneficiaryConfirm, [currentBeneficiary.nickname]),
        ),
        confirmText: AppStrings.delete,
        confirmButtonStyle: DialogButtonStyle.error,
        onConfirm: () {
          Navigator.pop(context);
          beneficiaryBloc.add(
                DeleteBeneficiary(currentBeneficiary.id),
              );
        },
      ),
    );
  }
}

