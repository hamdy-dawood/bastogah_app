import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

import '../networking/endpoints.dart';
import 'colors.dart';

class AppConstance {
  static const String appFomFamily = "cairo";

  static String formatDateTime(DateTime dateTime) {
    return "${dateFormat.format(dateTime)} ${timeFormat.format(dateTime)}";
  }

  static String formatCurrency(num? value) {
    final formatted = currencyFormat.format(value ?? 0);
    return '\u200E$formatted\u200E';
  }

  // date & time & currency format
  static DateFormat dateFormat = DateFormat('dd-MM-yyyy', 'en');
  static DateFormat timeFormat = DateFormat('hh:mm a', 'en');
  static NumberFormat currencyFormat = NumberFormat("#,##0.##", "en_US");

  static DateTime parseDate(String dateString) {
    List<String> parts = dateString.split('-');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);

    String formattedDateString =
        '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}T00:00:00.000';

    return DateTime.tryParse(formattedDateString) ?? DateTime.now();
  }

  // image path
  static String imagePathApi = '${ApiConstants.baseUrl}/images/';

  static Widget horizontalDivider = Divider(
    thickness: 1,
    indent: 0,
    endIndent: 0,
    color: AppColors.black4B.withValues(alpha: 0.2),
    height: 15,
  );

  static String someThingWentWrongMessage = 'حدث خطأ, برجاء المحاولة فى وقت لاحق';

  static String guestCachedKey = 'guest';
  static String clientCachedKey = 'client';
  static String driverCachedKey = 'driver';
  static String merchantCachedKey = 'merchant';
  static String loggedInUserKey = 'id';
  static String accessTokenKey = 'access_token';
  static String refreshTokenKey = 'refresh_token';
  static String favoriteCachedKey = 'favorite';
  static String cartCachedKey = 'cart';

  // printer

  static const double printer58Width = 380;
  static const double printer80Width = 550;

  static Future<void> printBill({required Uint8List imageWidget}) async {
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printImage(imageWidget);
    await SunmiPrinter.lineWrap(3);
    await SunmiPrinter.exitTransactionPrint(true);
  }
}
