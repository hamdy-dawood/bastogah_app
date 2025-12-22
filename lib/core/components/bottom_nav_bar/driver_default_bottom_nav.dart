import 'package:bastoga/core/utils/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/navigator_bloc/navigator_cubit.dart';
import '../../utils/colors.dart';
import '../../utils/constance.dart';

class DriverDefaultBottomNav extends StatelessWidget {
  const DriverDefaultBottomNav({super.key});

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
        currentIndex: context.read<NavigatorCubit>().driverCurrentIndex,
        onTap: (index) {
          context.read<NavigatorCubit>().driverGoTo(
            index: index,
            context: context,
            screen: context.read<NavigatorCubit>().driverScreens[index],
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              ImageManager.homeIcon,
              colorFilter:
                  context.read<NavigatorCubit>().driverCurrentIndex == 0
                      ? const ColorFilter.mode(AppColors.defaultColor, BlendMode.srcIn)
                      : null,
            ),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              ImageManager.reportsIcon,
              colorFilter:
                  context.read<NavigatorCubit>().driverCurrentIndex == 1
                      ? const ColorFilter.mode(AppColors.defaultColor, BlendMode.srcIn)
                      : null,
            ),
            label: "التقارير",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              ImageManager.profileIcon,
              colorFilter:
                  context.read<NavigatorCubit>().driverCurrentIndex == 2
                      ? const ColorFilter.mode(AppColors.defaultColor, BlendMode.srcIn)
                      : null,
            ),
            label: "حسابي",
          ),
        ],
      ),
    );
  }
}
