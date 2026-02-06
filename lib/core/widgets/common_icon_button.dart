import 'package:flutter/material.dart';
import '../constants/color_palette.dart';

class CommonIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? iconSize;
  final double? size;
  final String? tooltip;

  const CommonIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.iconSize,
    this.size,
    this.tooltip,
  });

  /// Factory constructor for creating a sized icon button
  const CommonIconButton.sized({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.size,
    this.iconSize,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final defaultIconColor = iconColor ?? colorScheme.onSurface;
    final defaultBackgroundColor = backgroundColor ?? ColorPalette.transparent;
    final defaultIconSize = iconSize ?? 24.0;

    Widget button = Material(
      color: defaultBackgroundColor,
      borderRadius: BorderRadius.circular(size != null ? size! / 2 : 20),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size != null ? size! / 2 : 20),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Icon(icon, size: defaultIconSize, color: defaultIconColor),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
