import 'package:bastoga/core/networking/errors/server_errors.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/orders.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/data/data_source/base_remote_merchant_order_data_source.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/domain/repository/base_merchant_orders_repository.dart';
import 'package:bastoga/modules/app_versions/merchant_version/reports/domain/entities/report.dart';
import 'package:dartz/dartz.dart';

import '../../../../client_version/my_profile/domain/entities/profile.dart';

class MerchantOrdersRepository extends BaseMerchantHomeRepository {
  final BaseRemoteMerchantOrdersDataSource dataSource;

  MerchantOrdersRepository(this.dataSource);

  @override
  Future<Either<ServerError, List<Orders>>> getOrders({
    required int page,
    required int status,
    String? date,
  }) async {
    try {
      final result = await dataSource.getOrders(page: page, status: status, date: date);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  // ========================  SET DRIVER  ========================== //

  @override
  Future<Either<ServerError, String>> setDriver({
    required String orderId,
    required String driverId,
  }) async {
    try {
      final result = await dataSource.setDriver(orderId: orderId, driverId: driverId);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  // ========================  CHANGE STATUS  ========================== //

  @override
  Future<Either<ServerError, String>> editOrder({
    required int status,
    required String orderId,
    String? canceledReason,
  }) async {
    try {
      final result = await dataSource.editOrder(
        status: status,
        orderId: orderId,
        canceledReason: canceledReason,
      );

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  // ========================  GET DRIVER  ========================== //

  @override
  Future<Either<ServerError, List<Profile>>> getDrivers({
    required int page,
    required String searchText,
  }) async {
    try {
      final result = await dataSource.getDrivers(page: page, searchText: searchText);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, List<Report>>> getMerchantDues() async {
    try {
      final result = await dataSource.getMerchantDues();

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }
}
