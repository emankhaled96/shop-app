import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import './cart.dart';

class OrderModel {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderModel(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  final String authToken;
  final String userId;

  List<OrderModel> _orders = [];

  Orders(this.authToken, this.userId, this._orders);
  List<OrderModel> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double totalPrice) async {
    final url =
        Uri.parse('https://twitter-clone-228ab.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "amount": totalPrice,
          "products": cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList(),
          "dateTime": timeStamp.toIso8601String(),
        }),
      );
      _orders.insert(
          0,
          OrderModel(
              id: json.decode(response.body)['name'],
              amount: totalPrice,
              products: cartProducts,
              dateTime: timeStamp));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getOrders() async {
    final url =
        Uri.parse('https://twitter-clone-228ab.firebaseio.com/orders/$userId.json?auth=$authToken');
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final List<OrderModel> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderModel(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity']))
                .toList()));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
