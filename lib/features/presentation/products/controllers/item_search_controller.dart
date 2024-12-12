import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:qikcart/features/domain/entities/item.dart';

class ItemSearchController extends GetxController {
  final Dio dio;
  ItemSearchController(this.dio);

  var searchResults = <Item>[].obs;
  var isLoading = false.obs;

  Future<void> searchItemsByName(String name) async {
    if (name.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      isLoading.value = true;
      final response = await dio.get(
        'http://54.235.246.131:8002/api/items/',
        queryParameters: {'name__icontains': name},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'];
        searchResults.value = data.map((item) => Item.fromJson(item)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Error al buscar productos: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
