import 'package:bastoga/modules/app_versions/client_version/my_orders/data/models/order_model.dart';
import 'package:bastoga/modules/app_versions/merchant_version/reports/data/models/report_model.dart';

import '../../../../../../core/caching/shared_prefs.dart';
import '../../../../../../core/networking/dio.dart';
import '../../../../../../core/networking/endpoints.dart';
import '../../../../../../core/networking/errors/errors_models/error_message_model.dart';
import '../../../../../../core/networking/errors/server_errors.dart';
import '../../../../../../core/utils/constance.dart';
import '../../../../client_version/my_profile/data/models/profile_model.dart';
import 'base_remote_driver_home_data_source.dart';

class RemoteDriverHomeDataSource extends BaseRemoteDriverHomeDataSource {
  final dioManager = DioManager();

  @override
  Future<List<ReportModel>> getDriverDues() async {
    final response = await dioManager.get(
      ApiConstants.fullReport,
      queryParameters: {"driver": Caching.getData(key: AppConstance.loggedInUserKey)},
    );

    if (response.statusCode == 200) {
      return List<ReportModel>.from(response.data.map((e) => ReportModel.fromJson(e)));
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<List<OrderModel>> getOrders({
    required int page,
    required double lat,
    required double lng,
    required int status,
  }) async {
    final response = await dioManager.get(
      ApiConstants.driverOrders,
      queryParameters: {
        "skip": page,
        "lat": lat,
        "lng": lng,
        "status": status,
        if (status != 1) "driver": Caching.getData(key: AppConstance.loggedInUserKey),
      },
    );

    if (response.statusCode == 200) {
      return List<OrderModel>.from(response.data.map((e) => OrderModel.fromJson(e)));
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<String> editOrder({
    required String orderId,
    required int status,
    String? canceledReason,
  }) async {
    final response = await dioManager.put(
      '${ApiConstants.orders}/$orderId',
      data: {
        "status": status,
        "fcmType":
            status == 1
                ? 0
                : status == 3
                ? 2
                : 3,
        if (canceledReason != null) "cancelReason": canceledReason,
      },
    );

    if (response.statusCode == 200) {
      return 'تم تعديل حالة الطلب بنجاح';
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<ProfileModel> getProfile() async {
    final response = await dioManager.get(ApiConstants.profile);

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(response.data);
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<String> setDriver({required String orderId}) async {
    final response = await dioManager.post(
      ApiConstants.setDriver,
      data: {"orderId": orderId, "driverId": Caching.getData(key: AppConstance.loggedInUserKey)},
    );

    if (response.statusCode == 201) {
      return 'تم قبول الطلب بنجاح';
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }
}
