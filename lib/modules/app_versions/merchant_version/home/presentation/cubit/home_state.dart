part of 'home_cubit.dart';

abstract class MerchantHomeStates {}

class HomeInitialState extends MerchantHomeStates {}

class MerchantDuesLoadingState extends MerchantHomeStates {}

// ========================  GET ORDERS  ========================== //

class LoadingState extends MerchantHomeStates {}

class OrdersSuccessState extends MerchantHomeStates {}

class OrdersFailState extends MerchantHomeStates {
  final String message;

  OrdersFailState({required this.message});
}

// ========================  SET DRIVER  ========================== //

class SetDriverLoadingState extends MerchantHomeStates {}

class SetDriverSuccessState extends MerchantHomeStates {
  final String message;

  SetDriverSuccessState({required this.message});
}

class SetDriverFailState extends MerchantHomeStates {
  final String message;

  SetDriverFailState({required this.message});
}
// ========================  CHANGE STATUS  ========================== //

class ChangeStatusLoadingState extends MerchantHomeStates {}

class ChangeStatusFailState extends MerchantHomeStates {
  final String message;

  ChangeStatusFailState({required this.message});
}

class ChangeStatusSuccessState extends MerchantHomeStates {}

// ========================  GET ORDERS  ========================== //

class GetHomeOrdersLoadingState extends MerchantHomeStates {}

class GetHomeOrdersSuccessState extends MerchantHomeStates {}

class GetHomeOrdersFailedState extends MerchantHomeStates {
  final String msg;

  GetHomeOrdersFailedState({required this.msg});
}

// ========================  ADD NEW ORDER  ========================== //

class MerchantAddOrderLoadingState extends MerchantHomeStates {}

class MerchantAddOrderSuccessState extends MerchantHomeStates {}

class MerchantAddOrderFailedState extends MerchantHomeStates {
  final String msg;

  MerchantAddOrderFailedState({required this.msg});
}

class ProfileLoadingState extends MerchantHomeStates {}

class ProfileSuccessState extends MerchantHomeStates {}

class ProfileFailState extends MerchantHomeStates {
  final String message;

  ProfileFailState({required this.message});
}

class GetDriversSuccessState extends MerchantHomeStates {}

class GetDriversFailState extends MerchantHomeStates {
  final String message;

  GetDriversFailState({required this.message});
}

// ========================  CALENDER  ========================== //

class UpdateDateStates extends MerchantHomeStates {}

// ====================== AUTO PRINTING ==================//

class AutoPrintingEnabledState extends MerchantHomeStates {}

class AutoPrintingDisabledState extends MerchantHomeStates {}

class MakeOrderInProgressLoadingState extends MerchantHomeStates {}

class MakeOrderInProgressSuccessState extends MerchantHomeStates {}

class MakeOrderInProgressErrorState extends MerchantHomeStates {
  final String message;

  MakeOrderInProgressErrorState(this.message);
}

class RemoveProductState extends MerchantHomeStates {}
