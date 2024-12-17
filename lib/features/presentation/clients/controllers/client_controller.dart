import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:qikcart/features/domain/entities/client.dart';
import 'package:qikcart/features/domain/entities/create_client.dart';
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

  // Método para agregar un cliente a la lista
  Future<void> addClient(CreateClient client) async {
    isLoading.value = true;
    try {
      final newClient = await fetchClients.createClient(client);
      clients.add(newClient);
    } catch (e) {
      Logger().e('Error al agregar cliente: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
