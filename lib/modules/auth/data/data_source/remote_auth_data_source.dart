import 'package:bastoga/core/networking/dio.dart';
import 'package:bastoga/core/networking/endpoints.dart';
import 'package:bastoga/core/networking/errors/errors_models/error_message_model.dart';
import 'package:bastoga/core/networking/errors/server_errors.dart';
import 'package:bastoga/modules/auth/data/models/login_model.dart';
import 'package:bastoga/modules/auth/data/models/otp_model.dart';
import 'package:bastoga/modules/auth/data/models/region_city_model.dart';
import 'package:dio/dio.dart';

import '../models/config_model.dart';
import '../models/signup_model.dart';
import 'base_remote_auth_data_source.dart';

class RemoteAuthDataSource extends BaseRemoteAuthDataSource {
  final dioManager = DioManager();

  @override
  Future<LoginModel> login({required String userName, required String password}) async {
    try {
      final response = await dioManager.post(
        ApiConstants.login,
        data: {"username": userName, "password": password},
      );

      if (response.statusCode == 201) {
        return LoginModel.fromJson(response.data);
      } else {
        throw ServerError(ErrorMessageModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      throw ServerError(ErrorMessageModel(message: e.message.toString()));
    }
  }

  @override
  Future<List<RegionAndCityModel>> getCities({required String region}) async {
    try {
      final response = await dioManager.get(
        ApiConstants.cities,
        queryParameters: {"region": region},
      );

      if (response.statusCode == 200) {
        return List<RegionAndCityModel>.from(
          response.data.map((e) => RegionAndCityModel.fromJson(e)),
        );
      } else {
        throw ServerError(ErrorMessageModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      throw ServerError(ErrorMessageModel(message: e.message.toString()));
    }
  }

  @override
  Future<List<RegionAndCityModel>> getRegions() async {
    try {
      final response = await dioManager.get(ApiConstants.regions);

      if (response.statusCode == 200) {
        return List<RegionAndCityModel>.from(
          response.data.map((e) => RegionAndCityModel.fromJson(e)),
        );
      } else {
        throw ServerError(ErrorMessageModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      throw ServerError(ErrorMessageModel(message: e.message.toString()));
    }
  }

  @override
  Future<SignupModel> signUp({
    required String userName,
    required String phone,
    required String city,
    required String region,
    required String password,
    required String otpCode,
    required String verificationId,
  }) async {
    try {
      final response = await dioManager.post(
        ApiConstants.signup,
        data: {
          "displayName": userName,
          "username": userName,
          "password": password,
          "phone": phone,
          "city": city,
          "region": region,
          "code": otpCode,
          "verificationId": verificationId,
        },
      );

      if (response.statusCode == 201) {
        return SignupModel.fromJson(response.data);
      } else {
        throw ServerError(ErrorMessageModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      throw ServerError(ErrorMessageModel(message: e.message.toString()));
    }
  }

  @override
  Future<OTPModel> verifyPhone({required String phoneNumber}) async {
    try {
      final response = await dioManager.post(
        ApiConstants.verifications,
        data: {"phone": phoneNumber},
      );

      if (response.statusCode == 201) {
        return OTPModel.fromJson(response.data);
      } else {
        throw ServerError(ErrorMessageModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      throw ServerError(ErrorMessageModel(message: e.message.toString()));
    }
  }

  @override
  Future<String> sendOtp({required String phoneNumber}) async {
    try {
      final response = await dioManager.post(ApiConstants.sendOtp, data: {"phone": phoneNumber});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['verificationId'];
      } else {
        throw ServerError(ErrorMessageModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      throw ServerError(ErrorMessageModel(message: e.message.toString()));
    }
  }

  @override
  Future<void> changePassword({
    required String phone,
    required String otpCode,
    required String newPassword,
    required String username,
  }) async {
    try {
      final response = await dioManager.post(
        ApiConstants.forgetPassword,
        data: {
          "phone": phone,
          "otpCode": otpCode,
          "newPassword": newPassword,
          "username": username,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw ServerError(ErrorMessageModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      throw ServerError(ErrorMessageModel(message: e.message.toString()));
    }
  }

  @override
  Future<ConfigModel> getConfig() async {
    try {
      final response = await dioManager.get(ApiConstants.config);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ConfigModel.fromJson(response.data);
      } else {
        throw ServerError(ErrorMessageModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      throw ServerError(ErrorMessageModel(message: e.message.toString()));
    }
  }
}
