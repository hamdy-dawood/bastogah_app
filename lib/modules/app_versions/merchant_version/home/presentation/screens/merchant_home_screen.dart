import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bastoga/core/components/bottom_nav_bar/merchant_default_bottom_nav.dart';
import 'package:bastoga/core/components/default_list_view.dart';
import 'package:bastoga/core/components/no_data.dart';
import 'package:bastoga/core/components/overlay_loading.dart';
import 'package:bastoga/core/components/printer/mdsoft_printer.dart';
import 'package:bastoga/core/components/warning_alert_pop_up.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/helpers/dialog_helper.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/core/utils/font_weight_helper.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/orders.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/cubit/merchant_profile_cubit.dart';
import 'package:bluetooth_thermal_printer_plus/bluetooth_thermal_printer_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/caching/shared_prefs.dart';
import '../../../../../../core/controllers/navigator_bloc/navigator_cubit.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../firebase_notifications.dart';
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

  List<String> tabs = ["انتظار", "انتظار سائق", "قيد التنفيذ", "مكتمل", "ملغي"];

  int tabIndex = 0;

  @override
  void initState() {
    context.read<MerchantProfileCubit>().getProfile();
    context.read<MerchantHomeCubit>().getOrders(page: 0, status: tabIndex);
    FirebaseNotifications.getFCM();
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
    if (ModalRoute.of(context)?.settings.name == Routes.merchantHomeScreen) {
      context.read<MerchantHomeCubit>().getMerchantDues();
      context.read<NavigatorCubit>().merchantCurrentIndex = 0;
    }
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Image.asset(ImageManager.logo),
        ),
        title: const Text('الرئيسية'),
        actions: [
          BlocBuilder<MerchantHomeCubit, MerchantHomeStates>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: context.read<MerchantHomeCubit>().isAutoPrintingEnabled,
                    onChanged: (bool? value) {
                      context.read<MerchantHomeCubit>().setAutoPrinting();
                    },
                    checkColor: AppColors.defaultColor,
                    activeColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Text(
                    'طباعة تلقائية',
                    style: TextStyle(
                      // color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              );
            },
          ),
        ],
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
            BlocBuilder<MerchantHomeCubit, MerchantHomeStates>(
              builder: (context, state) {
                return Container(
                  width: context.screenWidth,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.defaultColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'مستحقات الشهر الحالي',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          letterSpacing: 1.2,
                          fontWeight: FontWeightHelper.light,
                        ),
                      ),
                      const SizedBox(height: 10),
                      state is MerchantDuesLoadingState
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                            context.read<MerchantHomeCubit>().merchantDues != null
                                ? '${AppConstance.currencyFormat.format(context.read<MerchantHomeCubit>().merchantDues!.merchantDues)} د'
                                : '-',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(fontSize: 26, color: Colors.white),
                          ),
                    ],
                  ),
                );
              },
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
                            context.read<MerchantHomeCubit>().date == 'null'
                                ? ''
                                : context.read<MerchantHomeCubit>().date,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.defaultColor,
                              fontWeight: FontWeightHelper.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              context.read<MerchantHomeCubit>().pressDateRange(context, tabIndex);
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
                color: AppColors.greyColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              height: 40,
              child: TabBar(
                isScrollable: true,
                indicator: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                unselectedLabelColor: AppColors.black.withValues(alpha: 0.6),
                unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium,
                labelColor: Colors.white,
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                onTap: (index) {
                  tabIndex = index;
                  context.read<MerchantHomeCubit>().getOrders(
                    page: 0,
                    status: tabIndex,
                    date: context.read<MerchantHomeCubit>().date,
                  );
                },
                tabs:
                    tabs
                        .map(
                          (e) => Tab(
                            child: Container(
                              height: double.infinity,
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(e),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
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
                final cubit = context.read<MerchantHomeCubit>();

                if (cubit.orders != null && cubit.orders!.isNotEmpty) {
                  return Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children:
                          tabs
                              .map(
                                (e) => DefaultListView(
                                  refresh:
                                      (page) => context.read<MerchantHomeCubit>().getOrders(
                                        page: page,
                                        status: tabIndex,
                                        date: context.read<MerchantHomeCubit>().date,
                                      ),
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
                                  onRefreshCall:
                                      () => context.read<MerchantHomeCubit>().getOrders(
                                        page: 0,
                                        status: tabIndex,
                                        date: context.read<MerchantHomeCubit>().date,
                                      ),
                                ),
                              )
                              .toList(),
                    ),
                  );
                } else {
                  return Expanded(
                    child: NoData(
                      refresh: () {
                        return context.read<MerchantHomeCubit>().getOrders(
                          page: 0,
                          status: tabIndex,
                          date: context.read<MerchantHomeCubit>().date,
                        );
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
