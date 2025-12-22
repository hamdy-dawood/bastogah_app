import 'dart:async';

import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:bastoga/core/networking/dio.dart';
import 'package:bastoga/core/networking/endpoints.dart';
import 'package:bastoga/core/networking/errors/server_errors.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/orders.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/domain/repository/base_merchant_orders_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../client_version/my_profile/domain/entities/profile.dart';
import '../../../reports/domain/entities/report.dart';

part 'home_state.dart';

class MerchantHomeCubit extends Cubit<MerchantHomeStates> {
  final BaseMerchantHomeRepository baseMerchantHomeRepository;

  MerchantHomeCubit(this.baseMerchantHomeRepository) : super(HomeInitialState());

  List<Orders>? orders;

  Future getOrders({required int page, required int status, String? date}) async {
    if (page == 0) {
      emit(LoadingState());
      final Either<ServerError, List<Orders>> response = await baseMerchantHomeRepository.getOrders(
        page: page,
        status: status,
        date: date,
      );

      response.fold((l) => emit(OrdersFailState(message: l.errorMessageModel.message)), (r) {
        orders = r;
        emit(OrdersSuccessState());
      });
    } else {
      final Either<ServerError, List<Orders>> response = await baseMerchantHomeRepository.getOrders(
        page: page,
        status: status,
        date: date,
      );

      response.fold((l) => emit(OrdersFailState(message: l.errorMessageModel.message)), (r) {
        orders!.addAll(r);
        emit(OrdersSuccessState());
      });
    }
  }

  //===========================  SET DRIVER  ===========================//

  String? setDriverMessage;

  Future setDriver({required String orderId, required String driverId}) async {
    emit(SetDriverLoadingState());

    final Either<ServerError, String> response = await baseMerchantHomeRepository.setDriver(
      orderId: orderId,
      driverId: driverId,
    );

    response.fold((l) => emit(SetDriverFailState(message: l.errorMessageModel.message)), (r) {
      setDriverMessage = r;
      emit(SetDriverSuccessState(message: setDriverMessage!));
    });
  }

  //===========================  CHANGE STATUS  ===========================//

  Future editOrder({required int status, required String orderId, String? canceledReason}) async {
    emit(ChangeStatusLoadingState());

    final Either<ServerError, String> response = await baseMerchantHomeRepository.editOrder(
      status: status,
      orderId: orderId,
      canceledReason: canceledReason,
    );

    response.fold((l) => emit(ChangeStatusFailState(message: l.errorMessageModel.message)), (r) {
      emit(ChangeStatusSuccessState());
    });
  }

  // ========================  GET DRIVERS ========================== //

  List<Profile>? drivers;

  Future getDrivers({required int page, required String searchText}) async {
    if (page == 0) {
      emit(LoadingState());

      final Either<ServerError, List<Profile>> response = await baseMerchantHomeRepository
          .getDrivers(page: page, searchText: searchText);

      response.fold((l) => emit(GetDriversFailState(message: l.errorMessageModel.message)), (r) {
        drivers = r;
        emit(GetDriversSuccessState());
      });
    } else {
      final Either<ServerError, List<Profile>> response = await baseMerchantHomeRepository
          .getDrivers(page: page, searchText: searchText);

      response.fold((l) => emit(GetDriversFailState(message: l.errorMessageModel.message)), (r) {
        drivers!.addAll(r);
        emit(GetDriversSuccessState());
      });
    }
  }

  // ========================= MERCHANT DUES ========================== //
  Report? merchantDues;

  Future getMerchantDues() async {
    emit(MerchantDuesLoadingState());

    final Either<ServerError, List<Report>> response =
        await baseMerchantHomeRepository.getMerchantDues();

    response.fold((l) => emit(OrdersFailState(message: l.errorMessageModel.message)), (r) {
      merchantDues = r.isNotEmpty ? r.first : null;
      emit(OrdersSuccessState());
    });
  }

  // ========================  CALENDER  ========================== //

  // DateTime? date;
  //
  // void pressFirstDate(context, int status) async {
  //   date = await showDatePicker(
  //     context: context,
  //     initialDate: date ?? DateTime.now(),
  //     firstDate: DateTime.now().subtract(const Duration(days: 360)),
  //     lastDate: DateTime.now(),
  //   );
  //   emit(UpdateDateStates());
  //   getOrders(page: 0, status: status, date: date);
  // }

  // ========================  CALENDER DATE RANGE  ========================== //

  DateTimeRange? dateTimeRange;
  String date = "";

  void pressDateRange(BuildContext context, int status) async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 360)),
      lastDate: DateTime.now(),
      initialDateRange: dateTimeRange ?? DateTimeRange(start: DateTime.now(), end: DateTime.now()),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      saveText: 'تأكيد',
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: AppColors.defaultColor,
              onPrimary: Colors.white,
              surface: Colors.blueAccent,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            dialogTheme: const DialogThemeData(elevation: 0.0, shadowColor: Colors.transparent),
          ),
          child: Center(
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350.0, maxHeight: 550),
                child: child!,
              ),
            ),
          ),
        );
      },
    );

    if (pickedRange != null) {
      dateTimeRange = pickedRange;
      date =
          "${"${dateTimeRange!.start.toLocal()}".split(' ')[0]} - ${"${dateTimeRange!.end.toLocal()}".split(' ')[0]}";
      emit(UpdateDateStates());
      getOrders(page: 0, status: status, date: date);
    }
  }

  // ====================== AUTO PRINTING ==================//

  bool isAutoPrintingEnabled = false;
  bool printingInProgress = false;

  void setAutoPrinting() {
    isAutoPrintingEnabled = !isAutoPrintingEnabled;
    Caching.saveData(key: "auto_printing", value: isAutoPrintingEnabled);
    if (isAutoPrintingEnabled) {
      emit(AutoPrintingEnabledState());
    } else {
      emit(AutoPrintingDisabledState());
    }
  }

  final dioManager = DioManager();

  Future<bool> makeOrderInProgress({required String orderId}) async {
    emit(MakeOrderInProgressLoadingState());

    bool printed = false;

    await dioManager
        .put('${ApiConstants.orders}/$orderId', data: {"status": 1, "fcmType": 0})
        .then((response) {
          final status = response.data['status'];
          if (status == 'success') {
            emit(MakeOrderInProgressSuccessState());
            printed = false;
          } else {
            final errorMessage = response.data['message'];
            print(errorMessage);

            emit(MakeOrderInProgressErrorState(errorMessage));
          }
        })
        .catchError((error) {
          print(error);

          emit(MakeOrderInProgressErrorState(error.toString()));
        });
    return printed;
  }

  void removeOrder({required Orders order}) {
    orders!.remove(order);
    emit(RemoveProductState());
  }
}
