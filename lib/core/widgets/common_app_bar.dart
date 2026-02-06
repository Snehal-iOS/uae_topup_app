import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/color_palette.dart';
import '../constants/app_text_styles.dart';
import '../theme/theme_cubit.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showWalletIcon;
  final bool showThemeToggle;
  final Color? backgroundColor;
  final bool centerTitle;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.showWalletIcon = true,
    this.showThemeToggle = true,
    this.backgroundColor,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appBarBg = backgroundColor ?? 
        (theme.appBarTheme.backgroundColor ?? colorScheme.surface);
    final foreground = theme.appBarTheme.foregroundColor ?? colorScheme.onSurface;
    
    if (showWalletIcon && showThemeToggle) {
      return _buildCustomLayout(context, appBarBg, foreground, colorScheme);
    }
    
    return AppBar(
      backgroundColor: appBarBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              color: foreground,
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(
        title,
        style: AppTextStyles.h4.copyWith(color: foreground),
      ),
      actions: showThemeToggle ? [_ThemeToggleButton()] : null,
    );
  }

  Widget _buildCustomLayout(
    BuildContext context,
    Color appBarBg,
    Color foreground,
    ColorScheme colorScheme,
  ) {
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
        padding: EdgeInsets.only(
          left: showBackButton ? 8 : 16,
          right: 8,
          top: 8,
          bottom: 8,
        ),
        child: Row(
          children: [
            if (showBackButton) ...[
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                color: foreground,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(width: 8),
            ],
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
            if (showThemeToggle) _ThemeToggleButton(),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
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
