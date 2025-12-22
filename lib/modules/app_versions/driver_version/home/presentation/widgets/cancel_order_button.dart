import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:flutter/material.dart';

class CancelOrderButton extends StatelessWidget {
  final void Function()? onTap;

  const CancelOrderButton({super.key, required this.onTap, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: AppColors.greyF5, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: CustomText(
            text: text,
            color: AppColors.grey9A,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
