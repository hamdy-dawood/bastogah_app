import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/components/components.dart';

class OtpFields extends StatelessWidget {
  final TextEditingController firstDigitController;
  final TextEditingController secondDigitController;
  final TextEditingController thirdDigitController;
  final TextEditingController forthDigitController;
  final TextEditingController fifthDigitController;
  final TextEditingController sixthDigitController;

  final FocusNode firstDigitFocus;
  final FocusNode secondDigitFocus;
  final FocusNode thirdDigitFocus;
  final FocusNode forthDigitFocus;
  final FocusNode fifthDigitFocus;
  final FocusNode sixthDigitFocus;

  const OtpFields({
    super.key,
    required this.firstDigitController,
    required this.secondDigitController,
    required this.thirdDigitController,
    required this.forthDigitController,
    required this.fifthDigitController,
    required this.sixthDigitController,
    required this.firstDigitFocus,
    required this.secondDigitFocus,
    required this.thirdDigitFocus,
    required this.forthDigitFocus,
    required this.fifthDigitFocus,
    required this.sixthDigitFocus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomTextFormField(
            controller: firstDigitController,
            focusNode: firstDigitFocus,
            keyboardType: TextInputType.number,
            align: TextAlign.center,
            onChanged: (v) {
              if (v.length == 1) {
                FocusScope.of(context).requestFocus(secondDigitFocus);
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            hint: 'x',
            validator: (v) {
              if (v!.isEmpty) {
                return '';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: CustomTextFormField(
            controller: secondDigitController,
            focusNode: secondDigitFocus,
            keyboardType: TextInputType.number,
            align: TextAlign.center,
            onChanged: (v) {
              if (v.length == 1) {
                FocusScope.of(context).requestFocus(thirdDigitFocus);
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            hint: 'x',
            validator: (v) {
              if (v!.isEmpty) {
                return '';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: CustomTextFormField(
            controller: thirdDigitController,
            focusNode: thirdDigitFocus,
            keyboardType: TextInputType.number,
            align: TextAlign.center,
            // backgroundColor: AppColors.defaultColor.withValues(alpha:0.1),
            onChanged: (v) {
              if (v.length == 1) {
                FocusScope.of(context).requestFocus(forthDigitFocus);
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            hint: 'x',
            validator: (v) {
              if (v!.isEmpty) {
                return '';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: CustomTextFormField(
            controller: forthDigitController,
            focusNode: forthDigitFocus,
            keyboardType: TextInputType.number,
            align: TextAlign.center,
            // backgroundColor: AppColors.defaultColor.withValues(alpha:0.1),
            onChanged: (v) {
              if (v.length == 1) {
                FocusScope.of(context).requestFocus(fifthDigitFocus);
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            hint: 'x',
            validator: (v) {
              if (v!.isEmpty) {
                return '';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: CustomTextFormField(
            controller: fifthDigitController,
            focusNode: fifthDigitFocus,
            keyboardType: TextInputType.number,
            align: TextAlign.center,
            // backgroundColor: AppColors.defaultColor.withValues(alpha:0.1),
            onChanged: (v) {
              if (v.length == 1) {
                FocusScope.of(context).requestFocus(sixthDigitFocus);
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            hint: 'x',
            validator: (v) {
              if (v!.isEmpty) {
                return '';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: CustomTextFormField(
            controller: sixthDigitController,
            focusNode: sixthDigitFocus,
            keyboardType: TextInputType.number,
            align: TextAlign.center,
            // backgroundColor: AppColors.defaultColor.withValues(alpha:0.1),
            onChanged: (v) {
              if (v.length == 1) {
                FocusScope.of(context).unfocus();
              }
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            hint: 'x',
            validator: (v) {
              if (v!.isEmpty) {
                return '';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
