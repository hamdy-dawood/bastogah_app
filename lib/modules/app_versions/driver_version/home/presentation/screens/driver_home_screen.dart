import 'dart:async';

import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:bastoga/core/components/bottom_nav_bar/driver_default_bottom_nav.dart';
import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/components/default_flushbar.dart';
import 'package:bastoga/core/components/default_list_view.dart';
import 'package:bastoga/core/components/default_text_form_field.dart';
import 'package:bastoga/core/components/loader.dart';
import 'package:bastoga/core/components/no_data.dart';
import 'package:bastoga/core/components/svg_icons.dart';
import 'package:bastoga/core/components/warning_alert_pop_up.dart';
import 'package:bastoga/core/controllers/navigator_bloc/navigator_cubit.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/helpers/dialog_helper.dart';
import 'package:bastoga/core/routing/routes.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/firebase_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toastification/toastification.dart';
import '../cubit/driver_home_cubit.dart';
import '../widgets/driver_orders_card_view.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  List<String> tabs = ["قيد الانتظار", "قيد التنفيذ", "مكتمل"];

  int tabIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    final cubit = context.read<DriverHomeCubit>();

    cubit.checkLocationService().whenComplete(() {
      FirebaseNotifications.getFCM();
    });
    cubit.getProfile();
    getOrders();

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Get Orders Every 10 Sec
  void getOrders() {
    _timer = Timer.periodic(
      kDebugMode ? const Duration(minutes: 10) : const Duration(seconds: 10),
      (Timer timer) {
        final cubit = context.read<DriverHomeCubit>();
        if (cubit.devicePosition != null && tabIndex == 0) {
          cubit.getOrders(
            page: 0,
            lat: cubit.devicePosition!.latitude,
            lng: cubit.devicePosition!.longitude,
            status: tabIndex + 1,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DriverHomeCubit>();
    print(ModalRoute.of(context)?.settings.name);
    if (ModalRoute.of(context)?.settings.name == Routes.driverHomeScreen) {
      cubit.getDriverDues();
      context.read<NavigatorCubit>().driverCurrentIndex = 0;
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Image.asset(ImageManager.logo),
        ),
        title: Column(
          children: [
            CustomText(
              text: "أهلاً بك",
              color: AppColors.black1A,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
            SizedBox(height: 4),
            CustomText(
              text: "السائق النشط",
              color: AppColors.grey9A,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ],
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
      ),
      bottomNavigationBar: const DriverDefaultBottomNav(),
      body: DefaultTabController(
        length: tabs.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocListener<DriverHomeCubit, DriverHomeStates>(
              listener: (context, state) {
                if (state is DriverProfileSuccessState && cubit.profile!.active == false) {
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
              child: BlocConsumer<DriverHomeCubit, DriverHomeStates>(
                listener: (context, state) {
                  if (state is ServiceNotEnabledState) {
                    showDefaultFlushBar(
                      context: context,
                      color: AppColors.redE7.withValues(alpha: 0.6),
                      messageText: 'قم بتفعيل الوصول للموقع',
                    );
                  }

                  if (state is CurrentPreciseLocationFailState) {
                    cubit.checkLocationService();
                  }
                  if (state is PermissionDeniedState) {
                    showDefaultFlushBar(
                      context: context,
                      color: AppColors.redE7.withValues(alpha: 0.6),
                      messageText: 'قم بإعطاء سماحية للموقع',
                    );
                    cubit.checkLocationService();
                  }

                  if (state is PermissionDeniedForEverState) {
                    openAppSettings().whenComplete(() => cubit.checkLocationService());
                  }

                  if (state is CurrentPreciseLocationSuccessState) {
                    cubit.getOrders(
                      page: 0,
                      lat: cubit.devicePosition!.latitude,
                      lng: cubit.devicePosition!.longitude,
                      status: 1,
                    );
                  }
                },
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
                        state is DriverDuesLoadingState
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
                                    "${cubit.driverDues != null ? "${AppConstance.currencyFormat.format(cubit.driverDues!.driverDues)}" : "-"} د.ع",
                                color: AppColors.black1A,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                maxLines: 1,
                              ),
                            ),
                        const SizedBox(height: 5),
                        CustomText(
                          text: "مستحقات الشهر الحالي",
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
                        cubit.getOrders(
                          page: 0,
                          lat: cubit.devicePosition!.latitude,
                          lng: cubit.devicePosition!.longitude,
                          status: tabIndex + 1,
                        );
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
                      cubit.getOrders(
                        page: 0,
                        lat: cubit.devicePosition!.latitude,
                        lng: cubit.devicePosition!.longitude,
                        status: tabIndex + 1,
                      );
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
            SizedBox(height: 16),
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
                  if (cubit.devicePosition != null) {
                    cubit.orders = null;
                    cubit.getOrders(
                      page: 0,
                      lat: cubit.devicePosition!.latitude,
                      lng: cubit.devicePosition!.longitude,
                      status: index + 1,
                    );
                  }
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
            BlocConsumer<DriverHomeCubit, DriverHomeStates>(
              listener: (context, state) {
                if (state is EditOrderLoadingState) {
                  showDialog(context: context, builder: (context) => const Loader());
                }

                if (state is EditOrderFailState) {
                  context.pop();
                  showDefaultFlushBar(
                    context: context,
                    color: AppColors.redE7.withValues(alpha: 0.6),
                    messageText: state.message,
                  );
                }

                if (state is EditOrderSuccessState) {
                  context.pop();
                  showDefaultFlushBar(
                    context: context,
                    color: AppColors.greenColor.withValues(alpha: 0.6),
                    notificationType: ToastificationType.success,
                    messageText: state.success,
                  );
                  cubit.getOrders(
                    page: 0,
                    lat: cubit.devicePosition!.latitude,
                    lng: cubit.devicePosition!.longitude,
                    status: tabIndex + 1,
                  );
                }
              },
              builder: (context, state) {
                if (state is ServiceNotEnabledState) return const NoLocationAccessed();
                if (cubit.orders != null && cubit.orders!.isNotEmpty) {
                  return Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children:
                          tabs.map((e) {
                            return DefaultListView(
                              refresh: (page) {
                                return cubit.getOrders(
                                  page: page,
                                  lat: cubit.devicePosition!.latitude,
                                  lng: cubit.devicePosition!.longitude,
                                  status: tabIndex + 1,
                                );
                              },
                              itemBuilder: (context, index) {
                                return DriverOrdersCardView(
                                  order: cubit.orders![index],
                                  cubit: cubit,
                                );
                              },
                              length: cubit.orders!.length,
                              hasMore: false,
                              onRefreshCall: () {
                                return cubit.getOrders(
                                  page: 0,
                                  lat: cubit.devicePosition!.latitude,
                                  lng: cubit.devicePosition!.longitude,
                                  status: tabIndex + 1,
                                );
                              },
                            );
                          }).toList(),
                    ),
                  );
                } else if (cubit.orders != null && cubit.orders!.isEmpty) {
                  return Expanded(
                    child: NoData(
                      refresh: () {
                        return cubit.getOrders(
                          page: 0,
                          lat: cubit.devicePosition!.latitude,
                          lng: cubit.devicePosition!.longitude,
                          status: tabIndex + 1,
                        );
                      },
                    ),
                  );
                }
                return const Expanded(child: DefaultCircleProgressIndicator());
              },
            ),
            // const DriverOrdersSectionView(),
          ],
        ),
      ),
    );
  }
}

class NoLocationAccessed extends StatelessWidget {
  const NoLocationAccessed({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DriverHomeCubit>();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageManager.noDataImage,
            // scale: 6,
          ),
          Center(
            child: Text(
              'لا يمكن الوصول لموقعك في الوقت الحالي',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              cubit.checkLocationService();
            },
            child: const Icon(Icons.refresh, color: AppColors.defaultColor),
          ),
        ],
      ),
    );
  }
}
