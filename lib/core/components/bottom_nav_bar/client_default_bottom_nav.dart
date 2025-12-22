import 'package:bastoga/core/components/components.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/helpers/dialog_helper.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../caching/shared_prefs.dart';
import '../../controllers/navigator_bloc/navigator_cubit.dart';
import '../../routing/routes.dart';
import '../../utils/colors.dart';
import '../../utils/constance.dart';

class ClientDefaultBottomNav extends StatelessWidget {
  const ClientDefaultBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        textTheme: Theme.of(context).textTheme.apply(fontFamily: AppConstance.appFomFamily),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0.0,
        iconSize: 22.0,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.defaultColor,
        unselectedItemColor: Colors.grey,
        currentIndex: context.read<NavigatorCubit>().clientCurrentIndex,
        onTap: (index) {
          if (Caching.getData(key: AppConstance.guestCachedKey) != null &&
              (index == 1 || index == 3)) {
            DialogHelper.showCustomDialog(
              context: context,
              alertDialog: WarningAlertPopUp(
                image: ImageManager.warningIcon,
                description: 'قم بتسجيل الدخول أولا!',
                btnContent: 'تسجيل الدخول',
                onPress: () {
                  context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate: (route) => false);
                },
              ),
            );
          } else {
            context.read<NavigatorCubit>().clientGoTo(
              index: index,
              context: context,
              screen: context.read<NavigatorCubit>().clientScreens[index],
              arguments: context,
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon:
                context.read<NavigatorCubit>().clientCurrentIndex == 0
                    ? CircleAvatar(
                      backgroundColor: AppColors.defaultColor,
                      child: SvgPicture.asset(ImageManager.coloredHomeIcon),
                    )
                    : CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: SvgPicture.asset(ImageManager.homeIcon),
                    ),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon:
                context.read<NavigatorCubit>().clientCurrentIndex == 1
                    ? CircleAvatar(
                      backgroundColor: AppColors.defaultColor,
                      child: SvgPicture.asset(ImageManager.coloredOrdersIcon),
                    )
                    : CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: SvgPicture.asset(ImageManager.ordersIcon),
                    ),
            label: "طلباتي",
          ),
          BottomNavigationBarItem(
            icon:
                context.read<NavigatorCubit>().clientCurrentIndex == 2
                    ? CircleAvatar(
                      backgroundColor: AppColors.defaultColor,
                      child: SvgPicture.asset(ImageManager.coloredFavoriteIcon),
                    )
                    : CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: SvgPicture.asset(ImageManager.favoriteGreyIcon),
                    ),
            label: "المفضلة",
          ),
          BottomNavigationBarItem(
            icon:
                context.read<NavigatorCubit>().clientCurrentIndex == 3
                    ? CircleAvatar(
                      backgroundColor: AppColors.defaultColor,
                      child: SvgPicture.asset(ImageManager.coloredProfileIcon),
                    )
                    : CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: SvgPicture.asset(ImageManager.profileIcon),
                    ),
            label: "حسابي",
          ),
        ],
      ),
    );
  }
}
