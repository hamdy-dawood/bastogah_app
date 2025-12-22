import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/components/components.dart';

class RegisterPhoneField extends StatefulWidget {
  const RegisterPhoneField({super.key});

  static TextEditingController phoneController = TextEditingController();

  @override
  State<RegisterPhoneField> createState() => _RegisterPhoneFieldState();
}

class _RegisterPhoneFieldState extends State<RegisterPhoneField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('رقم الهاتف', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: RegisterPhoneField.phoneController,
            hint: 'ادخل رقم الهاتف...',
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "";
              }
              if (!value.startsWith('07')) {
                return "رقم الهاتف يجب ان يبدأ ب 07 !";
              }
              if (value.length != 11) {
                return "رقم الهاتف يجب ان يكون 11 رقم !";
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}
