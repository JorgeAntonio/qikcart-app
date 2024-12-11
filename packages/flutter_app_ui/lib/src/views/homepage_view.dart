import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.orange),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.orange),
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
              // Search bar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      'Search',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Categories grid
              const Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Image.asset(
                            categories[index]['image']!,
                            height: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        categories[index]['name']!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // Daily Items
              Section(title: 'Daily Items', items: dailyItems),

              // All you need
              Section(title: 'All you need', items: allYouNeed),
            ],
          ),
        ),
      ),
    );
  }
}

// Categories data
final categories = [
  {'name': 'Vegetable', 'image': 'assets/images/vegetable.png'},
  {'name': 'Baby Food', 'image': 'assets/images/baby_food.png'},
  {'name': 'Meat', 'image': 'assets/images/meat.png'},
  {'name': 'Fish', 'image': 'assets/images/fish.png'},
  {'name': 'Grocery', 'image': 'assets/images/grocery.png'},
  {'name': 'More', 'image': 'assets/images/more.png'},
];

// Daily items data
final dailyItems = [
  {'name': 'Horlicks', 'price': 400, 'image': 'assets/images/horlicks.png'},
  {'name': 'Axe', 'price': 380, 'image': 'assets/images/axe.png'},
  {'name': 'Charger Fan', 'price': 550, 'image': 'assets/images/fan.png'},
];

// All you need data
final allYouNeed = [
  {'name': 'Snacks', 'price': 100, 'image': 'assets/images/snacks.png'},
  {'name': 'Lays', 'price': 50, 'image': 'assets/images/lays.png'},
  {'name': 'Coke', 'price': 40, 'image': 'assets/images/coke.png'},
];

class Section extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('See more'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(
                          items[index]['image'] as String,
                          height: 60,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(items[index]['name'] as String),
                    Text(
                      '\$${items[index]['price']}',
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
