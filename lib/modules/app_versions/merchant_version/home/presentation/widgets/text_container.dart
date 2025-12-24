import 'package:bastoga/core/components/custom_text.dart';
import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  const TextContainer({
    super.key,
    required this.text,
    required this.buttonColor,
    this.borderColor,
    required this.fontColor,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
  });

  final String text;
  final Color buttonColor, fontColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        border: Border.all(color: borderColor ?? buttonColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: CustomText(
          text: text,
          color: fontColor,
          fontWeight: fontWeight ?? FontWeight.w700,
          fontSize: fontSize ?? 16,
        ),
      ),
    );
  }
}
