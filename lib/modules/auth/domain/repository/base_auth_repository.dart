import 'package:dartz/dartz.dart';

import '../../../../core/networking/errors/server_errors.dart';
import '../entities/config.dart';
import '../entities/login.dart';
import '../entities/otp.dart';
import '../entities/region.dart';
import '../entities/signup.dart';

abstract class BaseAuthRepository {
  Future<Either<ServerError, Login>> login({required String userName, required String password});

  Future<Either<ServerError, List<RegionAndCity>>> getRegions();

  Future<Either<ServerError, List<RegionAndCity>>> getCities({required String region});

  Future<Either<ServerError, Signup>> signUp({
    required String userName,
    required String phone,
    required String city,
    required String region,
    required String password,
    required String otpCode,
    required String verificationId,
  });

  Future<Either<ServerError, OTP>> verifyPhone({required String phoneNumber});

  Future<Either<ServerError, String>> sendOtp({required String phoneNumber});

  Future<Either<ServerError, void>> changePassword({
    required String phone,
    required String otpCode,
    required String newPassword,
    required String username,
  });

  Future<Either<ServerError, Config>> getConfig();
}
