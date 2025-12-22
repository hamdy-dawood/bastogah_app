// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bastoga/core/components/default_text_form_field.dart';
// import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_cubit.dart';
// import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_states.dart';
//
// class RequestDriverAddressField extends StatelessWidget {
//   const RequestDriverAddressField({
//     super.key,
//   });
//
//   static TextEditingController requestDriverAddressController =
//       TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'نقطة دالة',
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           const SizedBox(
//             height: 8,
//           ),
//           BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
//             builder: (context, state) {
//               return DefaultTextFormField(
//                 controller: requestDriverAddressController,
//                 hint: 'اضف نقطة دالة...',
//                 type: TextInputType.text,
//                 validate: (value) {
//                   if (value!.isEmpty) {
//                     return '';
//                   }
//                   return null;
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
