import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import 'package:qikcart/features/domain/entities/item.dart'; // Asegúrate de que esta clase esté correctamente definida

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
            // Imagen del producto (fondo)
            Positioned.fill(
              child: Image.network(
                'https://oechsle.vteximg.com.br/arquivos/ids/16233245-998-998/image-40f60b1b25aa4601b9da6c0035da489a.jpg?v=638304711005030000',
                fit: BoxFit.fitHeight, // Ajustamos la imagen al tamaño del card
              ),
            ),
            // Contenedor semitransparente para superposición
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4), // Fondo semitransparente
              ),
            ),
            // Contenido superpuesto (texto y botón)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nombre,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Texto en blanco
                        ),
                    maxLines: 1, // Máximo de una línea
                    overflow: TextOverflow.ellipsis, // Añade "..." si es largo
                  ),
                  const SizedBox(height: 8),
                  Text(
                    's/. ${item.valorUnitario.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.white, // Texto en blanco
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity, // Botón con ancho completo
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
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.green.shade400, // Color del botón
                      ),
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
