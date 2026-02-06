import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/color_palette.dart';

class UAEPhoneField extends StatelessWidget {
  final TextEditingController controller;

  const UAEPhoneField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.uaePhoneNumber,
          style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
        const SizedBox(height: 8),
        FormField<String>(
          initialValue: controller.text,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppStrings.pleaseEnterPhoneNumber;
            }
            final digits = value.replaceAll(RegExp(r'\s'), '');
            if (digits.length != AppConstants.uaePhoneDigitsCount ||
                !digits.startsWith(AppConstants.uaeMobileFirstDigit)) {
              return AppStrings.pleaseEnterValidUAENumber;
            }
            return null;
          },
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    border: Border.all(color: state.hasError ? ColorPalette.error : colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Text(
                          '+971',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Container(width: 1, height: 24, color: colorScheme.outlineVariant),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          onChanged: state.didChange,
                          decoration: InputDecoration(
                            hintText: AppStrings.phonePlaceholder,
                            hintStyle: AppTextStyles.bodyMedium.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurface),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[\d\s]')),
                            LengthLimitingTextInputFormatter(9),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.hasError && state.errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      state.errorText!,
                      style: AppTextStyles.captionSmall.copyWith(color: ColorPalette.error),
                    ),
                  ),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, size: 20, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                AppStrings.phoneVerifyInfo,
                style: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
