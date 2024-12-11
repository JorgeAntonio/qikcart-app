import 'package:qikcart/features/data/models/login_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String username, String password);
}
