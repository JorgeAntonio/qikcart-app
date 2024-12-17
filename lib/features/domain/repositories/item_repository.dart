import 'package:qikcart/features/domain/entities/item.dart';
import 'package:qikcart/features/domain/entities/item_create.dart';

abstract class ItemRepository {
  Future<List<Item>> getItems(int page);
  Future<List<Item>> getItemByName(String name);
  Future<Item> createItem(ItemCreate item);
}
