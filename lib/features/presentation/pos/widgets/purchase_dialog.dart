import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:qikcart/features/domain/entities/comprobante.dart';
import 'package:qikcart/features/presentation/products/controllers/cart_controller.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BoletaDialog extends StatelessWidget {
  final Comprobante comprobante;
  const BoletaDialog({super.key, required this.comprobante});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    // Datos ficticios de la empresa
    const String empresaNombre = "Mi Empresa S.A.C.";
    const String empresaRUC = "20512345678";
    const String empresaDireccion = "Av. Principal 123, Lima, Perú";
    const String logoUrl =
        "https://via.placeholder.com/150"; // Reemplaza con tu URL de logo

    // Generar qr
    final qrCode = QrImageView(
      data: '1234567890',
      version: QrVersions.auto,
      size: 200.0,
    );

    // Función para generar el PDF de la boleta
    Future<void> generateBoletaPDF() async {
      final pdf = pw.Document();

      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // Encabezado con Logo y detalles de la empresa
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(
                    pw.MemoryImage(NetworkAssetBundle(Uri.parse(logoUrl))
                        .load(logoUrl)
                        .then(
                          (value) => value.buffer.asUint8List(),
                        )
                        .asStream()
                        .first as Uint8List),
                    width: 80,
                    height: 80,
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(empresaNombre,
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.Text("RUC: $empresaRUC"),
                      pw.Text(empresaDireccion),
                      pw.Text("Fecha: $formattedDate"),
                      pw.Text("Comprobante: ${comprobante.serie}"),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
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
              // Código QR
              pw.Center(
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: 'Comprobante: ${comprobante.serie}\n'
                      'Total: s/. ${cartController.total.toStringAsFixed(2)}\n'
                      'Fecha: $formattedDate\n'
                      'Cliente: ${cartController.selectedClient.value?.nombreComercial ?? 'Consumidor Final'}',
                  width: 100,
                  height: 100,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Center(
                  child: pw.Text("Escanea el código QR para más detalles")),
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
                    physics: const BouncingScrollPhysics(),
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
