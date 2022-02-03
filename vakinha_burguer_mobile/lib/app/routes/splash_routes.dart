import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:vakinha_burguer_mobile/app/modules/splash/splash_bindings.dart';
import 'package:vakinha_burguer_mobile/app/modules/splash/splash_page.dart';

class SplashRouters {
  SplashRouters._();

  static final routers = <GetPage>[
    GetPage(
      name: '/',
      binding: SplashBindings(),
      page: () => const SplashPage(),
    ),
  ];
}
