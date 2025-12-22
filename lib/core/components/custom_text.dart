import 'package:flutter/material.dart';

import '../utils/constance.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    required this.color,
    required this.fontWeight,
    required this.fontSize,
    this.textDecoration = TextDecoration.none,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.textScaleFactor,
    this.fontFamily = AppConstance.appFomFamily,
    this.height = 1.5,
    this.textDirection,
  });

  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double fontSize;
  final TextDecoration textDecoration;
  final TextAlign textAlign;
  final int? maxLines;
  final double? height;
  final double? textScaleFactor;
  final String fontFamily;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaleFactor: textScaleFactor,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textDirection: textDirection,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
        height: height,
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: textDecoration,
        fontFamily: fontFamily,
      ),
    );
  }
}
