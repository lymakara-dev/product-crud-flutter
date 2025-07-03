import 'dart:io';
import 'package:frontend/models/porduct.dart';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<void> exportToPdf(List<Product> products) async {
  final PdfDocument document = PdfDocument();
  final PdfGrid grid = PdfGrid();

  grid.columns.add(count: 3);
  grid.headers.add(1);
  grid.headers[0].cells[0].value = 'Product Name';
  grid.headers[0].cells[1].value = 'Price';
  grid.headers[0].cells[2].value = 'Stock';

  for (var product in products) {
    final row = grid.rows.add();
    row.cells[0].value = product.name;
    row.cells[1].value = product.price.toString();
    row.cells[2].value = product.stock.toString();
  }

  grid.draw(
    page: document.pages.add(),
    bounds: const Rect.fromLTWH(0, 0, 0, 0),
  );
  final List<int> bytes = await document.save();
  document.dispose();

  final status = await Permission.storage.request();
  if (status.isGranted) {
    final directory = await getExternalStorageDirectory();
    final path = directory!.path;
    final file = File('$path/products.pdf');
    await file.writeAsBytes(bytes, flush: true);
    print('✅ PDF exported to: ${file.path}');
  } else {
    print('❌ Storage permission denied');
  }
}
