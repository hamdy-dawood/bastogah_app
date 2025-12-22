import 'package:dartz/dartz.dart';

import '../../../../../../core/networking/errors/server_errors.dart';
import '../../../../client_version/my_orders/domain/entities/orders.dart';
import '../../../../client_version/my_profile/domain/entities/profile.dart';
import '../../../../merchant_version/reports/domain/entities/report.dart';

abstract class BaseDriverHomeRepository {
  Future<Either<ServerError, List<Report>>> getDriverDues();

  Future<Either<ServerError, List<Orders>>> getOrders({
    required int page,
    required double lat,
    required double lng,
    required int status,
  });

  Future<Either<ServerError, String>> editOrder({
    required String orderId,
    required int status,
    String? canceledReason,
  });

  Future<Either<ServerError, String>> setDriver({required String orderId});

  Future<Either<ServerError, Profile>> getProfile();
}
