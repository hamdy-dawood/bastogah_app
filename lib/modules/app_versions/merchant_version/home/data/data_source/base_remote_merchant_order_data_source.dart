import 'package:bastoga/modules/app_versions/client_version/my_orders/data/models/order_model.dart';

import '../../../../client_version/my_profile/data/models/profile_model.dart';
import '../../../reports/data/models/report_model.dart';

abstract class BaseRemoteMerchantOrdersDataSource {
  Future<List<ReportModel>> getMerchantDues();

  Future<List<OrderModel>> getOrders({required int page, required int status, String? date});

  Future setDriver({required String orderId, required String driverId});

  Future editOrder({required int status, required String orderId, String? canceledReason});

  Future<List<ProfileModel>> getDrivers({required int page, required String searchText});
}
