import 'package:flutter/material.dart';
import '../../../../core/constants/color_palette.dart';
import '../../../../core/constants/app_text_styles.dart';

class LabelValueRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool valueBold;
  final bool valueHighlightGreen;

  const LabelValueRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueBold = false,
    this.valueHighlightGreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = valueColor ?? (valueHighlightGreen ? ColorPalette.success : colorScheme.onSurface);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: valueBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.bodyMedium.copyWith(
              color: effectiveColor,
              fontWeight: valueBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
