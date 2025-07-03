import 'package:flutter/material.dart';
import 'package:frontend/models/porduct.dart';
import '../utils/pdf_export.dart';

class ExportButton extends StatelessWidget {
  final List<Product> products;

  const ExportButton({required this.products, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton.icon(
          onPressed: () => exportToPdf(products),
          icon: Icon(Icons.download),
          label: Text('Export to PDF'),
        ),
      ),
    );
  }
}
