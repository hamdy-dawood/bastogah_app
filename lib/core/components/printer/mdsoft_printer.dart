import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:bastoga/core/components/bill_row.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/orders.dart';
import 'package:bluetooth_thermal_printer_plus/bluetooth_thermal_printer_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:image/image.dart' as decode_package;
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

String cachingPrinter = Caching.getData(key: "printer") ?? "Sunmi";
PrinterPaperSize cachingPaperSize = Caching.getPaperSize() ?? PrinterPaperSize.paper58;

class MdsoftPrinter {
  // print
  static Future<bool> printBill({required Widget widget}) async {
    if (cachingPrinter != "Sunmi") {
      await checkBluetoothState();
      await printTicket(widget: widget);
    } else {
      await bindingPrinter();
      sunmiPrint(widget: widget);
    }
    return true;
  }

  //============================================================================

  static Future<bool> requestBluetoothPermission() async {
    //bluetooth connect permission
    final PermissionStatus blConnectPermission = await Permission.bluetoothConnect.status;

    if (!blConnectPermission.isGranted) {
      PermissionStatus blConnect = await Permission.bluetoothConnect.request();

      if (blConnect.isGranted) {
        _showSnackBar(message: "blConnect Granted");
      } else {
        _showSnackBar(message: "blConnect Not Granted");
        return false;
      }
    }

    //bluetooth scan permission
    final PermissionStatus blScanPermission = await Permission.bluetoothScan.status;

    if (!blScanPermission.isGranted) {
      PermissionStatus blScan = await Permission.bluetoothScan.request();

      if (blScan.isGranted) {
        _showSnackBar(message: "blScan Connect Granted");
      } else {
        _showSnackBar(message: "blScan Not Granted");
        return false;
      }
    }

    return true;
  }

  // =================================================================

  static final ScreenshotController _screenshotController = ScreenshotController();

  static bool isBluetoothOn = false;
  static bool isBluetoothLoading = false;
  static List availableBluetoothDevices = [];
  static bool connected = false;
  static String? connectedDeviceMac;
  static bool isConnectLoading = false;
  static Set<String> connectingDevices = <String>{};
  static List pairedBluetoothDevices = [];

  static Future<void> checkBluetoothState({bool wantGetBluetooth = false}) async {
    bool isOn = await FlutterBluePlus.isAvailable;
    isBluetoothOn = isOn;
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      if (state == BluetoothAdapterState.on) {
        isBluetoothOn = true;
      } else {
        isBluetoothOn = false;
      }
    });
    final granted = await requestBluetoothPermission();
    if (granted && wantGetBluetooth) await getBluetooth();
  }

  static Future<void> getBluetooth() async {
    if (isBluetoothOn) {
      isBluetoothLoading = true;

      final List? bluetooth = await BluetoothThermalPrinter.getBluetooths;
      availableBluetoothDevices = bluetooth!;
      isBluetoothLoading = false;
    } else {
      _showSnackBar(message: "البلوتوث غير مفعل. من فضلك فعل البلوتوث");
    }
  }

  static Future<String> setConnect(String mac, String printerName, {bool reConnect = false}) async {
    if (reConnect) await checkBluetoothState();

    if (isBluetoothOn) {
      connectingDevices.add(mac);
      final String? result = await BluetoothThermalPrinter.connect(mac);
      connectingDevices.remove(mac);
      if (result == "true") {
        connected = true;
        connectedDeviceMac = mac;
        if (!reConnect) {
          Caching.saveData(key: "printer", value: printerName);
          Caching.saveData(key: "printer_mac", value: connectedDeviceMac);
          // navigatorKey.currentContext!.pushNamedAndRemoveUntil(
          //   Routes.merchantHomeScreen,
          //   predicate: (route) => false,
          // );
          _showSnackBar(
            message: "تم الاتصال بطابعة $printerName بنجاح",
            color: AppColors.green2Color.withValues(alpha: 0.6),
          );
        } else {
          _showSnackBar(
            message: "تم اعادة الاتصال بطابعة $printerName بنجاح",
            color: AppColors.green2Color.withValues(alpha: 0.6),
          );
        }

        return printerName;
      } else {
        _showSnackBar(message: "فشل الاتصال بطابعة $printerName");
        return "";
      }
    } else {
      _showSnackBar(message: "البلوتوث غير مفعل. من فضلك فعل البلوتوث !");
      return "";
    }
  }

  static Future<void> printTicket({required Widget widget}) async {
    if (isBluetoothOn) {
      String? isConnected = await BluetoothThermalPrinter.connectionStatus;
      if (isConnected == "true") {
        List<int> bytes = await getGraphicsTicket(widget: widget);
        await BluetoothThermalPrinter.writeBytes(bytes);
      } else {
        _showSnackBar(message: "لم يتم الاتصال باي طابعة");
      }
    } else {
      _showSnackBar(message: "البلوتوث غير مفعل. من فضلك فعل البلوتوث");
    }
  }

  static Future<List<int>> getGraphicsTicket({required Widget widget}) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(
      cachingPaperSize != PrinterPaperSize.paper58 ? PaperSize.mm80 : PaperSize.mm58,
      profile,
    );
    final result = await _screenshotController.captureFromLongWidget(
      ScreenShotWidget(screenshotController: _screenshotController, widget: widget),
    );

    final image = decode_package.decodeImage(result);
    bytes += generator.image(image!);

    return bytes;
  }

  static bool? result;
  static Uint8List? bytes;

  static void sunmiPrint({required Widget widget}) async {
    try {
      bytes = await _screenshotController.captureFromLongWidget(
        ScreenShotWidget(screenshotController: _screenshotController, widget: widget),
      );

      if (bytes != null) {
        if (result != null) {
          SunmiPrinterMdSoft.printBill(imageWidget: bytes!);
        }
      }
    } catch (e) {
      _showSnackBar(message: "An error occurred: $e");
    }
  }

  static Future<bool?> bindingPrinter() async {
    result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  static void _showSnackBar({required String message, Color? color}) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: color ?? AppColors.redE7,
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class SunmiPrinterMdSoft {
  static Future<void> printBill({required Uint8List imageWidget}) async {
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printImage(imageWidget);
    await SunmiPrinter.lineWrap(3);
    await SunmiPrinter.exitTransactionPrint(true);
  }
}

enum PrinterPaperSize { paper58, paper80 }

class PrinterConstants {
  static const double printer58Width = 380;
  static const double printer80Width = 550;
  static const double textFontSize = 22;
}

class ScreenShotWidget extends StatelessWidget {
  const ScreenShotWidget({super.key, required this.screenshotController, required this.widget});

  final ScreenshotController screenshotController;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    final double printerWidth =
        cachingPaperSize != PrinterPaperSize.paper58
            ? PrinterConstants.printer80Width
            : PrinterConstants.printer58Width;

    return Screenshot(
      controller: screenshotController,
      child: Container(color: Colors.white, width: printerWidth, child: widget),
    );
  }
}

class BillDesign extends StatelessWidget {
  const BillDesign({super.key, required this.order});

  final Orders order;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(ImageManager.logo, height: 150, color: Colors.black),
        Center(
          child: Text(
            "#${order.billNo}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 42,
              fontWeight: FontWeight.w600,
              fontFamily: AppConstance.appFomFamily,
            ),
          ),
        ),
        BillRow(
          title: "الوقت",
          value: AppConstance.timeFormat.format(
            DateTime.parse(order.createdAt).add(const Duration(hours: 3)),
          ),
        ),
        BillRow(
          title: "التاريخ",
          value: AppConstance.dateFormat.format(
            DateTime.parse(order.createdAt).add(const Duration(hours: 3)),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: AppConstance.printer58Width,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  "محتوي الطلب",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppConstance.appFomFamily,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(order.items.length, (index) {
                final orderProducts = order.items[index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "الاسم : ${orderProducts.productName}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppConstance.appFomFamily,
                      ),
                    ),
                    Text(
                      "الكمية : ${orderProducts.qty}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppConstance.appFomFamily,
                      ),
                    ),
                    if ((orderProducts.totalPrice) -
                            ((orderProducts.price * orderProducts.qty) +
                                orderProducts.totalDiscount) !=
                        0)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Text(
                          //   "السعر قبل الخصم : ${AppConstance.currencyFormat.format((orderProducts.price * orderProducts.qty) + orderProducts.totalDiscount)}",
                          //   style: const TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 22,
                          //     fontWeight: FontWeight.w600,
                          //     fontFamily: AppConstance.appFomFamily,
                          //   ),
                          // ),
                          // Text(
                          //   "الخصم : ${(orderProducts.totalPrice) - ((orderProducts.price * orderProducts.qty) + orderProducts.totalDiscount)}",
                          //   style: const TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 22,
                          //     fontWeight: FontWeight.w600,
                          //     fontFamily: AppConstance.appFomFamily,
                          //   ),
                          // ),
                          Text(
                            "السعر بعد الخصم : ${AppConstance.currencyFormat.format(orderProducts.totalPrice)}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppConstance.appFomFamily,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "السعر : ${AppConstance.currencyFormat.format(orderProducts.totalPrice)}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppConstance.appFomFamily,
                            ),
                          ),
                        ],
                      ),
                    if (orderProducts.notes.isNotEmpty)
                      Text(
                        "ملاحظات : ${orderProducts.notes}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppConstance.appFomFamily,
                        ),
                      ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      child: Divider(thickness: 1, color: Colors.black),
                    ),
                  ],
                );
              }),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    BillRow(
                      title: "مبلغ الطلب",
                      value: AppConstance.currencyFormat.format(
                        order.itemsPrice + order.discountDiff,
                      ),
                    ),
                    BillRow(
                      title: "التوصيل",
                      value: AppConstance.currencyFormat.format(order.shippingPrice),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      child: Divider(thickness: 1, color: Colors.black),
                    ),
                    BillRow(
                      title: "الاجمـالي",
                      value: AppConstance.currencyFormat.format(order.clientPrice),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}
