import '../../domain/entities/otp.dart';

class OTPModel extends OTP {
  OTPModel({required super.users});

  factory OTPModel.fromJson(Map<String, dynamic> json) =>
      OTPModel(users: List<String>.from(json['usernames'].map((e) => e)));
}
