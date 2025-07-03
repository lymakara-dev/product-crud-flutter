import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/screens/edit_product_sreen.dart';
import 'package:frontend/utils/pdf_export.dart';
import 'package:frontend/widgets/confirm_delete_dialog.dart';
import 'package:frontend/widgets/product_list_item.dart';
import 'package:frontend/widgets/search_bar.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'add_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _sortOption = 'Name';

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
    final confirm = await showConfirmDeleteDialog(context);

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
      appBar: AppBar(
        title: Text(
          "Product List",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            tooltip: 'Export to PDF',
            onPressed: () {
              final products =
                  Provider.of<ProductProvider>(context, listen: false).products;
              exportToPdf(products);
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add Product',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddProductScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              ProductSearchBar(
                controller: _searchController,
                onChanged: _onSearchChanged,
                onSortSelected: (val) {
                  setState(() => _sortOption = val);
                  Provider.of<ProductProvider>(
                    context,
                    listen: false,
                  ).sortBy(val);
                },
              ),

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
    );
  }
}
