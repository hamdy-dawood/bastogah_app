import 'package:bastoga/core/components/default_text_form_field.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestDriverPhoneField extends StatelessWidget {
  const RequestDriverPhoneField({super.key});

  static TextEditingController requestDriverPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('رقم هاتف المستلم', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
            builder: (context, state) {
              return CustomTextFormField(
                controller: requestDriverPhoneController,
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
              );
            },
          ),
        ],
      ),
    );
  }
}
