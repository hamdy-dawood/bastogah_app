class Login {
  final String id;
  final String accessToken;
  final String refreshToken;
  final List<String> roles;

  Login({
    required this.id,
    required this.accessToken,
    required this.refreshToken,
    required this.roles,
  });
}
