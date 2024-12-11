import 'package:dio/dio.dart';
import 'package:qikcart/features/domain/repositories/auth_repository.dart';

import '../models/login_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<LoginResponse> login(String username, String password) async {
    try {
      final response = await _dio.post(
        'http://3.94.6.120:8000/api/login/',
        data: {
          'username': username,
          'password': password,
        },
      );

      return LoginResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }
}
