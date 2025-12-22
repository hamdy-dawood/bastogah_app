// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bastoga/core/components/default_text_form_field.dart';
//
// import '../cubit/home_cubit.dart';
//
// class ClientPhoneField extends StatelessWidget {
//   const ClientPhoneField({super.key, required this.cubit});
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
//             'هاتف العميل',
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           const SizedBox(height: 8),
//           BlocBuilder<HomeCubit, HomeStates>(
//             builder: (context, state) {
//               return DefaultTextFormField(
//                 controller: cubit.addClientPhoneController,
//                 hint: 'ادخل رقم هاتف العميل...',
//                 type: TextInputType.number,
//                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 validate: (value) {
//                   if (value!.isEmpty) {
//                     return "";
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
