import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:shop_app/providers/cart.dart';

import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https(
      'shop-app-backend-da3f6-default-rtdb.firebaseio.com',
      '/order.json',
    );
    final response = await http.get(url);

    final List<OrderItem> loadedOrders = [];

    final extractedData = json.decode(response.body) as Map<String, dynamic>?;

    if (extractedData == null) {
      return;
    }

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                ),
              )
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ),
      );
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(
    List<CartItem> cartProducts,
    double total,
  ) async {
    final url = Uri.https(
      'shop-app-backend-da3f6-default-rtdb.firebaseio.com',
      '/order.json',
    );

    final timestamp = DateTime.now();

    final newOrder = json.encode({
      'amount': total,
      'dateTime': timestamp.toIso8601String(),
      'products': cartProducts
          .map(
            (cp) => {
              'id': cp.id,
              'title': cp.title,
              'quantity': cp.quantity,
              'price': cp.price,
            },
          )
          .toList()
    });

    final response = await http.post(
      url,
      body: newOrder,
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}
