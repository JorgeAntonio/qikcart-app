import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

    // Datos del Voucher

    final comprobanteNumber = GetStorage().read('comprobanteNumber');
    final comprobanteNumberTopadLeft =
        comprobanteNumber.toString().padLeft(8, '0');
    final comprobanteSerie = comprobante.serie;
    final comprobanteFechaEmision = comprobante.fechaEmision;

    // Datos de tienda
    final storeName = 'Mi Tienda';
    final storeAddress = 'Calle Nauta 123';
    final storePhone = '123456789';
    final storeRuc = '1072960321';

    // Función para generar el QR como Uint8List
    Future<Uint8List> generateQR(String data) async {
      final qrPainter = QrPainter(
        data: data,
        version: QrVersions.auto,
        gapless: false,
      );

      final picData = await qrPainter.toImageData(200.0); // Tamaño del QR
      final buffer = picData!.buffer.asUint8List();
      return buffer;
    }

    Future<void> generateBoletaPDF() async {
      final pdf = pw.Document();

      // Generar QR con el dato deseado
      final Uint8List qrCodeData = await generateQR(
          'Boleta de Venta\nSerie: $comprobanteSerie\nNúmero: $comprobanteNumberTopadLeft\nFecha de emisión: $comprobanteFechaEmision\nCliente: ${cartController.selectedClient.value?.nombreComercial ?? 'Sin Cliente'}\nTotal: s/. ${cartController.total.toStringAsFixed(2)}');

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Encabezado de la tienda
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(storeName,
                          style: pw.TextStyle(
                              fontSize: 24, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text(storeAddress, style: pw.TextStyle(fontSize: 12)),
                      pw.Text('Teléfono: $storePhone',
                          style: pw.TextStyle(fontSize: 12)),
                      pw.Text('RUC: $storeRuc',
                          style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                pw.Divider(thickness: 1, height: 20),

                // Información del comprobante
                pw.SizedBox(height: 8),
                pw.Text('Boleta de Venta',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text('Serie: $comprobanteSerie'),
                pw.Text('Número: $comprobanteNumberTopadLeft'),
                pw.Text('Fecha de emisión: $comprobanteFechaEmision'),
                pw.SizedBox(height: 8),

                // Información del cliente
                pw.Text(
                    'Cliente: ${cartController.selectedClient.value?.nombreComercial ?? 'Sin Cliente'}',
                    style: pw.TextStyle(fontSize: 12)),
                pw.Divider(thickness: 1, height: 20),

                // Tabla de productos
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  columnWidths: {
                    0: pw.FlexColumnWidth(4),
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(2),
                  },
                  children: [
                    // Encabezados
                    pw.TableRow(
                      decoration:
                          const pw.BoxDecoration(color: PdfColors.grey300),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Descripción',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Cant.',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Precio',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12)),
                        ),
                      ],
                    ),
                    // Filas de productos
                    ...cartController.cartItems.map((cartItem) {
                      return pw.TableRow(children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(cartItem.item.nombre),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('${cartItem.cantidad.value}'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                              's/. ${cartItem.item.valorUnitario.toStringAsFixed(2)}'),
                        ),
                      ]);
                    }),
                  ],
                ),
                pw.SizedBox(height: 8),

                // Totales
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                            'Subtotal: s/. ${cartController.subtotal.toStringAsFixed(2)}'),
                        pw.Text(
                            'Tax (0%): s/. ${cartController.tax.toStringAsFixed(2)}'),
                        pw.SizedBox(height: 4),
                        pw.Text(
                            'Total: s/. ${cartController.total.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
                pw.Divider(thickness: 1, height: 20),

                // Mensaje final y QR
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                          'Bienes transferidos en la amazonía región selva para ser consumidos en la misma.\nNo se aceptan devoluciones ni cambios de productos.\nGracias por su compra.',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(fontSize: 10)),
                      pw.SizedBox(height: 16),
                      pw.Image(pw.MemoryImage(qrCodeData),
                          width: 100, height: 100),
                      pw.SizedBox(height: 8),
                      pw.Text('Escanea el código QR para más información',
                          style: pw.TextStyle(fontSize: 10)),
                      pw.SizedBox(height: 16),
                      pw.Text(
                          'Por favor, conserve su boleta de venta para cualquier reclamo o devolución.',
                          style: pw.TextStyle(fontSize: 10),
                          textAlign: pw.TextAlign.center),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Mostrar el PDF generado
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
        return pdf.save();
      });

      // Limpiar carrito y cliente seleccionado
      cartController.clearCart();
      cartController.selectedClient.value = null;
    }

    Future<void> shareBoletaPDF() async {
      final pdf = pw.Document();

      // Generar QR con el dato deseado
      final Uint8List qrCodeData = await generateQR(
          'Boleta de Venta\nSerie: $comprobanteSerie\nNúmero: $comprobanteNumberTopadLeft\nFecha de emisión: $comprobanteFechaEmision\nCliente: ${cartController.selectedClient.value?.nombreComercial ?? 'Sin Cliente'}\nTotal: s/. ${cartController.total.toStringAsFixed(2)}');

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Encabezado de la tienda
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(storeName,
                          style: pw.TextStyle(
                              fontSize: 24, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text(storeAddress, style: pw.TextStyle(fontSize: 12)),
                      pw.Text('Teléfono: $storePhone',
                          style: pw.TextStyle(fontSize: 12)),
                      pw.Text('RUC: $storeRuc',
                          style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                pw.Divider(thickness: 1, height: 20),

                // Información del comprobante
                pw.SizedBox(height: 8),
                pw.Text('Boleta de Venta',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text('Serie: $comprobanteSerie'),
                pw.Text('Número: $comprobanteNumberTopadLeft'),
                pw.Text('Fecha de emisión: $comprobanteFechaEmision'),
                pw.SizedBox(height: 8),

                // Información del cliente
                pw.Text(
                    'Cliente: ${cartController.selectedClient.value?.nombreComercial ?? 'Sin Cliente'}',
                    style: pw.TextStyle(fontSize: 12)),
                pw.Divider(thickness: 1, height: 20),

                // Tabla de productos
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  columnWidths: {
                    0: pw.FlexColumnWidth(4),
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(2),
                  },
                  children: [
                    // Encabezados
                    pw.TableRow(
                      decoration:
                          const pw.BoxDecoration(color: PdfColors.grey300),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Descripción',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Cant.',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('Precio',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12)),
                        ),
                      ],
                    ),
                    // Filas de productos
                    ...cartController.cartItems.map((cartItem) {
                      return pw.TableRow(children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(cartItem.item.nombre),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('${cartItem.cantidad.value}'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                              's/. ${cartItem.item.valorUnitario.toStringAsFixed(2)}'),
                        ),
                      ]);
                    }),
                  ],
                ),
                pw.SizedBox(height: 8),

                // Totales
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                            'Subtotal: s/. ${cartController.subtotal.toStringAsFixed(2)}'),
                        pw.Text(
                            'Tax (0%): s/. ${cartController.tax.toStringAsFixed(2)}'),
                        pw.SizedBox(height: 4),
                        pw.Text(
                            'Total: s/. ${cartController.total.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
                pw.Divider(thickness: 1, height: 20),

                // Mensaje final y QR
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                          'Bienes transferidos en la amazonía región selva para ser consumidos en la misma.\nNo se aceptan devoluciones ni cambios de productos.\nGracias por su compra.',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(fontSize: 10)),
                      pw.SizedBox(height: 16),
                      pw.Image(pw.MemoryImage(qrCodeData),
                          width: 100, height: 100),
                      pw.SizedBox(height: 8),
                      pw.Text('Escanea el código QR para más información',
                          style: pw.TextStyle(fontSize: 10)),
                      pw.SizedBox(height: 16),
                      pw.Text(
                          'Por favor, conserve su boleta de venta para cualquier reclamo o devolución.',
                          style: pw.TextStyle(fontSize: 10),
                          textAlign: pw.TextAlign.center),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Guardar el PDF en memoria
      final pdfData = await pdf.save();

      // Compartir el PDF
      await Printing.sharePdf(bytes: pdfData, filename: 'boleta.pdf');

      // Limpiar carrito y cliente seleccionado
      cartController.clearCart();
      cartController.selectedClient.value = null;
    }

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
          cartController.cartItems.isNotEmpty
              ? SizedBox(
                  height: 200,
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
            cartController.clearCart();
            cartController.selectedClient.value = null;
          },
          child: Text('Cerrar'),
        ),
      ],
    );
  }
}
