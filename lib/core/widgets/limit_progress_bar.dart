import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_styles.dart';
import '../utils/progress_color.dart';

/// A widget that displays a progress bar showing used amount vs limit
/// 
/// Shows a linear progress indicator with color-coded progress based on usage ratio,
/// along with labels showing "Limit Used" and the used/limit amounts.
class LimitProgressBar extends StatelessWidget {
  final double used;
  final double limit;

  const LimitProgressBar({
    super.key,
    required this.used,
    required this.limit,
  });

  @override
  Widget build(BuildContext context) {
    final progress = limit > 0 ? (used / limit).clamp(0.0, 1.0) : 0.0;
    final color = progressColorForRatio(progress);
    final colorScheme = Theme.of(context).colorScheme;
    final trackColor = colorScheme.surfaceContainerHighest;
    final textColor = colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: trackColor,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.limitUsed,
              style: AppTextStyles.captionSmall.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppStrings.format(AppStrings.used, [
                used.toStringAsFixed(0),
                limit.toStringAsFixed(0),
              ]),
              style: AppTextStyles.captionSmall.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
