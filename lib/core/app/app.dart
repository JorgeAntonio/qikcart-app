import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:get/get.dart';
import 'package:qikcart/lib.dart';
import 'package:qikcart/theme_controller.dart';
// Importa el controlador del tema

class QikCart extends StatelessWidget {
  const QikCart({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Get.find(); // Obtén el controlador del tema

    TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");
    MaterialTheme theme = MaterialTheme(textTheme);

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Qikcart',
          themeMode: themeController.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
          theme: theme.light(),
          darkTheme: theme.dark(),
          getPages: AppRoutes.pages,
          initialRoute: AuthProvider.isAuthenticated()
              ? Routes.home.name
              : Routes.login.name,
          builder: (context, child) {
            return child!;
          },
        ));
  }
}
