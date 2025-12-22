import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/caching/shared_prefs.dart';
import '../../../../../core/dependancy_injection/dependancy_injection.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/utils/constance.dart';
import '../../../../core/utils/colors.dart';
import '../cubit/splash_cubit.dart';
import 'maintenance_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
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

class _SplashScreenState extends State<_SplashScreenContent> with SingleTickerProviderStateMixin {
  bool hasNavigated = false;
  bool isMaintenance = false;
  String maintenanceMsg = "";

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  String getRoute() {
    if (Caching.getData(key: AppConstance.merchantCachedKey) != null)
      return Routes.merchantHomeScreen;
    if (Caching.getData(key: AppConstance.driverCachedKey) != null) return Routes.driverHomeScreen;
    if (Caching.getData(key: AppConstance.clientCachedKey) != null) return Routes.clientHomeScreen;
    return Routes.loginScreen;
  }

  void _checkNavigation() {
    if (hasNavigated) return;

    hasNavigated = true;
    if (isMaintenance) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MaintenanceScreen(message: maintenanceMsg)),
        (route) => false,
      );
    } else {
      context.pushNamedAndRemoveUntil(getRoute(), predicate: (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), _checkNavigation);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashMaintenance) {
          isMaintenance = true;
          maintenanceMsg = state.message;
        }
        _checkNavigation();
      },
      child: Scaffold(
        backgroundColor: AppColors.defaultColor,
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFF6900), Color(0xFFFE9A00)],
              ),
            ),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Image.asset(ImageManager.logoWhite, height: 180),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
