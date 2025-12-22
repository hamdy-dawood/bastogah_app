import 'package:bastoga/modules/app_versions/client_version/home/data/data_source/base_remote_client_home_data_source.dart';
import 'package:bastoga/modules/app_versions/client_version/home/data/data_source/remote_client_home_data_source.dart';
import 'package:bastoga/modules/app_versions/client_version/home/data/repo/client_home_repository.dart';
import 'package:bastoga/modules/app_versions/client_version/home/domain/repository/base_client_home_repository.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/cubit/client_home_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/data/data_source/base_remote_merchant_order_data_source.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/data/data_source/remote_merchant_orders_data_source.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/data/repo/merchant_orders_repository.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/domain/repository/base_merchant_orders_repository.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/presentation/cubit/home_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/data/data_source/base_remote_merchant_profile_data_source.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/data/data_source/remote_merchant_profile_data_source.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/data/repo/merchant_profile_repository.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/domain/repository/base_merchant_profile_repository.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/cubit/merchant_profile_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../modules/app_versions/client_version/my_orders/data/data_sourse/base_remote_client_orders_data_source.dart';
import '../../modules/app_versions/client_version/my_orders/data/data_sourse/remote_client_orders_data_source.dart';
import '../../modules/app_versions/client_version/my_orders/data/repo/client_orders_repository.dart';
import '../../modules/app_versions/client_version/my_orders/domain/repository/base_client_orders_repository.dart';
import '../../modules/app_versions/client_version/my_orders/presentation/cubit/client_orders_cubit.dart';
import '../../modules/app_versions/driver_version/home/data/data_source/base_remote_driver_home_data_source.dart';
import '../../modules/app_versions/driver_version/home/data/data_source/remote_driver_home_data_source.dart';
import '../../modules/app_versions/driver_version/home/data/repo/driver_home_repository.dart';
import '../../modules/app_versions/driver_version/home/domain/repository/base_driver_home_repository.dart';
import '../../modules/app_versions/driver_version/home/presentation/cubit/driver_home_cubit.dart';
import '../../modules/app_versions/driver_version/reports/data/data_source/base_remote_driver_reports_data_source.dart';
import '../../modules/app_versions/driver_version/reports/data/data_source/remote_driver_reports_data_source.dart';
import '../../modules/app_versions/driver_version/reports/data/repo/driver_report_repository.dart';
import '../../modules/app_versions/driver_version/reports/domain/repository/base_driver_report_repository.dart';
import '../../modules/app_versions/driver_version/reports/presentation/cubit/driver_reports_cubit.dart';
import '../../modules/app_versions/merchant_version/products/data/data_source/base_remote_merchant_products_data_source.dart';
import '../../modules/app_versions/merchant_version/products/data/data_source/remote_merchant_products_data_source.dart';
import '../../modules/app_versions/merchant_version/products/data/repo/merchant_products_repository.dart';
import '../../modules/app_versions/merchant_version/products/domain/repository/base_merchant_products_repository.dart';
import '../../modules/app_versions/merchant_version/products/presentation/cubit/products_cubit.dart';
import '../../modules/app_versions/merchant_version/reports/data/data_source/base_remote_merchant_reports_data_source.dart';
import '../../modules/app_versions/merchant_version/reports/data/data_source/remote_merchant_reports_data_source.dart';
import '../../modules/app_versions/merchant_version/reports/data/repo/merchant_report_repository.dart';
import '../../modules/app_versions/merchant_version/reports/domain/repository/base_merchant_report_repository.dart';
import '../../modules/app_versions/merchant_version/reports/presentation/cubit/merchant_reports_cubit.dart';
import '../../modules/auth/data/data_source/base_remote_auth_data_source.dart';
import '../../modules/auth/data/data_source/remote_auth_data_source.dart';
import '../../modules/auth/data/repo/auth_repository.dart';
import '../../modules/auth/domain/repository/base_auth_repository.dart';
import '../../modules/auth/presentation/cubit/auth_cubit.dart';
import '../../modules/auth/presentation/cubit/splash_cubit.dart';
import '../controllers/navigator_bloc/navigator_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // navigator
  getIt.registerLazySingleton<NavigatorCubit>(() => NavigatorCubit());

  /// =================================== CLIENT ================================ ///

  // login
  getIt.registerLazySingleton<BaseRemoteAuthDataSource>(() => RemoteAuthDataSource());
  getIt.registerLazySingleton<BaseAuthRepository>(() => AuthRepository(getIt()));
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));
  getIt.registerFactory<SplashCubit>(() => SplashCubit(getIt()));

  // client home
  getIt.registerLazySingleton<BaseRemoteClientHomeDataSource>(() => RemoteClientHomeDataSource());
  getIt.registerLazySingleton<BaseClientHomeRepository>(() => ClientHomeRepository(getIt()));
  getIt.registerFactory<ClientHomeCubit>(() => ClientHomeCubit(getIt()));

  // client orders
  getIt.registerLazySingleton<BaseRemoteClientOrdersDataSource>(
    () => RemoteClientOrdersDataSource(),
  );
  getIt.registerLazySingleton<BaseClientOrdersRepository>(() => ClientOrdersRepository(getIt()));
  getIt.registerFactory<ClientOrdersCubit>(() => ClientOrdersCubit(getIt()));

  /// =================================== DRIVER ===================================== ///
  // driver orders home
  getIt.registerLazySingleton<BaseRemoteDriverHomeDataSource>(() => RemoteDriverHomeDataSource());
  getIt.registerLazySingleton<BaseDriverHomeRepository>(() => DriverHomeRepository(getIt()));
  getIt.registerFactory<DriverHomeCubit>(() => DriverHomeCubit(getIt()));

  // merchant reports
  getIt.registerLazySingleton<BaseRemoteDriverReportsDataSource>(
    () => RemoteDriverReportsDataSource(),
  );
  getIt.registerLazySingleton<BaseDriverReportsRepository>(() => DriverReportsRepository(getIt()));
  getIt.registerFactory<DriverReportsCubit>(() => DriverReportsCubit(getIt()));

  /// =================================== MERCHANT ===================================== ///
  // products
  getIt.registerLazySingleton<BaseRemoteMerchantProductsDataSource>(
    () => RemoteMerchantProductsDataSource(),
  );
  getIt.registerLazySingleton<BaseMerchantProductsRepository>(
    () => MerchantProductsRepository(getIt()),
  );
  getIt.registerFactory<MerchantProductsCubit>(() => MerchantProductsCubit(getIt()));

  // merchant orders
  getIt.registerLazySingleton<BaseRemoteMerchantOrdersDataSource>(
    () => RemoteMerchantOrdersDataSource(),
  );
  getIt.registerLazySingleton<BaseMerchantHomeRepository>(() => MerchantOrdersRepository(getIt()));
  getIt.registerFactory<MerchantHomeCubit>(() => MerchantHomeCubit(getIt()));

  // merchant profile
  getIt.registerLazySingleton<BaseRemoteMerchantProfileDataSource>(
    () => RemoteMerchantProfileDataSource(),
  );
  getIt.registerLazySingleton<BaseMerchantProfileRepository>(
    () => MerchantProfileRepository(getIt()),
  );
  getIt.registerFactory<MerchantProfileCubit>(() => MerchantProfileCubit(getIt()));

  // merchant reports
  getIt.registerLazySingleton<BaseRemoteMerchantReportsDataSource>(
    () => RemoteMerchantReportsDataSource(),
  );
  getIt.registerLazySingleton<BaseMerchantReportsRepository>(
    () => MerchantReportsRepository(getIt()),
  );
  getIt.registerFactory<MerchantReportsCubit>(() => MerchantReportsCubit(getIt()));
}
