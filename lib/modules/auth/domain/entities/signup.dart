class Signup {
  final String? id;
  final String displayName;
  final String accessToken;
  final String refreshToken;
  final List<String> roles;

  Signup({
    required this.id,
    required this.displayName,
    required this.accessToken,
    required this.refreshToken,
    required this.roles,
  });
}

//"roles": [
//         "client"
//     ],
//     "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjhjN2JkMTFkYjk0M2JiZjdhY2NjZDQiLCJpYXQiOjE3MjA0ODI3NjksImV4cCI6MTcyMDUxMTU2OX0.eAABPAIZfN5_aQb6Zmsede_fOWCCO3IwXmNydW9nm2g",
//     "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjhjN2JkMTFkYjk0M2JiZjdhY2NjZDQiLCJpYXQiOjE3MjA0ODI3Njl9.jmG2mPtlJoM3DxhnpQr4XHjU1O3ALX52oDTWVIu8tLQ"
