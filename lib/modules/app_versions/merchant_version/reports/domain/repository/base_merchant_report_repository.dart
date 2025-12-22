import 'package:dartz/dartz.dart';

import '../../../../../../core/networking/errors/server_errors.dart';
import '../entities/report.dart';

abstract class BaseMerchantReportsRepository {
  Future<Either<ServerError, List<Report>>> getChartReport({required int format});

  Future<Either<ServerError, List<Report>>> getSummaryReport({required int month});
}
