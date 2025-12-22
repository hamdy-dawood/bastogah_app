import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/networking/errors/server_errors.dart';
import '../../domain/entities/report.dart';
import '../../domain/repository/base_merchant_report_repository.dart';

part 'merchant_reports_state.dart';

class MerchantReportsCubit extends Cubit<MerchantReportsStates> {
  final BaseMerchantReportsRepository baseMerchantReportsRepository;

  MerchantReportsCubit(this.baseMerchantReportsRepository) : super(MerchantReportsInitial());

  List<Report>? chartReports;

  Future getChartReport({required int format}) async {
    emit(ChartLoadingState());

    final Either<ServerError, List<Report>> response = await baseMerchantReportsRepository
        .getChartReport(format: format);

    response.fold((l) => emit(ChartFailState(message: l.errorMessageModel.message)), (r) {
      chartReports = r;
      emit(ChartSuccessState());
    });
  }

  List<Report>? summaryReports;

  Future getSummaryReport({required int month}) async {
    emit(SummaryLoadingState());

    final Either<ServerError, List<Report>> response = await baseMerchantReportsRepository
        .getSummaryReport(month: month);

    response.fold((l) => emit(ChartFailState(message: l.errorMessageModel.message)), (r) {
      summaryReports = r;
      emit(ChartSuccessState());
    });
  }
}
