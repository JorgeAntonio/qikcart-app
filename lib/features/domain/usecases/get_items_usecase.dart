import 'package:qikcart/features/domain/repositories/item_repository.dart';
import 'package:qikcart/features/domain/entities/item.dart';

class GetItemsUseCase {
  final ItemRepository repository;

  GetItemsUseCase(this.repository);

  Future<List<Item>> call(int page) {
    return repository.getItems(page);
  }

  Future<List<Item>> getItemByName(String name) {
    return repository.getItemByName(name);
  }
}
