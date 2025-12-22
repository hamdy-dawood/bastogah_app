import 'package:dartz/dartz.dart';

import '../../../../../../core/networking/errors/server_errors.dart';
import '../../../../merchant_version/reports/domain/entities/report.dart';
import '../../domain/repository/base_driver_report_repository.dart';
import '../data_source/base_remote_driver_reports_data_source.dart';

class DriverReportsRepository extends BaseDriverReportsRepository {
  final BaseRemoteDriverReportsDataSource dataSource;

  DriverReportsRepository(this.dataSource);

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
