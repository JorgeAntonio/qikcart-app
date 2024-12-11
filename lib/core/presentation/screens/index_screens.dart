import 'package:flutter/material.dart';
import 'package:qikcart/core/presentation/presentation.dart';
import 'package:qikcart/core/presentation/screens/pos/post_screen.dart';
import 'package:qikcart/core/presentation/screens/products/products_screen.dart';

class IndexScreens extends StatefulWidget {
  const IndexScreens({super.key});

  @override
  State<IndexScreens> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<IndexScreens> {
  int currentPageIndex = 0;

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
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart),
            label: 'Productos',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_shopping_cart),
            label: 'POS',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
      body: <Widget>[
        HomeScreen(),
        const ProductsScreen(),
        const PostScreen(),
        const ProfileScreen(),
      ][currentPageIndex],
    );
  }
}
