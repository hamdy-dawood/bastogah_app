import 'dart:typed_data';

import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:bastoga/core/components/overlay_loading.dart';
import 'package:bastoga/core/components/printer/mdsoft_printer.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/routing/routes.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/orders.dart';
import 'package:bluetooth_thermal_printer_plus/bluetooth_thermal_printer_plus.dart';
import 'package:flutter/material.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

import '../../../../../../core/utils/colors.dart';
import '../../../../client_version/my_orders/presentation/widgets/order_details_row_item.dart';

class AppBills extends StatefulWidget {
  final Orders order;

  const AppBills({super.key, required this.order});

  @override
  State<AppBills> createState() => _AppBillsState();
}

class _AppBillsState extends State<AppBills> {
  bool? result;
  Uint8List? bytes;

  Future<bool?> _bindingPrinter() async {
    result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  @override
  void initState() {
    _bindingPrinter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => context.pop(),
                child: const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 20),
                  child: Icon(Icons.close),
                ),
              ),
            ),
            OrderDetailsRowItem(
              title: "مبلغ الطلب",
              value: AppConstance.currencyFormat.format(
                widget.order.itemsPrice + widget.order.discountDiff,
              ),
            ),
            const SizedBox(height: 16),
            OrderDetailsRowItem(
              title: "التوصيل",
              value: AppConstance.currencyFormat.format(widget.order.shippingPrice),
            ),
            const SizedBox(height: 16),
            OrderDetailsRowItem(
              title: "الاجمـــــــالي",
              value: AppConstance.currencyFormat.format(widget.order.clientPrice),
              valueColor: AppColors.defaultColor,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                String? isConnected = await BluetoothThermalPrinter.connectionStatus;

                if (isConnected == "true") {
                  OverlayLoadingProgress.start(context);
                  MdsoftPrinter.printBill(widget: BillDesign(order: widget.order)).whenComplete(() {
                    OverlayLoadingProgress.stop();
                  });
                } else {
                  String mac = Caching.getData(key: "printer_mac") ?? "";
                  String printer = Caching.getData(key: "printer") ?? "Sunmi";

                  print("ddd: ${printer}");

                  if (printer == "Sunmi") {
                    OverlayLoadingProgress.start(context);
                    MdsoftPrinter.printBill(widget: BillDesign(order: widget.order)).whenComplete(
                      () {
                        OverlayLoadingProgress.stop();
                      },
                    );
                  } else {
                    if (mac.isEmpty) {
                      context.pushNamed(Routes.printerScreen);
                    } else {
                      OverlayLoadingProgress.start(context);
                      MdsoftPrinter.setConnect(mac, printer, reConnect: true).whenComplete(() {
                        Future.delayed(const Duration(seconds: 3), () {
                          MdsoftPrinter.printBill(
                            widget: BillDesign(order: widget.order),
                          ).whenComplete(() {
                            OverlayLoadingProgress.stop();
                          });
                        });
                      });
                    }
                  }
                }
              },
              child: Container(
                height: 45,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: AppColors.defaultColor,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: AppColors.defaultColor, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "طباعة",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.print_outlined, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
