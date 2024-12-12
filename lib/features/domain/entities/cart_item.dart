import 'package:get/get.dart';
import 'package:qikcart/features/domain/entities/item.dart';

class CartItem {
  final Item item;
  var cantidad = 1.obs; // Propiedad reactiva

  CartItem({
    required this.item,
  });
}
