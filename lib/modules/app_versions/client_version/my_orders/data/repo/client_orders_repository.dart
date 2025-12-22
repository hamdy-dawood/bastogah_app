import 'package:bastoga/core/networking/errors/server_errors.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/orders.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repository/base_client_orders_repository.dart';
import '../data_sourse/base_remote_client_orders_data_source.dart';

class ClientOrdersRepository extends BaseClientOrdersRepository {
  final BaseRemoteClientOrdersDataSource dataSource;

  ClientOrdersRepository(this.dataSource);

  @override
  Future<Either<ServerError, List<Orders>>> getOrders({
    required int page,
    required int? status,
  }) async {
    try {
      final result = await dataSource.getOrders(page: page, status: status);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }
}
