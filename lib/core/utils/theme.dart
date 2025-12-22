import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'constance.dart';
import 'font_weight_helper.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: AppConstance.appFomFamily,
  useMaterial3: false,
  dialogBackgroundColor: Colors.white,
  dialogTheme: const DialogThemeData(elevation: 0.0, shadowColor: Colors.transparent),
  tabBarTheme: const TabBarThemeData(
    indicatorSize: TabBarIndicatorSize.tab,
    overlayColor: WidgetStatePropertyAll(Colors.transparent),
    splashFactory: NoSplash.splashFactory,
    indicator: BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.defaultColor, width: 2)),
    ),
    labelColor: AppColors.defaultColor,
    unselectedLabelColor: AppColors.defaultColor,
  ),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      // statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ),
    backgroundColor: AppColors.defaultColor,
    centerTitle: false,
    elevation: 0.0,
    // toolbarHeight: 80,
    titleTextStyle: TextStyle(
      fontFamily: AppConstance.appFomFamily,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    actionsIconTheme: IconThemeData(color: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  primaryColor: AppColors.defaultColor,
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: AppColors.defaultColor.withValues(alpha: 0.5),
    cursorColor: AppColors.defaultColor.withValues(alpha: 0.6),
    selectionHandleColor: AppColors.defaultColor.withValues(alpha: 1),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedLabelStyle: TextStyle(
      color: AppColors.defaultColor,
      fontSize: 18.0,
      fontFamily: AppConstance.appFomFamily,
      fontWeight: FontWeightHelper.bold,
    ),
    unselectedLabelStyle: TextStyle(
      color: Colors.black,
      fontSize: 18.0,
      fontFamily: AppConstance.appFomFamily,
      fontWeight: FontWeightHelper.bold,
    ),
  ),
  textTheme: const TextTheme().copyWith(
    titleLarge: const TextStyle(
      fontSize: 20.0,
      fontFamily: AppConstance.appFomFamily,
      fontWeight: FontWeightHelper.extraBold,
      color: Colors.black,
    ),
    titleMedium: const TextStyle(
      fontSize: 18.0,
      fontFamily: AppConstance.appFomFamily,
      fontWeight: FontWeightHelper.bold,
      color: Colors.black,
    ),
    bodyLarge: const TextStyle(
      fontSize: 17.0,
      fontFamily: AppConstance.appFomFamily,
      fontWeight: FontWeightHelper.bold,
      color: Colors.black,
    ),
    bodyMedium: const TextStyle(
      fontFamily: AppConstance.appFomFamily,
      fontWeight: FontWeightHelper.semiBold,
      fontSize: 14.0,
      color: Colors.black,
    ),
    bodySmall: TextStyle(
      fontSize: 12.0,
      fontFamily: AppConstance.appFomFamily,
      fontWeight: FontWeightHelper.regular,
      color: Colors.black.withValues(alpha: 0.5),
    ),
  ),
);
