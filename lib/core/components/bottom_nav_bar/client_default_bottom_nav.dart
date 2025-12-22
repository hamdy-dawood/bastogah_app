import 'package:bastoga/core/components/components.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/helpers/dialog_helper.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../caching/shared_prefs.dart';
import '../../controllers/navigator_bloc/navigator_cubit.dart';
import '../../controllers/navigator_bloc/navigator_states.dart';
import '../../routing/routes.dart';
import '../../utils/colors.dart';
import '../../utils/constance.dart';

class ClientDefaultBottomNav extends StatelessWidget {
  const ClientDefaultBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigatorCubit, NavigatorStates>(
      builder: (context, state) {
        final cubit = NavigatorCubit.get(context);
        final currentIndex = cubit.clientCurrentIndex;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                cubit: cubit,
                index: 0,
                label: "الرئيسية",
                iconPath: currentIndex == 0 ? ImageManager.coloredHomeIcon : ImageManager.homeIcon,
                isSelected: currentIndex == 0,
                colorIcon: false,
              ),
              _buildNavItem(
                context: context,
                cubit: cubit,
                index: 1,
                label: "طلباتي",
                iconPath:
                    currentIndex == 1 ? ImageManager.coloredOrdersIcon : ImageManager.ordersIcon,
                isSelected: currentIndex == 1,
                colorIcon: false,
              ),
              _buildNavItem(
                context: context,
                cubit: cubit,
                index: 2,
                label: "المفضلة",
                iconPath:
                    currentIndex == 2
                        ? ImageManager.coloredFavoriteIcon
                        : ImageManager.favoriteIcon,
                isSelected: currentIndex == 2,
                colorIcon: false,
              ),
              _buildNavItem(
                context: context,
                cubit: cubit,
                index: 3,
                label: "حسابي",
                iconPath:
                    currentIndex == 3 ? ImageManager.coloredProfileIcon : ImageManager.profileIcon,
                isSelected: currentIndex == 3,
                colorIcon: false,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required NavigatorCubit cubit,
    required int index,
    required String label,
    required String iconPath,
    required bool isSelected,
    bool colorIcon = true,
  }) {
    return GestureDetector(
      onTap: () {
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
          cubit.clientGoTo(
            index: index,
            context: context,
            screen: cubit.clientScreens[index],
            arguments: context,
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding:
            isSelected
                ? const EdgeInsets.symmetric(horizontal: 24, vertical: 8)
                : const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.defaultColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter:
                  colorIcon || (!isSelected && !iconPath.contains('colored'))
                      ? ColorFilter.mode(
                        isSelected ? AppColors.defaultColor : AppColors.orangeFF,
                        BlendMode.srcIn,
                      )
                      : null,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.defaultColor : AppColors.orangeFF,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
                fontFamily: AppConstance.appFomFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
