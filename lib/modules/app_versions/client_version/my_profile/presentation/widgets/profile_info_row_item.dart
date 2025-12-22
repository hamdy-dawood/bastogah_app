import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      highlightColor: WidgetStateColor.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 22,
                    width: 22,
                    child: SvgPicture.asset(iconPath, color: valueColor ?? const Color(0xff6E6E6E)),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      value,
                      textDirection: TextDirection.ltr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: valueColor ?? Colors.black.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            widget ?? const SizedBox(),
            const SizedBox(width: 5),
            onTap != null
                ? Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 18,
                  color: Colors.black.withValues(alpha: 0.5),
                )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
