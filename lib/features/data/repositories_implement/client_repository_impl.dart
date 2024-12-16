import 'package:dio/dio.dart';
import 'package:qikcart/features/domain/entities/client.dart';
import 'package:qikcart/features/domain/repositories/client_repository.dart';

class ClientRepositoryImpl implements ClientRepository {
  final Dio dio;

  ClientRepositoryImpl(this.dio);

  @override
  Future<List<Client>> fetchClients({
    int page = 1,
    String? numeroDocumento,
    String? razonSocial,
    String? nombreComercial,
  }) async {
    try {
      final queryParameters = {
        'page': page,
        if (numeroDocumento != null) 'numeroDocumento': numeroDocumento,
        if (razonSocial != null) 'razonSocial': razonSocial,
        if (nombreComercial != null) 'nombreComercial': nombreComercial,
      };

      final response = await dio.get(
        'http://54.235.246.131:8001/api/entidades',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'];
        return data.map((json) => Client.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener los clientes');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }
}
