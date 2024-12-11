import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';

class PosView extends StatefulWidget {
  const PosView({super.key});

  @override
  State<PosView> createState() => _PosViewState();
}

class _PosViewState extends State<PosView> {
  final List<Map<String, Object>> products = [
    {'name': 'RedBull', 'price': 30, 'quantity': 1},
    {'name': 'Water', 'price': 50, 'quantity': 1},
    {'name': 'Oil', 'price': 150, 'quantity': 1},
  ];

  int get subtotal => products.fold(
        0,
        (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int),
      );
  double get tax => subtotal * 0.14;
  double get total => subtotal + tax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
        ),
      ),
      body: Padding(
        padding: edgeInsets16,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: edgeInsetsV8,
                    child: ListTile(
                      title: Text(product['name'] as String),
                      subtitle: Text('${product['price']} EGP'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              setState(() {
                                if ((product['quantity'] as int) > 1) {
                                  product['quantity'] =
                                      (product['quantity'] as int) - 1;
                                }
                              });
                            },
                          ),
                          space4,
                          Text('${product['quantity']}',
                              style: Theme.of(context).textTheme.titleMedium),
                          space4,
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() {
                                product['quantity'] =
                                    (product['quantity'] as int) + 1;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Column(
              children: [
                ListTile(
                  title: Text('Select Customer (optional)'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  title: Text('Select Payment Method'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                Divider(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: TextStyle(fontSize: 16)),
                      Text('${subtotal.toStringAsFixed(2)} EGP',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tax (14%)'),
                      Text('${tax.toStringAsFixed(2)} EGP'),
                    ],
                  ),
                  Divider(thickness: 1, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total'),
                      Text('${total.toStringAsFixed(2)} EGP',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Checkout',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
