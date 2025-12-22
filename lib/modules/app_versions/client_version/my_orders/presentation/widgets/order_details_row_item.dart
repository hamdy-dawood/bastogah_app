import 'package:flutter/material.dart';

import '../../../../../../core/utils/colors.dart';

class OrderDetailsRowItem extends StatelessWidget {
  final String title;
  final String value;
  final bool valueColored;

  const OrderDetailsRowItem({
    super.key,
    required this.title,
    required this.value,
    this.valueColored = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black.withValues(alpha: 0.5)),
        ),
        Text(
          '$value د.ع',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: valueColored ? AppColors.defaultColor : null),
        ),
      ],
    );
  }
}
