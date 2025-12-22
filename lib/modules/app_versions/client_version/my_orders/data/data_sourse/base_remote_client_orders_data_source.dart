import '../models/order_model.dart';

abstract class BaseRemoteClientOrdersDataSource {
  Future<List<OrderModel>> getOrders({required int page, required int? status});
}
