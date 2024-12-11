import 'package:qikcart/features/data/models/login_response_model.dart';
import 'package:qikcart/features/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<LoginResponse> call(String username, String password) {
    return repository.login(username, password);
  }
}
