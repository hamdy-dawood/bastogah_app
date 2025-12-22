import '../models/config_model.dart';
import '../models/login_model.dart';
import '../models/otp_model.dart';
import '../models/region_city_model.dart';
import '../models/signup_model.dart';

abstract class BaseRemoteAuthDataSource {
  Future<LoginModel> login({required String userName, required String password});

  Future<List<RegionAndCityModel>> getRegions();

  Future<List<RegionAndCityModel>> getCities({required String region});

  Future<SignupModel> signUp({
    required String userName,
    required String phone,
    required String city,
    required String region,
    required String password,
    required String otpCode,
    required String verificationId,
  });

  Future<OTPModel> verifyPhone({required String phoneNumber});

  Future<String> sendOtp({required String phoneNumber});

  Future<void> changePassword({
    required String phone,
    required String otpCode,
    required String newPassword,
    required String username,
  });

  Future<ConfigModel> getConfig();
}
