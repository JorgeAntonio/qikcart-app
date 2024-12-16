import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:qikcart/core/router/routes.dart';
import 'package:qikcart/features/presentation/products/controllers/cart_controller.dart';
import 'package:qikcart/features/presentation/products/controllers/item_controller.dart';
import '../widgets/product_card.dart';
import 'package:get/get.dart';

class ProductsView extends HookWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemController controller = Get.find();
    final cartController = Get.find<CartController>();
    final searchController = useTextEditingController();
    final baseTextTheme = Theme.of(context).textTheme;

    useEffect(() {
      searchController.addListener(() {
        final value = searchController.text;
        if (value.isNotEmpty) {
          controller.fetchItemsByName(value);
        } else {
          controller.refreshItems();
        }
      });
      return () => searchController.dispose();
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    labelText: 'Buscar productos',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  controller.refreshItems(); // Restaurar la lista completa
                },
              ),
            ],
          ),
        ),
        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Get.toNamed(Routes.pos.name);
                    },
                  ),
                  if (cartController.totalItems > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          '${cartController.totalItems}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.items.isEmpty) {
            return const Center(child: Text('No hay items disponibles.'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Todos los productos',
                    style: baseTextTheme.bodyMedium,
                  ),
                  gap16,
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 2;
                      if (constraints.maxWidth > 600) {
                        crossAxisCount = 4;
                      }
                      if (constraints.maxWidth > 800) {
                        crossAxisCount = 5;
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: controller.items.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            item: controller.items[index],
                          );
                        },
                      );
                    },
                  ),
                  // Indicador de carga si se están cargando más productos
                  if (controller.isLoading.value && controller.items.isNotEmpty)
                    const Center(child: CircularProgressIndicator()),
                  // Controles de paginación
                  gap16,
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       'Página ${controller.currentPage.value} de ${controller.totalPages.value}',
                  //       style: baseTextTheme.bodySmall,
                  //     ),
                  //     FilledButton(
                  //       onPressed: controller.currentPage.value > 1
                  //           ? () {
                  //               controller.loadPreviousPage();
                  //             }
                  //           : null,
                  //       child: const Icon(Icons.arrow_back_ios, size: 14),
                  //     ),
                  //     space8,
                  //     FilledButton(
                  //       onPressed: controller.currentPage.value <
                  //               controller.totalPages.value
                  //           ? () {
                  //               controller.loadNextPage();
                  //             }
                  //           : null,
                  //       child: const Icon(Icons.arrow_forward_ios, size: 14),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
