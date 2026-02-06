import 'package:flutter/material.dart';
import '../../domain/entities/topup_option.dart';
import 'amount_card.dart';

class AmountGrid extends StatelessWidget {
  final double? selectedAmount;
  final ValueChanged<double> onSelect;
  final ColorScheme colorScheme;
  final bool Function(double amount) isAmountAvailable;

  const AmountGrid({
    super.key,
    required this.selectedAmount,
    required this.onSelect,
    required this.colorScheme,
    required this.isAmountAvailable,
  });

  @override
  Widget build(BuildContext context) {
    const int perRow = 3;
    const double gap = 12.0;
    final options = TopupOption.availableOptions;

    return Column(
      children: [
        for (int i = 0; i < options.length; i += perRow) ...[
          if (i > 0) const SizedBox(height: gap),
          Row(
            children: [
              for (int j = 0; j < perRow && i + j < options.length; j++) ...[
                if (j > 0) const SizedBox(width: gap),
                Expanded(
                  child: AmountCard(
                    amount: options[i + j].amount,
                    isSelected: selectedAmount == options[i + j].amount,
                    isEnabled: isAmountAvailable(options[i + j].amount),
                    onTap: () => onSelect(options[i + j].amount),
                    colorScheme: colorScheme,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
