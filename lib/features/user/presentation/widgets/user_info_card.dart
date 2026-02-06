import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/display_formatters.dart';
import '../../../../core/utils/progress_color.dart';
import '../../domain/entities/user.dart';

class UserInfoCard extends StatelessWidget {
  final User user;

  const UserInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor = theme.cardTheme.color ?? colorScheme.surface;
    final progressBg = colorScheme.surfaceContainerHighest;
    final secondaryColor = colorScheme.onSurfaceVariant;
    final iconColor = colorScheme.onSurface;

    return Card(
      elevation: 0.0,
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(user.name, style: AppTextStyles.h3),
                          const SizedBox(width: 4),
                          // Verification Status Badge
                          user.isVerified
                              ? Image.asset('assets/verified_user_blue.png', width: 22, height: 22)
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/dirham.svg',
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4),
                    Text(DisplayFormatters.formatBalance(user.balance), style: AppTextStyles.balanceLarge),
                  ],
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.monthlyLimitUsed,
                      style: AppTextStyles.labelLarge.copyWith(color: colorScheme.onSurface),
                    ),
                    Text(
                      AppStrings.allBeneficiaries,
                      style: AppTextStyles.captionSmall.copyWith(fontSize: 9, color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/dirham.svg',
                      width: 14,
                      height: 14,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4),
                    Text('${user.monthlyTopupTotal.toStringAsFixed(0)} / ', style: AppTextStyles.labelLarge),
                    SvgPicture.asset(
                      'assets/dirham.svg',
                      width: 14,
                      height: 14,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4),
                    Text(user.totalMonthlyLimit.toStringAsFixed(0), style: AppTextStyles.labelLarge),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: user.monthlyLimitProgress,
                minHeight: 8,
                backgroundColor: progressBg,
                valueColor: AlwaysStoppedAnimation<Color>(progressColorForRatio(user.monthlyLimitProgress)),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(AppStrings.remainingLabel, style: AppTextStyles.caption.copyWith(color: secondaryColor)),
                SvgPicture.asset(
                  'assets/dirham.svg',
                  width: 12,
                  height: 12,
                  colorFilter: ColorFilter.mode(secondaryColor, BlendMode.srcIn),
                ),
                const SizedBox(width: 4),
                Text(
                  user.remainingMonthlyLimit.toStringAsFixed(2),
                  style: AppTextStyles.caption.copyWith(color: secondaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
