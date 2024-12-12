import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/item_model.dart';

class ItemRemoteDataSource {
  final Dio dio;

  ItemRemoteDataSource(this.dio);

  Future<List<ItemModel>> getItems() async {
    try {
      final response = await dio.get('http://54.235.246.131:8002/api/items/');
      final data = response.data['results'] as List;
      return data.map((json) => ItemModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching items: $e');
      rethrow;
    }
  }
}
