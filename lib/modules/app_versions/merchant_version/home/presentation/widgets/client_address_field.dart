// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bastoga/core/components/default_text_form_field.dart';
//
// import '../cubit/home_cubit.dart';
//
// class ClientAddressField extends StatelessWidget {
//   const ClientAddressField({super.key, required this.cubit});
//
//   final HomeCubit cubit;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'عنوان العميل',
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           const SizedBox(height: 8),
//           BlocBuilder<HomeCubit, HomeStates>(
//             builder: (context, state) {
//               return DefaultTextFormField(
//                 controller: cubit.addClientAddressController,
//                 hint: 'ادخل عنوان العميل...',
//                 type: TextInputType.text,
//                 validate: (value) {
//                   if (value!.isEmpty) {
//                     return "ادخل العنوان !";
//                   }
//                   return null;
//                 },
//                 nextInputAction: TextInputAction.done,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
