import 'package:qikcart/features/domain/entities/client.dart';
import 'package:qikcart/features/domain/repositories/client_repository.dart';

class ClientUsecase {
  final ClientRepository repository;

  ClientUsecase(this.repository);

  Future<List<Client>> call({
    int page = 1,
    String? numeroDocumento,
    String? razonSocial,
    String? nombreComercial,
  }) async {
    return await repository.fetchClients(
      page: page,
      numeroDocumento: numeroDocumento,
      razonSocial: razonSocial,
      nombreComercial: nombreComercial,
    );
  }
}
