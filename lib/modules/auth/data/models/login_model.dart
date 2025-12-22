import '../../domain/entities/login.dart';

class LoginModel extends Login {
  LoginModel({
    required super.id,
    required super.accessToken,
    required super.refreshToken,
    required super.roles,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    id: json['_id'],
    accessToken: json['access_token'],
    refreshToken: json['refresh_token'],
    roles: List<String>.from(json['roles'].map((e) => e)),
  );
}
