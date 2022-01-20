import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Local
import '../models/http_excpetion.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  // Constructor
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  // Trigger favorite of an item
  Future<void> toggleFavorite() async {
    final oldStatus = isFavorite;
    final url = Uri.https(
      'flutter--shop-app-default-rtdb.firebaseio.com',
      '/products/$id.',
    );

    _setFavValue(!isFavorite);

    try {
      // If the delete fails it item gets readded to the list
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      // http package only throws its own error for GET and POST requests
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
        throw HttpException('Could not favorite product.');
      }
    } catch (e) {
      _setFavValue(oldStatus);

      // Custom exception hander
      throw HttpException('Could not favorite product.');
    }
  }
}
