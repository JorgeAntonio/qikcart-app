import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:qikcart/core/core.dart';
import 'package:qikcart/features/domain/entities/client.dart';
import 'package:qikcart/features/domain/entities/comprobante.dart';
import 'package:qikcart/features/presentation/pos/widgets/client_selector.dart';
import 'package:qikcart/features/presentation/pos/widgets/purchase_dialog.dart';
import 'package:qikcart/features/presentation/products/controllers/cart_controller.dart';

class PosView extends HookWidget {
  const PosView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    Future<Client?> showCustomerSelector(BuildContext context) {
      return showModalBottomSheet<Client>(
        context: context,
        isScrollControlled: true,
        builder: (context) => FractionallySizedBox(
          heightFactor: 0.8,
          child: CustomerSelector(),
        ),
      );
    }

    DateTime now = DateTime.now();

    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final isProcessing =
        useState(false); // Estado para simular el procesamiento de pago

    final comprobanteSerie = '001';
    // Al iniciar, leer el número de comprobante desde el almacenamiento.
    final comprobanteNumber =
        useState<int>(GetStorage().read('comprobanteNumber') ?? 00000001);

    // Función para incrementar el número de comprobante
    void incrementComprobanteNumber() {
      comprobanteNumber.value++;
      // Guardar el nuevo número de comprobante en GetStorage
      GetStorage().write('comprobanteNumber', comprobanteNumber.value);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Obx(
        () {
          if (cartController.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Aun no hay productos en el carrito'),
                  gap16,
                  FilledButton.icon(
                    onPressed: () {
                      Get.offAll(IndexScreens());
                    },
                    label: Text(
                      'Continuar Comprando',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: edgeInsets16,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartController.cartItems[index];
                      return Card(
                        margin: edgeInsetsV8,
                        child: ListTile(
                          title: Text(cartItem.item.nombre),
                          subtitle: Text(
                              's/. ${cartItem.item.valorUnitario.toStringAsFixed(2)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  cartController.decrementItem(
                                    cartController.cartItems[index],
                                  );
                                },
                              ),
                              space4,
                              Obx(() {
                                // Asegurémonos de que la UI se actualice con el cambio en cantidad
                                return Text(
                                  '${cartItem.cantidad.value}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                );
                              }),
                              space4,
                              IconButton(
                                icon: Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  cartController.incrementItem(
                                    cartController.cartItems[index],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Seleccionar cliente',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        final selectedClient =
                            await showCustomerSelector(context);
                        if (selectedClient != null) {
                          cartController.selectedClient.value = selectedClient;
                        }
                      },
                    ),
                    Obx(() {
                      final client = cartController.selectedClient.value;
                      return client != null
                          ? ListTile(
                              title: Text('Cliente: ${client.nombreComercial}'),
                              subtitle:
                                  Text('Documento: ${client.numeroDocumento}'),
                            )
                          : SizedBox.shrink();
                    }),
                    Divider(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal', style: TextStyle(fontSize: 16)),
                          Text(
                              's/. ${cartController.subtotal.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tax (0%)'),
                          Text('s/. ${cartController.tax.toStringAsFixed(2)}'),
                        ],
                      ),
                      Divider(thickness: 1, height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total'),
                          Text('s/. ${cartController.total.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      // final comprobanteController =
                      //     Get.find<ComprobanteController>();
                      final cartController = Get.find<CartController>();

                      if (cartController.cartItems.isEmpty) {
                        Get.snackbar(
                          'Error',
                          backgroundColor: Theme.of(context).colorScheme.error,
                          'El carrito está vacío. Agrega productos antes de pagar.',
                        );
                        return;
                      }

                      if (cartController.selectedClient.value == null) {
                        Get.snackbar(
                          'Error',
                          backgroundColor: Theme.of(context).colorScheme.error,
                          colorText: Theme.of(context).colorScheme.onError,
                          'Selecciona un cliente antes de continuar.',
                        );
                        return;
                      }

                      isProcessing.value = true;
                      showDialog(
                        useSafeArea: true,
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Procesando Pago...'),
                            content: Row(
                              children: [
                                CircularProgressIndicator(),
                                space16,
                                Text('Esperando...'),
                              ],
                            ),
                          );
                        },
                      );

                      // Incrementa el número de comprobante
                      incrementComprobanteNumber();

                      // Simulamos el tiempo de pago
                      await Future.delayed(
                          Duration(seconds: 3)); // Simula el tiempo de pago

                      // Cierra el dialog de loading
                      Get.back();

                      // Crea el comprobante
                      final comprobanteData = Comprobante(
                        serie: comprobanteSerie,
                        numeroComprobante:
                            comprobanteNumber.value.toString().padLeft(8, '0'),
                        fechaEmision: formattedDate,
                        emitidoASunat: false,
                        emisor: 1, // Ajustar según el ID del emisor
                        adquiriente: 2,
                        tipoComprobante: '03', // Factura
                        tipoOperacion: '0101', // Venta Interna
                        tipoPago: 1, // Efectivo
                        codigoMoneda: 1, // Soles
                        resumenDeEmision: null,
                        estado: null,
                      );

                      // await comprobanteController
                      //     .createComprobante(comprobanteData);
                      // Mostramos la boleta
                      Get.dialog(
                        useSafeArea: true,
                        barrierDismissible: false,
                        BoletaDialog(comprobante: comprobanteData),
                      );

                      // Genera el PDF
                      // if (comprobanteController.comprobante != null) {
                      //   await comprobanteController.generatePDF(
                      //     emisor: 1, // Ajustar según el ID del emisor
                      //     comprador: 1,
                      //     items: cartController.cartItems.map((cartItem) {
                      //       return {
                      //         'id': cartItem.item.id,
                      //         'quantity': cartItem.cantidad.value.toString(),
                      //       };
                      //     }).toList(),
                      //     payTerms: [
                      //       {'metodo': 'contado'},
                      //     ],
                      //     observaciones: 'Gracias por tu compra.',
                      //     tipoPago: 3,
                      //     tipoPdf: 'A4',
                      //   );
                      // }
                    },
                    child: Text(
                      'Pagar',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
