import 'package:bastoga/core/components/map/route_tracker_app/view.dart';
import 'package:bastoga/core/components/printer/presentation/printer_settting_view.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/screens/discount_merchants_screen.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/driver_order_details_object.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/domain/entities/merchant_order_details_object.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/presentation/cubit/home_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/presentation/screens/merchant_details_screen.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/presentation/screens/merchant_home_screen.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/screens/merchant_products_screen.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/screens/merchant_request_driver.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/cubit/merchant_profile_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/screens/merchant_profile_screen.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/screens/product_categories_screen.dart';
import 'package:bastoga/modules/app_versions/merchant_version/reports/presentation/screens/merchant_reports_screen.dart';
import 'package:bastoga/modules/auth/presentation/screens/register_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/app_versions/client_version/favourites/presentation/screens/client_favorite_screen.dart';
import '../../modules/app_versions/client_version/home/domain/entities/merchant_details_object.dart';
import '../../modules/app_versions/client_version/home/domain/entities/product_details_object.dart';
import '../../modules/app_versions/client_version/home/domain/entities/sub_category_object.dart';
import '../../modules/app_versions/client_version/home/presentation/screens/client_home_screen.dart';
import '../../modules/app_versions/client_version/home/presentation/screens/merchant_details_screen.dart';
import '../../modules/app_versions/client_version/home/presentation/screens/new_order_screen.dart';
import '../../modules/app_versions/client_version/home/presentation/screens/product_details_screen.dart';
import '../../modules/app_versions/client_version/home/presentation/screens/sub_category_list_screen.dart';
import '../../modules/app_versions/client_version/my_orders/presentation/cubit/client_orders_cubit.dart';
import '../../modules/app_versions/client_version/my_orders/presentation/screens/client_order_details_screen.dart';
import '../../modules/app_versions/client_version/my_orders/presentation/screens/client_orders_screen.dart';
import '../../modules/app_versions/client_version/my_profile/presentation/screens/client_profile_screen.dart';
import '../../modules/app_versions/driver_version/home/presentation/cubit/driver_home_cubit.dart';
import '../../modules/app_versions/driver_version/home/presentation/screens/driver_home_screen.dart';
import '../../modules/app_versions/driver_version/home/presentation/screens/driver_order_details_screen.dart';
import '../../modules/app_versions/driver_version/profile/presentation/screens/driver_profile_screen.dart';
import '../../modules/app_versions/driver_version/reports/presentation/cubit/driver_reports_cubit.dart';
import '../../modules/app_versions/driver_version/reports/presentation/screens/driver_reports_screen.dart';
import '../../modules/app_versions/merchant_version/home/domain/entities/new_order_object.dart';
import '../../modules/app_versions/merchant_version/products/domain/entities/product_object.dart';
import '../../modules/app_versions/merchant_version/products/presentation/cubit/products_cubit.dart';
import '../../modules/app_versions/merchant_version/products/presentation/screens/add_edit_product_screen.dart';
import '../../modules/app_versions/merchant_version/products/presentation/screens/merchant_new_order_screen.dart';
import '../../modules/app_versions/merchant_version/reports/presentation/cubit/merchant_reports_cubit.dart';
import '../../modules/auth/domain/entities/otp_with_context.dart';
import '../../modules/auth/presentation/cubit/auth_cubit.dart';
import '../../modules/auth/presentation/screens/confirm_otp_screen.dart';
import '../../modules/auth/presentation/screens/forget_password_screen.dart';
import '../../modules/auth/presentation/screens/login_screen.dart';
import '../../modules/auth/presentation/screens/sign_up_screen.dart';
import '../../modules/auth/presentation/screens/splash_screen.dart';
import '../dependancy_injection/dependancy_injection.dart';
import 'routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case '/':
        return null;
      case Routes.splashScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => FadeTransition(opacity: anim, child: const SplashScreen()),
        );
      case Routes.loginScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) =>
                  BlocProvider(create: (context) => getIt<AuthCubit>(), child: const LoginScreen()),
        );
      case Routes.forgetPassword:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => ForgetPasswordScreen(blocContext: arguments as BuildContext),
        );
      case Routes.confirmOtpScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => ConfirmOtpScreen(otpWithContext: arguments as OTPWithContext),
        );
      case Routes.registerOtpScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => RegisterOtpScreen(registerContext: arguments as BuildContext),
        );
      case Routes.signUpScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, anim, anim1) => SignUpScreen(blocContext: arguments as BuildContext),
        );
      case Routes.clientHomeScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, anim, anim1) => const ClientHomeScreen(),
        );
      case Routes.discountMerchantsScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, anim, anim1) => const DiscountMerchantsScreen(),
        );
      case Routes.clientOrdersScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => BlocProvider(
                create: (context) => getIt<ClientOrdersCubit>(),
                child: const ClientOrdersScreen(),
              ),
        );
      case Routes.clientFavoriteScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, anim, anim1) => const ClientFavoriteScreen(),
        );
      case Routes.clientProfileScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, anim, anim1) => const ClientProfileScreen(),
        );

      case Routes.subCategoryListScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) =>
                  SubCategoryListScreen(categoryObject: arguments as SubCategoryObject),
        );
      case Routes.merchantDetailsScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) =>
                  MerchantDetailsScreen(merchantDetailsObject: arguments as MerchantDetailsObject),
        );
      case Routes.productDetailsScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) =>
                  ProductDetailsScreen(productDetailsObject: arguments as ProductDetailsObject),
        );

      case Routes.clientOrderDetailsScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => ClientOrderDetailsScreen(
                driverOrderDetailsObject: arguments as ClientOrderDetailsObject,
              ),
        );

      case Routes.newOrderScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => NewOrderScreen(newOrderObject: arguments as NewOrderObject),
        );

      // ==================  DRIVER ================== //
      case Routes.driverHomeScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => BlocProvider(
                create: (context) => getIt<DriverHomeCubit>(),
                child: const DriverHomeScreen(),
              ),
        );
      case Routes.driverReportsScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => BlocProvider(
                create: (context) => getIt<DriverReportsCubit>(),
                child: const DriverReportsScreen(),
              ),
        );
      case Routes.driverProfileScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => BlocProvider.value(
                value: getIt<DriverHomeCubit>(),
                child: const DriverProfileScreen(),
              ),
        );

      case Routes.driverOrderDetailsScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => DriverOrderDetailsScreen(
                driverOrderDetailsObject: arguments as ClientDriverOrderDetailsObject,
              ),
        );

      // ==================  MERCHANT ================== //
      case Routes.merchantHomeScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => getIt<MerchantHomeCubit>()),
                  BlocProvider(create: (context) => getIt<MerchantProfileCubit>()),
                ],
                child: const MerchantHomeScreen(),
              ),
        );
      case Routes.merchantProductsScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => BlocProvider(
                create: (context) => getIt<MerchantProductsCubit>(),
                child: const MerchantProductsScreen(),
              ),
        );
      case Routes.merchantRequestDriver:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: getIt<MerchantProductsCubit>()),
                  BlocProvider.value(value: getIt<MerchantHomeCubit>()),
                ],
                child: const MerchantRequestDriver(),
              ),
        );
      case Routes.routeTrackerAppMap:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => RouteTrackerAppMap(blocContext: arguments as BuildContext),
        );
      case Routes.merchantReportsScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => BlocProvider(
                create: (context) => getIt<MerchantReportsCubit>(),
                child: const MerchantReportsScreen(),
              ),
        );
      case Routes.merchantProfileScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => BlocProvider(
                create: (context) => getIt<MerchantProfileCubit>(),
                child: const MerchantProfileScreen(),
              ),
        );
      case Routes.productCategoriesScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => BlocProvider.value(
                value: getIt<MerchantProfileCubit>(),
                child: const ProductCategoriesScreen(),
              ),
        );
      case Routes.merchantOrderDetailsScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => MerchantOrderDetailsScreen(
                merchantOrderDetailsObject: arguments as MerchantOrderDetailsObject,
              ),
        );
      case Routes.merchantNewOrderScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) =>
                  MerchantNewOrderScreen(newOrderObject: arguments as NewOrderObject),
        );

      case Routes.addProductScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder:
              (_, anim, anim1) => AddEditProductScreen(productObject: arguments as ProductObject),
        );

      case Routes.printerScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, anim, anim1) => const PrinterSettingScreen(),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(body: Center(child: Text('No route defined for ${settings.name}'))),
        );
    }
  }
}
