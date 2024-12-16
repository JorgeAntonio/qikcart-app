import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:qikcart/core/core.dart';
import 'package:qikcart/features/domain/entities/client.dart';
import 'package:qikcart/features/domain/entities/comprobante.dart';
import 'package:qikcart/features/presentation/clients/controllers/client_controller.dart';
// import 'package:qikcart/features/presentation/pos/controllers/pos_controller.dart';
import 'package:qikcart/features/presentation/products/controllers/cart_controller.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

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
                      title: Text('Seleccionar Cliente'),
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
                        Get.snackbar('Error',
                            'El carrito está vacío. Agrega productos antes de pagar.');
                        return;
                      }

                      if (cartController.selectedClient.value == null) {
                        Get.snackbar('Error',
                            'Selecciona un cliente antes de continuar.');
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
                                SizedBox(width: 16),
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

class BoletaDialog extends StatelessWidget {
  final Comprobante comprobante;
  const BoletaDialog({super.key, required this.comprobante});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    // Función para generar el PDF de la boleta
    Future<void> generateBoletaPDF() async {
      final pdf = pw.Document();

      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Boleta de Pago',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Fecha: $formattedDate'),
              pw.SizedBox(height: 16),
              pw.Text(
                  'Cliente: ${cartController.selectedClient.value?.nombreComercial ?? 'Sin Cliente'}'),
              pw.SizedBox(height: 16),
              pw.Divider(),
              ...cartController.cartItems.map((cartItem) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(cartItem.item.nombre),
                    pw.Text('x${cartItem.cantidad.value}'),
                    pw.Text(
                        's/. ${cartItem.item.valorUnitario.toStringAsFixed(2)}'),
                  ],
                );
              }),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Subtotal:'),
                  pw.Text('s/. ${cartController.subtotal.toStringAsFixed(2)}'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Tax (0%)'),
                  pw.Text('s/. ${cartController.tax.toStringAsFixed(2)}'),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total'),
                  pw.Text('s/. ${cartController.total.toStringAsFixed(2)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          );
        },
      ));

      // Mostrar el PDF generado
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
        return pdf.save();
      });

      // Limpiamos el carrito y el cliente seleccionado
      cartController.clearCart(); // Limpiar carrito
      cartController.selectedClient.value = null; // Limpiar cliente
    }

    // Función para compartir el PDF de la boleta
    Future<void> shareBoletaPDF() async {
      final pdf = pw.Document();

      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Boleta de Pago',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Fecha: $formattedDate'),
              pw.SizedBox(height: 16),
              pw.Text(
                  'Cliente: ${cartController.selectedClient.value?.nombreComercial ?? 'Sin Cliente'}'),
              pw.SizedBox(height: 16),
              pw.Divider(),
              ...cartController.cartItems.map((cartItem) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(cartItem.item.nombre),
                    pw.Text('x${cartItem.cantidad.value}'),
                    pw.Text(
                        's/. ${cartItem.item.valorUnitario.toStringAsFixed(2)}'),
                  ],
                );
              }),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Subtotal:'),
                  pw.Text('s/. ${cartController.subtotal.toStringAsFixed(2)}'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Tax (0%)'),
                  pw.Text('s/. ${cartController.tax.toStringAsFixed(2)}'),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total'),
                  pw.Text('s/. ${cartController.total.toStringAsFixed(2)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          );
        },
      ));

      // Compartir el PDF generado
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'boleta.pdf');
      // Limpiamos el carrito y el cliente seleccionado
      cartController.clearCart(); // Limpiar carrito
      cartController.selectedClient.value = null; // Limpiar cliente
    }

    //retrieving the comprobante number from Get storage
    final comprobanteNumber = GetStorage().read('comprobanteNumber');
    final comprobanteNumberTopadLeft =
        comprobanteNumber.toString().padLeft(8, '0');

    return AlertDialog(
      title: Text('Boleta de Pago'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Serie: ${comprobante.serie}'),
          Text('Número: $comprobanteNumberTopadLeft'),
          Text('Fecha: ${comprobante.fechaEmision}'),
          Text(
              'Cliente: ${cartController.selectedClient.value?.nombreComercial ?? 'Sin Cliente'}'),
          Text('Total: s/. ${cartController.total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium),
          Divider(),

          // Items del carrito
          cartController.cartItems.isNotEmpty
              ? SizedBox(
                  height: 200, // Adjust the height as needed
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: cartController.cartItems.map((cartItem) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gap4,
                              Text(cartItem.item.nombre,
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                              Text(
                                  'Cantidad: ${cartItem.cantidad.value} x ${cartItem.item.valorUnitario.toStringAsFixed(2)}'),
                              gap4,
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              : SizedBox.shrink(),

          // Aquí puedes agregar más detalles del comprobante
          Divider(),
          Text('¿Deseas imprimir la boleta?'),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () async {
            // Aquí generamos el PDF
            // Puedes incluir la lógica para generar el PDF aquí
            await generateBoletaPDF();
            Get.back();
          },
          child: Text('Imprimir'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () async {
            // Aquí compartimos el PDF
            // Puedes incluir la lógica para compartir el PDF aquí
            await shareBoletaPDF();
            Get.back();
          },
          child: Text('Compartir'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () {
            Get.back();
            // Limpiamos el carrito y el cliente seleccionado
            cartController.clearCart(); // Limpiar carrito
            cartController.selectedClient.value = null; // Limpiar cliente
          },
          child: Text('Cerrar'),
        ),
      ],
    );
  }
}
