import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/color_palette.dart';

Color progressColorForRatio(double progress) {
  if (progress < AppConstants.progressGreenThreshold) return ColorPalette.success;
  if (progress < AppConstants.progressAmberThreshold) return ColorPalette.amber;
  return ColorPalette.error;
}
