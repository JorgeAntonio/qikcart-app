import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Observable para el estado del tema
  RxBool isDarkMode = false.obs;

  // Alterna entre el tema claro y oscuro
  void toggleTheme(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
