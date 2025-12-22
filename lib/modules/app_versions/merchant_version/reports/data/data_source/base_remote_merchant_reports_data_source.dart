import '../models/report_model.dart';

abstract class BaseRemoteMerchantReportsDataSource {
  Future<List<ReportModel>> getChartReport({required int format});

  Future<List<ReportModel>> getSummaryReport({required int month});
}
