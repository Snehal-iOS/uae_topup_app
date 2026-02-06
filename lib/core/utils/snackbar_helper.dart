import 'package:flutter/material.dart';
import '../constants/color_palette.dart';
import '../constants/app_text_styles.dart';

class AppSnackBar {
  AppSnackBar._();

  static void showError(BuildContext context, String message, {int seconds = 4}) {
    _show(context, message, ColorPalette.error, seconds);
  }

  static void showSuccess(BuildContext context, String message, {int seconds = 3}) {
    _show(context, message, ColorPalette.success, seconds);
  }

  static void _show(BuildContext context, String message, Color backgroundColor, int seconds) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(color: ColorPalette.white),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: seconds),
      ),
    );
  }
}
