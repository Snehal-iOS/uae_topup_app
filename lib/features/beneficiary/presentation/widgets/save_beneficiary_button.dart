import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_palette.dart';
import '../../../../core/constants/app_text_styles.dart';

class SaveBeneficiaryButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveBeneficiaryButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.check, color: ColorPalette.white, size: 22),
        label: Text(
          AppStrings.saveBeneficiary,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: ColorPalette.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.primaryDark,
          foregroundColor: ColorPalette.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
    );
  }
}
