import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyShop',
        ),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch!,
              value: cart.itemCount.toString(),
              color: Colors.red,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  CartScreen.routeName,
                );
              },
              icon: const Icon(
                Icons.shopping_cart,
              ),
            ),
          ),
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
            ),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Visibility(
                      visible: _showOnlyFavorites,
                      child: const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                    const Text(
                      'Only Favorites',
                    ),
                  ],
                ),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Visibility(
                      visible: !_showOnlyFavorites,
                      child: const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                    const Text(
                      'Show all',
                    ),
                  ],
                ),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductsGrid(
        showFavs: _showOnlyFavorites,
      ),
    );
  }
}
