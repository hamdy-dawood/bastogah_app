import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:flutter/material.dart';

class OrderDetailsRowItem extends StatelessWidget {
  final String title;
  final String value;
  final Color? titleColor;
  final Color? valueColor;

  const OrderDetailsRowItem({
    super.key,
    required this.title,
    required this.value,
    this.titleColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            color: titleColor ?? AppColors.black4B,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          CustomText(
            text: "$value د.ع",
            color: valueColor ?? AppColors.black4B,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ],
      ),
    );
  }
}
