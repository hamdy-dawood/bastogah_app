import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:bastoga/core/components/alert_pop_up.dart';
import 'package:bastoga/core/components/components.dart';
import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/components/overlay_loading.dart';
import 'package:bastoga/core/components/printer/mdsoft_printer.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/routing/routes.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/presentation/widgets/order_details_row_item.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/presentation/widgets/order_items_widget.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/presentation/widgets/time_date_box.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/domain/entities/merchant_order_details_object.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/presentation/cubit/home_cubit.dart';
import 'package:bluetooth_thermal_printer_plus/bluetooth_thermal_printer_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                            ? 'قيد الانتظار'
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
                            ? AppColors.blue005
                            : merchantOrderDetailsObject.order.status == 3
                            ? AppColors.green2Color
                            : AppColors.redE7,
                    fontColor:
                        merchantOrderDetailsObject.order.status == 0 ||
                                merchantOrderDetailsObject.order.status == 0 ||
                                merchantOrderDetailsObject.order.status == 1
                            ? AppColors.yellowColor
                            : merchantOrderDetailsObject.order.status == 2
                            ? AppColors.blue005
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
                  padding: const EdgeInsets.all(12),
                  child: CustomText(
                    text: "طلب سائق",
                    color: AppColors.black1A,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.greyFC,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.greyF5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: CustomText(
                        text: "الزبون",
                        color: AppColors.black4B,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    MerchantClientRow(
                      icon: ImageManager.user,
                      title: "اسم الزبون:",
                      subTitle: merchantOrderDetailsObject.order.clientName,
                    ),
                    AppConstance.horizontalDivider,
                    MerchantClientRow(
                      icon: ImageManager.home2,
                      title: "العنوان:",
                      subTitle:
                          "${merchantOrderDetailsObject.order.region?.name ?? merchantOrderDetailsObject.order.client?.region?.name ?? ""} , ${merchantOrderDetailsObject.order.city?.name ?? merchantOrderDetailsObject.order.client?.city?.name ?? ""}",
                    ),
                    AppConstance.horizontalDivider,
                    MerchantClientRow(
                      icon: ImageManager.phoneIcon,
                      title: "رقم الهاتف:",
                      subTitle: merchantOrderDetailsObject.order.phone,
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),

              SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.greyFC,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.greyF5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: CustomText(
                        text: "السائق",
                        color: AppColors.black4B,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    MerchantClientRow(
                      icon: ImageManager.user,
                      title: "",
                      subTitle:
                          merchantOrderDetailsObject.order.driverName.isNotEmpty
                              ? merchantOrderDetailsObject.order.driverName
                              : "لم يتم التعيين بعد",
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.greyFC,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.greyF5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: CustomText(
                        text: "السعر",
                        color: AppColors.black4B,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),

                    if (merchantOrderDetailsObject.order.totalAppliedDiscount > 0) ...[
                      OrderDetailsRowItem(
                        title: "إجمالي الخصم",
                        value: AppConstance.currencyFormat.format(
                          merchantOrderDetailsObject.order.totalAppliedDiscount,
                        ),
                        valueColor: AppColors.redE7,
                      ),
                      AppConstance.horizontalDivider,
                    ],
                    OrderDetailsRowItem(
                      title: "مبلغ الطلب",
                      value: AppConstance.currencyFormat.format(
                        merchantOrderDetailsObject.order.itemsPrice +
                            merchantOrderDetailsObject.order.discountDiff,
                      ),
                    ),
                    AppConstance.horizontalDivider,
                    OrderDetailsRowItem(
                      title: "التوصيل",
                      value: AppConstance.currencyFormat.format(
                        merchantOrderDetailsObject.order.shippingPrice,
                      ),
                    ),
                    AppConstance.horizontalDivider,
                    OrderDetailsRowItem(
                      title: "الإجمالي",
                      value: AppConstance.currencyFormat.format(
                        merchantOrderDetailsObject.order.clientPrice,
                      ),
                      titleColor: AppColors.defaultColor,
                      valueColor: AppColors.defaultColor,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              if (merchantOrderDetailsObject.order.items.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: CustomText(
                    text: "المنتجات",
                    color: AppColors.black4B,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ...merchantOrderDetailsObject.order.items.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: OrderItems(item: e),
                ),
              ),
              if (merchantOrderDetailsObject.order.status == 4 &&
                  merchantOrderDetailsObject.order.canceledReason.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.greyFC,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.greyF5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: CustomText(
                          text: "سبب الالغاء",
                          color: AppColors.redE7,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      MerchantClientRow(
                        icon: ImageManager.close,
                        title: "",
                        subTitle: merchantOrderDetailsObject.order.canceledReason,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
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
                              child: CustomText(
                                text: "هل ترغب في طباعة الطلب ايضا؟",
                                color: AppColors.black1A,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                maxLines: 10,
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

                      showDialog(
                        context: context,
                        builder: (context) {
                          return BlocProvider.value(
                            value: merchantOrderDetailsObject.blocContext.read<MerchantHomeCubit>(),
                            child: AlertPopUp(
                              alertTitle: "سبب الرفض",
                              content: CustomTextFormField(
                                controller: rejectedController,
                                keyboardType: TextInputType.text,
                                hint: 'اكتب سبب الرفض',
                                textInputAction: TextInputAction.done,
                              ),
                              confirmText: "رفض",
                              onButtonClick: () {
                                if (rejectedController.text.isNotEmpty) {
                                  merchantOrderDetailsObject.blocContext
                                      .read<MerchantHomeCubit>()
                                      .editOrder(
                                        status: 4,
                                        orderId: merchantOrderDetailsObject.order.id,
                                        canceledReason: rejectedController.text,
                                      )
                                      .whenComplete(() {
                                        context.pop();
                                      });
                                }
                              },
                              onButtonCancel: () {
                                context.pop();
                              },
                            ),
                          );
                        },
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
        showDialog(
          context: context,
          builder: (context) {
            return AlertPopUp(
              alertTitle: "سبب الرفض",
              content: CustomTextFormField(
                controller: rejectedController,
                keyboardType: TextInputType.text,
                hint: 'اكتب سبب الرفض',
                textInputAction: TextInputAction.done,
              ),
              confirmText: "رفض",
              onButtonClick: () {
                if (rejectedController.text.isNotEmpty) {
                  merchantOrderDetailsObject.blocContext
                      .read<MerchantHomeCubit>()
                      .editOrder(
                        status: 4,
                        orderId: merchantOrderDetailsObject.order.id,
                        canceledReason: rejectedController.text,
                      )
                      .whenComplete(() {
                        context.pop();
                      });
                }
              },
              onButtonCancel: () {
                context.pop();
              },
            );
          },
        );
      },
    );
  }
}
