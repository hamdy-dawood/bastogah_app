import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../../core/networking/errors/server_errors.dart';
import '../../../../client_version/my_orders/domain/entities/orders.dart';
import '../../../../client_version/my_profile/domain/entities/profile.dart';
import '../../../../merchant_version/reports/domain/entities/report.dart';
import '../../domain/repository/base_driver_home_repository.dart';

part 'driver_home_state.dart';

class DriverHomeCubit extends Cubit<DriverHomeStates> {
  final BaseDriverHomeRepository baseDriverHomeRepository;

  DriverHomeCubit(this.baseDriverHomeRepository) : super(DriverHomeInitial());

  //======================= LOCATION ========================//

  Position? devicePosition;

  Future checkLocationService() async {
    devicePosition = await myCheckLocation();
    if (devicePosition != null) {
      emit(CurrentPreciseLocationSuccessState());
    }
  }

  Future myCheckLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(ServiceNotEnabledState());
      return;
    }

    // here we check permission to show popup to the user
    permission = await Geolocator.checkPermission();
    emit(CurrentPreciseLocationLoadingState());

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(PermissionDeniedState());
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(PermissionDeniedForEverState());
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    return position;
  }

  //============================ GET PROFILE =================================//

  Profile? profile;

  Future getProfile() async {
    emit(ProfileLoadingState());

    final Either<ServerError, Profile> result = await baseDriverHomeRepository.getProfile();

    result.fold((l) => emit(ProfileFailState(message: l.errorMessageModel.message)), (r) {
      profile = r;
      emit(DriverProfileSuccessState());
    });
  }

  //============================ GET ORDERS =================================//

  final searchController = TextEditingController();

  List<Orders>? orders;

  Future getOrders({
    required int page,
    required double lat,
    required double lng,
    required int status,
  }) async {
    if (page == 0) {
      emit(LoadingState());

      final Either<ServerError, List<Orders>> response = await baseDriverHomeRepository.getOrders(
        page: page,
        lat: lat,
        lng: lng,
        status: status,
      );

      response.fold((l) => emit(OrdersFailState(message: l.errorMessageModel.message)), (r) {
        orders = r;
        emit(OrdersSuccessState());
      });
    } else {
      final Either<ServerError, List<Orders>> response = await baseDriverHomeRepository.getOrders(
        page: page,
        lat: lat,
        lng: lng,
        status: status,
      );

      response.fold((l) => emit(OrdersFailState(message: l.errorMessageModel.message)), (r) {
        orders!.addAll(r);
        emit(OrdersSuccessState());
      });
    }
  }

  //============================ SET DRIVER =================================//

  Future setDriver({required String orderId}) async {
    emit(EditOrderLoadingState());
    final Either<ServerError, String> response = await baseDriverHomeRepository.setDriver(
      orderId: orderId,
    );

    response.fold((l) => emit(EditOrderFailState(message: l.errorMessageModel.message)), (r) {
      emit(EditOrderSuccessState(success: r));
    });
  }

  //============================ EDIT ORDERS =================================//

  Future editOrder({required String orderId, required int status, String? canceledReason}) async {
    emit(EditOrderLoadingState());
    final Either<ServerError, String> response = await baseDriverHomeRepository.editOrder(
      orderId: orderId,
      status: status,
      canceledReason: canceledReason,
    );

    response.fold((l) => emit(EditOrderFailState(message: l.errorMessageModel.message)), (r) {
      emit(EditOrderSuccessState(success: r));
    });
  }

  // ========================= DRIVER DUES ========================== //

  Report? driverDues;

  Future getDriverDues() async {
    emit(DriverDuesLoadingState());

    final Either<ServerError, List<Report>> response =
        await baseDriverHomeRepository.getDriverDues();

    response.fold((l) => emit(OrdersFailState(message: l.errorMessageModel.message)), (r) {
      driverDues = r.isNotEmpty ? r.first : null;
      emit(OrdersSuccessState());
    });
  }
}
