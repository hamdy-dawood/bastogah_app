import 'package:bastoga/core/components/default_flushbar.dart';
import 'package:bastoga/core/components/loader.dart';
import 'package:bastoga/core/components/warning_alert_pop_up.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/helpers/dialog_helper.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/cubit/client_home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/caching/shared_prefs.dart';
import '../../../../../../core/components/app_version_widget.dart';
import '../../../../../../core/components/bottom_nav_bar/driver_default_bottom_nav.dart';
import '../../../../../../core/components/default_emit_loading.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/utils/constance.dart';
import '../../../../../../core/utils/image_manager.dart';
import '../../../../../../firebase_notifications.dart';
import '../../../../client_version/my_profile/presentation/widgets/profile_info_row_item.dart';
import '../../../home/presentation/cubit/driver_home_cubit.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  @override
  void initState() {
    context.read<DriverHomeCubit>().getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: SizedBox(height: 40, child: Image.asset(ImageManager.logo)),
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
      bottomNavigationBar: const DriverDefaultBottomNav(),
      body: BlocBuilder<DriverHomeCubit, DriverHomeStates>(
        builder: (context, state) {
          if (context.read<DriverHomeCubit>().profile != null) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                      '${AppConstance.imagePathApi}${context.read<DriverHomeCubit>().profile!.image}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      context.read<DriverHomeCubit>().profile!.displayName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(letterSpacing: 1.5),
                    ),
                  ),
                  Text(
                    '@${context.read<DriverHomeCubit>().profile!.username}',
                    style: Theme.of(context).textTheme.bodySmall,
                    textDirection: TextDirection.ltr,
                  ),
                  const SizedBox(height: 32),
                  Row(children: [Text('بياناتي', style: Theme.of(context).textTheme.bodyLarge)]),
                  ProfileInfoRowItem(
                    iconPath: ImageManager.emailIcon,
                    value: context.read<DriverHomeCubit>().profile!.username,
                  ),
                  AppConstance.horizontalDivider,
                  ProfileInfoRowItem(
                    iconPath: ImageManager.phoneIcon,
                    value: context.read<DriverHomeCubit>().profile!.phone,
                  ),
                  AppConstance.horizontalDivider,
                  ProfileInfoRowItem(
                    iconPath: ImageManager.driverMoneyIcon,
                    value:
                        'سعر التوصيل (${context.read<DriverHomeCubit>().profile!.driverShippingPrice} د)',
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
            );
          } else {
            return const DefaultCircleProgressIndicator();
          }
        },
      ),
    );
  }
}
