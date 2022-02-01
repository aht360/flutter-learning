import 'package:get/get.dart';
import 'package:vakinha_burguer_mobile/app/modules/auth/register/register_page.dart';

class RegisterRouters {
  RegisterRouters._();
  static final routers = <GetPage>[
    GetPage(name: '/auth/register', page: () => const RegisterPage())
  ];
}
