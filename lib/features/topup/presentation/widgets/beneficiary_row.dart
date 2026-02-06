import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../beneficiary/domain/entities/beneficiary.dart';

class BeneficiaryRow extends StatelessWidget {
  final Beneficiary beneficiary;

  const BeneficiaryRow({super.key, required this.beneficiary});

  static const String _diceBearBase = 'https://api.dicebear.com/7.x/avataaars/png';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final seed = Uri.encodeComponent(beneficiary.id);
    final imageUrl = '$_diceBearBase?seed=$seed';

    return Row(
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => CircleAvatar(radius: 28, backgroundImage: imageProvider),
            placeholder: (context, url) => CircleAvatar(
              radius: 28,
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                beneficiary.nickname.isNotEmpty ? beneficiary.nickname[0].toUpperCase() : '?',
                style: AppTextStyles.h3.copyWith(color: colorScheme.onPrimaryContainer),
              ),
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              radius: 28,
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                beneficiary.nickname.isNotEmpty ? beneficiary.nickname[0].toUpperCase() : '?',
                style: AppTextStyles.h3.copyWith(color: colorScheme.onPrimaryContainer),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(beneficiary.nickname, style: AppTextStyles.h3.copyWith(color: colorScheme.onSurface)),
              const SizedBox(height: 2),
              Text(
                beneficiary.phoneNumber,
                style: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
