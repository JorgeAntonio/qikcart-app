import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:qikcart/features/domain/entities/client.dart';
import 'package:qikcart/features/domain/usecases/client_usecase.dart';

class ClientController extends GetxController {
  final ClientUsecase fetchClients;
  final clients = <Client>[].obs;
  final isLoading = false.obs;

  ClientController(this.fetchClients);

  Future<void> loadClients({
    int page = 1,
    String? numeroDocumento,
    String? razonSocial,
    String? nombreComercial,
  }) async {
    isLoading.value = true;
    try {
      final clientList = await fetchClients(
        page: page,
        numeroDocumento: numeroDocumento,
        razonSocial: razonSocial,
        nombreComercial: nombreComercial,
      );
      clients.assignAll(clientList);
    } catch (e) {
      Logger().e('Error al cargar clientes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Método para filtrar clientes en la lista cargada
  Future<List<Client>> getFilteredClients(String query) async {
    return clients
        .where((client) => client.nombreComercial.contains(query))
        .toList();
  }
}
