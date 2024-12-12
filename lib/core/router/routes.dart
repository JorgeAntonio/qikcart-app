class Routes {
  const Routes._({required this.name, required this.path});
  final String name;
  final String path;

  static Routes get login => const Routes._(
        name: '/login',
        path: '/login',
      );

  static Routes get home => const Routes._(
        name: '/home',
        path: '/',
      );

  static Routes get search => const Routes._(
        name: '/search',
        path: '/search',
      );

  static Routes get products => const Routes._(
        name: '/products',
        path: 'products/:id',
      );

  static Routes get profile => const Routes._(
        name: '/profile',
        path: '/profile',
      );

  static Routes get pos => const Routes._(
        name: '/pos',
        path: '/pos',
      );

  static Routes get services => const Routes._(
        name: 'services',
        path: '/services',
      );
}
