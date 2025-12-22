import 'package:bastoga/core/networking/errors/server_errors.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/orders.dart';
import 'package:dartz/dartz.dart';

import '../../../../client_version/my_profile/domain/entities/profile.dart';
import '../../../reports/domain/entities/report.dart';

abstract class BaseMerchantHomeRepository {
  Future<Either<ServerError, List<Report>>> getMerchantDues();

  Future<Either<ServerError, List<Orders>>> getOrders({
    required int page,
    required int status,
    String? date,
  });

  Future<Either<ServerError, String>> setDriver({
    required String orderId,
    required String driverId,
  });

  Future<Either<ServerError, String>> editOrder({
    required int status,
    required String orderId,
    String? canceledReason,
  });

  Future<Either<ServerError, List<Profile>>> getDrivers({
    required int page,
    required String searchText,
  });
}
