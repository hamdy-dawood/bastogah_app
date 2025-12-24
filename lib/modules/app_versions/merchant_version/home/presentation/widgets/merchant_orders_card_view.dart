import 'dart:io';

import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/components/svg_icons.dart';
import 'package:bastoga/core/external/url_launcher.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/routing/routes.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/orders.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/domain/entities/merchant_order_details_object.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MerchantOrdersCardView extends StatelessWidget {
  final Orders order;
  final int tabIndex;

  const MerchantOrdersCardView({super.key, required this.order, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          Routes.merchantOrderDetailsScreen,
          arguments: MerchantOrderDetailsObject(
            order: order,
            blocContext: context,
            tabIndex: tabIndex,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey9A.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: CustomText(
                        text: "#${order.billNo}",
                        color: AppColors.black1A,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        maxLines: 3,
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //   child: Text(
                  //     '${AppConstance.dateFormat.format(DateTime.parse(order.createdAt).add(const Duration(hours: 3)))} في ${AppConstance.timeFormat.format(DateTime.parse(order.createdAt).add(const Duration(hours: 3)))}',
                  //     style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: AppColors.defaultColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "هاتف الزبون",
                                color: AppColors.black4B,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      UrlLaunchers().phoneCallLauncher(phoneNumber: order.phone);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SvgIcon(
                                        icon: ImageManager.phoneIcon,
                                        color: AppColors.defaultColor,
                                        height: 18,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Builder(
                                      builder: (context) {
                                        final phone = order.phone;
                                        return CustomText(
                                          text:
                                              phone.startsWith('+')
                                                  ? PhoneNumber.fromCompleteNumber(
                                                    completeNumber: phone,
                                                  ).number
                                                  : phone,
                                          color: AppColors.black1A,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          textDirection: TextDirection.ltr,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "الموقع :",
                                color: AppColors.black4B,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (Platform.isIOS) {
                                        await launchUrlString(
                                          "maps:${order.locationLat},${order.locationLng}?q=${order.locationLat},${order.locationLng}",
                                          mode: LaunchMode.externalApplication,
                                        );
                                      } else {
                                        await launchUrlString(
                                          "geo:${order.locationLat},${order.locationLng}?q=${order.locationLat},${order.locationLng}",
                                          mode: LaunchMode.externalApplication,
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SvgIcon(
                                        icon: ImageManager.location,
                                        color: AppColors.defaultColor,
                                        height: 18,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: CustomText(
                                      text:
                                          "${order.region?.name ?? order.client?.region?.name ?? ""} , ${order.city?.name ?? order.client?.city?.name ?? ""}",

                                      color: AppColors.black1A,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "السائق",
                              color: AppColors.black4B,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SvgIcon(
                                    icon: ImageManager.user,
                                    color: AppColors.defaultColor,
                                    height: 18,
                                  ),
                                ),
                                Flexible(
                                  child: CustomText(
                                    text: order.driverName.isNotEmpty ? order.driverName : "--",
                                    color: AppColors.black1A,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "صافى المبلغ",
                              color: AppColors.black4B,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            const SizedBox(height: 5),
                            CustomText(
                              text: "${AppConstance.currencyFormat.format(order.itemsPrice)} د",
                              color: AppColors.black1A,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "مبلغ التوصيل",
                              color: AppColors.black4B,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            const SizedBox(height: 5),
                            CustomText(
                              text: "${AppConstance.currencyFormat.format(order.shippingPrice)} د",
                              color: AppColors.black1A,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (order.status == 4) SizedBox(height: 20),
                  if (order.status == 4)
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Icon(CupertinoIcons.clear, size: 21, color: AppColors.redE7),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "سبب الإلغاء",
                                color: AppColors.redE7,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              const SizedBox(height: 5),
                              CustomText(
                                text: order.canceledReason,
                                color: AppColors.black1A,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                maxLines: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
