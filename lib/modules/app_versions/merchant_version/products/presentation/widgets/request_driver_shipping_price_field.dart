import 'package:bastoga/core/components/default_text_form_field.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../client_version/home/presentation/widgets/city_field.dart';

class RequestDriverShippingPriceField extends StatelessWidget {
  const RequestDriverShippingPriceField({super.key});

  static TextEditingController requestDriverShippingPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('سعر التوصيل', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
            builder: (context, state) {
              return CustomTextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text:
                      CityField.cityPrice != null
                          ? AppConstance.currencyFormat.format(CityField.cityPrice)
                          : "0",
                ),
                hint: CityField.cityPrice.toString(),
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
          // BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
          //   builder: (context, state) {
          //     return DefaultTextFormField(
          //       controller: requestDriverShippingPriceController,
          //       hint: '0',
          //       type: TextInputType.number,
          //       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          //       suffixIcon: Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 12),
          //         child: Text(
          //           "دينار عراقي",
          //           style: Theme.of(context).textTheme.bodySmall,
          //         ),
          //       ),
          //       validate: (value) {
          //         if (value!.isEmpty) {
          //           return '';
          //         }
          //         return null;
          //       },
          //       onChange: (value) {
          //         context.read<MerchantProductsCubit>().changeRequestDriverTotalPrice();
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
