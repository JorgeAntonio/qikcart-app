import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:get/get.dart';
import 'package:qikcart/features/domain/entities/item.dart';
import 'package:qikcart/features/presentation/products/controllers/cart_controller.dart';

class ProductCard extends StatelessWidget {
  final Item item;

  const ProductCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find();

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                'https://picsum.photos/200',
                fit: BoxFit.fitHeight,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    item.nombre,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  gap8,
                  Text(
                    's/. ${item.valorUnitario.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                  gap8,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        cartController.addItemToCart(item);
                        Get.snackbar(
                          item.nombre,
                          'Producto agregado al carrito',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          colorText: Theme.of(context).colorScheme.onPrimary,
                          duration: const Duration(seconds: 1),
                        );
                      },
                      child: const Text('Comprar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
