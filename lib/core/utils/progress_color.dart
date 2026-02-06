import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/color_palette.dart';

/// Progress bar color by ratio (0.0–1.0). Green under threshold, amber mid, red high.
/// Shared by UserInfoCard and BeneficiaryCard
Color progressColorForRatio(double progress) {
  if (progress < AppConstants.progressGreenThreshold) return ColorPalette.success;
  if (progress < AppConstants.progressAmberThreshold) return ColorPalette.amber;
  return ColorPalette.error;
}
