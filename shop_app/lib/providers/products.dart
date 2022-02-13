import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';

import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  final String? authToken;
  final String? userId;

  Products(
    this.authToken,
    this._items,
    this.userId,
  );

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser
        ? {
            'orderBy': '"creatorId"',
            'equalTo': '"$userId"',
          }
        : {};
    var url = Uri.https(
      'shop-app-backend-da3f6-default-rtdb.firebaseio.com',
      '/product.json',
      {
        ...filterString,
        'auth': authToken,
      },
    );

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      url = Uri.https(
        'shop-app-backend-da3f6-default-rtdb.firebaseio.com',
        '/userFavorites/$userId.json',
        {
          'auth': authToken,
        },
      );

      final favoriteResponse = await http.get(url);

      final favoriteData = json.decode(
        favoriteResponse.body,
      );

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(
    Product product,
  ) async {
    final url = Uri.https(
      'shop-app-backend-da3f6-default-rtdb.firebaseio.com',
      '/product.json',
      {
        'auth': authToken,
      },
    );

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          },
        ),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == newProduct.id);
    if (prodIndex >= 0) {
      final url = Uri.https(
        'shop-app-backend-da3f6-default-rtdb.firebaseio.com',
        '/product/$id.json',
        {
          'auth': authToken,
        },
      );

      try {
        final updatedProduct = json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        });
        final response = await http.put(
          url,
          body: updatedProduct,
        );
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('NÃO ACHEI ESSE PRODUTO');
    }
  }

  Future<void> deleteProduct(String id) async {
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final url = Uri.https(
      'shop-app-backend-da3f6-default-rtdb.firebaseio.com',
      '/product/$id.json',
      {
        'auth': authToken,
      },
    );

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException(
        'Could not delete product.',
      );
    }

    existingProduct = null;
  }
}
