import 'package:flutter/material.dart';
import '../constants/color_palette.dart';

/// Common IconButton widget that provides consistent styling across the app
/// Supports different button styles: standard, compact, and sized
class CommonIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? iconColor;
  final double? iconSize; // defaults to 24
  final IconButtonStyle style;
  final double? size; // Fixed size for the button (used when style is IconButtonStyle.sized)
  final bool disabled; // Whether the button is disabled (loading state)

  const CommonIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.iconColor,
    this.iconSize,
    this.style = IconButtonStyle.standard,
    this.size,
    this.disabled = false,
  });

  // Creates a compact IconButton (used in cards, lists)
  const CommonIconButton.compact({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.iconColor,
    this.iconSize,
    this.disabled = false,
  }) : style = IconButtonStyle.compact,
       size = null;

  // Creates a sized IconButton (wrapped in SizedBox)
  const CommonIconButton.sized({
    super.key,
    required this.icon,
    required this.size,
    this.onPressed,
    this.tooltip,
    this.iconColor,
    this.iconSize,
    this.disabled = false,
  }) : style = IconButtonStyle.sized;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      icon,
      color: iconColor,
      size: iconSize,
    );

    final iconButton = IconButton(
      icon: iconWidget,
      onPressed: disabled ? null : onPressed,
      tooltip: tooltip,
      padding: style == IconButtonStyle.compact || style == IconButtonStyle.sized
          ? EdgeInsets.zero
          : null,
      constraints: style == IconButtonStyle.compact || style == IconButtonStyle.sized
          ? const BoxConstraints(minWidth: 24, minHeight: 24)
          : null,
      visualDensity: style == IconButtonStyle.compact || style == IconButtonStyle.sized
          ? VisualDensity.compact
          : null,
    );

    if (style == IconButtonStyle.sized && size != null) {
      return SizedBox(
        height: size,
        width: size,
        child: iconButton,
      );
    }

    return iconButton;
  }
}

/// IconButton style types
enum IconButtonStyle {
  standard,  // Standard IconButton with default padding and constraints
  compact,  // Compact IconButton with zero padding and minimal constraints
  sized,   // Sized IconButton wrapped in SizedBox with fixed dimensions
}

/// Predefined common icon buttons for frequently used actions
class CommonIconButtons {
  CommonIconButtons._();

  // Delete button with error color
  static Widget delete({
    Key? key,
    VoidCallback? onPressed,
    String? tooltip,
    bool disabled = false,
    IconButtonStyle style = IconButtonStyle.compact,
    double? size,
    double? iconSize,
  }) {
    final buttonSize = size ?? 32;
    final defaultIconSize = iconSize ?? 32;
    return style == IconButtonStyle.sized
        ? CommonIconButton.sized(
            key: key,
            icon: Icons.cancel,
            size: buttonSize,
            iconColor: ColorPalette.error,
            iconSize: defaultIconSize,
            onPressed: onPressed,
            tooltip: tooltip ?? 'Delete',
            disabled: disabled,
          )
        : CommonIconButton.compact(
            key: key,
            icon: Icons.delete_outline,
            iconColor: ColorPalette.error,
            iconSize: defaultIconSize,
            onPressed: onPressed,
            tooltip: tooltip ?? 'Delete',
            disabled: disabled,
          );
  }

  // Refresh button
  static Widget refresh({
    Key? key,
    VoidCallback? onPressed,
    String? tooltip,
    bool disabled = false,
    double? iconSize,
  }) {
    final defaultIconSize = iconSize ?? 32;
    return CommonIconButton(
      key: key,
      icon: Icons.refresh,
      iconSize: defaultIconSize,
      onPressed: onPressed,
      tooltip: tooltip ?? 'Refresh',
      disabled: disabled,
      style: IconButtonStyle.standard,
    );
  }
}
