import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:flutter/material.dart';

class AcceptOrderButton extends StatelessWidget {
  final void Function()? onTap;

  const AcceptOrderButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.defaultColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: CustomText(
            text: "قبول الطلب",
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
