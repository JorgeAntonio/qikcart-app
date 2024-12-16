import 'package:qikcart/features/domain/entities/comprobante.dart';
import 'package:qikcart/features/domain/repositories/comprobante_repository.dart';

class CreateComprobanteUseCase {
  final ComprobanteRepository repository;

  CreateComprobanteUseCase(this.repository);

  Future<Comprobante> call(Comprobante comprobante) {
    return repository.createComprobante(comprobante);
  }
}
