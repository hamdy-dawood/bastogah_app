import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:flutter/material.dart';

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
        CustomText(
          text: title,
          color: AppColors.black4B,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        CustomText(
          text: "$value د.ع",
          // check color
          color: valueColored ? AppColors.defaultColor : AppColors.black4B,
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
      ],
    );
  }
}
