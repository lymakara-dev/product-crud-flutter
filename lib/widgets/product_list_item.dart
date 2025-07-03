import 'package:flutter/material.dart';
import 'package:frontend/models/porduct.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductListItem({
    required this.product,
    required this.onEdit,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text('Price: \$${product.price} | Stock: ${product.stock}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
          IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
        ],
      ),
    );
  }
}
