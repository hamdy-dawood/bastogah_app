import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:bastoga/core/components/app_version_widget.dart';
import 'package:bastoga/core/components/bottom_nav_bar/merchant_default_bottom_nav.dart';
import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/components/default_flushbar.dart';
import 'package:bastoga/core/components/loader.dart';
import 'package:bastoga/core/components/warning_alert_pop_up.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/helpers/dialog_helper.dart';
import 'package:bastoga/core/routing/routes.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/firebase_notifications.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/cubit/client_home_cubit.dart';
import 'package:bastoga/modules/app_versions/client_version/my_profile/presentation/widgets/profile_info_row_item.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/presentation/widgets/row_icon_text.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/cubit/merchant_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MerchantProfileScreen extends StatefulWidget {
  const MerchantProfileScreen({super.key});

  @override
  State<MerchantProfileScreen> createState() => _MerchantProfileScreenState();
}

class _MerchantProfileScreenState extends State<MerchantProfileScreen> {
  @override
  void initState() {
    context.read<MerchantProfileCubit>().getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const MerchantDefaultBottomNav(),
      body: BlocBuilder<MerchantProfileCubit, MerchantProfileStates>(
        builder: (context, state) {
          if (context.read<MerchantProfileCubit>().profile != null) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    SizedBox.fromSize(
                      size: const Size.fromRadius(50),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                          "${AppConstance.imagePathApi}${context.read<MerchantProfileCubit>().profile!.image}",
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    CustomText(
                      text: context.read<MerchantProfileCubit>().profile!.displayName,
                      color: AppColors.black1A,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text: "@${context.read<MerchantProfileCubit>().profile!.username}",
                      color: AppColors.black4B,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      maxLines: 3,
                    ),
                    CustomText(
                      text: "${context.read<MerchantProfileCubit>().profile!.phone}",
                      color: AppColors.black4B,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),
                    // ProfileInfoRowItem(
                    //   iconPath: ImageManager.bluetoothIcon,
                    //   value: "اعدادات الطابعة",
                    //   onTap: () {
                    //     context.pushNamed(Routes.printerScreen);
                    //   },
                    // ),
                    ProfileInfoRowItem(
                      iconPath: ImageManager.categoriesIcon,
                      value: "إضافة الاقسام الفرعية",
                      onTap: () {
                        context.pushNamed(Routes.productCategoriesScreen);
                      },
                    ),
                    ProfileInfoRowItem(
                      iconPath: ImageManager.filterIcon,
                      value: "إضافة تصنيفات المنتج",
                      onTap: () {},
                    ),
                    ProfileInfoRowItem(
                      iconPath: ImageManager.notification2,
                      value: "الإشعارات",
                      onTap: () {},
                    ),
                    ProfileInfoRowItem(
                      iconPath: ImageManager.security,
                      value: "الخصوصية والأمان",
                      onTap: () {
                        context.pushNamed(Routes.securityScreen);
                      },
                    ),
                    ProfileInfoRowItem(
                      iconPath: ImageManager.help,
                      value: "المساعدة والدعم",
                      onTap: () {
                        context.pushNamed(Routes.supportScreen);
                      },
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        FirebaseUnsubscribe.unsubscribeFromTopics();
                        Future.delayed(const Duration(milliseconds: 100)).whenComplete(() {
                          context.pushNamedAndRemoveUntil(
                            Routes.loginScreen,
                            predicate: (route) => false,
                          );
                          Caching.clearAllData();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.redE7.withValues(alpha: 0.5)),
                        ),
                        child: RowIconText(
                          svgIcon: ImageManager.logout,
                          text: "تسجيل الخروج",
                          fontColor: AppColors.redE7,
                          height: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    BlocProvider.value(
                      value: context.read<ClientHomeCubit>(),
                      child: BlocConsumer<ClientHomeCubit, ClientHomeStates>(
                        listener: (context, state) {
                          if (state is DisableAccountLoadingState) {
                            showDialog(context: context, builder: (context) => const Loader());
                          }

                          if (state is DisableAccountFailState) {
                            context.pop();
                            showDefaultFlushBar(
                              context: context,
                              color: AppColors.redE7,
                              messageText: state.message,
                            );
                          }
                          if (state is DisableAccountSuccessState) {
                            FirebaseUnsubscribe.unsubscribeFromTopics();
                            Future.delayed(const Duration(milliseconds: 100)).whenComplete(() {
                              context.pushNamedAndRemoveUntil(
                                Routes.loginScreen,
                                predicate: (route) => false,
                              );
                              Caching.clearAllData();
                            });
                          }
                        },
                        builder: (context, state) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              DialogHelper.showCustomDialog(
                                context: context,
                                alertDialog: WarningAlertPopUp(
                                  image: ImageManager.warningIcon,
                                  description: 'هل أنت متأكد من تعطيل الحساب؟',
                                  btnContent: 'تعطيل الحساب',
                                  onPress: () {
                                    context.read<ClientHomeCubit>().disableAccount();
                                  },
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.redE7.withValues(alpha: 0.5)),
                              ),
                              child: RowIconText(
                                svgIcon: ImageManager.disableAccount,
                                text: "تعطيل الحساب",
                                fontColor: AppColors.redE7,
                                height: 20,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const AppVersionWidget(),
                  ],
                ),
              ),
            );
          } else {
            return const DefaultCircleProgressIndicator();
          }
        },
      ),
    );
  }
}
