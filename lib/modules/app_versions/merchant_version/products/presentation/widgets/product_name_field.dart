import 'package:bastoga/core/components/default_text_form_field.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductNameField extends StatelessWidget {
  const ProductNameField({super.key});

  static TextEditingController productNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('اسم المنتج', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
            builder: (context, state) {
              return CustomTextFormField(
                controller: productNameController,
                hint: 'اضف اسم...',
                keyboardType: TextInputType.text,
                maxLines: 4,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '';
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
