import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/color_palette.dart';

class AmountCard extends StatelessWidget {
  final double amount;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const AmountCard({
    super.key,
    required this.amount,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSelected = isSelected && isEnabled;
    final bgColor = !isEnabled
        ? colorScheme.surfaceContainerHighest.withOpacity(0.5)
        : (effectiveSelected
            ? ColorPalette.primaryLight100
            : colorScheme.surfaceContainerHighest.withOpacity(0.6));
    final borderColor = !isEnabled
        ? colorScheme.outlineVariant.withOpacity(0.6)
        : (effectiveSelected ? ColorPalette.primaryDark : colorScheme.outlineVariant);
    final textColor = !isEnabled
        ? colorScheme.onSurfaceVariant.withOpacity(0.6)
        : (effectiveSelected ? ColorPalette.primaryDark : colorScheme.onSurface);

    return Material(
      color: ColorPalette.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.6,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: effectiveSelected ? 2 : 1),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    amount.toInt().toString(),
                    style: AppTextStyles.h3.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppStrings.aed,
                    style: AppTextStyles.bodySmall.copyWith(color: textColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
