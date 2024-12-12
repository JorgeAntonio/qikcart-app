import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:qikcart/features/domain/usecases/login_usecase.dart';
import 'package:qikcart/lib.dart';

class LoginController extends GetxController {
  final LoginUseCase loginUseCase;

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  LoginController(this.loginUseCase);

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await loginUseCase(username, password);

      // Guarda el token en el almacenamiento local
      AuthProvider.saveToken(response.accessToken);

      // Log para depuración
      Logger().i('Usuario autenticado: ${response.ruc}');

      // Redirige al usuario al Home
      Get.offAllNamed(Routes.home.name);
    } catch (e) {
      errorMessage.value = 'Error: $e';
      Get.snackbar('Error', 'No se pudo iniciar sesión');
    } finally {
      isLoading.value = false;
    }
  }
}
