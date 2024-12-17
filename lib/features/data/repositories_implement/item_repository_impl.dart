import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:qikcart/features/domain/entities/item_create.dart';
import 'package:qikcart/features/domain/repositories/item_repository.dart';
import 'package:qikcart/features/domain/entities/item.dart';

class ItemRepositoryImpl implements ItemRepository {
  final Dio dio;

  ItemRepositoryImpl(this.dio);

  @override
  Future<List<Item>> getItems(int page) async {
    try {
      final response = await dio.get('http://54.235.246.131:8002/api/items/',
          queryParameters: {'page': page});

      if (response.statusCode == 200) {
        // Mapear la respuesta y devolver una lista de objetos Item
        final List<dynamic> data = response.data['results'];
        return data.map((item) => Item.fromJson(item)).toList();
      } else {
        throw Exception('Error al obtener los items');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  @override
  Future<List<Item>> getItemByName(String name) async {
    try {
      final response = await dio.get('http://54.235.246.131:8002/api/items/',
          queryParameters: {'nombre': name});

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'];
        return data.map((item) => Item.fromJson(item)).toList();
      } else {
        throw Exception('Error al buscar el item por nombre');
      }
    } catch (e) {
      throw Exception('Error al buscar el item por nombre: $e');
    }
  }

  @override
  Future<Item> createItem(ItemCreate item) async {
    try {
      final response = await dio.post(
        'http://54.235.246.131:8002/api/items/',
        data: item.toJson(),
      );

      Logger().i('Response: ${response.data}');

      if (response.statusCode == 201) {
        return Item.fromJson(response.data);
      } else {
        throw Exception('Error al crear el item');
      }
    } on DioException catch (e) {
      throw Exception('Error en la red: $e');
    }
  }
}
