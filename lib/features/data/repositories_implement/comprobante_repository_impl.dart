import 'package:dio/dio.dart';
import 'package:qikcart/features/data/models/comprobante_model.dart';
import 'package:qikcart/features/domain/entities/comprobante.dart';
import 'package:qikcart/features/domain/repositories/comprobante_repository.dart';

class ComprobanteRepositoryImpl implements ComprobanteRepository {
  final Dio dio;

  ComprobanteRepositoryImpl(this.dio);

  @override
  Future<Comprobante> createComprobante(Comprobante comprobante) async {
    try {
      final response = await dio.post(
        'http://54.235.246.131:8001/api/comprobantes/',
        data: comprobante.toJson(),
      );

      if (response.statusCode == 201) {
        return ComprobanteModel.fromJson(response.data);
      } else {
        throw Exception('Error al crear el comprobante');
      }
    } catch (e) {
      throw Exception('Error en la red: $e');
    }
  }

  @override
  Future<void> generatePDF({
    required int comprobanteId,
    required int emisorId,
    required int compradorId,
    required List<Map<String, dynamic>> items,
    required List<Map<String, String>> payTerms,
    required String observaciones,
    required int tipoPago,
    required String tipoPdf,
  }) async {
    try {
      await dio.post(
        'http://54.235.246.131:8001/api/enviar-servicio-facturacion/boleta-o-factura',
        data: {
          'comprobante': comprobanteId,
          'emisor': emisorId,
          'comprador': compradorId,
          'items': items,
          'payTerms': payTerms,
          'observaciones': observaciones,
          'tipoPago': tipoPago,
          'tipo_pdf': tipoPdf,
        },
      );
    } catch (e) {
      throw Exception('Error al generar el PDF: $e');
    }
  }
}
