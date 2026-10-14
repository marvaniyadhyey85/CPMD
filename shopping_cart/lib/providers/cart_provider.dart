import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, Product> _cart = {};
  final Set<int> _wishlist = {};

  Map<int, Product> get cart => _cart;
  Set<int> get wishlist => _wishlist;

  int get quantity => _cart.length;

  double get subtotal {
    double sum = 0;
    _cart.forEach((id, product) {
      sum += product.price;
    });
    return sum;
  }

  double get total => subtotal;

  void addToCart(Product product) {
    _cart[product.id] = product;
    notifyListeners();
  }

  void removeFromCart(int id) {
    _cart.remove(id);
    notifyListeners();
  }

  void toggleWishlist(Product product) {
    if (_wishlist.contains(product.id)) {
      _wishlist.remove(product.id);
    } else {
      _wishlist.add(product.id);
    }
    notifyListeners();
  }
}