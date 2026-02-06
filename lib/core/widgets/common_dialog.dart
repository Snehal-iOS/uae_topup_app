import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/app_strings.dart';
import '../constants/color_palette.dart';
import '../constants/app_text_styles.dart';

/// Common dialog widget that provides consistent styling across the app
class CommonDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String? cancelText;
  final String? confirmText;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final DialogButtonStyle confirmButtonStyle;
  final bool showCancelButton; // defaults to true
  final bool showConfirmButton; // defaults to true
  
  final List<Widget>? customActions;

  const CommonDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelText,
    this.confirmText,
    this.onCancel,
    this.onConfirm,
    this.confirmButtonStyle = DialogButtonStyle.primary,
    this.showCancelButton = true,
    this.showConfirmButton = true,
    this.customActions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return AlertDialog(
      title: Text(
        title,
        style: AppTextStyles.h4.copyWith(color: colorScheme.onSurface),
      ),
      content: DefaultTextStyle(
        style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurface),
        child: content,
      ),
      actions: customActions ?? _buildDefaultActions(context),
    );
  }

  List<Widget> _buildDefaultActions(BuildContext context) {
    final actions = <Widget>[];
    final colorScheme = Theme.of(context).colorScheme;

    if (showCancelButton) {
      actions.add(
        TextButton(
          onPressed: onCancel ?? () => Navigator.pop(context),
          child: Text(
            cancelText ?? AppStrings.cancel,
            style: AppTextStyles.labelMedium.copyWith(color: colorScheme.primary),
          ),
        ),
      );
    }

    if (showConfirmButton) {
      final buttonStyle = _getButtonStyle(confirmButtonStyle);
      actions.add(
        ElevatedButton(
          style: buttonStyle,
          onPressed: onConfirm,
          child: Text(
            confirmText ?? AppStrings.confirm,
            style: AppTextStyles.button.copyWith(color: ColorPalette.white),
          ),
        ),
      );
    }

    return actions;
  }

  ButtonStyle? _getButtonStyle(DialogButtonStyle style) {
    switch (style) {
      case DialogButtonStyle.primary:
        return ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: ColorPalette.primaryDarkAlt),
          ),
        );
      case DialogButtonStyle.success:
        return ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.success,
          foregroundColor: ColorPalette.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: ColorPalette.success),
          ),
        );
      case DialogButtonStyle.warning:
        return ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.warning,
          foregroundColor: ColorPalette.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: ColorPalette.warning),
          ),
        );
      case DialogButtonStyle.error:
        return ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.error,
          foregroundColor: ColorPalette.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: ColorPalette.error),
          ),
        );
    }
  }
}

/// Dialog button style types
enum DialogButtonStyle {
  primary, // default theme color
  success, // green
  warning, // orange/yellow
  error, // red
}

/// Helper class for common dialog operations
class CommonDialogs {
  CommonDialogs._();

  // Shows a confirmation dialog
  static Future<void> showConfirm({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    DialogButtonStyle confirmButtonStyle = DialogButtonStyle.primary,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => CommonDialog(
        title: title,
        content: Text(message),
        confirmText: confirmText,
        cancelText: cancelText,
        onCancel: onCancel ?? () => Navigator.pop(dialogContext),
        onConfirm: onConfirm ?? () => Navigator.pop(dialogContext),
        confirmButtonStyle: confirmButtonStyle,
      ),
    );
  }

  // Shows a delete confirmation dialog
  static Future<void> showDelete({
    required BuildContext context,
    required String title,
    required String message,
    String? deleteText,
    String? cancelText,
    VoidCallback? onDelete,
    VoidCallback? onCancel,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => CommonDialog(
        title: title,
        content: Text(message),
        confirmText: deleteText ?? AppStrings.delete,
        cancelText: cancelText ?? AppStrings.cancel,
        onCancel: onCancel ?? () => Navigator.pop(dialogContext),
        onConfirm: onDelete ?? () => Navigator.pop(dialogContext),
        confirmButtonStyle: DialogButtonStyle.error,
      ),
    );
  }

  // Shows a toggle (activate/deactivate) confirmation dialog
  static Future<void> showToggle({
    required BuildContext context,
    required String title,
    required String message,
    required bool willActivate,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => CommonDialog(
        title: title,
        content: Text(message),
        confirmText: willActivate ? AppStrings.activate : AppStrings.deactivate,
        cancelText: cancelText ?? AppStrings.cancel,
        onCancel: onCancel ?? () => Navigator.pop(dialogContext),
        onConfirm: onConfirm ?? () => Navigator.pop(dialogContext),
        confirmButtonStyle: willActivate 
            ? DialogButtonStyle.success 
            : DialogButtonStyle.warning,
      ),
    );
  }

  // Shows a dialog with BlocProvider wrapper
  static Future<void> showWithBlocProvider<T extends BlocBase<Object?>>({
    required BuildContext context,
    required T bloc,
    required Widget dialog,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: bloc,
        child: dialog,
      ),
    );
  }

  // Shows a custom dialog with custom content
  static Future<void> showCustom({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    String? cancelText,
    VoidCallback? onCancel,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => CommonDialog(
        title: title,
        content: content,
        customActions: actions,
        cancelText: cancelText,
        onCancel: onCancel ?? () => Navigator.pop(dialogContext),
        showConfirmButton: false,
      ),
    );
  }
}
