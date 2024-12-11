import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/product_card.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  // Función para generar una lista de productos con datos aleatorios
  List<Map<String, dynamic>> generateProducts(int count) {
    final random = Random();
    final List<Map<String, dynamic>> products = [];
    final productNames = [
      'Product 1',
      'Product 2',
      'Product 3',
      'Product 4',
      'Product 5',
      'Product 6',
      'Product 7',
      'Product 8',
      'Product 9',
      'Product 10'
    ];
    final productImages = [
      'assets/images/product_1.png',
      'assets/images/product_2.png',
      'assets/images/product_3.png',
      'assets/images/product_4.png',
      'assets/images/product_5.png',
      'assets/images/product_6.png',
    ];

    for (int i = 0; i < count; i++) {
      final name = productNames[random.nextInt(productNames.length)];
      final price = random.nextInt(1000) + 100; // Precio entre 100 y 1099
      final image = productImages[random.nextInt(productImages.length)];
      products.add({
        'name': name,
        'price': price,
        'image': image,
      });
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = Theme.of(context).textTheme;

    // Generamos 10 productos aleatorios
    final products = generateProducts(10);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 8),
                    Text(
                      'Search',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Todos los productos',
                style: baseTextTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
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
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        image: products[index]['image'] as String,
                        name: products[index]['name'] as String,
                        price: products[index]['price'] as int,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
