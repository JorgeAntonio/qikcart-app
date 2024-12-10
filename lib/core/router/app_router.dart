import 'package:get/get.dart';
import 'package:qikcart/core/presentation/screens/index_screens.dart';
import 'package:qikcart/core/presentation/screens/login/login_screen.dart';
import 'package:qikcart/core/presentation/screens/profile/profile_screen.dart';
import 'package:qikcart/core/router/router.dart';

class AppRoutes {
  const AppRoutes._();

  // Rutas nombradas
  static const login = '/login';
  static const home = '/home';
  static const profile = '/home/profile';
  static const colegiadoDetail = '/home/colegiado_detail';

  // Lista de páginas para GetX
  static final pages = [
    GetPage(
      name: Routes.login.name,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.home.name,
      page: () => const IndexScreens(),
      // middlewares: [AuthMiddleware()], // Middleware para validar autenticación
      children: [
        GetPage(
          name: profile,
          page: () => const ProfileScreen(),
        ),
      ],
    ),
  ];
}

// class AuthMiddleware extends GetMiddleware {
//   @override
//   RouteSettings? redirect(String? route) {
//     final isAuthenticated = AuthProvider.isAuthenticated();
//     if (!isAuthenticated && route != AppRoutes.login) {
//       return const RouteSettings(name: AppRoutes.login);
//     }
//     return null;
//   }
// }
