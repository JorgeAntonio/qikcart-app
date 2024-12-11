class LoginResponse {
  final String accessToken;
  final int userId;
  final String username;

  LoginResponse({
    required this.accessToken,
    required this.userId,
    required this.username,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access'],
      userId: json['user_id'],
      username: json['username'],
    );
  }
}
