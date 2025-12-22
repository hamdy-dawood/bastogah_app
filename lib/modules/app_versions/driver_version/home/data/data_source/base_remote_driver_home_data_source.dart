import '../../../../client_version/my_orders/data/models/order_model.dart';
import '../../../../client_version/my_profile/data/models/profile_model.dart';
import '../../../../merchant_version/reports/data/models/report_model.dart';

abstract class BaseRemoteDriverHomeDataSource {
  Future<List<ReportModel>> getDriverDues();

  Future<List<OrderModel>> getOrders({
    required int page,
    required double lat,
    required double lng,
    required int status,
  });

  Future<String> editOrder({required String orderId, required int status, String? canceledReason});

  Future<String> setDriver({required String orderId});

  Future<ProfileModel> getProfile();
}
