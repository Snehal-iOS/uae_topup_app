import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/common_app_bar.dart';
import '../widgets/add_beneficiary_avatar_header.dart';
import '../widgets/nickname_field.dart';
import '../widgets/uae_phone_field.dart';
import '../widgets/save_beneficiary_button.dart';
import '../bloc/beneficiary_bloc.dart';
import '../bloc/beneficiary_event.dart';

class AddBeneficiaryScreen extends StatefulWidget {
  const AddBeneficiaryScreen({super.key});

  @override
  State<AddBeneficiaryScreen> createState() => _AddBeneficiaryScreenState();
}

class _AddBeneficiaryScreenState extends State<AddBeneficiaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _phoneController = TextEditingController();

  Color _getBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return colorScheme.brightness == Brightness.dark ? colorScheme.surfaceContainerHighest : colorScheme.surface;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CommonAppBar(
        title: AppStrings.addNewBeneficiaryTitle,
        showBackButton: true,
        showWalletIcon: false,
        showThemeToggle: false,
        backgroundColor: backgroundColor,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                const AddBeneficiaryAvatarHeader(),
                const SizedBox(height: 32),
                NicknameField(controller: _nicknameController, onChanged: (_) => setState(() {})),
                const SizedBox(height: 10),
                UAEPhoneField(controller: _phoneController),
                const SizedBox(height: 24),
                Builder(
                  builder: (context) {
                    final colorScheme = Theme.of(context).colorScheme;
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.safety_check, size: 28, color: colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.transactionLimitsTitle,
                                  style: AppTextStyles.labelMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppStrings.transactionLimitsDescription,
                                  style: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                SaveBeneficiaryButton(onPressed: _submitForm),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final nickname = _nicknameController.text.trim();
    final digits = _phoneController.text.replaceAll(RegExp(r'\s'), '');
    final phoneNumber = '+971$digits';

    context.read<BeneficiaryBloc>().add(AddBeneficiary(nickname: nickname, phoneNumber: phoneNumber));
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
