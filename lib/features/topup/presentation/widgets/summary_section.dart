import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_palette.dart';
import 'label_value_row.dart';

class SummarySection extends StatelessWidget {
  final double remaining;
  final double? topUpAmount;
  final double serviceFee;
  final double totalAmount;
  final ColorScheme colorScheme;

  const SummarySection({
    super.key,
    required this.remaining,
    required this.topUpAmount,
    required this.serviceFee,
    required this.totalAmount,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          LabelValueRow(
            label: AppStrings.remainingForThisMonth,
            value: AppStrings.format(AppStrings.aedFormat, [remaining.toStringAsFixed(2)]),
            valueColor: colorScheme.brightness == Brightness.dark
                ? colorScheme.onSurface
                : ColorPalette.primaryDark,
            valueBold: true,
          ),
          const SizedBox(height: 12),
          LabelValueRow(
            label: AppStrings.topupAmountLabel,
            value: topUpAmount != null
                ? AppStrings.format(AppStrings.aedFormat, [topUpAmount!.toStringAsFixed(2)])
                : AppStrings.amountNotSelected,
            valueColor: colorScheme.onSurface,
          ),
          const SizedBox(height: 12),
          LabelValueRow(
            label: AppStrings.serviceFee,
            value: AppStrings.format(AppStrings.aedFormat, [serviceFee.toStringAsFixed(2)]),
            valueColor: colorScheme.onSurface,
          ),
          const SizedBox(height: 12),
          LabelValueRow(
            label: AppStrings.totalAmount,
            value: AppStrings.format(AppStrings.aedFormat, [totalAmount.toStringAsFixed(2)]),
            valueColor: colorScheme.brightness == Brightness.dark
                ? colorScheme.onSurface
                : ColorPalette.primaryDark,
            valueBold: true,
          ),
        ],
      ),
    );
  }
}
