import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:bastoga/core/components/alert_pop_up.dart';
import 'package:bastoga/core/components/components.dart';
import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/components/overlay_loading.dart';
import 'package:bastoga/core/components/printer/mdsoft_printer.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/routing/routes.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/domain/entities/merchant_order_details_object.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/presentation/cubit/home_cubit.dart';
import 'package:bluetooth_thermal_printer_plus/bluetooth_thermal_printer_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/dialog_helper.dart';
import '../../../../client_version/my_orders/presentation/widgets/order_details_row_item.dart';
import '../../../../client_version/my_orders/presentation/widgets/order_items_widget.dart';
import '../../../../client_version/my_orders/presentation/widgets/time_date_box.dart';
import '../../../../driver_version/home/presentation/widgets/cancel_order_button.dart';
import '../widgets/details_finish_bottom_sheet.dart';
import '../widgets/details_pending_bottom_sheet.dart';
import '../widgets/merchant_client_row.dart';
import '../widgets/text_container.dart';

class MerchantOrderDetailsScreen extends StatelessWidget {
  const MerchantOrderDetailsScreen({super.key, required this.merchantOrderDetailsObject});

  final MerchantOrderDetailsObject merchantOrderDetailsObject;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: merchantOrderDetailsObject.blocContext.read<MerchantHomeCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          leading: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                context.pop();
              },
              child: CircleAvatar(
                backgroundColor: AppColors.defaultColor.withValues(alpha: 0.15),
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: AppColors.defaultColor,
                  size: 20,
                ),
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  text: "تفاصيل طلب #${merchantOrderDetailsObject.order.billNo}",
                  color: AppColors.black1A,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  maxLines: 3,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) => AppBills(order: merchantOrderDetailsObject.order),
                  //     );
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.all(6),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white.withValues(alpha: 0.9),
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: SvgPicture.asset(
                  //       ImageManager.print,
                  //       height: 22,
                  //       colorFilter: const ColorFilter.mode(
                  //         AppColors.defaultColor,
                  //         BlendMode.srcIn,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 10),
                  TextContainer(
                    text:
                        merchantOrderDetailsObject.order.status == 0
                            ? 'انتظار'
                            : merchantOrderDetailsObject.order.status == 1
                            ? 'انتظار سائق'
                            : merchantOrderDetailsObject.order.status == 2
                            ? 'قيد التنفيذ'
                            : merchantOrderDetailsObject.order.status == 3
                            ? 'مكتمل'
                            : 'ملغي',

                    buttonColor: AppColors.white,
                    borderColor:
                        merchantOrderDetailsObject.order.status == 0 ||
                                merchantOrderDetailsObject.order.status == 1
                            ? AppColors.yellowColor
                            : merchantOrderDetailsObject.order.status == 2
                            ? AppColors.blue2Color
                            : merchantOrderDetailsObject.order.status == 3
                            ? AppColors.green2Color
                            : AppColors.redE7,
                    fontColor:
                        merchantOrderDetailsObject.order.status == 0 ||
                                merchantOrderDetailsObject.order.status == 0 ||
                                merchantOrderDetailsObject.order.status == 1
                            ? AppColors.yellowColor
                            : merchantOrderDetailsObject.order.status == 2
                            ? AppColors.blue2Color
                            : merchantOrderDetailsObject.order.status == 3
                            ? AppColors.green2Color
                            : AppColors.redE7,
                  ),
                ],
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TimeAndDateBox(
                        icon: ImageManager.calenderIcon,
                        value: AppConstance.dateFormat.format(
                          DateTime.parse(merchantOrderDetailsObject.order.createdAt).toLocal(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TimeAndDateBox(
                        icon: ImageManager.clockIcon,
                        value: AppConstance.timeFormat.format(
                          DateTime.parse(merchantOrderDetailsObject.order.createdAt).toLocal(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (merchantOrderDetailsObject.order.items.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                  child: Text('طلب سائق', style: Theme.of(context).textTheme.titleLarge),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 4, right: 16, left: 16),
                child: Text(
                  'العميل',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: AppColors.grey2Color),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 16, left: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1),
                  ],
                ),
                child: Column(
                  children: [
                    MerchantClientRow(
                      icon: ImageManager.circleUserIcon,
                      title: 'اسم العميل',
                      subTitle: merchantOrderDetailsObject.order.clientName,
                    ),
                    const SizedBox(height: 16),
                    MerchantClientRow(
                      icon: ImageManager.circleLocationIcon,
                      title: 'العنوان',
                      subTitle:
                          "${merchantOrderDetailsObject.order.region?.name ?? merchantOrderDetailsObject.order.client?.region?.name ?? ""} , ${merchantOrderDetailsObject.order.city?.name ?? merchantOrderDetailsObject.order.client?.city?.name ?? ""}",
                    ),
                    const SizedBox(height: 16),
                    MerchantClientRow(
                      icon: ImageManager.circleHomeIcon,
                      title: 'نقطة دالة',
                      subTitle: merchantOrderDetailsObject.order.address,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 4, right: 16, left: 16),
                child: Text(
                  'السائق',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: AppColors.grey2Color),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 16, left: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              merchantOrderDetailsObject.order.driverName.isNotEmpty
                                  ? merchantOrderDetailsObject.order.driverName
                                  : "غير معين",
                              style: Theme.of(context).textTheme.bodyLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SetDriverButton(
                    //   merchantOrderDetailsObject: merchantOrderDetailsObject,
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 4, right: 16, left: 16),
                child: Text(
                  'السعر',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: AppColors.grey2Color),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 16, left: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1),
                  ],
                ),
                child: Column(
                  children: [
                    if (merchantOrderDetailsObject.order.totalAppliedDiscount > 0) ...[
                      OrderDetailsRowItem(
                        title: "إجمالي الخصم",
                        value: AppConstance.currencyFormat.format(
                          merchantOrderDetailsObject.order.totalAppliedDiscount,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    OrderDetailsRowItem(
                      title: 'مبلغ الطلب',
                      value: AppConstance.currencyFormat.format(
                        merchantOrderDetailsObject.order.itemsPrice +
                            merchantOrderDetailsObject.order.discountDiff,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OrderDetailsRowItem(
                      title: 'التوصيل',
                      value: AppConstance.currencyFormat.format(
                        merchantOrderDetailsObject.order.shippingPrice,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OrderDetailsRowItem(
                      title: 'الإجمالي',
                      value: AppConstance.currencyFormat.format(
                        merchantOrderDetailsObject.order.clientPrice,
                      ),
                      valueColor: AppColors.defaultColor,
                    ),
                  ],
                ),
              ),
              if (merchantOrderDetailsObject.order.items.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 4, right: 16, left: 16),
                  child: Text('المنتجات', style: Theme.of(context).textTheme.titleMedium),
                ),
              ...merchantOrderDetailsObject.order.items.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: OrderItems(item: e),
                ),
              ),
              if (merchantOrderDetailsObject.order.status == 4 &&
                  merchantOrderDetailsObject.order.canceledReason.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                      child: Text('سبب الالغاء', style: Theme.of(context).textTheme.titleMedium),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        merchantOrderDetailsObject.order.canceledReason,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 50),
            ],
          ),
        ),
        bottomNavigationBar: BlocListener<MerchantHomeCubit, MerchantHomeStates>(
          listener: (context, state) {
            if (state is ChangeStatusLoadingState) {
              showDialog(context: context, builder: (context) => const Loader());
            }
            if (state is ChangeStatusFailState) {
              context.pop();
              showDefaultFlushBar(
                context: context,
                color: AppColors.redE7.withValues(alpha: 0.6),
                messageText: state.message,
              );
            }
            if (state is ChangeStatusSuccessState) {
              context.pushNamedAndRemoveUntil(
                Routes.merchantHomeScreen,
                predicate: (route) => false,
              );
            }
          },
          child:
              merchantOrderDetailsObject.order.status == 0
                  ? DetailsPendingBottomSheet(
                    onTapAccept: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertPopUp(
                            alertTitle: "طباعة الطلب",
                            content: Center(
                              child: Text(
                                "هل ترغب في طباعة الطلب ايضا؟",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onButtonClick: () async {
                              context.pop();
                              String? isConnected = await BluetoothThermalPrinter.connectionStatus;

                              if (isConnected == "true") {
                                merchantOrderDetailsObject.blocContext
                                    .read<MerchantHomeCubit>()
                                    .editOrder(
                                      status: 1,
                                      orderId: merchantOrderDetailsObject.order.id,
                                    );
                                MdsoftPrinter.printBill(
                                  widget: BillDesign(order: merchantOrderDetailsObject.order),
                                );
                              } else {
                                String mac = Caching.getData(key: "printer_mac") ?? "";
                                String printer = Caching.getData(key: "printer") ?? "Sunmi";

                                print("ddd: ${printer}");

                                if (printer == "Sunmi") {
                                  merchantOrderDetailsObject.blocContext
                                      .read<MerchantHomeCubit>()
                                      .editOrder(
                                        status: 1,
                                        orderId: merchantOrderDetailsObject.order.id,
                                      );
                                  MdsoftPrinter.printBill(
                                    widget: BillDesign(order: merchantOrderDetailsObject.order),
                                  );
                                } else {
                                  if (mac.isEmpty) {
                                    context.pushNamed(Routes.printerScreen);
                                  } else {
                                    OverlayLoadingProgress.start(context);
                                    MdsoftPrinter.setConnect(
                                      mac,
                                      printer,
                                      reConnect: true,
                                    ).whenComplete(() {
                                      Future.delayed(const Duration(seconds: 2), () {
                                        OverlayLoadingProgress.stop();
                                        merchantOrderDetailsObject.blocContext
                                            .read<MerchantHomeCubit>()
                                            .editOrder(
                                              status: 1,
                                              orderId: merchantOrderDetailsObject.order.id,
                                            );
                                        MdsoftPrinter.printBill(
                                          widget: BillDesign(
                                            order: merchantOrderDetailsObject.order,
                                          ),
                                        );
                                      });
                                    });
                                  }
                                }
                              }
                            },
                            onButtonCancel: () {
                              context.pop();
                              merchantOrderDetailsObject.blocContext
                                  .read<MerchantHomeCubit>()
                                  .editOrder(
                                    status: 1,
                                    orderId: merchantOrderDetailsObject.order.id,
                                  );
                            },
                          );
                        },
                      );
                    },
                    onTapReject: () {
                      final TextEditingController rejectedController = TextEditingController();
                      DialogHelper.showCustomDialog(
                        context: context,
                        alertDialog: AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("سبب الرفض", style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 10),
                              CustomTextFormField(
                                controller: rejectedController,
                                keyboardType: TextInputType.text,
                                hint: 'اكتب سبب الرفض',
                                textInputAction: TextInputAction.done,
                              ),
                            ],
                          ),
                          actions: [
                            CancelOrderButton(
                              text: "رجوع",
                              onTap: () {
                                // close dialog
                                context.pop();
                              },
                            ),
                            CancelOrderButton(
                              text: "رفض",
                              onTap: () {
                                if (rejectedController.text.isNotEmpty) {
                                  merchantOrderDetailsObject.blocContext
                                      .read<MerchantHomeCubit>()
                                      .editOrder(
                                        status: 4,
                                        orderId: merchantOrderDetailsObject.order.id,
                                        canceledReason: rejectedController.text,
                                      )
                                      .whenComplete(() {
                                        // close dialog
                                        context.pop();
                                      });
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  )
                  : merchantOrderDetailsObject.order.status == 2
                  ? merchantOrderDetailsObject.order.driverName.isNotEmpty
                      ? _buildDetailsFinishBottomSheet(context: context)
                      : const SizedBox()
                  : const SizedBox(),
        ),
      ),
    );
  }

  Widget _buildDetailsFinishBottomSheet({required BuildContext context}) {
    final TextEditingController rejectedController = TextEditingController();
    return DetailsFinishBottomSheet(
      onTapFinish: () {
        merchantOrderDetailsObject.blocContext.read<MerchantHomeCubit>().editOrder(
          status: 3,
          orderId: merchantOrderDetailsObject.order.id,
        );
      },
      onTapCancel: () {
        DialogHelper.showCustomDialog(
          context: context,
          alertDialog: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("سبب الرفض", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: rejectedController,
                  keyboardType: TextInputType.text,
                  hint: 'اكتب سبب الرفض',
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
            actions: [
              CancelOrderButton(
                text: "رجوع",
                onTap: () {
                  // close dialog
                  context.pop();
                },
              ),
              CancelOrderButton(
                text: "رفض",
                onTap: () {
                  if (rejectedController.text.isNotEmpty) {
                    merchantOrderDetailsObject.blocContext
                        .read<MerchantHomeCubit>()
                        .editOrder(
                          status: 4,
                          orderId: merchantOrderDetailsObject.order.id,
                          canceledReason: rejectedController.text,
                        )
                        .whenComplete(() {
                          // close dialog
                          context.pop();
                        });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// class SetDriverButton extends StatefulWidget {
//   final MerchantOrderDetailsObject merchantOrderDetailsObject;
//
//   const SetDriverButton({
//     super.key,
//     required this.merchantOrderDetailsObject,
//   });
//
//   @override
//   State<SetDriverButton> createState() => _SetDriverButtonState();
// }
//
// class _SetDriverButtonState extends State<SetDriverButton> {
//   final TextEditingController searchDriverController = TextEditingController();
//
//   @override
//   void dispose() {
//     searchDriverController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<MerchantHomeCubit, MerchantHomeStates>(
//       listener: (context, state) {
//         if (state is SetDriverLoadingState) {
//           showDialog(
//             context: context,
//             builder: (context) => const Loader(),
//           );
//         }
//         if (state is SetDriverFailState) {
//           context.pop();
//           showDefaultFlushBar(
//             context: context,
//             color: AppColors.redColor.withValues(alpha:0.6),
//             messageText: state.message,
//           );
//         }
//         if (state is SetDriverSuccessState) {
//           context.pop();
//           context.pop();
//           showDefaultFlushBar(
//             context: context,
//             color: AppColors.greenColor.withValues(alpha:0.6),
//             notificationType: ToastificationType.success,
//             messageText: state.message,
//           );
//           context.read<MerchantHomeCubit>().getOrders(
//                 page: 0,
//                 status: widget.merchantOrderDetailsObject.tabIndex,
//                 date: context.read<MerchantHomeCubit>().date,
//               );
//         }
//       },
//       builder: (context, state) {
//         return widget.merchantOrderDetailsObject.order.driverName.isNotEmpty
//             ? widget.merchantOrderDetailsObject.order.status != 3
//                 ? InkWell(
//                     onTap: () {
//                       SheetHelper.showCustomSheet(
//                         context: context,
//                         title: 'اختيار سائق',
//                         bottomSheetContent: BlocProvider.value(
//                           value: context.read<MerchantHomeCubit>()
//                             ..getDrivers(
//                               page: 0,
//                               searchText: searchDriverController.text,
//                             ),
//                           child: Column(
//                             children: [
//                               DefaultTextFormField(
//                                 controller: searchDriverController,
//                                 type: TextInputType.text,
//                                 hint: 'البحث باسم السائق',
//                                 onSubmitted: (v) {
//                                   FocusScope.of(context).unfocus();
//                                   context.read<MerchantHomeCubit>().getDrivers(
//                                         page: 0,
//                                         searchText: searchDriverController.text,
//                                       );
//                                 },
//                               ),
//                               const SizedBox(
//                                 height: 16,
//                               ),
//                               Expanded(
//                                 child: BlocBuilder<MerchantHomeCubit, MerchantHomeStates>(
//                                   builder: (context, state) {
//                                     if (state is LoadingState) {
//                                       return const DefaultCircleProgressIndicator();
//                                     }
//                                     if (context.read<MerchantHomeCubit>().drivers != null && context.read<MerchantHomeCubit>().drivers!.isNotEmpty) {
//                                       return Material(
//                                         color: AppColors.lightWhiteColor,
//                                         child: DefaultListView(
//                                           noPadding: true,
//                                           refresh: (page) => context.read<MerchantHomeCubit>().getDrivers(
//                                                 page: page,
//                                                 searchText: searchDriverController.text,
//                                               ),
//                                           itemBuilder: (_, index) => Padding(
//                                             padding: const EdgeInsets.only(bottom: 8.0),
//                                             child: Theme(
//                                               data: ThemeData(
//                                                 highlightColor: Colors.transparent,
//                                                 splashFactory: NoSplash.splashFactory,
//                                               ),
//                                               child: ListTile(
//                                                 tileColor: Colors.white,
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius: BorderRadius.circular(10),
//                                                   side: BorderSide(
//                                                     color: widget.merchantOrderDetailsObject.order.driverName == context.read<MerchantHomeCubit>().drivers![index].displayName ? AppColors.defaultColor : Colors.transparent,
//                                                   ),
//                                                 ),
//                                                 title: Text(
//                                                   context.read<MerchantHomeCubit>().drivers![index].displayName,
//                                                   style: Theme.of(context).textTheme.bodyMedium,
//                                                 ),
//                                                 onTap: () {
//                                                   context.pop();
//                                                   // merchantOrderDetailsObject.order.driverName = context.read<MerchantHomeCubit>().drivers![index].displayName;
//                                                   context.read<MerchantHomeCubit>().setDriver(
//                                                         orderId: widget.merchantOrderDetailsObject.order.id,
//                                                         driverId: context.read<MerchantHomeCubit>().drivers![index].id,
//                                                       );
//                                                 },
//                                               ),
//                                             ),
//                                           ),
//                                           length: context.read<MerchantHomeCubit>().drivers!.length,
//                                           hasMore: false,
//                                           onRefreshCall: () => context.read<MerchantHomeCubit>().getDrivers(
//                                                 page: 0,
//                                                 searchText: searchDriverController.text,
//                                               ),
//                                         ),
//                                       );
//                                     } else {
//                                       return NoData(
//                                         refresh: () => context.read<MerchantHomeCubit>().getDrivers(
//                                               page: 0,
//                                               searchText: searchDriverController.text,
//                                             ),
//                                       );
//                                     }
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         isForm: true,
//                       );
//                     },
//                     child: const TextContainer(
//                       text: 'تغيير',
//                       buttonColor: AppColors.defaultColor,
//                       fontColor: Colors.white,
//                       borderRadius: 5,
//                     ),
//                   )
//                 : const SizedBox()
//             : InkWell(
//                 onTap: () {
//                   SheetHelper.showCustomSheet(
//                     context: context,
//                     title: 'اختيار سائق',
//                     bottomSheetContent: BlocProvider.value(
//                       value: context.read<MerchantHomeCubit>()
//                         ..getDrivers(
//                           page: 0,
//                           searchText: searchDriverController.text,
//                         ),
//                       child: Column(
//                         children: [
//                           DefaultTextFormField(
//                             controller: searchDriverController,
//                             type: TextInputType.text,
//                             hint: 'البحث باسم السائق',
//                             onSubmitted: (v) {
//                               FocusScope.of(context).unfocus();
//                               context.read<MerchantHomeCubit>().getDrivers(
//                                     page: 0,
//                                     searchText: searchDriverController.text,
//                                   );
//                             },
//                           ),
//                           const SizedBox(
//                             height: 16,
//                           ),
//                           Expanded(
//                             child: BlocBuilder<MerchantHomeCubit, MerchantHomeStates>(
//                               builder: (context, state) {
//                                 if (state is LoadingState) {
//                                   return const DefaultCircleProgressIndicator();
//                                 }
//                                 if (context.read<MerchantHomeCubit>().drivers != null && context.read<MerchantHomeCubit>().drivers!.isNotEmpty) {
//                                   return Material(
//                                     color: AppColors.lightWhiteColor,
//                                     child: DefaultListView(
//                                       noPadding: true,
//                                       refresh: (page) => context.read<MerchantHomeCubit>().getDrivers(
//                                             page: page,
//                                             searchText: searchDriverController.text,
//                                           ),
//                                       itemBuilder: (_, index) => Padding(
//                                         padding: const EdgeInsets.only(bottom: 8.0),
//                                         child: Theme(
//                                           data: ThemeData(
//                                             highlightColor: Colors.transparent,
//                                             splashFactory: NoSplash.splashFactory,
//                                           ),
//                                           child: ListTile(
//                                             tileColor: Colors.white,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(10),
//                                               side: BorderSide(
//                                                 color: widget.merchantOrderDetailsObject.order.driverName == context.read<MerchantHomeCubit>().drivers![index].displayName ? AppColors.defaultColor : Colors.transparent,
//                                               ),
//                                             ),
//                                             title: Text(
//                                               context.read<MerchantHomeCubit>().drivers![index].displayName,
//                                               style: Theme.of(context).textTheme.bodyMedium,
//                                             ),
//                                             onTap: () {
//                                               context.pop();
//                                               // merchantOrderDetailsObject.order.driverName = context.read<MerchantHomeCubit>().drivers![index].displayName;
//                                               context.read<MerchantHomeCubit>().setDriver(
//                                                     orderId: widget.merchantOrderDetailsObject.order.id,
//                                                     driverId: context.read<MerchantHomeCubit>().drivers![index].id,
//                                                   );
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                       length: context.read<MerchantHomeCubit>().drivers!.length,
//                                       hasMore: false,
//                                       onRefreshCall: () => context.read<MerchantHomeCubit>().getDrivers(
//                                             page: 0,
//                                             searchText: searchDriverController.text,
//                                           ),
//                                     ),
//                                   );
//                                 } else {
//                                   return NoData(
//                                     refresh: () => context.read<MerchantHomeCubit>().getDrivers(
//                                           page: 0,
//                                           searchText: searchDriverController.text,
//                                         ),
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     isForm: true,
//                   );
//                 },
//                 child: const TextContainer(
//                   text: 'تعيين',
//                   buttonColor: AppColors.defaultColor,
//                   fontColor: Colors.white,
//                   borderRadius: 5,
//                 ),
//               );
//       },
//     );
//   }
// }
