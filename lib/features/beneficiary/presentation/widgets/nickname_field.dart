import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/color_palette.dart';

class NicknameField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const NicknameField({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.nickname,
          style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: AppStrings.nicknameHintPlaceholder,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            errorStyle: AppTextStyles.captionSmall.copyWith(color: ColorPalette.error),
            counterStyle: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurface),
          maxLength: AppConstants.maxNicknameLength,
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppStrings.pleaseEnterNickname;
            }
            if (value.trim().length > AppConstants.maxNicknameLength) {
              return AppStrings.nicknameMaxLength;
            }
            return null;
          },
        ),
      ],
    );
  }
}
