import 'package:bastoga/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddButtonWithTextIcon extends StatelessWidget {
  const AddButtonWithTextIcon({
    super.key,
    required this.buttonText,
    this.onTap,
    this.icon,
    this.color,
    this.buttonColor,
  });

  final String buttonText;
  final String? icon;
  final VoidCallback? onTap;
  final Color? color, buttonColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: buttonColor ?? AppColors.blue2Color,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon!,
              height: 25,
              colorFilter: ColorFilter.mode(color ?? Colors.white, BlendMode.srcIn),
            ),
            const SizedBox(width: 5),
            Text(
              buttonText,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: color ?? Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
