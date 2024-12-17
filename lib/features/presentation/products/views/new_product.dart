import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:qikcart/features/domain/entities/item_create.dart';
import 'package:qikcart/features/presentation/products/controllers/item_controller.dart';

class NewProductView extends HookWidget {
  const NewProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final itemController = Get.find<ItemController>();

    final nombreController = useTextEditingController();
    final descripcionController = useTextEditingController();
    final valorUnitarioController = useTextEditingController();
    final stockController = useTextEditingController();

    final isLoading = useState(false);

    void clearForm() {
      nombreController.clear();
      descripcionController.clear();
      valorUnitarioController.clear();
      stockController.clear();
    }

    Future<void> submitForm() async {
      if (nombreController.text.isNotEmpty &&
          descripcionController.text.isNotEmpty &&
          valorUnitarioController.text.isNotEmpty &&
          stockController.text.isNotEmpty) {
        final item = ItemCreate(
          nombre: nombreController.text,
          descripcion: descripcionController.text,
          valorUnitario: double.parse(valorUnitarioController.text),
          stock: int.parse(stockController.text),
          peso: int.parse('20'),
          volumen: int.parse('20'),
          codigoBarras: '123456789',
          unidadMedida: "4A",
          tipoPrecio: '01',
          codigoProducto: '10101515-',
          categoria: '14',
        );

        try {
          isLoading.value = true;
          Logger().i('Nuevo producto: ${item.toJson()}');
          await itemController.addItem(item);
          Get.snackbar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            colorText: Theme.of(context).colorScheme.onPrimary,
            'Producto agregado',
            'El producto se ha agregado correctamente',
          );
          clearForm();
        } catch (e) {
          Get.snackbar(
            backgroundColor: Theme.of(context).colorScheme.error,
            colorText: Theme.of(context).colorScheme.onError,
            'Error',
            'Hubo un error al agregar el producto',
          );
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar(
          backgroundColor: Theme.of(context).colorScheme.error,
          colorText: Theme.of(context).colorScheme.onError,
          'Error',
          'Por favor, complete todos los campos',
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return ListView(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              gap16,
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              gap16,
              TextFormField(
                controller: valorUnitarioController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Valor unitario'),
              ),
              gap16,
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock'),
              ),
              gap20,
              ElevatedButton(
                onPressed: itemController.isLoading.value
                    ? null
                    : submitForm, // Desactivar el botón si está cargando
                child: itemController.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Crear Producto'),
              ),
            ],
          );
        }),
      ),
    );
  }
}
