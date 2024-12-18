import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:qikcart/features/domain/usecases/get_items_usecase.dart';
import 'package:qikcart/features/domain/entities/item.dart';

class ItemController extends GetxController {
  final GetItemsUseCase getItemsUseCase;

  ItemController(this.getItemsUseCase);

  var items = <Item>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems(currentPage.value);
  }

  void fetchItems(int page) async {
    try {
      isLoading.value = true;
      final result = await getItemsUseCase(page);
      items.value = result;
    } catch (e) {
      Logger().e('Error al cargar los items: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void fetchItemsByName(String name) async {
    isLoading.value = true;
    try {
      final results = await getItemsUseCase.getItemByName(name);
      items.assignAll(results);
    } catch (e) {
      Logger().e('Error al buscar productos: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void calculateTotalPages(int totalItems) {
    totalPages.value = (totalItems / 10).ceil();
    Logger().i('Total pages: ${totalPages.value}');
  }

  void refreshItems() {
    fetchItems(currentPage.value);
  }

  void loadNextPage() {
    currentPage.value++;
    fetchItems(currentPage.value);
  }

  void loadPreviousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchItems(currentPage.value);
    }
  }
}
