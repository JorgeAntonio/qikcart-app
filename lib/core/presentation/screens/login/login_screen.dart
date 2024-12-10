import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qikcart/core/router/routes.dart';
import 'package:qikcart/features/presentation/controllers/count_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CountController c = Get.put(CountController());

    return Scaffold(
      appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),
      body: Center(
        child: ElevatedButton(
          child: const Text("Go to Other"),
          onPressed: () => Get.toNamed(
            Routes.home.name,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: c.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
