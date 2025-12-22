import 'package:bastoga/core/components/default_text_form_field.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestDriverTotalPriceField extends StatelessWidget {
  const RequestDriverTotalPriceField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الاجمالي', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
            builder: (context, state) {
              return CustomTextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: context.read<MerchantProductsCubit>().requestDriverTotalPrice,
                ),
                hint: context.read<MerchantProductsCubit>().requestDriverTotalPrice,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text("دينار عراقي", style: Theme.of(context).textTheme.bodySmall),
                ),
                validator: (value) {
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
