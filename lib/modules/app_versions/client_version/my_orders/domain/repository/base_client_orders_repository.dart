import 'package:dartz/dartz.dart';

import '../../../../../../core/networking/errors/server_errors.dart';
import '../entities/orders.dart';

abstract class BaseClientOrdersRepository {
  Future<Either<ServerError, List<Orders>>> getOrders({required int page, required int? status});
}
