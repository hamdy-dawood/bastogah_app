import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/colors.dart';
import 'custom_text.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.title = "",
    required this.hint,
    this.hintColor,
    this.fontSize,
    this.onChanged,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.interactiveSelection = true,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.autoValidate = AutovalidateMode.onUserInteraction,
    this.isLastInput = false,
    this.readOnly = false,
    this.controller,
    this.validator,
    this.borderRadius = 12,
    this.inputFormatters = const [],
    this.fontFamily = "cairo",
    this.align = TextAlign.start,
    this.maxLength,
    this.onTap,
    this.maxLines,
    this.textInputAction,
    this.titleColor,
    this.titleFontWeight,
    this.titleFontSize = 14,
    this.textDirection,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 10),
    this.isDense,
    this.fillColor,
    this.filled,
    this.minLines,
    this.expands,
    this.focusNode,
  });

  final String title;
  final double titleFontSize;
  final FontWeight? titleFontWeight;
  final Color? titleColor;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String hint, fontFamily;
  final Color? hintColor;
  final double? fontSize;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText, interactiveSelection;
  final TextInputType? keyboardType;
  final AutovalidateMode autoValidate;
  final bool isLastInput, readOnly;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final double borderRadius;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign align;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final TextDirection? textDirection;
  final EdgeInsetsGeometry? contentPadding;
  final bool? isDense;
  final Color? fillColor;
  final bool? filled;
  final int? maxLength, maxLines, minLines;
  final bool? expands;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: CustomText(
              text: title,
              color: titleColor ?? AppColors.black1A,
              fontSize: titleFontSize,
              fontWeight: titleFontWeight ?? FontWeight.w400,
              maxLines: 5,
            ),
          ),
        TextFormField(
          focusNode: focusNode,
          readOnly: readOnly,
          minLines: minLines ?? 1,
          maxLines: maxLines,
          expands: expands ?? false,
          onTap: onTap,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          textDirection: textDirection,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: AppColors.black1A,
            fontSize: fontSize ?? 16,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w400,
          ),
          controller: controller,
          autovalidateMode: autoValidate,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textInputAction:
              textInputAction ?? (isLastInput ? TextInputAction.done : TextInputAction.next),
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          textAlign: align,
          // obscuringCharacter: "●",
          enableInteractiveSelection: interactiveSelection,
          decoration: InputDecoration(
            filled: filled,
            fillColor: fillColor,
            isDense: isDense,
            contentPadding: contentPadding,
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: hintColor ?? AppColors.grey9A,
              fontSize: fontSize ?? 14,
              fontWeight: FontWeight.w400,
              fontFamily: fontFamily,
            ),
            errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: fontFamily,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(width: 1.5, color: fillColor ?? AppColors.greyE0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(width: 1.5, color: fillColor ?? AppColors.greyE0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: AppColors.defaultColor),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: AppColors.redE7),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: AppColors.redE7),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      ],
    );
  }
}
