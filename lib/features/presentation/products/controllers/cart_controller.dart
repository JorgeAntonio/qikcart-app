import 'package:get/get.dart';
import 'package:qikcart/features/domain/entities/cart_item.dart';
import 'package:qikcart/features/domain/entities/client.dart';
import 'package:qikcart/features/domain/entities/item.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var selectedClient = Rxn<Client>(); // Cliente seleccionado (puede ser null)

  void addItemToCart(Item item) {
    final existingItem =
        cartItems.firstWhereOrNull((i) => i.item.id == item.id);
    if (existingItem != null) {
      existingItem.cantidad.value++;
    } else {
      cartItems.add(CartItem(item: item));
    }
  }

  void incrementItem(CartItem cartItem) {
    cartItem.cantidad.value++;
    update();
  }

  void decrementItem(CartItem cartItem) {
    if (cartItem.cantidad.value > 1) {
      cartItem.cantidad.value--;
    } else {
      removeItemFromCart(cartItem);
    }
    update();
  }

  void removeItemFromCart(CartItem cartItem) {
    cartItems.remove(cartItem);
  }

  int get totalItems =>
      cartItems.fold(0, (sum, cartItem) => sum + cartItem.cantidad.value);

  double get subtotal {
    return cartItems.fold(
        0,
        (sum, cartItem) =>
            sum +
            (cartItem.item.valorUnitario * cartItem.cantidad.value).toInt());
  }

  double get tax {
    return subtotal * 0.0;
  }

  double get total {
    return subtotal + tax;
  }

  void clearCart() {
    cartItems.clear();
  }
}
