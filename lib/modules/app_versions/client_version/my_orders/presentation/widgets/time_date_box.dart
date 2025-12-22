import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/components/svg_icons.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:flutter/material.dart';

class TimeAndDateBox extends StatelessWidget {
  final String icon;
  final String value;

  const TimeAndDateBox({super.key, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyE0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgIcon(icon: icon, color: AppColors.grey9A, height: 20),
          const SizedBox(width: 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: CustomText(
              text: value,
              color: AppColors.grey9A,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
