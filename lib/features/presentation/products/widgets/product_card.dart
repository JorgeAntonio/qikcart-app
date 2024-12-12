import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:get/get.dart';
import 'package:qikcart/features/domain/entities/item.dart';
import 'package:qikcart/lib.dart';
import '../controllers/cart_controller.dart';

class ProductCard extends StatelessWidget {
  final Item item; // Objeto del producto

  const ProductCard({
    super.key,
    required this.item,
  });

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
        child: Column(
          children: [
            Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.network('https://picsum.photos/200').image,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  gap8,
                  Text(
                    item.nombre,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    's/. ${item.valorUnitario}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  gap8,
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        cartController.addItemToCart(item);
                        Get.snackbar(
                          item.nombre,
                          'Producto agregado al carrito',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          titleText: Text(
                            item.nombre,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                          messageText: Text(
                            'Agregado al carrito exitosamente',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                          duration: const Duration(seconds: 1),
                          onTap: (snack) {
                            Get.toNamed(Routes.pos.name);
                          },
                        );
                      },
                      child: const Text(
                        'Comprar',
                        textAlign: TextAlign.center,
                      ),
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
