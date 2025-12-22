import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RowIconText extends StatelessWidget {
  const RowIconText({
    super.key,
    this.icon,
    required this.text,
    this.fontColor,
    this.svgIcon,
    this.widthSpace,
  });

  final String? svgIcon;
  final IconData? icon;
  final String text;
  final Color? fontColor;
  final double? widthSpace;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        svgIcon != null
            ? SvgPicture.asset(svgIcon!, color: fontColor ?? Colors.white)
            : Icon(icon, color: fontColor ?? Colors.white),
        SizedBox(width: widthSpace ?? 10),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: fontColor ?? Colors.white),
          ),
        ),
      ],
    );
  }
}
