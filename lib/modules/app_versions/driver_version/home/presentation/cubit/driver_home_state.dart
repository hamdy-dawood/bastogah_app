part of 'driver_home_cubit.dart';

abstract class DriverHomeStates {}

class DriverHomeInitial extends DriverHomeStates {}

// ================== LOCATION STATES ============================= //

class ServiceNotEnabledState extends DriverHomeStates {}

class PermissionDeniedState extends DriverHomeStates {}

class PermissionDeniedForEverState extends DriverHomeStates {}

class CurrentPreciseLocationLoadingState extends DriverHomeStates {}

class CurrentPreciseLocationSuccessState extends DriverHomeStates {}

class CurrentPreciseLocationFailState extends DriverHomeStates {}

// ========================= DRIVER DUES ========================== //

class DriverDuesLoadingState extends DriverHomeStates {}

class LoadingState extends DriverHomeStates {}

class OrdersSuccessState extends DriverHomeStates {}

class OrdersFailState extends DriverHomeStates {
  final String message;

  OrdersFailState({required this.message});
}

//============================ EDIT ORDERS =================================//

class EditOrderLoadingState extends DriverHomeStates {}

class EditOrderSuccessState extends DriverHomeStates {
  final String success;

  EditOrderSuccessState({required this.success});
}

class EditOrderFailState extends DriverHomeStates {
  final String message;

  EditOrderFailState({required this.message});
}
//============================ GET PROFILE =================================//

class ProfileLoadingState extends DriverHomeStates {}

class DriverProfileSuccessState extends DriverHomeStates {}

class ProfileFailState extends DriverHomeStates {
  final String message;

  ProfileFailState({required this.message});
}
