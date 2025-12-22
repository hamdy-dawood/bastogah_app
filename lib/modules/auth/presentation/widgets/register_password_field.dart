import 'package:flutter/material.dart';

import '../../../../core/components/components.dart';
import '../../../../core/utils/colors.dart';

class RegisterPasswordField extends StatefulWidget {
  const RegisterPasswordField({super.key});

  static TextEditingController passwordController = TextEditingController();

  @override
  State<RegisterPasswordField> createState() => _RegisterPasswordFieldState();
}

class _RegisterPasswordFieldState extends State<RegisterPasswordField> {
  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('كلمة المرور', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: RegisterPasswordField.passwordController,
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
        ],
      ),
    );
  }
}
