import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:qikcart/features/domain/entities/create_client.dart';
import 'package:qikcart/features/presentation/clients/controllers/client_controller.dart';

class CreateClientPage extends HookWidget {
  const CreateClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final clientController = Get.find<ClientController>();

    // Uso de hooks para gestionar el estado de los campos del formulario
    final nombreComercialController = useTextEditingController();
    final razonSocialController = useTextEditingController();
    final numeroDocumentoController = useTextEditingController();
    final direccionController = useTextEditingController();

    // Método para crear el cliente
    Future<void> createClient() async {
      final nombreComercial = nombreComercialController.text;
      final razonSocial = razonSocialController.text;
      final numeroDocumento = numeroDocumentoController.text;
      final direccion = direccionController.text;

      if (nombreComercial.isNotEmpty &&
          razonSocial.isNotEmpty &&
          numeroDocumento.isNotEmpty) {
        final newClient = CreateClient(
          nombreComercial: nombreComercial,
          razonSocial: razonSocial,
          numeroDocumento: numeroDocumento,
          celular: '',
          direccion: direccion,
          imagen:
              'https://cdn2.iconfinder.com/data/icons/avatar-profession-circle/100/avatar_profession_employee-02-1024.png',
          tipoDocumento: '',
          ubigeo: 1,
          codigoPais: 1,
        );
        Logger().i('Nuevo cliente: ${newClient.toJson()}');
        await clientController.addClient(newClient);
        Get.snackbar(
            'Cliente agregado', 'El cliente se ha agregado correctamente');
      } else {
        Get.snackbar('Error', 'Todos los campos son obligatorios');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nombreComercialController,
              decoration: InputDecoration(labelText: 'Nombre Comercial'),
            ),
            TextField(
              controller: razonSocialController,
              decoration: InputDecoration(labelText: 'Razón Social'),
            ),
            TextField(
              controller: numeroDocumentoController,
              decoration: InputDecoration(labelText: 'Número de Documento'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: direccionController,
              decoration: InputDecoration(labelText: 'Dirección'),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createClient,
              child: Text('Crear Cliente'),
            ),
          ],
        ),
      ),
    );
  }
}
