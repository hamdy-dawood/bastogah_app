part of 'auth_cubit.dart';

abstract class AuthStates {}

class AuthInitial extends AuthStates {}

//========================= LOGIN ===========================//

class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {
  final String role;

  LoginSuccessState({required this.role});
}

class LoginFailState extends AuthStates {
  final String message;

  LoginFailState({required this.message});
}

class LoadingState extends AuthStates {}

//========================= REGION AND CITY ===========================//

class RegionAndCitySuccessState extends AuthStates {}

class RegionAndCityFailState extends AuthStates {
  final String message;

  RegionAndCityFailState({required this.message});
}

//========================= SIGN UP ===========================//

class SignUpLoadingState extends AuthStates {}

class SignUpSuccessState extends AuthStates {
  final Signup success;

  SignUpSuccessState({required this.success});
}

class SignUpFailState extends AuthStates {
  final String message;

  SignUpFailState({required this.message});
}

//========================= VERIFY ===========================//

class VerifyLoadingState extends AuthStates {}

class VerifySuccessState extends AuthStates {
  final OTP success;

  VerifySuccessState({required this.success});
}

class VerifyFailState extends AuthStates {
  final String message;

  VerifyFailState({required this.message});
}

//========================= CHANGE PASSWORD ===========================//

class ChangePasswordLoadingState extends AuthStates {}

class ChangePasswordSuccessState extends AuthStates {}

class ChangePasswordFailState extends AuthStates {
  final String message;

  ChangePasswordFailState({required this.message});
}

//========================= SEND OTP ===========================//

class SendOtpLoadingState extends AuthStates {}

class SendOtpSuccessState extends AuthStates {}

class SendOtpFailState extends AuthStates {
  final String message;

  SendOtpFailState({required this.message});
}

//========================= MAINTENANCE ===========================//

class AuthMaintenanceState extends AuthStates {
  final String message;

  AuthMaintenanceState({required this.message});
}
