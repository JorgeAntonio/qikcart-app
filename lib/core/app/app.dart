import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:get/get.dart';
import 'package:qikcart/lib.dart';

class QikCart extends StatelessWidget {
  const QikCart({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");

    MaterialTheme theme = MaterialTheme(textTheme);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QikaCart',
      themeMode: ThemeMode.light,
      theme: theme.light(),
      darkTheme: theme.dark(),
      getPages: AppRoutes.pages,
      initialRoute:
          AuthProvider.isAuthenticated() ? Routes.home.name : Routes.login.name,
      builder: (context, child) {
        return child!;
      },
    );
  }
}
