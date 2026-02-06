import 'package:flutter/material.dart';

/// This file contains color palette for the entire application
/// All colors used in the app should be defined here
class ColorPalette {
  ColorPalette._();

  // Primary Colors (Blue)
  static const Color primary = Colors.blue;
  static Color primaryLight50 = Colors.blue[50]!;
  static Color primaryLight100 = Colors.blue[100]!;
  static Color primaryLight200 = Colors.blue[200]!;
  static Color blueColor = Colors.indigo;
  static const Color primaryDark = Color(0xFF012a4a);
  static const Color primaryDarkAlt = Color(0xFF013a63);

  // Success Colors (Green)
  static const Color success = Colors.green;
  static Color successLight50 = Colors.green[50]!;
  static Color successDark700 = Colors.green[700]!;

  // Warning Colors (Orange)
  static const Color warning = Colors.orange;
  static Color warningLight50 = Colors.orange[50]!;
  static Color warningDark700 = Colors.orange[700]!;
  static Color warningDark900 = Colors.orange[900]!;

  // Error Colors (Red)
  static const Color error = Colors.red;

  // Amber (progress / accent)
  static const Color amber = Colors.amber;

  // Neutral Colors (Grey)
  static const Color grey = Colors.grey;
  static Color greyLight50 = Colors.grey[50]!;
  static Color greyLight100 = Colors.grey[100]!;
  static Color greyLight200 = Colors.grey[200]!;
  static Color greyLight300 = Colors.grey[300]!;
  static Color greyLight400 = Colors.grey[400]!;
  static Color greyLight500 = Colors.grey[500]!;
  static Color greyDark600 = Colors.grey[600]!;
  static Color greyDark900 = Colors.grey[800]!;

  // Common Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  // Dark theme surface (for ColorScheme overrides)
  static const Color darkSurface = Color(0xFF1E1E2E);
  static const Color darkOnSurface = Color(0xFFE4E4E7);
  static const Color darkOnSurfaceVariant = Color(0xFFA1A1AA);

  // Overlay / shadow (black with opacity)
  static const Color overlayLight = Color(0x0F000000); // ~6%
  static const Color overlayMedium = Color(0x1A000000); // ~10%
}
