import 'package:flutter/material.dart';
import '../../../../core/constants/color_palette.dart';

class AddBeneficiaryAvatarHeader extends StatelessWidget {
  const AddBeneficiaryAvatarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: colorScheme.brightness == Brightness.dark
              ? colorScheme.primaryContainer
              : ColorPalette.primaryLight100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.person_add,
          size: 40,
          color: colorScheme.brightness == Brightness.dark ? colorScheme.onPrimaryContainer : ColorPalette.primaryDark,
        ),
      ),
    );
  }
}
