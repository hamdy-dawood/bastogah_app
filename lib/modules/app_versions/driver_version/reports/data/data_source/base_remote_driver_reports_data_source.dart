import '../../../../merchant_version/reports/data/models/report_model.dart';

abstract class BaseRemoteDriverReportsDataSource {
  Future<List<ReportModel>> getChartReport({required int format});

  Future<List<ReportModel>> getSummaryReport({required int month});
}
