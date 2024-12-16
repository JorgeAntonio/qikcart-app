import 'package:qikcart/features/domain/entities/comprobante.dart';

abstract class ComprobanteRepository {
  Future<Comprobante> createComprobante(Comprobante comprobante);
  Future<void> generatePDF({
    required int comprobanteId,
    required int emisorId,
    required int compradorId,
    required List<Map<String, dynamic>> items,
    required List<Map<String, String>> payTerms,
    required String observaciones,
    required int tipoPago,
    required String tipoPdf,
  });
}
