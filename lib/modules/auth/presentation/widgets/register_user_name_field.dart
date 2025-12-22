import 'package:flutter/material.dart';

import '../../../../core/components/components.dart';

class RegisterUserNameField extends StatefulWidget {
  const RegisterUserNameField({super.key});

  static TextEditingController userNameController = TextEditingController();

  @override
  State<RegisterUserNameField> createState() => _RegisterUserNameFieldState();
}

class _RegisterUserNameFieldState extends State<RegisterUserNameField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('اسم المستخدم', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: RegisterUserNameField.userNameController,
            hint: 'اسم المستخدم',
            keyboardType: TextInputType.text,
            validator: (v) {
              if (v!.isEmpty) {
                return '';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
