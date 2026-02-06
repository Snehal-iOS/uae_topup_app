import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/color_palette.dart';

class AddBeneficiaryButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddBeneficiaryButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    const borderRadius = 8.0;
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = colorScheme.outline;
    final contentColor = colorScheme.onSurface;
    final backgroundColor = colorScheme.brightness == Brightness.dark
        ? colorScheme.surfaceContainerHigh
        : colorScheme.surface;

    return Material(
      color: ColorPalette.transparent,
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
                  painter: DashedBorderPainter(
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

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double borderRadius;
  final double dashLength;
  final double gapLength;

  DashedBorderPainter({
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
