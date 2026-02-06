import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/color_palette.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/beneficiary.dart';

class BeneficiaryAvatar extends StatelessWidget {
  static const String _diceBearBase = 'https://api.dicebear.com/7.x/avataaars/png';
  static const double _size = 44;

  final Beneficiary beneficiary;
  final bool showManagementActions;
  final bool isActive;

  const BeneficiaryAvatar({
    super.key,
    required this.beneficiary,
    required this.showManagementActions,
    required this.isActive,
  });

  Widget _buildInitialsPlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final bgColor = showManagementActions && !isActive
        ? (isDark ? colorScheme.surfaceContainerHigh : ColorPalette.greyLight300)
        : (isDark ? colorScheme.primaryContainer : ColorPalette.primaryLight100);
    final textColor = showManagementActions && !isActive
        ? colorScheme.onSurfaceVariant
        : (isDark ? colorScheme.onPrimaryContainer : ColorPalette.primary);
    return CircleAvatar(
      radius: _size / 2,
      backgroundColor: bgColor,
      child: Text(
        beneficiary.nickname.isNotEmpty ? beneficiary.nickname[0].toUpperCase() : '?',
        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final seed = Uri.encodeComponent(beneficiary.id);
    final imageUrl = '$_diceBearBase?seed=$seed';

    return SizedBox(
      width: _size,
      height: _size,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => CircleAvatar(radius: _size / 2, backgroundImage: imageProvider),
        placeholder: (context, url) => _buildInitialsPlaceholder(context),
        errorWidget: (context, url, error) => _buildInitialsPlaceholder(context),
      ),
    );
  }
}
