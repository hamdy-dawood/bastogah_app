import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/components/svg_icons.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:flutter/material.dart';

class ProfileInfoRowItem extends StatelessWidget {
  final String iconPath;
  final String value;
  final Color? valueColor;
  final VoidCallback? onTap;
  final Widget? widget;

  const ProfileInfoRowItem({
    super.key,
    required this.iconPath,
    required this.value,
    this.valueColor,
    this.onTap,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      highlightColor: WidgetStateColor.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greyF5),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey9A.withValues(alpha: 0.2),
              blurRadius: 3,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.defaultColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SvgIcon(
                        icon: iconPath,
                        color: valueColor ?? AppColors.defaultColor,
                        height: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomText(
                    text: value,
                    color: AppColors.black1A,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            widget ?? const SizedBox(),
            const SizedBox(width: 5),
            onTap != null
                ? Icon(Icons.arrow_forward_ios_outlined, size: 18, color: AppColors.black4B)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
