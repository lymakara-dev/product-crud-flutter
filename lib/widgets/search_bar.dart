import 'package:flutter/material.dart';

class ProductSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(String) onSortSelected;

  const ProductSearchBar({
    required this.controller,
    required this.onChanged,
    required this.onSortSelected,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () {
      if (mounted) setState(() {});
    };
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search),
                suffixIcon:
                    widget.controller.text.isNotEmpty
                        ? IconButton(
                          onPressed: () {
                            widget.controller.clear();
                            widget.onChanged('');
                          },
                          icon: Icon(Icons.clear),
                        )
                        : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
              onChanged: widget.onChanged,
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            color: Colors.white,
            offset: Offset(0, 40),
            onSelected: widget.onSortSelected,
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: 'Name', child: Text('Sort by name')),
                  PopupMenuItem(value: 'Price', child: Text('Sort by price')),
                  PopupMenuItem(value: 'Stock', child: Text('Sort by stock')),
                ],
          ),
        ],
      ),
    );
  }
}
