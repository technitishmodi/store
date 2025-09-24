import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';

class WishlistProvider with ChangeNotifier {
  final List<Product> _items = [];
  static const String _wishlistKey = 'wishlist_items';

  WishlistProvider() {
    // Load persisted wishlist when provider is initialized
    loadWishlist();
  }

  List<Product> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  Future<void> loadWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wishlistJson = prefs.getString(_wishlistKey);
      
      if (wishlistJson != null) {
        final List<dynamic> decoded = json.decode(wishlistJson);
        _items.clear();
        _items.addAll(decoded.map((item) => Product.fromJson(item)).toList());
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading wishlist: $e');
    }
  }

  Future<void> _saveWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wishlistJson = json.encode(_items.map((item) => item.toJson()).toList());
      await prefs.setString(_wishlistKey, wishlistJson);
    } catch (e) {
      debugPrint('Error saving wishlist: $e');
    }
  }

  void addItem(Product product) {
    if (!isInWishlist(product.id)) {
      _items.add(product);
      _saveWishlist();
      notifyListeners();
    }
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.id == productId);
    _saveWishlist();
    notifyListeners();
  }

  void toggleWishlist(Product product) {
    if (isInWishlist(product.id)) {
      removeItem(product.id);
    } else {
      addItem(product);
    }
  }

  bool isInWishlist(int productId) {
    return _items.any((item) => item.id == productId);
  }

  void clearWishlist() {
    _items.clear();
    _saveWishlist();
    notifyListeners();
  }
}
