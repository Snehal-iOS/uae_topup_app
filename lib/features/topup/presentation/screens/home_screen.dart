import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/color_palette.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/common_app_bar.dart';
import '../widgets/empty_state_card.dart';
import '../../../beneficiary/presentation/bloc/beneficiary_bloc.dart';
import '../../../beneficiary/presentation/bloc/beneficiary_event.dart' as beneficiary_events;
import '../../../beneficiary/presentation/bloc/beneficiary_event.dart';
import '../../../beneficiary/presentation/bloc/beneficiary_state.dart';
import '../../../beneficiary/presentation/screens/add_beneficiary_screen.dart';
import 'topup_transaction_screen.dart';
import '../../../beneficiary/domain/entities/beneficiary.dart';
import '../../../beneficiary/presentation/widgets/beneficiary_card.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/bloc/user_event.dart';
import '../../../user/presentation/bloc/user_state.dart';
import '../../../user/presentation/widgets/user_info_card.dart';
import '../bloc/topup_bloc.dart';
import '../bloc/topup_event.dart' as topup_events;
import '../bloc/topup_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onNavigateToManageBeneficiaries});

  final VoidCallback? onNavigateToManageBeneficiaries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: AppStrings.dashboard),
      body: MultiBlocListener(
        listeners: [
          BlocListener<BeneficiaryBloc, BeneficiaryState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                AppSnackBar.showError(context, state.errorMessage!);
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (context.mounted) {
                    context.read<BeneficiaryBloc>().add(const beneficiary_events.ClearMessages());
                  }
                });
              }
              if (state.successMessage != null) {
                AppSnackBar.showSuccess(context, state.successMessage!);
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (context.mounted) {
                    context.read<BeneficiaryBloc>().add(const beneficiary_events.ClearMessages());
                  }
                });
              }
            },
          ),
          BlocListener<TopupBloc, TopupState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                AppSnackBar.showError(context, state.errorMessage!);
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (context.mounted) {
                    context.read<TopupBloc>().add(const topup_events.ClearMessages());
                  }
                });
              }
              if (state.successMessage != null) {
                AppSnackBar.showSuccess(context, state.successMessage!);
                final userBloc = context.read<UserBloc>();
                final beneficiaryBloc = context.read<BeneficiaryBloc>();
                userBloc.add(const RefreshUser(silent: true));
                beneficiaryBloc.add(const RefreshBeneficiaries(silent: true));
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (context.mounted) {
                    context.read<TopupBloc>().add(const topup_events.ClearMessages());
                  }
                });
              }
            },
          ),
        ],
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            if (userState.status == UserStatus.loading && userState.user == null) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator(), SizedBox(height: 16), Text(AppStrings.loading)],
                ),
              );
            }

            if (userState.status == UserStatus.error && userState.user == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: ColorPalette.error),
                    const SizedBox(height: 16),
                    Text(
                      userState.errorMessage ?? AppStrings.somethingWentWrong,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<UserBloc>().add(const LoadUser());
                      },
                      child: const Text(AppStrings.retry),
                    ),
                  ],
                ),
              );
            }

            return BlocBuilder<BeneficiaryBloc, BeneficiaryState>(
              builder: (context, beneficiaryState) {
                final canAddMore = beneficiaryState.activeBeneficiaries.length < AppConstants.maxActiveBeneficiaries;
                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<UserBloc>().add(const RefreshUser());
                          context.read<BeneficiaryBloc>().add(const beneficiary_events.RefreshBeneficiaries());
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (userState.user != null)
                                UserInfoCard(
                                  key: ValueKey('user_${userState.user!.balance}_${userState.user!.monthlyTopupTotal}'),
                                  user: userState.user!,
                                ),
                              const SizedBox(height: 15),
                              BlocBuilder<BeneficiaryBloc, BeneficiaryState>(
                                builder: (context, beneficiaryState) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                AppStrings.activeBeneficiaries,
                                                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '(${beneficiaryState.activeBeneficiaries.length}/${AppConstants.maxActiveBeneficiaries})',
                                                style: AppTextStyles.labelMedium.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorPalette.greyDark600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (onNavigateToManageBeneficiaries != null)
                                            TextButton(
                                              onPressed: onNavigateToManageBeneficiaries,
                                              style: TextButton.styleFrom(
                                                foregroundColor: Theme.of(context).colorScheme.primary,
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                minimumSize: Size.zero,
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              ),
                                              child: Text(
                                                AppStrings.seeAll,
                                                style: AppTextStyles.labelMedium.copyWith(
                                                  color: Theme.of(context).colorScheme.primary,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      if (beneficiaryState.activeBeneficiaries.isEmpty)
                                        const EmptyStateCard.noBeneficiaries()
                                      else if (userState.user != null)
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: beneficiaryState.activeBeneficiaries.length,
                                          itemBuilder: (context, index) {
                                            final beneficiary = beneficiaryState.activeBeneficiaries[index];
                                            return BeneficiaryCard(
                                              key: ValueKey(beneficiary.id),
                                              beneficiary: beneficiary,
                                              user: userState.user!,
                                              isLoading: beneficiaryState.status == BeneficiaryStatus.loading,
                                              isActive: beneficiary.isActive,
                                              showManagementActions: false,
                                              onTap: (b, u) => _navigateToTopUp(context, b, u),
                                            );
                                          },
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Add Beneficiary button fixed above the bottom nav bar
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        child: _AddBeneficiaryButton(
                          onPressed: canAddMore ? () => _navigateToAddBeneficiary(context) : null,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _navigateToAddBeneficiary(BuildContext context) {
    final beneficiaryBloc = context.read<BeneficiaryBloc>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(value: beneficiaryBloc, child: const AddBeneficiaryScreen()),
      ),
    );
  }

  void _navigateToTopUp(BuildContext context, Beneficiary beneficiary, User user) {
    final topupBloc = context.read<TopupBloc>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: topupBloc,
          child: TopUpTransactionScreen(beneficiary: beneficiary, user: user),
        ),
      ),
    );
  }
}

/// Add Beneficiary button: white background, light grey dashed border, person+ icon, dark grey text.
class _AddBeneficiaryButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _AddBeneficiaryButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    const borderRadius = 8.0;
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = colorScheme.outline;
    final contentColor = colorScheme.onSurface;
    final backgroundColor = colorScheme.surface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Opacity(
          opacity: onPressed == null ? 0.5 : 1.0,
          child: Stack(
            children: [
              Container(
                height: 45,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(borderRadius)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_add, size: 22, color: contentColor),
                    const SizedBox(width: 12),
                    Text(
                      AppStrings.addBeneficiary,
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: contentColor),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: _DashedBorderPainter(
                    color: borderColor,
                    strokeWidth: 1.5,
                    borderRadius: borderRadius,
                    dashLength: 6,
                    gapLength: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Paints a dashed rounded rectangle border.
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double borderRadius;
  final double dashLength;
  final double gapLength;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.borderRadius = 12,
    this.dashLength = 6,
    this.gapLength = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final path = Path()..addRRect(rrect);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final length = (distance + dashLength <= metric.length) ? dashLength : metric.length - distance;
        if (length > 0) {
          canvas.drawPath(metric.extractPath(distance, distance + length), paint);
        }
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
