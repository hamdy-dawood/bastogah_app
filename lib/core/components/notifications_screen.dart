// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
//
// import '../../modules/general_cubit/data/models/notification_model.dart' show NotificationsModel;
// import '../../modules/general_cubit/general_cubit.dart';
// import '../../modules/general_cubit/general_states.dart';
// import '../utils/colors.dart';
// import 'custom_text.dart';
// import 'default_emit_field.dart';
// import 'default_emit_loading.dart';
// import 'default_filled_button.dart';
// import 'list_view_pagination.dart';
//
//
// class NotificationsScreenAlert extends StatelessWidget {
//   const NotificationsScreenAlert({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => GeneralCubit()..getNotificationsData(),
//       child: NotificationsScreenData(),
//     );
//   }
// }
//
// class NotificationsScreenData extends StatelessWidget {
//   const NotificationsScreenData({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<GeneralCubit>();
//
//     return AlertDialog(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(
//             child: Row(
//               children: [
//                 Flexible(
//                   child: CustomText(
//                     text: "الإشعارات",
//                     color: AppColors.black2Color,
//                     fontSize: 20,
//                     fontWeight: FontWeightHelper.bold,
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 InkWell(
//                   onTap: () {
//                     context.pop();
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AddNotificationAlert();
//                       },
//                     );
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(3),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       color: AppColors.defaultColor,
//                     ),
//                     child: SvgIcon(
//                       icon: ImageManager.add,
//                       color: AppColors.white,
//                       height: 20,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           horizontalSpace(20.w),
//           IconButton(
//             pressed: () {
//               context.pop();
//             },
//             icon: const Icon(
//               Icons.close,
//               color: AppColors.black2Color,
//             ),
//           ),
//         ],
//       ),
//       content: BlocBuilder<GeneralCubit, GeneralStates>(
//         builder: (context, state) {
//           if (state is NotificationsLoadingState) {
//             return const DefaultCircleProgressIndicator();
//           } else if (state is NotificationsFailState) {
//             return EmitFailedItem(text: state.message);
//           } else if (cubit.notificationsList.isEmpty) {
//             return const SizedBox();
//           }
//
//           return ListViewPagination(
//             addEvent: () {
//               cubit.getNotificationsData();
//             },
//             itemCount: cubit.notificationHasReachedMax ? cubit.notificationsList.length : cubit.notificationsList.length + 1,
//             itemBuilder: (context, index) {
//               if (index == cubit.notificationsList.length) {
//                 return const EmitSmallestLoadingItem();
//               }
//               return NotificationContainer(
//                 notification: cubit.notificationsList[index],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class NotificationContainer extends StatelessWidget {
//   const NotificationContainer({super.key, required this.notification});
//
//   final NotificationsModel notification;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       child: Opacity(
//         opacity: /*notificationsEntity.isSeen ? 0.4 : */ 1,
//         child: Container(
//           padding: const EdgeInsets.all(15),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color:  AppColors.grey7Color, width: 1),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CustomText(
//                       text: notification.title,
//                       color: AppColors.defaultColor,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 20,
//                       maxLines: 2,
//                     ),
//                     SizedBox(height: 5),
//                     CustomText(
//                       text: notification.body,
//                       color: AppColors.blackColor,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 16,
//                       maxLines: 3,
//                       textAlign: TextAlign.start,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
