import 'package:qikcart/features/domain/entities/client.dart';
import 'package:qikcart/features/domain/entities/create_client.dart';

abstract class ClientRepository {
  Future<List<Client>> fetchClients({
    int page,
    String? numeroDocumento,
    String? razonSocial,
    String? nombreComercial,
  });

  Future<Client> createClient(CreateClient createClient);
}
