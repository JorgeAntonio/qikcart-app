import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:qikcart/features/data/repositories_implement/auth_repository_impl.dart';
import 'package:qikcart/features/domain/repositories/auth_repository.dart';
import 'package:qikcart/features/domain/usecases/login_usecase.dart';
import 'package:qikcart/features/presentation/auth/controllers/login_controller.dart';

class DependencyInjection {
  static void init() {
    final dio = Dio();

    // Inyecta AuthRepositoryImpl como AuthRepository
    Get.put<AuthRepository>(AuthRepositoryImpl(dio));

    // Inyecta LoginUseCase, usando el AuthRepository
    Get.put(LoginUseCase(Get.find<AuthRepository>()));

    // Inyecta LoginController, usando el LoginUseCase
    Get.put(LoginController(Get.find<LoginUseCase>()));
  }
}
