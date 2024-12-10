import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qikcart/features/presentation/controllers/count_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final CountController c = Get.find();

  @override
  Widget build(context) {
    return Scaffold(
      body: Center(child: Text("${c.count}")),
    );
  }
}
