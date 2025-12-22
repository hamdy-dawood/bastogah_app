import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/networking/errors/server_errors.dart';
import '../../../../merchant_version/reports/domain/entities/report.dart';
import '../../domain/repository/base_driver_report_repository.dart';

part 'driver_reports_state.dart';

class DriverReportsCubit extends Cubit<DriverReportsStates> {
  final BaseDriverReportsRepository baseDriverReportsRepository;

  DriverReportsCubit(this.baseDriverReportsRepository) : super(DriverReportsInitial());

  List<Report>? chartReports;

  Future getChartReport({required int format}) async {
    emit(ChartLoadingState());

    final Either<ServerError, List<Report>> response = await baseDriverReportsRepository
        .getChartReport(format: format);

    response.fold((l) => emit(ChartFailState(message: l.errorMessageModel.message)), (r) {
      chartReports = r;
      print(chartReports);
      emit(ChartSuccessState());
    });
  }

  List<Report>? summaryReports;

  Future getSummaryReport({required int month}) async {
    emit(SummaryLoadingState());

    final Either<ServerError, List<Report>> response = await baseDriverReportsRepository
        .getSummaryReport(month: month);

    response.fold((l) => emit(ChartFailState(message: l.errorMessageModel.message)), (r) {
      summaryReports = r;
      emit(ChartSuccessState());
    });
  }
}
