import 'package:bastoga/core/components/alert_pop_up.dart';
import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/driver_order_details_object.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/components/default_text_form_field.dart';
import '../../../../../../core/external/url_launcher.dart';
import '../../../../../../core/utils/constance.dart';
import '../../../../client_version/my_orders/presentation/widgets/order_details_row_item.dart';
import '../../../../client_version/my_orders/presentation/widgets/order_items_widget.dart';
import '../../../../client_version/my_orders/presentation/widgets/time_date_box.dart';
import '../../../../merchant_version/home/presentation/widgets/details_finish_bottom_sheet.dart';
import '../../../../merchant_version/home/presentation/widgets/row_icon_text.dart';
import '../../../../merchant_version/home/presentation/widgets/text_container.dart';

class DriverOrderDetailsScreen extends StatelessWidget {
  final ClientDriverOrderDetailsObject driverOrderDetailsObject;

  const DriverOrderDetailsScreen({super.key, required this.driverOrderDetailsObject});

  num calculateTotalOrder() {
    return driverOrderDetailsObject.order.itemsPrice + driverOrderDetailsObject.order.shippingPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                text: "تفاصيل طلب #${driverOrderDetailsObject.order.billNo}",
                color: AppColors.black1A,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                maxLines: 3,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // if (driverOrderDetailsObject.isDriver)
                //   GestureDetector(
                //     onTap: () {
                //       showDialog(
                //         context: context,
                //         builder: (context) => AppBills(order: driverOrderDetailsObject.order),
                //       );
                //     },
                //     child: Container(
                //       padding: const EdgeInsets.all(6),
                //       decoration: BoxDecoration(
                //         color: Colors.white.withValues(alpha: 0.9),
                //         shape: BoxShape.circle,
                //       ),
                //       child: SvgPicture.asset(
                //         ImageManager.print,
                //         height: 22,
                //         colorFilter: const ColorFilter.mode(
                //           AppColors.defaultColor,
                //           BlendMode.srcIn,
                //         ),
                //       ),
                //     ),
                //   ),
                // const SizedBox(width: 10),
                TextContainer(
                  text:
                      driverOrderDetailsObject.order.status == 0
                          ? 'انتظار'
                          : driverOrderDetailsObject.order.status == 1
                          ? 'انتظار سائق'
                          : driverOrderDetailsObject.order.status == 2
                          ? 'قيد التنفيذ'
                          : driverOrderDetailsObject.order.status == 3
                          ? 'مكتمل'
                          : 'ملغي',
                  buttonColor: AppColors.white,
                  borderColor:
                      driverOrderDetailsObject.order.status == 0 ||
                              driverOrderDetailsObject.order.status == 1
                          ? AppColors.yellowE4
                          : driverOrderDetailsObject.order.status == 2
                          ? AppColors.defaultColor
                          : driverOrderDetailsObject.order.status == 3
                          ? AppColors.green00A
                          : AppColors.redE7,
                  fontColor:
                      driverOrderDetailsObject.order.status == 0 ||
                              driverOrderDetailsObject.order.status == 1
                          ? AppColors.yellowE4
                          : driverOrderDetailsObject.order.status == 2
                          ? AppColors.defaultColor
                          : driverOrderDetailsObject.order.status == 3
                          ? AppColors.green00A
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TimeAndDateBox(
                      icon: ImageManager.calenderIcon,
                      value: AppConstance.dateFormat.format(
                        DateTime.parse(
                          driverOrderDetailsObject.order.createdAt,
                        ).add(const Duration(hours: 3)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TimeAndDateBox(
                      icon: ImageManager.clockIcon,
                      value: AppConstance.timeFormat.format(
                        DateTime.parse(
                          driverOrderDetailsObject.order.createdAt,
                        ).add(const Duration(hours: 3)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            PriceDetailsSection(driverOrderDetailsObject: driverOrderDetailsObject),
            const SizedBox(height: 25),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.greyFC,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.greyF5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "المتجر",
                    color: AppColors.black4B,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            driverOrderDetailsObject.order.merchantName,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            driverOrderDetailsObject.order.merchantPhone,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          UrlLaunchers().phoneCallLauncher(
                            phoneNumber: driverOrderDetailsObject.order.merchantPhone,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 8, 8.0),
                          child: Icon(CupertinoIcons.phone_fill, color: AppColors.green00A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: CustomText(
                text: "المنتجات",
                color: AppColors.black4B,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            ...driverOrderDetailsObject.order.items.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: OrderItems(item: e),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          driverOrderDetailsObject.order.status == 1
              ? GestureDetector(
                onTap: () {
                  driverOrderDetailsObject.cubit
                      .setDriver(orderId: driverOrderDetailsObject.order.id)
                      .whenComplete(() {
                        context.pop();
                      });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.defaultColor,
                  ),
                  child: const RowIconText(icon: Icons.check, text: "قبول الطلب"),
                ),
              )
              : driverOrderDetailsObject.order.status == 2
              ? _buildFinishButton(context)
              : const SizedBox(),
    );
  }

  Widget _buildFinishButton(BuildContext context) {
    final TextEditingController rejectedController = TextEditingController();
    return DetailsFinishBottomSheet(
      onTapFinish: () {
        driverOrderDetailsObject.cubit
            .editOrder(orderId: driverOrderDetailsObject.order.id, status: 3)
            .whenComplete(() {
              context.pop();
            });
      },
      onTapCancel: () {
        showDialog(
          context: context,
          builder: (context) {
            return BlocProvider.value(
              value: driverOrderDetailsObject.cubit,
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
                    driverOrderDetailsObject.cubit
                        .editOrder(
                          orderId: driverOrderDetailsObject.order.id,
                          status: 4,
                          canceledReason: rejectedController.text,
                        )
                        .whenComplete(() {
                          context.pop();
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
    );
  }
}

class PriceDetailsSection extends StatelessWidget {
  const PriceDetailsSection({super.key, required this.driverOrderDetailsObject});

  final ClientDriverOrderDetailsObject driverOrderDetailsObject;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              text: "تفاصيل الطلب",
              color: AppColors.black4B,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          if (driverOrderDetailsObject.order.totalAppliedDiscount > 0) ...[
            OrderDetailsRowItem(
              title: "إجمالي الخصم",
              value: AppConstance.currencyFormat.format(
                driverOrderDetailsObject.order.totalAppliedDiscount,
              ),
              valueColor: AppColors.redE7,
            ),
            AppConstance.horizontalDivider,
          ],
          OrderDetailsRowItem(
            title: 'مبلغ الطلب',
            value: AppConstance.currencyFormat.format(
              driverOrderDetailsObject.order.itemsPrice +
                  driverOrderDetailsObject.order.discountDiff,
            ),
          ),
          AppConstance.horizontalDivider,
          OrderDetailsRowItem(
            title: 'التوصيل',
            value: AppConstance.currencyFormat.format(driverOrderDetailsObject.order.shippingPrice),
          ),
          AppConstance.horizontalDivider,
          OrderDetailsRowItem(
            title: 'الإجمالي',
            value: AppConstance.currencyFormat.format(driverOrderDetailsObject.order.clientPrice),
            titleColor: AppColors.defaultColor,
            valueColor: AppColors.defaultColor,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
