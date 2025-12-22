import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:bastoga/core/components/bottom_nav_bar/merchant_default_bottom_nav.dart';
import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/components/default_flushbar.dart';
import 'package:bastoga/core/components/loader.dart';
import 'package:bastoga/core/components/warning_alert_pop_up.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/helpers/dialog_helper.dart';
import 'package:bastoga/core/routing/routes.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/firebase_notifications.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/cubit/client_home_cubit.dart';
import 'package:bastoga/modules/app_versions/client_version/my_profile/presentation/widgets/profile_info_row_item.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/cubit/merchant_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/components/app_version_widget.dart';

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
      appBar: AppBar(
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Image.asset(ImageManager.logo),
        ),
        title: const Text("حسابي"),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseUnsubscribe.unsubscribeFromTopics();
              Future.delayed(const Duration(milliseconds: 100)).whenComplete(() {
                context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate: (route) => false);
                Caching.clearAllData();
              });
            },
            icon: const Icon(Icons.power_settings_new) /*SvgPicture.asset(
              ImageManager.shoppingCartIcon,
            )*/,
          ),
        ],
      ),
      bottomNavigationBar: const MerchantDefaultBottomNav(),
      body: BlocBuilder<MerchantProfileCubit, MerchantProfileStates>(
        builder: (context, state) {
          if (context.read<MerchantProfileCubit>().profile != null) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(
                        "${AppConstance.imagePathApi}${context.read<MerchantProfileCubit>().profile!.image}",
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        context.read<MerchantProfileCubit>().profile!.displayName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(letterSpacing: 1.5),
                      ),
                    ),
                    Text(
                      '@${context.read<MerchantProfileCubit>().profile!.username}',
                      style: Theme.of(context).textTheme.bodySmall,
                      textDirection: TextDirection.ltr,
                    ),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('بياناتي', style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    const SizedBox(height: 10),
                    ProfileInfoRowItem(
                      iconPath: ImageManager.emailIcon,
                      value: context.read<MerchantProfileCubit>().profile!.username,
                    ),
                    AppConstance.horizontalDivider,
                    ProfileInfoRowItem(
                      iconPath: ImageManager.phoneIcon,
                      value: context.read<MerchantProfileCubit>().profile!.phone,
                    ),
                    if (context.read<MerchantProfileCubit>().profile!.region != null) ...[
                      AppConstance.horizontalDivider,
                      ProfileInfoRowItem(
                        iconPath: ImageManager.addressIcon,
                        value:
                            '${context.read<MerchantProfileCubit>().profile!.region},${context.read<MerchantProfileCubit>().profile!.city}',
                      ),
                    ],
                    AppConstance.horizontalDivider,
                    ProfileInfoRowItem(
                      iconPath: ImageManager.categoriesIcon,
                      value: "اقسام المنتجات",
                      onTap: () {
                        context.pushNamed(Routes.productCategoriesScreen);
                      },
                    ),
                    AppConstance.horizontalDivider,
                    ProfileInfoRowItem(
                      iconPath: ImageManager.bluetoothIcon,
                      value: "اعدادات الطابعة",
                      onTap: () {
                        context.pushNamed(Routes.printerScreen);
                      },
                    ),
                    AppConstance.horizontalDivider,
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
                          return ProfileInfoRowItem(
                            iconPath: ImageManager.disableAccount,
                            value: 'تعطيل الحساب',
                            valueColor: AppColors.redE7,
                            onTap: () {
                              DialogHelper.showCustomDialog(
                                context: context,
                                alertDialog: WarningAlertPopUp(
                                  image: ImageManager.warningIcon,
                                  description: 'هل أنت متأكد من تعطيل الحساب؟',
                                  btnContent: 'تعطيل الحساب',
                                  onPress: () {
                                    // context.read<MoreCubit>().updateProfile(
                                    //   context: context,
                                    //   active: false,
                                    // );
                                    context.read<ClientHomeCubit>().disableAccount();
                                  },
                                ),
                              );
                            },
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
