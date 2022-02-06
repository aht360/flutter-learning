import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vakinha_burguer_mobile/app/core/services/auth_service.dart';
import 'package:vakinha_burguer_mobile/app/core/services/shopping_card_service.dart';
import 'package:vakinha_burguer_mobile/app/modules/menu/menu_page.dart';
import 'package:vakinha_burguer_mobile/app/modules/menu/menu_bindings.dart';
import 'package:vakinha_burguer_mobile/app/modules/order/shopping_cart/shopping_cart_page.dart';
import 'package:vakinha_burguer_mobile/app/modules/order/shopping_cart/shopping_cart_bindings.dart';

class HomeController extends GetxController {
  static const NAVIGATOR_KEY = 1;

  final ShoppingCardService _shoppingCardService;

  final _tabIndex = 0.obs;

  final _tabs = ['/menu', '/order/shopping_card', 'exit'];

  HomeController({
    required ShoppingCardService shoppingCardService,
  }) : _shoppingCardService = shoppingCardService;

  int get totalProductsInShoppingCard => _shoppingCardService.totalProducts;

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

    if (settings.name == '/order/shopping_card') {
      return GetPageRoute(
        settings: settings,
        page: () => ShoppingCartPage(),
        binding: ShoppingCartBindings(),
        transition: Transition.fadeIn,
      );
    }
  }
}
