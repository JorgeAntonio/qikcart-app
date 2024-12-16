import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:qikcart/features/domain/entities/comprobante.dart';
import 'package:qikcart/features/domain/usecases/create_comprobante_usecase.dart';
import 'package:qikcart/features/domain/usecases/generate_pdf_usecase.dart';

class ComprobanteController extends GetxController {
  final CreateComprobanteUseCase createComprobanteUseCase;
  final GeneratePDFUseCase generatePDFUseCase;

  ComprobanteController({
    required this.createComprobanteUseCase,
    required this.generatePDFUseCase,
  });

  final Rxn<Comprobante> _comprobante = Rxn<Comprobante>();
  Comprobante? get comprobante => _comprobante.value;

  final RxBool isLoading = false.obs;

  Future<void> createComprobante(Comprobante comprobanteData) async {
    isLoading.value = true;
    try {
      final result = await createComprobanteUseCase(comprobanteData);
      _comprobante.value = result;
      Get.snackbar('Éxito', 'Comprobante generado correctamente');
    } on DioException catch (e) {
      Get.snackbar(
        duration: Duration(
          seconds: 3,
        ),
        'Error',
        'No se pudo generar el comprobante: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generatePDF({
    required int comprador,
    required int emisor,
    required List<Map<String, dynamic>> items,
    required List<Map<String, String>> payTerms,
    required String observaciones,
    required int tipoPago,
    required String tipoPdf,
  }) async {
    if (_comprobante.value == null) {
      Get.snackbar('Error', 'Primero genera el comprobante');
      return;
    }

    final comprobanteid = _comprobante.value!.id;
    Logger().i(comprobanteid);

    isLoading.value = true;
    try {
      await generatePDFUseCase.call(
        comprobante: comprobanteid!,
        emisor: emisor,
        comprador: comprador,
        items: items,
        payTerms: payTerms,
        observaciones: observaciones,
        tipoPago: tipoPago,
        tipoPdf: tipoPdf,
      );
      Get.snackbar('Éxito', 'PDF generado correctamente');
    } on DioException catch (e) {
      Get.snackbar('Error', 'No se pudo generar el PDF: $e');
      Logger().e(e.response!.data);
    } finally {
      isLoading.value = false;
    }
  }
}
