import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qikcart/core/presentation/screens/login/login_screen.dart';
import 'package:qikcart/core/presentation/screens/pos/post_screen.dart';
import 'package:qikcart/lib.dart';

class AppRoutes {
  const AppRoutes._();

  // Lista de páginas para GetX
  static final pages = [
    GetPage(
      name: Routes.login.name,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.home.name,
      page: () => const IndexScreens(),
      // middlewares: [AuthMiddleware()],
      children: [
        GetPage(
          name: Routes.profile.name,
          page: () => const ProfileScreen(),
        ),
      ],
    ),
    GetPage(
      name: Routes.pos.name,
      page: () => const PosScreen(),
    ),
  ];
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final isAuthenticated = AuthProvider.isAuthenticated();
    if (!isAuthenticated && route != Routes.login.name) {
      return RouteSettings(name: Routes.login.name);
    }
    return null;
  }
}
