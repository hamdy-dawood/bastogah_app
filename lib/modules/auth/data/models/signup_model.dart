import '../../domain/entities/signup.dart';

class SignupModel extends Signup {
  SignupModel({
    required super.id,
    required super.displayName,
    required super.accessToken,
    required super.refreshToken,
    required super.roles,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) => SignupModel(
    id: json['_id'],
    displayName: json['displayName'],
    accessToken: json['access_token'],
    refreshToken: json['refresh_token'],
    roles: List<String>.from(json['roles'].map((e) => e)),
  );
}
