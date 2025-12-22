import 'package:bastoga/core/networking/errors/server_errors.dart';
import 'package:bastoga/modules/auth/domain/entities/login.dart';
import 'package:bastoga/modules/auth/domain/entities/otp.dart';
import 'package:bastoga/modules/auth/domain/entities/region.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/config.dart';
import '../../domain/entities/signup.dart';
import '../../domain/repository/base_auth_repository.dart';
import '../data_source/base_remote_auth_data_source.dart';

class AuthRepository extends BaseAuthRepository {
  final BaseRemoteAuthDataSource dataSource;

  AuthRepository(this.dataSource);

  @override
  Future<Either<ServerError, Login>> login({
    required String userName,
    required String password,
  }) async {
    try {
      final result = await dataSource.login(userName: userName, password: password);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, List<RegionAndCity>>> getCities({required String region}) async {
    try {
      final result = await dataSource.getCities(region: region);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, List<RegionAndCity>>> getRegions() async {
    try {
      final result = await dataSource.getRegions();

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, Signup>> signUp({
    required String userName,
    required String phone,
    required String city,
    required String region,
    required String password,
    required String otpCode,
    required String verificationId,
  }) async {
    try {
      final result = await dataSource.signUp(
        userName: userName,
        phone: phone,
        city: city,
        region: region,
        password: password,
        otpCode: otpCode,
        verificationId: verificationId,
      );

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, OTP>> verifyPhone({required String phoneNumber}) async {
    try {
      final result = await dataSource.verifyPhone(phoneNumber: phoneNumber);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, String>> sendOtp({required String phoneNumber}) async {
    try {
      final result = await dataSource.sendOtp(phoneNumber: phoneNumber);

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, void>> changePassword({
    required String phone,
    required String otpCode,
    required String newPassword,
    required String username,
  }) async {
    try {
      final result = await dataSource.changePassword(
        phone: phone,
        otpCode: otpCode,
        newPassword: newPassword,
        username: username,
      );

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }

  @override
  Future<Either<ServerError, Config>> getConfig() async {
    try {
      final result = await dataSource.getConfig();

      return Right(result);
    } on ServerError catch (fail) {
      return Left(fail);
    }
  }
}
