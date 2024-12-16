import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:qikcart/core/providers/theme_controller.dart';
import 'package:qikcart/features/data/repositories_implement/auth_repository_impl.dart';
import 'package:qikcart/features/data/repositories_implement/client_repository_impl.dart';
import 'package:qikcart/features/data/repositories_implement/comprobante_repository_impl.dart';
import 'package:qikcart/features/data/repositories_implement/item_repository_impl.dart';
import 'package:qikcart/features/domain/repositories/auth_repository.dart';
import 'package:qikcart/features/domain/repositories/client_repository.dart';
import 'package:qikcart/features/domain/repositories/comprobante_repository.dart';
import 'package:qikcart/features/domain/repositories/item_repository.dart';
import 'package:qikcart/features/domain/usecases/client_usecase.dart';
import 'package:qikcart/features/domain/usecases/create_comprobante_usecase.dart';
import 'package:qikcart/features/domain/usecases/generate_pdf_usecase.dart';
import 'package:qikcart/features/domain/usecases/get_items_usecase.dart';
import 'package:qikcart/features/domain/usecases/login_usecase.dart';
import 'package:qikcart/features/presentation/auth/controllers/login_controller.dart';
import 'package:qikcart/features/presentation/clients/controllers/client_controller.dart';
import 'package:qikcart/features/presentation/pos/controllers/pos_controller.dart';
import 'package:qikcart/features/presentation/products/controllers/cart_controller.dart';
import 'package:qikcart/features/presentation/products/controllers/item_controller.dart';

class DependencyInjection {
  static void init() {
    final dio = Dio();

    // Inyecta AuthRepositoryImpl como AuthRepository
    Get.put<AuthRepository>(AuthRepositoryImpl(dio));

    // Inyecta LoginUseCase, usando el AuthRepository
    Get.put(LoginUseCase(Get.find<AuthRepository>()));

    // Inyecta LoginController, usando el LoginUseCase
    Get.put(LoginController(Get.find<LoginUseCase>()));

    // Inyecta el ItemRepositoryImpl como ItemRepository
    Get.put<ItemRepository>(ItemRepositoryImpl(dio));

    // Inyecta GetItemsUseCase, usando el ItemRepository
    Get.put(GetItemsUseCase(Get.find<ItemRepository>()));

    // Inyecta el controlador ItemController
    Get.put(ItemController(Get.find<GetItemsUseCase>()));

    // Inyecta el controlador CartController
    Get.put(CartController());

    // Inyecta el controlador ThemeController
    Get.put(ThemeController());

    // Inyecta el controlador ClientController
    Get.put<ClientRepository>(ClientRepositoryImpl(dio));
    Get.put(ClientUsecase(Get.find<ClientRepository>()));
    Get.put(ClientController(Get.find<ClientUsecase>()));

    //Injectar el controlador de generar comprobante
    Get.put<ComprobanteRepository>(ComprobanteRepositoryImpl(dio));
    Get.put(CreateComprobanteUseCase(Get.find<ComprobanteRepository>()));
    Get.put(GeneratePDFUseCase(Get.find<ComprobanteRepository>()));
    Get.put(ComprobanteController(
      createComprobanteUseCase: Get.find<CreateComprobanteUseCase>(),
      generatePDFUseCase: Get.find<GeneratePDFUseCase>(),
    ));
  }
}
