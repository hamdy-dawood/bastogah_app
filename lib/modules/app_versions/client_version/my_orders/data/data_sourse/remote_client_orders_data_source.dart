import 'package:bastoga/modules/app_versions/client_version/my_orders/data/models/order_model.dart';

import '../../../../../../core/caching/shared_prefs.dart';
import '../../../../../../core/networking/dio.dart';
import '../../../../../../core/networking/endpoints.dart';
import '../../../../../../core/networking/errors/errors_models/error_message_model.dart';
import '../../../../../../core/networking/errors/server_errors.dart';
import '../../../../../../core/utils/constance.dart';
import 'base_remote_client_orders_data_source.dart';

class RemoteClientOrdersDataSource extends BaseRemoteClientOrdersDataSource {
  final dioManager = DioManager();

  @override
  Future<List<OrderModel>> getOrders({required int page, required int? status}) async {
    final response = await dioManager.get(
      ApiConstants.orders,
      queryParameters: {
        "skip": page,
        "client": Caching.getData(key: AppConstance.loggedInUserKey),
        if (status != null) "status": status,
      },
    );

    if (response.statusCode == 200) {
      return List<OrderModel>.from(response.data.map((e) => OrderModel.fromJson(e)));
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }
}
