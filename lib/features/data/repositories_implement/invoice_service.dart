import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class InvoiceService {
  final Dio dio;

  InvoiceService(this.dio);

  Future<Map<String, dynamic>?> createComprobante(
      Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        'http://54.235.246.131:8001/api/comprobantes/',
        data: data,
      );
      return response.data;
    } catch (e) {
      Logger().e('Error al crear comprobante: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> generateInvoice(
      Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        'http://54.235.246.131:8001/api/enviar-servicio-facturacion/boleta-o-factura',
        data: data,
      );
      return response.data;
    } catch (e) {
      Logger().e('Error al generar factura: $e');
      return null;
    }
  }
}
