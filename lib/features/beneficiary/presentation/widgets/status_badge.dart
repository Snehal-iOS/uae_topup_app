import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_palette.dart';
import '../../../../core/constants/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final bool isActive;
  final double iconSize;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double borderWidth;
  final double spacing;
  final bool wrapText;
  final TextStyle? textStyle;

  const StatusBadge({
    super.key,
    required this.isActive,
    this.iconSize = 12,
    this.padding,
    this.borderRadius = 12,
    this.borderWidth = 1,
    this.spacing = 4,
    this.wrapText = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final statusText = isActive ? AppStrings.active : AppStrings.inactive;
    final backgroundColor = isActive ? ColorPalette.successLight50 : ColorPalette.greyLight200;
    final borderColor = isActive ? ColorPalette.success : ColorPalette.grey;
    final iconColor = isActive ? ColorPalette.successDark700 : ColorPalette.greyDark600;
    final textColor = isActive ? ColorPalette.successDark700 : ColorPalette.greyDark600;

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isActive ? Icons.check_circle : Icons.cancel, size: iconSize, color: iconColor),
          SizedBox(width: spacing),
          if (wrapText)
            Flexible(
              child: Text(
                statusText,
                style: textStyle ?? AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w600, color: textColor),
                overflow: TextOverflow.ellipsis,
              ),
            )
          else
            Text(
              statusText,
              style: textStyle ?? AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w600, color: textColor),
            ),
        ],
      ),
    );
  }
}
