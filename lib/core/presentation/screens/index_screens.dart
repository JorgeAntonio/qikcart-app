import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qikcart/core/presentation/presentation.dart';
import 'package:qikcart/core/presentation/screens/pos/post_screen.dart';
import 'package:qikcart/core/presentation/screens/products/products_screen.dart';
import 'package:qikcart/features/presentation/products/controllers/cart_controller.dart';

class IndexScreens extends StatefulWidget {
  const IndexScreens({super.key});

  @override
  State<IndexScreens> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<IndexScreens> {
  int currentPageIndex = 0;
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: theme.primary,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.store),
            label: 'Inventario',
          ),
          NavigationDestination(
            // icon: Icon(Icons.add_shopping_cart),
            icon: Obx(() => Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.add_shopping_cart,
                      color: cartController.totalItems > 0
                          ? theme.primary
                          : theme.onSurface,
                    ),
                    if (cartController.totalItems > 0)
                      Positioned(
                        left: 8,
                        right: 0,
                        top: 0,
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
                )),
            label: 'POS',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
      body: <Widget>[
        const ProductsScreen(),
        const PosScreen(),
        const ProfileScreen(),
      ][currentPageIndex],
    );
  }
}
