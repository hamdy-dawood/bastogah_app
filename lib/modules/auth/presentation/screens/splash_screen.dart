import 'dart:async';

import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:bastoga/core/components/animation/scale_transition_animation.dart';
import 'package:bastoga/core/dependancy_injection/dependancy_injection.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/routing/routes.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/splash_cubit.dart';
import 'maintenance_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<SplashCubit>();

        final hasToken = Caching.getData(key: AppConstance.accessTokenKey) != null;

        if (hasToken) {
          cubit.getConfig();
        }

        return cubit;
      },
      child: const _SplashScreenContent(),
    );
  }
}

class _SplashScreenContent extends StatefulWidget {
  const _SplashScreenContent();

  @override
  State<_SplashScreenContent> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreenContent> {
  bool hasNavigated = false;
  bool isMaintenance = false;
  String maintenanceMsg = "";
  Timer? _timer;
  bool _minTimePassed = false;

  String getRoute() {
    if (Caching.getData(key: AppConstance.merchantCachedKey) != null) {
      return Routes.merchantHomeScreen;
    }
    if (Caching.getData(key: AppConstance.driverCachedKey) != null) {
      return Routes.driverHomeScreen;
    }
    if (Caching.getData(key: AppConstance.clientCachedKey) != null) {
      return Routes.clientHomeScreen;
    }
    return Routes.loginScreen;
  }

  void _checkNavigation() {
    if (hasNavigated || !_minTimePassed) return;

    hasNavigated = true;

    if (isMaintenance) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => MaintenanceScreen(message: maintenanceMsg)),
        (_) => false,
      );
    } else {
      context.pushNamedAndRemoveUntil(getRoute(), predicate: (_) => false);
    }
  }

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 3), () {
      _minTimePassed = true;
      _checkNavigation();
    });

    final hasToken = Caching.getData(key: AppConstance.accessTokenKey) != null;
    if (!hasToken) {
      Future.delayed(const Duration(seconds: 3), () {
        _minTimePassed = true;
        _checkNavigation();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashMaintenance) {
          isMaintenance = true;
          maintenanceMsg = state.message;
          _minTimePassed = true;
          _checkNavigation();
        }

        if (state is SplashSuccess) {
          _checkNavigation();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF6900), Color(0xFFFE9A00)],
            ),
          ),
          child: Center(
            child: ScaleTransitionAnimation(
              duration: Duration(milliseconds: 1500),
              child: Image.asset(ImageManager.logoWhite, height: 0.2 * context.screenHeight),
            ),
          ),
        ),
      ),
    );
  }
}
