import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/components/svg_icons.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:flutter/material.dart';

class MerchantClientRow extends StatelessWidget {
  const MerchantClientRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  final String icon, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.defaultColor.withValues(alpha: 0.15),
            child: SvgIcon(icon: icon, color: AppColors.defaultColor, height: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             if(title.isNotEmpty) CustomText(
                text: title,
                color: AppColors.grey9A,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              subTitle.isNotEmpty
                  ? Column(
                    children: [
                      const SizedBox(height: 3),
                      CustomText(
                        text: subTitle,
                        color: AppColors.black4B,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
