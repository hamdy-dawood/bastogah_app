// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bastoga/core/components/default_text_form_field.dart';
// import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_cubit.dart';
// import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_states.dart';
//
// class RequestDriverNameField extends StatelessWidget {
//   const RequestDriverNameField({
//     super.key,
//   });
//
//   static TextEditingController requestDriverNameController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'اسم المستلم',
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           const SizedBox(
//             height: 8,
//           ),
//           BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
//             builder: (context, state) {
//               return DefaultTextFormField(
//                 controller: requestDriverNameController,
//                 hint: 'اضف اسم...',
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
