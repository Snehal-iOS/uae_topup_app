import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/color_palette.dart';
import '../constants/app_text_styles.dart';
import '../theme/theme_cubit.dart';

/// Common AppBar widget across the app
class AppBarStyle extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const AppBarStyle({
    super.key,
    required this.title,
    this.showBackButton = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appBarBg = theme.appBarTheme.backgroundColor ?? colorScheme.surface;
    final foreground = theme.appBarTheme.foregroundColor ?? colorScheme.onSurface;
    final walletBg = colorScheme.brightness == Brightness.dark
        ? colorScheme.primaryContainer
        : ColorPalette.primaryLight100;
    final walletIcon = colorScheme.brightness == Brightness.dark
        ? colorScheme.onPrimaryContainer
        : ColorPalette.primaryDark;

    return SafeArea(
      child: Container(
        height: kToolbarHeight,
        color: appBarBg,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            if (showBackButton)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                color: foreground,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            const SizedBox(width: 16),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: walletBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                size: 20,
                color: walletIcon,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: foreground,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _ThemeButton(),
            const SizedBox(width: 16),

          ],
        ),
      ),
    );
  }
}

class _ThemeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final buttonBg = colorScheme.surfaceContainerHighest;
    final iconColor = colorScheme.onSurfaceVariant;
    return Material(
      color: ColorPalette.transparent,
      child: InkWell(
        onTap: () => context.read<ThemeCubit>().toggle(),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: buttonBg,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(isDark ? 0.3 : 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            size: 20,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
