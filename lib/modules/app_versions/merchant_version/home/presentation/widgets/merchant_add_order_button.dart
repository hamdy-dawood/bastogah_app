// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bastoga/core/components/default_emit_loading.dart';
// import 'package:bastoga/core/components/default_filled_button.dart';
// import 'package:bastoga/core/components/default_flushbar.dart';
// import 'package:bastoga/core/helpers/context_extention.dart';
// import 'package:bastoga/core/routing/routes.dart';
// import 'package:bastoga/core/utils/colors.dart';
//
// import '../cubit/home_cubit.dart';
//
// class MerchantAddOrderButton extends StatelessWidget {
//   const MerchantAddOrderButton({super.key, required this.cubit});
//
//   final HomeCubit cubit;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: BlocConsumer<HomeCubit, HomeStates>(
//         listener: (context, state) {
//           if (state is MerchantAddOrderFailedState) {
//             showDefaultFlushBar(
//               context: context,
//               color: AppColors.redColor,
//               messageText: state.msg,
//             );
//           } else if (state is HomeNetworkErrorState) {
//             showDefaultFlushBar(
//               context: context,
//               color: AppColors.redColor,
//               messageText: "افحص الانترنت",
//             );
//           } else if (state is MerchantAddOrderSuccessState) {
//             context.pushNamed(Routes.merchantHomeScreen);
//           }
//         },
//         builder: (context, state) {
//           if (state is MerchantAddOrderLoadingState) {
//             return const SizedBox(
//                 height: 40, child: DefaultCircleProgressIndicator());
//           }
//           return CustomElevated(
//             title: 'تاكيد الاضافة',
//             press: () {
//               cubit.addNewOrder();
//             },
//           );
//         },
//       ),
//     );
//   }
// }
