import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
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
    final tipoDocumento = useTextEditingController();
    final numeroDocumentoController = useTextEditingController();
    final celularController = useTextEditingController();
    final direccionController = useTextEditingController();
    final isLoading = useState(false);

    void clearForm() {
      nombreComercialController.clear();
      razonSocialController.clear();
      numeroDocumentoController.clear();
      direccionController.clear();
      celularController.clear();
      tipoDocumento.clear();
    }

    // Método para crear el cliente
    Future<void> createClient() async {
      final nombreComercial = nombreComercialController.text;
      final razonSocial = razonSocialController.text;
      final numeroDocumento = numeroDocumentoController.text;
      final direccion = direccionController.text;
      final celular = celularController.text;
      final documento = tipoDocumento.text;
      if (nombreComercial.isNotEmpty &&
          razonSocial.isNotEmpty &&
          numeroDocumento.isNotEmpty &&
          direccion.isNotEmpty &&
          celular.isNotEmpty) {
        final newClient = CreateClient(
          nombreComercial: nombreComercial,
          razonSocial: razonSocial,
          numeroDocumento: numeroDocumento,
          celular: celular,
          direccion: direccion,
          imagen:
              'https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png',
          tipoDocumento: int.parse(documento),
          ubigeo: 1,
          codigoPais: 1,
        );
        try {
          isLoading.value = true;
          Logger().i('Nuevo cliente: ${newClient.toJson()}');
          await clientController.addClient(newClient);
          Get.snackbar(
            'Cliente agregado',
            'El cliente se ha agregado correctamente',
          );
          clearForm();
        } catch (e) {
          Get.snackbar(
            backgroundColor: Theme.of(context).colorScheme.error,
            colorText: Theme.of(context).colorScheme.onError,
            'Error',
            'Hubo un error al agregar el cliente',
          );
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar(
          backgroundColor: Theme.of(context).colorScheme.error,
          colorText: Theme.of(context).colorScheme.onError,
          'Error',
          'Todos los campos son obligatorios',
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Cliente'),
      ),
      body: Padding(
        padding: edgeInsets16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Datos del cliente',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            gap2,
            Text(
              'Todos los campos son obligatorios',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            gap16,
            TextFormField(
              controller: nombreComercialController,
              decoration: InputDecoration(labelText: 'Nombre Comercial'),
            ),
            gap16,
            TextFormField(
              controller: razonSocialController,
              decoration: InputDecoration(labelText: 'Nombre o Razón Social'),
            ),
            gap16,
            DropdownButtonFormField<int>(
              value: tipoDocumento.text.isEmpty
                  ? null
                  : int.tryParse(tipoDocumento.text),
              decoration: InputDecoration(
                labelText: 'Tipo de documento',
              ),
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Text('DNI'),
                ),
                DropdownMenuItem(
                  value: 6,
                  child: Text('RUC'),
                ),
              ],
              onChanged: (value) {
                tipoDocumento.text = value.toString();
              },
            ),
            gap16,
            TextFormField(
              controller: numeroDocumentoController,
              decoration: InputDecoration(labelText: 'Numero de documento'),
              keyboardType: TextInputType.text,
            ),
            gap16,
            TextFormField(
              controller: celularController,
              decoration: InputDecoration(labelText: 'Celular'),
              keyboardType: TextInputType.text,
            ),
            gap16,
            TextFormField(
              controller: direccionController,
              decoration: InputDecoration(labelText: 'Dirección'),
              keyboardType: TextInputType.text,
            ),
            gap20,
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isLoading.value ? null : createClient,
                child: isLoading.value
                    ? const CircularProgressIndicator()
                    : Text('Crear Cliente'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
