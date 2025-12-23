import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/components/svg_icons.dart';
import 'package:flutter/material.dart';

class RowIconText extends StatelessWidget {
  const RowIconText({
    super.key,
    this.icon,
    required this.text,
    this.fontColor,
    this.svgIcon,
    this.widthSpace,
    this.height = 10,
  });

  final String? svgIcon;
  final IconData? icon;
  final String text;
  final Color? fontColor;
  final double? widthSpace;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        svgIcon != null
            ? SvgIcon(icon: svgIcon!, color: fontColor ?? Colors.white, height: height)
            : Icon(icon, color: fontColor ?? Colors.white),
        SizedBox(width: widthSpace ?? 10),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: CustomText(
            text: text,
            color: fontColor ?? Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
