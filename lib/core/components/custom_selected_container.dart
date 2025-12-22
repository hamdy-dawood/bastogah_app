import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:flutter/material.dart';

class CustomSelectedContainer extends StatelessWidget {
  const CustomSelectedContainer({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.only(left: 10, right: 20, top: 12, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.black),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.defaultColor,
                fontWeight: FontWeight.w700,
                fontFamily: AppConstance.appFomFamily,
                fontSize: 20,
              ),
            ),
          ),
          const Icon(Icons.arrow_drop_down, color: AppColors.black),
        ],
      ),
    );
  }
}
