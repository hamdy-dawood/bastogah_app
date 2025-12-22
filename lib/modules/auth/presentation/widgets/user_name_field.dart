import 'package:flutter/material.dart';

import '../../../../core/components/components.dart';

class UserNameField extends StatefulWidget {
  const UserNameField({super.key});

  static TextEditingController userNameController = TextEditingController();

  @override
  State<UserNameField> createState() => _UserNameFieldState();
}

class _UserNameFieldState extends State<UserNameField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomTextFormField(
        controller: UserNameField.userNameController,
        hint: 'اسم المستخدم',
        validator: (v) {
          if (v!.isEmpty) {
            return '';
          }
          return null;
        },
        keyboardType: TextInputType.text,
      ),
    );
  }
}
