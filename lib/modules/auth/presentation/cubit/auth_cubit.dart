import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/caching/shared_prefs.dart';
import '../../../../core/networking/errors/server_errors.dart';
import '../../../../core/utils/constance.dart';
import '../../domain/entities/login.dart';
import '../../domain/entities/otp.dart';
import '../../domain/entities/region.dart';
import '../../domain/entities/signup.dart';
import '../../domain/repository/base_auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthStates> {
  final BaseAuthRepository baseAuthRepository;

  AuthCubit(this.baseAuthRepository) : super(AuthInitial());

  //========================= LOGIN ===========================//

  Future login({required String userName, required String password}) async {
    emit(LoginLoadingState());

    final Either<ServerError, Login> response = await baseAuthRepository.login(
      userName: userName,
      password: password,
    );

    response.fold((l) => emit(LoginFailState(message: l.errorMessageModel.message)), (r) async {
      Caching.saveData(key: AppConstance.accessTokenKey, value: 'Bearer ${r.accessToken}');
      Caching.saveData(key: AppConstance.refreshTokenKey, value: r.refreshToken);
      Caching.saveData(key: AppConstance.loggedInUserKey, value: r.id);

      final configResult = await baseAuthRepository.getConfig();
      configResult.fold((l) => emit(LoginFailState(message: l.errorMessageModel.message)), (
        config,
      ) {
        if (config.maintenanceMode) {
          emit(AuthMaintenanceState(message: config.maintenanceMsg));
        } else {
          emit(LoginSuccessState(role: r.roles.first));
        }
      });
    });
  }

  //========================= REGION AND CITY ===========================//

  List<RegionAndCity>? regions;

  Future getRegions() async {
    emit(LoadingState());

    final Either<ServerError, List<RegionAndCity>> response = await baseAuthRepository.getRegions();

    response.fold((l) => emit(RegionAndCityFailState(message: l.errorMessageModel.message)), (r) {
      regions = r;
      emit(RegionAndCitySuccessState());
    });
  }

  List<RegionAndCity>? cities;

  Future getCities({required String region}) async {
    if (region.isEmpty) {
      cities = null;
      emit(RegionAndCityFailState(message: 'Please select a region first'));
      return;
    }
    emit(LoadingState());

    final Either<ServerError, List<RegionAndCity>> response = await baseAuthRepository.getCities(
      region: region,
    );

    response.fold((l) => emit(RegionAndCityFailState(message: l.errorMessageModel.message)), (r) {
      cities = r;
      emit(RegionAndCitySuccessState());
    });
  }

  //========================= SIGN UP ===========================//

  Future signUp({
    required String userName,
    required String phone,
    required String city,
    required String region,
    required String password,
    required String otpCode,
  }) async {
    emit(SignUpLoadingState());

    final Either<ServerError, Signup> response = await baseAuthRepository.signUp(
      userName: userName,
      phone: phone,
      city: city,
      region: region,
      password: password,
      otpCode: otpCode,
      verificationId: verificationId,
    );

    response.fold((l) => emit(SignUpFailState(message: l.errorMessageModel.message)), (r) async {
      final configResult = await baseAuthRepository.getConfig();
      configResult.fold((l) => emit(SignUpFailState(message: l.errorMessageModel.message)), (
        config,
      ) {
        if (config.maintenanceMode) {
          emit(AuthMaintenanceState(message: config.maintenanceMsg));
        } else {
          Caching.saveData(key: AppConstance.accessTokenKey, value: 'Bearer ${r.accessToken}');
          Caching.saveData(key: AppConstance.refreshTokenKey, value: r.refreshToken);
          Caching.saveData(key: AppConstance.loggedInUserKey, value: r.id);
          emit(SignUpSuccessState(success: r));
        }
      });
    });
  }

  //========================= VERIFY ===========================//

  Future verifyPhone({required String phoneNumber}) async {
    emit(VerifyLoadingState());

    final Either<ServerError, OTP> response = await baseAuthRepository.verifyPhone(
      phoneNumber: phoneNumber,
    );

    response.fold((l) => emit(VerifyFailState(message: l.errorMessageModel.message)), (r) {
      emit(VerifySuccessState(success: r));
    });
  }

  //========================= SEND OTP ===========================//

  String verificationId = "";

  Future sendOtp({required String phoneNumber}) async {
    emit(SendOtpLoadingState());

    final Either<ServerError, String> response = await baseAuthRepository.sendOtp(
      phoneNumber: phoneNumber,
    );

    response.fold((l) => emit(SendOtpFailState(message: l.errorMessageModel.message)), (r) {
      verificationId = r;
      emit(SendOtpSuccessState());
    });
  }

  //========================= CHANGE PASSWORD ===========================//

  Future changePassword({
    required String phone,
    required String otpCode,
    required String newPassword,
    required String username,
  }) async {
    emit(ChangePasswordLoadingState());

    final Either<ServerError, void> response = await baseAuthRepository.changePassword(
      phone: phone,
      otpCode: otpCode,
      newPassword: newPassword,
      username: username,
    );

    response.fold((l) => emit(ChangePasswordFailState(message: l.errorMessageModel.message)), (r) {
      emit(ChangePasswordSuccessState());
    });
  }
}
