import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import 'custom_text.dart';

class CustomElevated extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color? btnColor;
  final double hSize, wSize, fontSize, borderRadius;
  final VoidCallback? press;
  final FontWeight fontWeight;
  final String fontFamily;

  const CustomElevated({
    super.key,
    required this.text,
    this.press,
    this.textColor = Colors.white,
    this.btnColor,
    this.hSize = 50,
    this.wSize = 1,
    this.fontSize = 16,
    this.borderRadius = 8,
    this.fontFamily = "cairo",
    this.fontWeight = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        backgroundColor: btnColor ?? AppColors.defaultColor,
        fixedSize: Size(wSize * context.screenWidth, hSize),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: CustomText(
          text: text,
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          textAlign: TextAlign.center,
          fontFamily: fontFamily,
        ),
      ),
    );
  }
}
