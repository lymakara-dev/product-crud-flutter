import 'package:flutter/material.dart';
import 'package:frontend/models/porduct.dart';
import 'package:frontend/services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _allProducts = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    _allProducts = await ApiService.getProducts();
    _products = List.from(_allProducts);
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

  void filterProducts(String query) {
    if (query.isEmpty) {
      _products = List.from(_allProducts);
    } else {
      _products =
          _allProducts
              .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    }
    notifyListeners();
  }

  void sortBy(String option) {
    switch (option) {
      case 'Name':
        _products.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Price':
        _products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Stock':
        _products.sort((a, b) => a.stock.compareTo(b.stock));
        break;
    }
    notifyListeners();
  }

  List<Product> getExportData() {
    return List.from(_products);
  }
}
