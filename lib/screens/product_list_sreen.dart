import 'package:flutter/material.dart';
import 'package:frontend/screens/edit_product_sreen.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'add_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  Future<void> _refresh() async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
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
          if (provider.isLoading)
            return Center(child: CircularProgressIndicator());

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                    "Price: \$${product.price} | Stock: ${product.stock}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => EditProductScreen(product: product),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _confirmDelete(context, product.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
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
