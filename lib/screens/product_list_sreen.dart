import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/screens/edit_product_sreen.dart';
import 'package:frontend/widgets/export_button.dart';
import 'package:frontend/widgets/product_list_item.dart';
import 'package:frontend/widgets/sort_dropdown.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'add_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _sortOption = 'Price';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      Provider.of<ProductProvider>(
        context,
        listen: false,
      ).filterProducts(value);
    });
  }

  void _confirmDelete(BuildContext context, int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Delete Product?"),
            content: Text("Are you sure you want to delete this product?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Delete"),
              ),
            ],
          ),
    );

    if (confirm ?? false) {
      await Provider.of<ProductProvider>(
        context,
        listen: false,
      ).deleteProduct(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product List")),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              SearchBar(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
              SortDropdown(
                value: _sortOption,
                onChanged: (val) {
                  setState(() => _sortOption = val);
                  Provider.of<ProductProvider>(
                    context,
                    listen: false,
                  ).sortBy(val);
                },
              ),
              ExportButton(products: provider.products),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    itemCount: provider.products.length,
                    itemBuilder: (context, index) {
                      final product = provider.products[index];
                      return ProductListItem(
                        product: product,
                        onEdit:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => EditProductScreen(product: product),
                              ),
                            ),
                        onDelete: () => _confirmDelete(context, product.id!),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddProductScreen()),
            ),
      ),
    );
  }
}
