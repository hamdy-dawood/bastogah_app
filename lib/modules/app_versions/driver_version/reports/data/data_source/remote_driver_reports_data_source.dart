import 'package:bastoga/modules/app_versions/merchant_version/reports/data/models/report_model.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/caching/shared_prefs.dart';
import '../../../../../../core/networking/dio.dart';
import '../../../../../../core/networking/endpoints.dart';
import '../../../../../../core/networking/errors/errors_models/error_message_model.dart';
import '../../../../../../core/networking/errors/server_errors.dart';
import '../../../../../../core/utils/constance.dart';
import 'base_remote_driver_reports_data_source.dart';

class RemoteDriverReportsDataSource extends BaseRemoteDriverReportsDataSource {
  final dioManager = DioManager();

  @override
  Future<List<ReportModel>> getChartReport({required int format}) async {
    final response = await dioManager.get(
      ApiConstants.fullReport,
      queryParameters: {
        "format": format,
        "driver": Caching.getData(key: AppConstance.loggedInUserKey),
      },
    );

    if (response.statusCode == 200) {
      return List<ReportModel>.from(response.data.map((e) => ReportModel.fromJson(e)));
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<List<ReportModel>> getSummaryReport({required int month}) async {
    // void printMonthDates(int monthNumber) {
    // Get the current year
    int currentYear = DateTime.now().year;

    // Create DateTime objects for the start and end of the selected month
    DateTime startDate = DateTime(currentYear, month, 1);
    DateTime endDate = DateTime(
      currentYear,
      month + 1,
      0,
    ); // Day 0 of next month is the last day of current month

    // Format the dates using DateFormat
    DateFormat dateFormat = DateFormat('yyyy-MM-dd', 'en');
    String formattedStartDate = dateFormat.format(startDate);
    String formattedEndDate = dateFormat.format(endDate);

    // Print the formatted dates
    print('Starting date of month $month: $formattedStartDate');
    print('Ending date of month $month: $formattedEndDate');
    // }

    final response = await dioManager.get(
      ApiConstants.fullReport,
      queryParameters: {
        "startDate": formattedStartDate,
        "endDate": formattedEndDate,
        "driver": Caching.getData(key: AppConstance.loggedInUserKey),
      },
    );

    if (response.statusCode == 200) {
      return List<ReportModel>.from(response.data.map((e) => ReportModel.fromJson(e)));
    } else {
      throw ServerError(ErrorMessageModel.fromJson(response.data));
    }
  }
}
