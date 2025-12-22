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
  });

  final String text;
  final Color buttonColor, fontColor;
  final Color? borderColor;
  final double? borderRadius;

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
        child: CustomText(text: text, color: fontColor, fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }
}
