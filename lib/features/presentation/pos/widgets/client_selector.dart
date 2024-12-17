import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:qikcart/features/presentation/clients/controllers/client_controller.dart';
import 'package:qikcart/features/presentation/clients/views/create_client.dart';

class CustomerSelector extends HookWidget {
  const CustomerSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final clientController = Get.find<ClientController>();
    final searchController = useTextEditingController();
    final isLoading = useState(false);

    useEffect(() {
      clientController.loadClients(
        numeroDocumento: '',
        nombreComercial: '',
      );
      return null;
    }, []);

    Future<void> fetchClients({
      String? documentNumber,
      String? businessName,
    }) async {
      isLoading.value = true;
      try {
        await clientController.loadClients(
          numeroDocumento: documentNumber,
          nombreComercial: businessName,
        );
      } catch (e) {
        Get.snackbar('Error', 'No se pudieron cargar los clientes');
      } finally {
        isLoading.value = false;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Selecciona un cliente para continuar'),
          TextButton(
            onPressed: () {
              Get.to(() => CreateClientPage());
            },
            child: Text('Crear Cliente'),
          ),
          gap16,
          TextField(
            controller: searchController,
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                fetchClients(documentNumber: value);
              } else {
                fetchClients(businessName: value);
              }
            },
            decoration: InputDecoration(
              labelStyle: TextStyle(fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              labelText: 'Buscar por Documento o Nombre',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 16,
                    ),
                    onPressed: () {
                      searchController.clear();
                      fetchClients(
                        documentNumber: '',
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                    ),
                    onPressed: () {
                      fetchClients(
                        documentNumber: searchController.text,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          gap16,
          isLoading.value
              ? CircularProgressIndicator()
              : Expanded(
                  child: Obx(() {
                    if (clientController.clients.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('No se encontraron clientes. Intenta de nuevo.'),
                        ],
                      );
                    }
                    return ListView.builder(
                      itemCount: clientController.clients.length,
                      itemBuilder: (context, index) {
                        final client = clientController.clients[index];
                        return ListTile(
                          title: Text(client.nombreComercial),
                          subtitle: Text(client.numeroDocumento),
                          onTap: () {
                            // Devuelve el cliente seleccionado
                            Navigator.pop(context, client);
                          },
                        );
                      },
                    );
                  }),
                ),
        ],
      ),
    );
  }
}
