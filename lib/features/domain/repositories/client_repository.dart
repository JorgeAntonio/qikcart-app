import 'package:qikcart/features/domain/entities/client.dart';

abstract class ClientRepository {
  Future<List<Client>> fetchClients({
    int page,
    String? numeroDocumento,
    String? razonSocial,
    String? nombreComercial,
  });
}
