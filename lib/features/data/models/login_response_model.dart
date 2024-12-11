class LoginResponse {
  final String accessToken;
  final String ruc;

  LoginResponse({
    required this.accessToken,
    required this.ruc,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access'],
      ruc: json['ruc'],
    );
  }
}
