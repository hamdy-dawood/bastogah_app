import 'dart:io';

import 'package:bastoga/core/components/alert_pop_up.dart';
import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/components/default_text_form_field.dart';
import 'package:bastoga/core/components/svg_icons.dart';
import 'package:bastoga/core/external/url_launcher.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/routing/routes.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/driver_order_details_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/constance.dart';
import '../../../../../../core/utils/image_manager.dart';
import '../../../../client_version/my_orders/domain/entities/orders.dart';
import '../cubit/driver_home_cubit.dart';
import 'accept_order_button.dart';
import 'cancel_order_button.dart';
import 'deliver_order_button.dart';

class DriverOrdersCardView extends StatefulWidget {
  final Orders order;
  final DriverHomeCubit cubit;

  const DriverOrdersCardView({super.key, required this.order, required this.cubit});

  @override
  State<DriverOrdersCardView> createState() => _DriverOrdersCardViewState();
}

class _DriverOrdersCardViewState extends State<DriverOrdersCardView> {
  final TextEditingController rejectedController = TextEditingController();

  @override
  void dispose() {
    rejectedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          Routes.driverOrderDetailsScreen,
          arguments: ClientDriverOrderDetailsObject(
            order: widget.order,
            isDriver: true,
            cubit: widget.cubit,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1)],
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
                        text: "#${widget.order.billNo}",
                        color: AppColors.black1A,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        maxLines: 3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (widget.order.status == 1)
                    AcceptOrderButton(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return BlocProvider.value(
                              value: widget.cubit,
                              child: AlertPopUp(
                                alertTitle: "تأكيد العملية",
                                content: Center(
                                  child: CustomText(
                                    text: "هل أنت متأكد من قبول الطلب؟",
                                    color: AppColors.black1A,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    maxLines: 10,
                                  ),
                                ),
                                onButtonClick: () async {
                                  context.pop();
                                  widget.cubit.setDriver(orderId: widget.order.id);
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
                  else if (widget.order.status == 2) ...[
                    CancelOrderButton(
                      text: "الغاء",
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return BlocProvider.value(
                              value: widget.cubit,
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
                                    widget.cubit
                                        .editOrder(
                                          orderId: widget.order.id,
                                          status: 4,
                                          canceledReason: rejectedController.text,
                                        )
                                        .whenComplete(() => context.pop());
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
                    ),
                    const SizedBox(width: 8),
                    DeliverOrderButton(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return BlocProvider.value(
                              value: widget.cubit,
                              child: AlertPopUp(
                                alertTitle: "تأكيد العملية",
                                content: Center(
                                  child: CustomText(
                                    text: "هل أنت متأكد من تسليم الطلب؟",
                                    color: AppColors.black1A,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    maxLines: 10,
                                  ),
                                ),
                                onButtonClick: () async {
                                  context.pop();
                                  widget.cubit.editOrder(orderId: widget.order.id, status: 3);
                                },
                                onButtonCancel: () {
                                  context.pop();
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ] else
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: SvgIcon(
                        icon: ImageManager.arrowLeft,
                        color: AppColors.black1A,
                        height: 24,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: AppColors.defaultColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (Platform.isIOS) {
                                  await launchUrlString(
                                    "maps:${widget.order.merchantLocation.coordinates.last},${widget.order.merchantLocation.coordinates.first}?q=${widget.order.merchantLocation.coordinates.last},${widget.order.merchantLocation.coordinates.first}",
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  await launchUrlString(
                                    "geo:${widget.order.merchantLocation.coordinates.last},${widget.order.merchantLocation.coordinates.first}?q=${widget.order.merchantLocation.coordinates.last},${widget.order.merchantLocation.coordinates.first}",
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SvgIcon(
                                  icon: ImageManager.location,
                                  color: AppColors.defaultColor,
                                  height: 24,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: "الاستلام من",
                                    color: AppColors.black4B,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                  const SizedBox(height: 5),
                                  CustomText(
                                    text: widget.order.merchantName,
                                    color: AppColors.black1A,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (Platform.isIOS) {
                                  await launchUrlString(
                                    "maps:${widget.order.locationLat},${widget.order.locationLng}?q=${widget.order.locationLat},${widget.order.locationLng}",
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  await launchUrlString(
                                    "geo:${widget.order.locationLat},${widget.order.locationLng}?q=${widget.order.locationLat},${widget.order.locationLng}",
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SvgIcon(
                                  icon: ImageManager.location,
                                  color: AppColors.defaultColor,
                                  height: 24,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: "التوصيل إلى",
                                    color: AppColors.black4B,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                  const SizedBox(height: 5),
                                  CustomText(
                                    text: widget.order.address,
                                    color: AppColors.black1A,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: "قيمة الطلب :",
                                  color: AppColors.black4B,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                                const SizedBox(height: 5),
                                CustomText(
                                  text:
                                      "${AppConstance.currencyFormat.format(widget.order.clientPrice)} د",
                                  color: AppColors.black1A,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                UrlLaunchers().phoneCallLauncher(phoneNumber: widget.order.phone);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SvgIcon(
                                  icon: ImageManager.phoneIcon,
                                  color: AppColors.defaultColor,
                                  height: 20,
                                ),
                              ),
                            ),
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
                                  Builder(
                                    builder: (context) {
                                      final phone = widget.order.phone;
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
                                ],
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
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
