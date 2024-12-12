import 'package:get/get.dart';
import 'package:qikcart/features/domain/entities/cart_item.dart';
import 'package:qikcart/features/domain/entities/item.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  void addItemToCart(Item item) {
    // Verifica si el producto ya está en el carrito
    final existingItem =
        cartItems.firstWhereOrNull((i) => i.item.id == item.id);
    if (existingItem != null) {
      // Si ya está en el carrito, incrementa la cantidad
      existingItem.cantidad.value++;
    } else {
      // Si no está, agrégalo con cantidad 1
      cartItems.add(CartItem(item: item));
    }
  }

  void incrementItem(CartItem cartItem) {
    cartItem.cantidad.value++;
    update(); // Fuerza la actualización de la UI
  }

  void decrementItem(CartItem cartItem) {
    if (cartItem.cantidad.value > 1) {
      cartItem.cantidad.value--;
    } else {
      removeItemFromCart(cartItem);
    }
    update(); // Fuerza la actualización de la UI
  }

  void removeItemFromCart(CartItem cartItem) {
    cartItems.remove(cartItem);
  }

  int get totalItems =>
      cartItems.fold(0, (sum, cartItem) => sum + cartItem.cantidad.value);

  // Método para calcular el subtotal
  double get subtotal {
    return cartItems.fold(
        0,
        (sum, cartItem) =>
            sum +
            (cartItem.item.valorUnitario * cartItem.cantidad.value).toInt());
  }

  // Método para calcular los impuestos (suponiendo 0% de impuestos en este ejemplo)
  double get tax {
    return subtotal * 0.0; // Puedes actualizar el porcentaje si es necesario
  }

  // Método para calcular el total
  double get total {
    return subtotal + tax;
  }
}
