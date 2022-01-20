import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Local
import '../providers/cart.dart';

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

  Future<void> fetchOrders() async {
    final url = Uri.https('flutter--shop-app-default-rtdb.firebaseio.com', '/orders.json');

    try {
      // GET request to the firebase server
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;

      if (extractedData == null) return;

      final List<OrderItem> loadedOrders = [];

      extractedData.forEach((id, order) {
        loadedOrders.add(OrderItem(
          id: id,
          amount: order['amount'],
          dateTime: DateTime.parse(order['dateTime']),
          products: (order['products'] as List<dynamic>)
              .map((items) => CartItem(
                    id: items['id'],
                    title: items['title'],
                    quantity: items['quantity'],
                    price: items['price'],
                  ))
              .toList(),
        ));
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      // ignore: avoid_print
      print(error);
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final url = Uri.https(
      'flutter--shop-app-default-rtdb.firebaseio.com',
      '/orders.json',
    );

    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'price': cp.price,
                  'quantity': cp.quantity,
                })
            .toList(),
      }),
    );

    // adds order to the begining of the list of orders
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
