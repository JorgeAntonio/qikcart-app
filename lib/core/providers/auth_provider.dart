import 'package:get_storage/get_storage.dart';

class AuthProvider {
  static final _storage = GetStorage();
  static const _tokenKey = 'auth_token';

  // Guardar el token en el almacenamiento local
  static void saveToken(String token) {
    _storage.write(_tokenKey, token);
  }

  // Obtener el token
  static String? getToken() {
    return _storage.read<String>(_tokenKey);
  }

  // Verificar si el usuario está autenticado
  static bool isAuthenticated() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  // Cerrar sesión
  static void logout() {
    _storage.remove(_tokenKey);
  }
}
