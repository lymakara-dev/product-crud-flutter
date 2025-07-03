import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/screens/product_list_sreen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: ".env");
    print("✅ .env loaded: ${dotenv.env}");
  } catch (e) {
    print("❌ Failed to load .env: $e");
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ProductListScreen(),
      ),
    ),
  );
}
