import 'package:bastoga/core/networking/errors/server_errors.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/orders.dart';
import 'package:bastoga/modules/app_versions/merchant_version/reports/domain/entities/report.dart';
import 'package:dartz/dartz.dart';

import '../../../../client_version/my_profile/domain/entities/profile.dart';
import '../../domain/repository/base_driver_home_repository.dart';
import '../data_source/base_remote_driver_home_data_source.dart';

class DriverHomeRepository extends BaseDriverHomeRepository {
  final BaseRemoteDriverHomeDataSource dataSource;

  DriverHomeRepository(this.dataSource);

  @override
  Future<Either<ServerError, List<Report>>> getDriverDues() async {
    try {
      final result = await dataSource.getDriverDues();

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, List<Orders>>> getOrders({
    required int page,
    required double lat,
    required double lng,
    required int status,
  }) async {
    try {
      final result = await dataSource.getOrders(page: page, lat: lat, lng: lng, status: status);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, String>> editOrder({
    required String orderId,
    required int status,
    String? canceledReason,
  }) async {
    try {
      final result = await dataSource.editOrder(
        orderId: orderId,
        status: status,
        canceledReason: canceledReason,
      );

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, Profile>> getProfile() async {
    try {
      final result = await dataSource.getProfile();

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, String>> setDriver({required String orderId}) async {
    try {
      final result = await dataSource.setDriver(orderId: orderId);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }
}
