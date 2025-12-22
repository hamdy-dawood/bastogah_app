import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:flutter/material.dart';

import '../../../../core/components/components.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/utils/colors.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  static TextEditingController passwordController = TextEditingController();

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: PasswordField.passwordController,
            hint: 'كلمة المرور',
            keyboardType: TextInputType.text,
            validator: (v) {
              if (v!.isEmpty) {
                return '';
              }
              return null;
            },
            obscureText: isObscureText,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isObscureText = !isObscureText;
                });
              },
              child: Icon(
                isObscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.defaultColor,
                size: 18,
              ),
            ),
            textInputAction: TextInputAction.done,
            maxLines: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.transparent)),
                onPressed: () {
                  context.pushNamed(Routes.forgetPassword, arguments: context);
                },
                child: CustomText(
                  text: "نسيت كلمة المرور؟",
                  color: AppColors.black1A,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
