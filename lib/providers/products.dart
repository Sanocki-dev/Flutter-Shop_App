// ignore_for_file: prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Local
import 'product.dart';
import '../models/http_excpetion.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  // Returns a copy of the items list so changes made to the list are only done in this file
  // to make the notifications possible
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https('flutter--shop-app-default-rtdb.firebaseio.com', '/products.json');

    try {
      // POST request to the firebase server
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      extractedData.forEach((id, product) {
        loadedProducts.add(Product(
          id: id,
          title: product['title'],
          description: product['description'],
          price: product['price'],
          imageUrl: product['imageUrl'],
          isFavorite: product['isFavorite'],
        ));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  // Method to add items to the list
  Future<void> addProduct(Product product) async {
    final url = Uri.https('flutter--shop-app-default-rtdb.firebaseio.com', '/products.json');

    try {
      // POST request to the firebase server
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          }));

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
      rethrow;
    }
  }

  // Method to update items to the list
  Future<void> updateProduct(String id, Product product) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    final url = Uri.https(
      'flutter--shop-app-default-rtdb.firebaseio.com',
      '/products/$id.json',
    );

    try {
      // PATCH request to the firebase server
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          }));

      if (productIndex >= 0) {
        _items[productIndex] = product;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Method to delete items from the list
  Future<void> deleteProduct(String id) async {
    final url = Uri.https(
      'flutter--shop-app-default-rtdb.firebaseio.com',
      '/products/$id.json',
    );

    // Find and remove the product locally before trying to do it online
    final existingProductIndex = _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    // If the delete fails it item gets readded to the list
    final response = await http.delete(url);

    // If the url had an error reinsert the 'deleted' item back locally
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();

      // Custom exception hander
      throw HttpException('Could not delete product.');
    }

    existingProduct = null;
  }

  // Retrieve a product by id
  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
