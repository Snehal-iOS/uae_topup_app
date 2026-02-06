import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_palette.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/common_app_bar.dart';
import '../widgets/label_value_row.dart';
import '../widgets/amount_grid.dart';
import '../widgets/summary_section.dart';
import '../widgets/beneficiary_row.dart';
import '../../../beneficiary/domain/entities/beneficiary.dart';
import '../../../user/domain/entities/user.dart';
import '../utils/topup_eligibility.dart';
import '../bloc/topup_bloc.dart';
import '../bloc/topup_event.dart';
import '../bloc/topup_state.dart';
import 'topup_success_screen.dart' show showTopUpSuccessBottomSheet;

class TopUpTransactionScreen extends StatefulWidget {
  final Beneficiary beneficiary;
  final User user;

  const TopUpTransactionScreen({
    super.key,
    required this.beneficiary,
    required this.user,
  });

  @override
  State<TopUpTransactionScreen> createState() => _TopUpTransactionScreenState();
}

class _TopUpTransactionScreenState extends State<TopUpTransactionScreen> {
  double? _selectedAmount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<TopupBloc, TopupState>(
      listenWhen: (prev, curr) =>
          prev.status == TopupStatus.loading &&
          (curr.status == TopupStatus.success || curr.status == TopupStatus.error),
      listener: (context, state) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        if (state.status == TopupStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage!,
                style: AppTextStyles.bodyMedium.copyWith(color: ColorPalette.white),
              ),
              backgroundColor: ColorPalette.error,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
            ),
          );
          context.read<TopupBloc>().add(const ClearMessages());
          return;
        }
        if (state.status == TopupStatus.success && _selectedAmount != null) {
          final amount = _selectedAmount!;
          context.read<TopupBloc>().add(const ClearMessages());
          showTopUpSuccessBottomSheet(
            context: context,
            beneficiary: widget.beneficiary,
            amountToppedUp: amount,
            serviceFeePaid: TopupEligibility.serviceCharge,
            totalPaid: TopupEligibility.totalWithFee(amount),
            remainingLimitForBeneficiary: TopupEligibility.remainingAfterTopup(
              widget.user,
              widget.beneficiary,
              amount,
            ),
            onSheetClosed: () => Navigator.of(context).pop(),
          );
        }
      },
      child: Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CommonAppBar(
        title: AppStrings.topUpTransactionTitle,
        showBackButton: true,
        showWalletIcon: false,
        showThemeToggle: false,
        backgroundColor: colorScheme.surface,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            BeneficiaryRow(beneficiary: widget.beneficiary),
            const SizedBox(height: 28),
            // Select Amount header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  AppStrings.selectAmount,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppStrings.currencyAed,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AmountGrid(
              selectedAmount: _selectedAmount,
              onSelect: (amount) => setState(() => _selectedAmount = amount),
              colorScheme: colorScheme,
              isAmountAvailable: (amount) =>
                  TopupEligibility.canPerformTopup(widget.user, widget.beneficiary, amount),
            ),
            const SizedBox(height: 24),
            SummarySection(
              remaining: TopupEligibility.remainingForBeneficiary(widget.user, widget.beneficiary),
              topUpAmount: _selectedAmount,
              serviceFee: TopupEligibility.serviceCharge,
              totalAmount: TopupEligibility.totalWithFee(_selectedAmount ?? 0),
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _selectedAmount != null ? _confirmTopUp : null,
                icon: const Icon(Icons.arrow_forward, color: ColorPalette.white, size: 20),
                label: Text(
                  AppStrings.confirmTopup,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primaryDark,
                  foregroundColor: ColorPalette.white,
                  disabledBackgroundColor: colorScheme.surfaceContainerHighest,
                  disabledForegroundColor: colorScheme.onSurfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      ),
    );
  }

  void _confirmTopUp() {
    if (_selectedAmount == null) return;
    context.read<TopupBloc>().add(
          PerformTopup(
            beneficiaryId: widget.beneficiary.id,
            amount: _selectedAmount!,
            user: widget.user,
            beneficiary: widget.beneficiary,
          ),
        );
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: Material(
            color: ColorPalette.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: ColorPalette.overlayMedium,
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(AppStrings.processingTopup, style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

