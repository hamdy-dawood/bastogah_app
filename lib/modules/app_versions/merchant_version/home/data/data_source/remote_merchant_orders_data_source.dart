import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:bastoga/core/networking/dio.dart';
import 'package:bastoga/core/networking/endpoints.dart';
import 'package:bastoga/core/networking/errors/errors_models/error_message_model.dart';
import 'package:bastoga/core/networking/errors/server_errors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/data/models/order_model.dart';
import 'package:bastoga/modules/app_versions/client_version/my_profile/data/models/profile_model.dart';
import 'package:bastoga/modules/app_versions/merchant_version/reports/data/models/report_model.dart';

import 'base_remote_merchant_order_data_source.dart';

class RemoteMerchantOrdersDataSource extends BaseRemoteMerchantOrdersDataSource {
  final dioManager = DioManager();

  @override
  Future<List<OrderModel>> getOrders({required int page, required int status, String? date}) async {
    final response = await dioManager.get(
      ApiConstants.orders,
      queryParameters: {
        "skip": page,
        "status": status,
        "merchant": Caching.getData(key: AppConstance.loggedInUserKey),
        if (date != null && date != 'null' && date.isNotEmpty) "startDate": date.split(" - ").first,
        if (date != null && date != 'null' && date.isNotEmpty) "endDate": date.split(" - ").last,
      },
    );

    if (response.statusCode == 200) {
      return List<OrderModel>.from(response.data.map((e) => OrderModel.fromJson(e)));
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  //===========================  SET DRIVER  ===========================//

  @override
  Future setDriver({required String orderId, required String driverId}) async {
    final response = await dioManager.post(
      ApiConstants.setDriver,
      data: {"orderId": orderId, "driverId": driverId},
    );

    if (response.statusCode == 201) {
      return "Set Driver Success";
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  //===========================  SET DRIVER  ===========================//

  @override
  Future editOrder({required int status, required String orderId, String? canceledReason}) async {
    final response = await dioManager.put(
      "${ApiConstants.orders}/$orderId",
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
      return "";
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<List<ProfileModel>> getDrivers({required int page, required String searchText}) async {
    final response = await dioManager.get(
      ApiConstants.drivers,
      queryParameters: {"skip": page, if (searchText.isNotEmpty) "searchText": searchText},
    );

    if (response.statusCode == 200) {
      return List<ProfileModel>.from(response.data.map((e) => ProfileModel.fromJson(e)));
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<List<ReportModel>> getMerchantDues() async {
    final response = await dioManager.get(
      ApiConstants.fullReport,
      queryParameters: {"merchant": Caching.getData(key: AppConstance.loggedInUserKey)},
    );

    if (response.statusCode == 200) {
      return List<ReportModel>.from(response.data.map((e) => ReportModel.fromJson(e)));
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }
}
