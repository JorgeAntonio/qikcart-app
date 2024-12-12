import 'package:qikcart/features/domain/entities/item.dart';

abstract class ItemRepository {
  Future<List<Item>> getItems(int page);
  Future<List<Item>> getItemByName(String name);
}
