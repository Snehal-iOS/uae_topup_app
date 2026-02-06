import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_palette.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../widgets/label_value_row.dart';
import '../../../beneficiary/domain/entities/beneficiary.dart';

class TopUpSuccessContent extends StatelessWidget {
  final Beneficiary beneficiary;
  final double amountToppedUp;
  final double serviceFeePaid;
  final double totalPaid;
  final double remainingLimitForBeneficiary;
  final VoidCallback onBackToDashboard;
  final ScrollController? scrollController;

  const TopUpSuccessContent({
    super.key,
    required this.beneficiary,
    required this.amountToppedUp,
    required this.serviceFeePaid,
    required this.totalPaid,
    required this.remainingLimitForBeneficiary,
    required this.onBackToDashboard,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor = colorScheme.brightness == Brightness.dark ? colorScheme.surfaceContainerHigh : ColorPalette.white;

    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: ColorPalette.overlayLight, blurRadius: 16, offset: Offset(0, 4))],
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: ColorPalette.success.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, size: 56, color: ColorPalette.success),
                ),
                const SizedBox(height: 24),
                Text(
                  AppStrings.topUpSuccessfulTitle,
                  style: AppTextStyles.h2.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.transactionCompletedSuccessfully,
                  style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Divider(color: colorScheme.outlineVariant),
                const SizedBox(height: 20),
                LabelValueRow(label: AppStrings.beneficiaryLabelShort, value: beneficiary.nickname),
                const SizedBox(height: 12),
                LabelValueRow(label: AppStrings.phoneNumberLabel, value: beneficiary.phoneNumber),
                const SizedBox(height: 12),
                LabelValueRow(
                  label: AppStrings.amountToppedUp,
                  value: AppStrings.format(AppStrings.aedFormat, [amountToppedUp.toStringAsFixed(2)]),
                ),
                const SizedBox(height: 12),
                LabelValueRow(
                  label: AppStrings.serviceFeePaid,
                  value: AppStrings.format(AppStrings.aedFormat, [serviceFeePaid.toStringAsFixed(2)]),
                ),
                const SizedBox(height: 12),
                LabelValueRow(
                  label: AppStrings.totalPaid,
                  value: AppStrings.format(AppStrings.aedFormat, [totalPaid.toStringAsFixed(2)]),
                  valueHighlightGreen: true,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, size: 24, color: colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.monthlyLimitNotice,
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                style: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
                                children: [
                                  const TextSpan(text: AppStrings.remainingLimitForBeneficiary),
                                  TextSpan(
                                    text: AppStrings.format(AppStrings.aedFormat, [
                                      remainingLimitForBeneficiary.toStringAsFixed(2),
                                    ]),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: ColorPalette.success,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onBackToDashboard,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryDark,
                foregroundColor: ColorPalette.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(AppStrings.backToDashboard, style: AppTextStyles.button.copyWith(color: ColorPalette.white)),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

void showTopUpSuccessBottomSheet({
  required BuildContext context,
  required Beneficiary beneficiary,
  required double amountToppedUp,
  required double serviceFeePaid,
  required double totalPaid,
  required double remainingLimitForBeneficiary,
  required VoidCallback onSheetClosed,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: ColorPalette.transparent,
    builder: (sheetContext) => DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: TopUpSuccessContent(
          beneficiary: beneficiary,
          amountToppedUp: amountToppedUp,
          serviceFeePaid: serviceFeePaid,
          totalPaid: totalPaid,
          remainingLimitForBeneficiary: remainingLimitForBeneficiary,
          onBackToDashboard: () => Navigator.of(sheetContext).pop(),
          scrollController: scrollController,
        ),
      ),
    ),
  ).then((_) => onSheetClosed());
}
