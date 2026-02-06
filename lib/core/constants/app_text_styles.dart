import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_palette.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _baseTextStyle({
    // sans-serif font
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle get h1 => _baseTextStyle(fontSize: 28, fontWeight: FontWeight.bold);

  static TextStyle get h2 => _baseTextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  static TextStyle get h3 => _baseTextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  static TextStyle get h4 => _baseTextStyle(fontSize: 18, fontWeight: FontWeight.w600);

  static TextStyle get bodyLarge => _baseTextStyle(fontSize: 16, fontWeight: FontWeight.normal);

  static TextStyle get bodyMedium => _baseTextStyle(fontSize: 14, fontWeight: FontWeight.normal);

  static TextStyle get bodySmall => _baseTextStyle(fontSize: 12, fontWeight: FontWeight.normal);

  static TextStyle get bodyXSmall => _baseTextStyle(fontSize: 10, fontWeight: FontWeight.normal);

  static TextStyle get labelLarge => _baseTextStyle(fontSize: 14, fontWeight: FontWeight.w500);

  static TextStyle get labelMedium => _baseTextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle get labelSmall => _baseTextStyle(fontSize: 10, fontWeight: FontWeight.w500);

  static TextStyle get button => _baseTextStyle(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle get balanceLarge => _baseTextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  static TextStyle get balanceMedium => _baseTextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  static TextStyle get caption =>
      _baseTextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: ColorPalette.greyDark600);

  static TextStyle get captionSmall =>
      _baseTextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: ColorPalette.greyDark600);

  static TextStyle get overline => _baseTextStyle(fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 1.5);

  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}
