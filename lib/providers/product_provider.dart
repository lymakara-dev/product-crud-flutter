import 'package:flutter/material.dart';
import 'package:frontend/models/porduct.dart';
import 'package:frontend/services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    _products = await ApiService.getProducts();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await ApiService.addProduct(product);
    await fetchProducts();
  }

  Future<void> updateProduct(int id, Product product) async {
    await ApiService.updateProduct(id, product);
    await fetchProducts();
  }

  Future<void> deleteProduct(int id) async {
    await ApiService.deleteProduct(id);
    await fetchProducts();
  }
}
