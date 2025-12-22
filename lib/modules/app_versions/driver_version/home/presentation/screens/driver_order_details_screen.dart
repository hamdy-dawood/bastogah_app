import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/driver_order_details_object.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/presentation/widgets/print_bill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/components/default_text_form_field.dart';
import '../../../../../../core/external/url_launcher.dart';
import '../../../../../../core/helpers/dialog_helper.dart';
import '../../../../../../core/utils/constance.dart';
import '../../../../client_version/my_orders/presentation/widgets/order_details_row_item.dart';
import '../../../../client_version/my_orders/presentation/widgets/order_items_widget.dart';
import '../../../../client_version/my_orders/presentation/widgets/time_date_box.dart';
import '../../../../driver_version/home/presentation/cubit/driver_home_cubit.dart';
import '../../../../merchant_version/home/presentation/widgets/details_finish_bottom_sheet.dart';
import '../../../../merchant_version/home/presentation/widgets/row_icon_text.dart';
import '../../../../merchant_version/home/presentation/widgets/text_container.dart';
import '../widgets/cancel_order_button.dart';

class DriverOrderDetailsScreen extends StatelessWidget {
  final ClientDriverOrderDetailsObject driverOrderDetailsObject;

  const DriverOrderDetailsScreen({super.key, required this.driverOrderDetailsObject});

  num calculateTotalOrder() {
    return driverOrderDetailsObject.order.itemsPrice + driverOrderDetailsObject.order.shippingPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            context.pop();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text('طلب #${driverOrderDetailsObject.order.billNo}')),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (driverOrderDetailsObject.isDriver)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AppBills(order: driverOrderDetailsObject.order),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        ImageManager.print,
                        height: 22,
                        colorFilter: const ColorFilter.mode(
                          AppColors.defaultColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
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
                  buttonColor:
                      driverOrderDetailsObject.order.status == 0 ||
                              driverOrderDetailsObject.order.status == 1
                          ? AppColors.yellowColor
                          : driverOrderDetailsObject.order.status == 2
                          ? AppColors.blue2Color
                          : driverOrderDetailsObject.order.status == 3
                          ? AppColors.green2Color
                          : AppColors.redE7,
                  fontColor: Colors.white,
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
                  TimeAndDateBox(
                    iconData: Icons.calendar_month,
                    value: AppConstance.dateFormat.format(
                      DateTime.parse(
                        driverOrderDetailsObject.order.createdAt,
                      ).add(const Duration(hours: 3)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TimeAndDateBox(
                    iconData: Icons.access_time,
                    value: AppConstance.timeFormat.format(
                      DateTime.parse(
                        driverOrderDetailsObject.order.createdAt,
                      ).add(const Duration(hours: 3)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4, right: 16, left: 16),
              child: Text('تفاصيل الطلبية', style: Theme.of(context).textTheme.titleMedium),
            ),
            PriceDetailsSection(driverOrderDetailsObject: driverOrderDetailsObject),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 4, right: 16, left: 16),
              child: Text('المتجر', style: Theme.of(context).textTheme.titleMedium),
            ),
            // const StoreNameSection(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        driverOrderDetailsObject.order.merchantName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 5),
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
                      child: Icon(CupertinoIcons.phone_fill, color: AppColors.defaultColor),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 4, right: 16, left: 16),
              child: Text('المنتجات', style: Theme.of(context).textTheme.titleMedium),
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
                  driverOrderDetailsObject.blocContext
                      .read<DriverHomeCubit>()
                      .setDriver(orderId: driverOrderDetailsObject.order.id)
                      .whenComplete(() {
                        context.pop();
                      });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.blue2Color,
                  ),
                  child: const RowIconText(icon: Icons.check, text: "قبول"),
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
        driverOrderDetailsObject.blocContext
            .read<DriverHomeCubit>()
            .editOrder(orderId: driverOrderDetailsObject.order.id, status: 3)
            .whenComplete(() {
              // close details page
              context.pop();
            });
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
                    driverOrderDetailsObject.blocContext
                        .read<DriverHomeCubit>()
                        .editOrder(
                          orderId: driverOrderDetailsObject.order.id,
                          status: 4,
                          canceledReason: rejectedController.text,
                        )
                        .whenComplete(() {
                          //close dialog
                          context.pop();
                          // close page
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

class PriceDetailsSection extends StatelessWidget {
  final ClientDriverOrderDetailsObject driverOrderDetailsObject;

  const PriceDetailsSection({super.key, required this.driverOrderDetailsObject});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1)],
      ),
      child: Column(
        children: [
          if (driverOrderDetailsObject.order.totalAppliedDiscount > 0) ...[
            OrderDetailsRowItem(
              title: "إجمالي الخصم",
              value: AppConstance.currencyFormat.format(
                driverOrderDetailsObject.order.totalAppliedDiscount,
              ),
            ),
            const SizedBox(height: 16),
          ],
          OrderDetailsRowItem(
            title: 'مبلغ الطلب',
            value: AppConstance.currencyFormat.format(
              driverOrderDetailsObject.order.itemsPrice +
                  driverOrderDetailsObject.order.discountDiff,
            ),
          ),
          const SizedBox(height: 16),
          OrderDetailsRowItem(
            title: 'التوصيل',
            value: AppConstance.currencyFormat.format(driverOrderDetailsObject.order.shippingPrice),
          ),
          const SizedBox(height: 16),
          OrderDetailsRowItem(
            title: 'الإجمالي',
            value: AppConstance.currencyFormat.format(driverOrderDetailsObject.order.clientPrice),
            valueColored: true,
          ),
        ],
      ),
    );
  }
}
