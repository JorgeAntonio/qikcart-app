import 'package:qikcart/features/domain/repositories/comprobante_repository.dart';

class GeneratePDFUseCase {
  final ComprobanteRepository repository;

  GeneratePDFUseCase(this.repository);

  Future<void> call({
    required int comprobante,
    required int emisor,
    required int comprador,
    required List<Map<String, dynamic>> items,
    required List<Map<String, String>> payTerms,
    required String observaciones,
    required int tipoPago,
    required String tipoPdf,
  }) {
    return repository.generatePDF(
      comprobanteId: comprobante,
      emisorId: emisor,
      compradorId: comprador,
      items: items,
      payTerms: payTerms,
      observaciones: observaciones,
      tipoPago: tipoPago,
      tipoPdf: tipoPdf,
    );
  }
}
