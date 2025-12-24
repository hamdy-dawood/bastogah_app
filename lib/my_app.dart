import 'package:bastoga/core/dependancy_injection/dependancy_injection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/controllers/navigator_bloc/navigator_cubit.dart';
import 'core/helpers/context_extention.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/utils/theme.dart';
import 'modules/app_versions/client_version/home/presentation/cubit/client_home_cubit.dart';
import 'modules/general_cubit/general_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ClientHomeCubit>()),
        BlocProvider(create: (context) => getIt<NavigatorCubit>()),
        BlocProvider(create: (context) => GeneralCubit()),
      ],
      child: NotificationListener(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: MaterialApp(
          title: "Bastogah",
          debugShowCheckedModeBanner: false,
          locale: context.locale,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          theme: lightTheme,
          initialRoute: Routes.splashScreen,
          onGenerateRoute: AppRouter().generateRoute,
          navigatorKey: navigatorKey,
          themeAnimationCurve: Curves.fastLinearToSlowEaseIn,
          themeAnimationDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
