import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:qikcart/features/presentation/products/controllers/item_controller.dart';
import '../widgets/product_card.dart';
import 'package:get/get.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemController controller = Get.find();
    final baseTextTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(Icons.search),
              SizedBox(width: 8),
              Text(
                'Buscar producto',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
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
                            image: controller.items[index].nombre,
                            name: controller.items[index].descripcion,
                            price: controller.items[index].valorUnitario,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Página ${controller.currentPage.value} de ${controller.totalPages.value}',
                        style: baseTextTheme.bodySmall,
                      ),
                      FilledButton(
                        onPressed: controller.currentPage.value > 1
                            ? () {
                                controller.loadPreviousPage();
                              }
                            : null,
                        child: Icon(Icons.arrow_back_ios, size: 14),
                      ),
                      space8,
                      FilledButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                controller.loadNextPage();
                              },
                        child: Icon(Icons.arrow_forward_ios, size: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
