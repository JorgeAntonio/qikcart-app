import 'package:get/get.dart';
import 'package:qikcart/features/data/repositories_implement/invoice_service.dart';

class PosController extends GetxController {
  final InvoiceService invoiceService;

  PosController(this.invoiceService);

  Future<void> facturarCarrito(
      {required Map<String, dynamic> comprobanteData,
      required Map<String, dynamic> invoiceData}) async {
    // Crear el comprobante
    final comprobante = await invoiceService.createComprobante(comprobanteData);

    if (comprobante == null) {
      Get.snackbar('Error', 'No se pudo crear el comprobante');
      return;
    }

    // Agregar el ID del comprobante al cuerpo de la factura
    invoiceData['comprobante'] = comprobante['id'];

    // Generar la factura
    final factura = await invoiceService.generateInvoice(invoiceData);

    if (factura != null) {
      Get.snackbar('Éxito', 'Factura generada correctamente');
    } else {
      Get.snackbar('Error', 'No se pudo generar la factura');
    }
  }
}
