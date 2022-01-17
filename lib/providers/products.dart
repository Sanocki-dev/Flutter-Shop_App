// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Local
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // Returns a copy of the items list so changes made to the list are only done in this file
  // to make the notifications possible
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  // Method to add items to the list
  Future<void> addProduct(Product product) async {
    final url = Uri.https(
      'flutter--shop-app-default-rtdb.firebaseio.com',
      '/products.json',
    );

    // POST request to the firebase server
    return http
        .post(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl,
              'isFavorite': product.isFavorite,
            }))
        .then(
      (response) {
        final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
        );

        _items.add(newProduct);
        notifyListeners();
      },
    ).catchError((error) {
      print(error);
      throw (error);
    });
  }

  // Method to update items to the list
  void updateProduct(String id, Product product) {
    final url = Uri.https(
      'flutter--shop-app-default-rtdb.firebaseio.com',
      '/products.json',
    );

    // POST request to the firebase server
    http.patch(
      url,
      body: json.encode(
        {
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        },
      ),
    );

    final productIndex = _items.indexWhere((element) => element.id == id);

    if (productIndex >= 0) {
      _items[productIndex] = product;
      notifyListeners();
    }
  }

  // Method to delete items from the list
  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);

    notifyListeners();
  }

  // Retrieve a product by id
  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
