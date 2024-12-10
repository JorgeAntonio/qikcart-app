import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:get/get.dart';
import 'package:qikcart/core/router/routes.dart';

import '../router/app_router.dart';

class QikCart extends StatelessWidget {
  const QikCart({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");

    MaterialTheme theme = MaterialTheme(textTheme);

    // Usamos GetMaterialApp para integrar GetX.
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CIP Loreto',
      themeMode: ThemeMode.light,
      theme: theme.light(),
      darkTheme: theme.dark(),
      getPages: AppRoutes.pages,
      initialRoute: Routes.login.name,
      builder: (context, child) {
        return child!;
      },
    );
  }
}
