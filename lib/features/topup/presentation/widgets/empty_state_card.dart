import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

class EmptyStateCard extends StatelessWidget {
  final String message;
  final String? hint;
  final IconData? icon;
  final double iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final bool centerContent;
  final TextStyle? messageStyle;
  final TextStyle? hintStyle;

  const EmptyStateCard({
    super.key,
    required this.message,
    this.hint,
    this.icon,
    this.iconSize = 40,
    this.iconColor,
    this.padding,
    this.centerContent = true,
    this.messageStyle,
    this.hintStyle,
  });

  const EmptyStateCard.noBeneficiaries({
    super.key,
    String? message,
    String? hint,
    this.iconSize = 40,
    this.iconColor,
    this.padding,
    this.centerContent = true,
    this.messageStyle,
    this.hintStyle,
  }) : message = message ?? AppStrings.noBeneficiariesYet,
       hint = hint ?? AppStrings.addBeneficiaryHint,
       icon = Icons.people_alt_rounded;

  const EmptyStateCard.noActiveBeneficiaries({
    super.key,
    String? message,
    this.iconSize = 40,
    this.iconColor,
    this.padding,
    this.centerContent = true,
    this.messageStyle,
    this.hintStyle,
  }) : message = message ?? AppStrings.noActiveBeneficiaries,
       hint = null,
       icon = null;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final defaultIconColor = iconColor ?? colorScheme.onSurfaceVariant;
    final defaultMessageColor = colorScheme.onSurfaceVariant;
    final defaultHintColor = colorScheme.outline;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: iconSize, color: defaultIconColor), const SizedBox(height: 12)],
        Text(
          message,
          textAlign: centerContent ? TextAlign.center : null,
          style: messageStyle ?? AppTextStyles.bodyLarge.copyWith(color: defaultMessageColor),
        ),
        if (hint != null) ...[
          const SizedBox(height: 8),
          Text(
            hint!,
            textAlign: TextAlign.center,
            style: hintStyle ?? AppTextStyles.bodyMedium.copyWith(color: defaultHintColor),
          ),
        ],
      ],
    );

    return Padding(
      padding: padding ?? const EdgeInsets.all(24),
      child: centerContent ? Center(child: content) : content,
    );
  }
}
