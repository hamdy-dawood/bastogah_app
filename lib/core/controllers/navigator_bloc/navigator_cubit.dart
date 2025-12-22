import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routing/routes.dart';
import 'navigator_states.dart';

class NavigatorCubit extends Cubit<NavigatorStates> {
  NavigatorCubit() : super(NavigatorInitialState());

  static NavigatorCubit get(context) => BlocProvider.of(context);

  List<String> clientScreens = [
    Routes.clientHomeScreen,
    Routes.clientOrdersScreen,
    Routes.clientFavoriteScreen,
    Routes.clientProfileScreen,
  ];

  int clientCurrentIndex = 0;

  void clientGoTo({
    required BuildContext context,
    required int index,
    required dynamic screen,
    Object? arguments,
  }) {
    clientCurrentIndex = index;
    // GoRouter.of(context).push(screen);
    emit(ChangeNavBarState());

    // First we need to close the drawer to avoid any duplicated UI View
    // So First check if the drawer is opened or not
    // Use Try and Catch to Avoid any errors if the context don't have an scaffold instance
    try {
      if (Scaffold.of(context).isDrawerOpen) {
        Scaffold.of(context).closeDrawer();
      }
    } catch (e) {}

    //Case One
    //  First we need to know if there any screens in the stack or not
    if (ModalRoute.of(context)?.isFirst == true) {
      print('first');
      if (screen == Routes.clientHomeScreen) {
        print('1');
        return;
      } else {
        // Navigator.push(
        //   context,
        //   PageRouteBuilder(
        //     pageBuilder: (context, animation1, animation2) {
        //
        //     },
        //     transitionDuration: Duration.zero,
        //     reverseTransitionDuration: Duration.zero,
        //   ),
        // );
        print('2');
        context.pushNamed(screen, arguments: arguments);
      }
    }

    //Case Two
    //  First we need to know if there any screens in the stack or not
    if (ModalRoute.of(context)?.isFirst == false) {
      print('not first');
      if (screen == Routes.clientHomeScreen) {
        print('3');
        // context.pop();
        Navigator.of(context).popUntil((route) => route.isFirst);
        return;
      }
      context.pushReplacementNamed(screen, arguments: arguments);
    }
  }

  // ===================== DRIVER ================== //
  List<String> driverScreens = [
    Routes.driverHomeScreen,
    Routes.driverReportsScreen,
    Routes.driverProfileScreen,
  ];

  int driverCurrentIndex = 0;

  void driverGoTo({required BuildContext context, required int index, required dynamic screen}) {
    driverCurrentIndex = index;
    // GoRouter.of(context).push(screen);
    emit(ChangeNavBarState());

    // First we need to close the drawer to avoid any duplicated UI View
    // So First check if the drawer is opened or not
    // Use Try and Catch to Avoid any errors if the context don't have an scaffold instance
    try {
      if (Scaffold.of(context).isDrawerOpen) {
        Scaffold.of(context).closeDrawer();
      }
    } catch (e) {}

    //Case One
    //  First we need to know if there any screens in the stack or not
    if (ModalRoute.of(context)?.isFirst == true) {
      print('first');
      if (screen == Routes.driverHomeScreen) {
        print('1');
        return;
      } else {
        // Navigator.push(
        //   context,
        //   PageRouteBuilder(
        //     pageBuilder: (context, animation1, animation2) {
        //
        //     },
        //     transitionDuration: Duration.zero,
        //     reverseTransitionDuration: Duration.zero,
        //   ),
        // );
        print('2');
        context.pushNamed(screen);
      }
    }

    //Case Two
    //  First we need to know if there any screens in the stack or not
    if (ModalRoute.of(context)?.isFirst == false) {
      print('not first');
      if (screen == Routes.driverHomeScreen) {
        print('3');
        // context.pop();
        Navigator.of(context).popUntil((route) => route.isFirst);
        return;
      }
      context.pushReplacementNamed(screen);
    }
  }

  // ===================== MERCHANT ================== //
  List<String> merchantScreens = [
    Routes.merchantHomeScreen,
    Routes.merchantProductsScreen,
    Routes.merchantReportsScreen,
    Routes.merchantProfileScreen,
  ];

  int merchantCurrentIndex = 0;

  void merchantGoTo({required BuildContext context, required int index, required dynamic screen}) {
    merchantCurrentIndex = index;
    // GoRouter.of(context).push(screen);
    emit(ChangeNavBarState());

    // First we need to close the drawer to avoid any duplicated UI View
    // So First check if the drawer is opened or not
    // Use Try and Catch to Avoid any errors if the context don't have an scaffold instance
    try {
      if (Scaffold.of(context).isDrawerOpen) {
        Scaffold.of(context).closeDrawer();
      }
    } catch (e) {}

    //Case One
    //  First we need to know if there any screens in the stack or not
    if (ModalRoute.of(context)?.isFirst == true) {
      print('first');
      if (screen == Routes.merchantHomeScreen) {
        print('1');
        return;
      } else {
        // Navigator.push(
        //   context,
        //   PageRouteBuilder(
        //     pageBuilder: (context, animation1, animation2) {
        //
        //     },
        //     transitionDuration: Duration.zero,
        //     reverseTransitionDuration: Duration.zero,
        //   ),
        // );
        print('2');
        context.pushNamed(screen);
      }
    }

    //Case Two
    //  First we need to know if there any screens in the stack or not
    if (ModalRoute.of(context)?.isFirst == false) {
      print('not first');
      if (screen == Routes.merchantHomeScreen) {
        print('3');
        // context.pop();
        Navigator.of(context).popUntil((route) => route.isFirst);
        return;
      }
      context.pushReplacementNamed(screen);
    }
  }
}
