import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:bastoga/core/components/bottom_nav_bar/merchant_default_bottom_nav.dart';
import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/components/default_list_view.dart';
import 'package:bastoga/core/components/default_text_form_field.dart';
import 'package:bastoga/core/components/no_data.dart';
import 'package:bastoga/core/components/overlay_loading.dart';
import 'package:bastoga/core/components/printer/mdsoft_printer.dart';
import 'package:bastoga/core/components/svg_icons.dart';
import 'package:bastoga/core/components/warning_alert_pop_up.dart';
import 'package:bastoga/core/controllers/navigator_bloc/navigator_cubit.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/helpers/dialog_helper.dart';
import 'package:bastoga/core/routing/routes.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/core/utils/font_weight_helper.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/firebase_notifications.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/orders.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/cubit/merchant_profile_cubit.dart';
import 'package:bluetooth_thermal_printer_plus/bluetooth_thermal_printer_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../cubit/home_cubit.dart';
import '../widgets/merchant_orders_card_view.dart';

class MerchantHomeScreen extends StatefulWidget {
  const MerchantHomeScreen({super.key});

  @override
  State<MerchantHomeScreen> createState() => _MerchantHomeScreenState();
}

class _MerchantHomeScreenState extends State<MerchantHomeScreen> {
  AudioPlayer player = AudioPlayer();
  bool newOrderSound = false;
  Timer? _timer;

  List<String> tabs = ["قيد الانتظار", "انتظار سائق", "قيد التنفيذ", "مكتمل", "ملغي"];

  int tabIndex = 0;

  @override
  void initState() {
    final cubit = context.read<MerchantHomeCubit>();

    context.read<MerchantProfileCubit>().getProfile();
    cubit.getOrders(page: 0, status: tabIndex);
    FirebaseNotifications.getFCM();
    cubit.getMerchantDues();
    context.read<NavigatorCubit>().merchantCurrentIndex = 0;
    getOrders();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    player.dispose();
    super.dispose();
  }

  // Get Orders Every 10 Sec
  void getOrders() {
    if (tabIndex == 0) {
      _timer = Timer.periodic(
        kDebugMode ? const Duration(minutes: 10) : const Duration(seconds: 10),
        (Timer timer) {
          newOrderSound = false;
          context.read<MerchantHomeCubit>().getOrders(page: 0, status: tabIndex);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MerchantHomeCubit>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Image.asset(ImageManager.logo),
        ),
        title: CustomText(
          text: "أهلاً بك",
          color: AppColors.black1A,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgIcon(
              icon: ImageManager.notificationIcon,
              color: AppColors.black1A,
              height: 22,
            ),
          ),
        ],
        // actions: [
        //   BlocBuilder<MerchantHomeCubit, MerchantHomeStates>(
        //     builder: (context, state) {
        //       return Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Checkbox(
        //             value: cubit.isAutoPrintingEnabled,
        //             onChanged: (bool? value) {
        //               cubit.setAutoPrinting();
        //             },
        //             checkColor: AppColors.defaultColor,
        //             activeColor: Colors.white,
        //             shape: RoundedRectangleBorder(
        //               side: const BorderSide(color: Colors.white),
        //               borderRadius: BorderRadius.circular(2),
        //             ),
        //           ),
        //           const Text(
        //             'طباعة تلقائية',
        //             style: TextStyle(
        //               // color: Colors.black,
        //               fontWeight: FontWeight.w700,
        //             ),
        //           ),
        //           const SizedBox(width: 10),
        //         ],
        //       );
        //     },
        //   ),
        // ],
      ),
      bottomNavigationBar: const MerchantDefaultBottomNav(),
      body: DefaultTabController(
        length: tabs.length,
        child: Column(
          children: [
            BlocListener<MerchantProfileCubit, MerchantProfileStates>(
              listener: (context, state) {
                if (state is MerchantProfileSuccessState &&
                    context.read<MerchantProfileCubit>().profile!.active == false) {
                  DialogHelper.showCustomDialog(
                    context: context,
                    alertDialog: WarningAlertPopUp(
                      image: ImageManager.warningIcon,
                      description: 'تم ايقاف حسابك من قبل الادارة',
                      onPress: () {
                        FirebaseUnsubscribe.unsubscribeFromTopics();
                        context.pushNamedAndRemoveUntil(
                          Routes.loginScreen,
                          predicate: (route) => false,
                        );
                        Caching.clearAllData();
                      },
                    ),
                  );
                }
              },
              child: const SizedBox(),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: BlocBuilder<MerchantHomeCubit, MerchantHomeStates>(
                builder: (context, state) {
                  return Container(
                    width: context.screenWidth,
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey9A.withValues(alpha: 0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgIcon(
                          icon: ImageManager.dollar,
                          color: AppColors.defaultColor,
                          height: 24,
                        ),
                        const SizedBox(height: 10),
                        state is MerchantDuesLoadingState
                            ? const Center(
                              heightFactor: 1,
                              widthFactor: 1,
                              child: SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              ),
                            )
                            : FittedBox(
                              child: CustomText(
                                text:
                                    "${cubit.merchantDues != null ? "${AppConstance.currencyFormat.format(cubit.merchantDues!.merchantDues)}" : "-"} د.ع",
                                color: AppColors.black1A,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                maxLines: 1,
                              ),
                            ),
                        const SizedBox(height: 5),
                        CustomText(
                          text: "المستحقات الحالية",
                          color: AppColors.grey9A,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Flexible(
                    child: CustomTextFormField(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      controller: cubit.searchController,
                      hint: "بحث عن طلب",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(10),
                        child: SvgIcon(icon: ImageManager.search, color: AppColors.grey9A),
                      ),
                      onFieldSubmitted: (value) {
                        cubit.orders = null;
                        cubit.getOrders(page: 0, status: tabIndex, date: cubit.date);
                      },
                      validator: (value) {
                        return null;
                      },
                      isLastInput: true,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 5),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      cubit.orders = null;
                      cubit.getOrders(page: 0, status: tabIndex, date: cubit.date);
                    },
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 1.5, color: AppColors.greyE0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgIcon(
                          icon: ImageManager.refresh,
                          color: AppColors.black4B,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('قائمة الطلبات', style: Theme.of(context).textTheme.titleMedium),
                  ),
                  BlocBuilder<MerchantHomeCubit, MerchantHomeStates>(
                    builder: (context, state) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            cubit.date == 'null' ? '' : cubit.date,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.defaultColor,
                              fontWeight: FontWeightHelper.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              cubit.pressDateRange(context, tabIndex);
                            },
                            child: SvgPicture.asset(ImageManager.calenderIcon),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.greyE0.withValues(alpha: 0.5), width: 1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey9A.withValues(alpha: 0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              height: 45,
              child: TabBar(
                isScrollable: true,
                labelPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                unselectedLabelColor: AppColors.grey9A,
                unselectedLabelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppConstance.appFomFamily,
                ),
                labelColor: AppColors.defaultColor,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppConstance.appFomFamily,
                ),
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                onTap: (index) {
                  tabIndex = index;
                  cubit.orders = null;
                  cubit.getOrders(page: 0, status: tabIndex, date: cubit.date);
                },
                tabs:
                    tabs.asMap().entries.map((entry) {
                      return Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color:
                                    entry.key == 0
                                        ? Colors.transparent
                                        : AppColors.grey9A.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                              child: Text(entry.value),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            BlocBuilder<MerchantHomeCubit, MerchantHomeStates>(
              builder: (context, state) {
                if (state is LoadingState) {
                  return SizedBox(
                    height: 5,
                    child: LinearProgressIndicator(
                      color: AppColors.defaultColor,
                      backgroundColor: AppColors.defaultColor.withValues(alpha: 0.1),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            BlocBuilder<MerchantHomeCubit, MerchantHomeStates>(
              builder: (context, state) {
                if (cubit.orders != null && cubit.orders!.isNotEmpty) {
                  return Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children:
                          tabs
                              .map(
                                (e) => DefaultListView(
                                  refresh: (page) {
                                    return cubit.getOrders(
                                      page: page,
                                      status: tabIndex,
                                      date: cubit.date,
                                    );
                                  },
                                  itemBuilder: (_, index) {
                                    if (!newOrderSound && cubit.orders![index].status == 0) {
                                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                                        await player.setSource(AssetSource('sounds/new_order.wav'));
                                        await player.resume();
                                      });
                                      newOrderSound = true;
                                    }

                                    if (cubit.isAutoPrintingEnabled) {
                                      autoPrintOrders(cubit);
                                    }

                                    return MerchantOrdersCardView(
                                      order: cubit.orders![index],
                                      tabIndex: tabIndex,
                                    );
                                  },
                                  length: cubit.orders!.length,
                                  hasMore: false,
                                  onRefreshCall: () {
                                    return cubit.getOrders(
                                      page: 0,
                                      status: tabIndex,
                                      date: cubit.date,
                                    );
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  );
                } else {
                  return Expanded(
                    child: NoData(
                      refresh: () {
                        return cubit.getOrders(page: 0, status: tabIndex, date: cubit.date);
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void autoPrintOrders(MerchantHomeCubit cubit) async {
    if (cubit.printingInProgress) {
      return;
    }
    cubit.printingInProgress = true;

    List<Orders> allOrders = cubit.orders!;
    List<Orders> ordersToPrint = allOrders.where((order) => order.status == 0).toList();

    for (int i = ordersToPrint.length - 1; i >= 0; i--) {
      if (cubit.isAutoPrintingEnabled == false) {
        cubit.printingInProgress = false;
        return;
      }

      String? isConnected = await BluetoothThermalPrinter.connectionStatus;
      if (isConnected == "true") {
        var futures = [
          cubit.makeOrderInProgress(orderId: ordersToPrint[i].id),
          printOrder(order: ordersToPrint[i]),
        ];
        await Future.wait(futures);

        cubit.removeOrder(order: ordersToPrint[i]);
      } else {
        String mac = Caching.getData(key: "printer_mac") ?? "";
        String printer = Caching.getData(key: "printer") ?? "Sunmi";

        if (mac.isEmpty) {
          context.pushNamed(Routes.printerScreen);
        } else {
          OverlayLoadingProgress.start(context);
          MdsoftPrinter.setConnect(mac, printer, reConnect: true).whenComplete(() {
            OverlayLoadingProgress.stop();
          });
        }
      }
    }

    cubit.printingInProgress = false;
  }

  Future<bool> printOrder({required Orders order}) async {
    MdsoftPrinter.printBill(widget: BillDesign(order: order));
    return false;
  }
}
