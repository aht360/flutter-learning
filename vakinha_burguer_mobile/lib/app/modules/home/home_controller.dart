import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vakinha_burguer_mobile/app/core/services/auth_service.dart';
import 'package:vakinha_burguer_mobile/app/modules/menu/menu_page.dart';
import 'package:vakinha_burguer_mobile/app/modules/menu/menu_bindings.dart';

class HomeController extends GetxController {
  static const NAVIGATOR_KEY = 1;

  final _tabIndex = 0.obs;

  final _tabs = ['/menu', '/order/shopping_card', 'exit'];

  set tabIndex(int index) {
    _tabIndex(index);
    if (_tabs[index] == 'exit') {
      Get.find<AuthService>().logout();
    } else {
      Get.toNamed(
        _tabs[index],
        id: NAVIGATOR_KEY,
      );
    }
  }

  int get tabIndex => _tabIndex.value;

  Route? onGeneratedRouter(RouteSettings settings) {
    if (settings.name == '/menu') {
      return GetPageRoute(
        settings: settings,
        page: () => const MenuPage(),
        binding: MenuBindings(),
        transition: Transition.fadeIn,
      );
    }

    if (settings.name == '/order/shopping_card') {}
  }
}
