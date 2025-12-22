import 'package:bastoga/core/networking/errors/server_errors.dart';
import 'package:bastoga/modules/app_versions/merchant_version/reports/data/data_source/base_remote_merchant_reports_data_source.dart';
import 'package:bastoga/modules/app_versions/merchant_version/reports/domain/entities/report.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repository/base_merchant_report_repository.dart';

class MerchantReportsRepository extends BaseMerchantReportsRepository {
  final BaseRemoteMerchantReportsDataSource dataSource;

  MerchantReportsRepository(this.dataSource);

  @override
  Future<Either<ServerError, List<Report>>> getChartReport({required int format}) async {
    try {
      final result = await dataSource.getChartReport(format: format);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, List<Report>>> getSummaryReport({required int month}) async {
    try {
      final result = await dataSource.getSummaryReport(month: month);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }
}
