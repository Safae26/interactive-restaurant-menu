import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  List<Product> get favoriteProducts =>
      _products.where((p) => p.isFavorite).toList();

  Future<void> toggleFavorite(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product.copyWith(isFavorite: !product.isFavorite);
      await _saveFavorites();
      notifyListeners();
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('favorites') ?? [];

      _products =
          _products.map((product) {
            return product.copyWith(isFavorite: favorites.contains(product.id));
          }).toList();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites =
          _products.where((p) => p.isFavorite).map((p) => p.id).toList();
      await prefs.setStringList('favorites', favorites);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  Future<void> _saveProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson =
          _products.map((p) => json.encode(p.toMap())).toList();
      await prefs.setStringList('products', productsJson);
    } catch (e) {
      debugPrint('Error saving products: $e');
    }
  }

  Future<void> loadProducts(List<Product> initialProducts) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = prefs.getStringList('products');

      if (productsJson != null && productsJson.isNotEmpty) {
        _products =
            productsJson
                .map((jsonStr) => Product.fromMap(json.decode(jsonStr)))
                .toList();
      } else {
        _products = List.from(initialProducts);
      }

      await _loadFavorites();
    } catch (e) {
      debugPrint('Error loading products: $e');
      _products = List.from(initialProducts);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addProduct(Product product) {
    if (_products.any((p) => p.id == product.id)) {
      throw Exception('Product with ID ${product.id} already exists');
    }
    _products.add(product);
    _saveProducts();
    notifyListeners();
  }

  Future<void> updateProduct(Product updatedProduct) async {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
      _saveProducts();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((product) => product.id == id);
    _saveProducts();
    notifyListeners();
  }
}
