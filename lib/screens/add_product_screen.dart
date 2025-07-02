import 'package:flutter/material.dart';
import 'package:frontend/models/porduct.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _price = 0.0;
  int _stock = 0;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newProduct = Product(name: _name, price: _price, stock: _stock);
      await Provider.of<ProductProvider>(
        context,
        listen: false,
      ).addProduct(newProduct);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Product Name"),
                validator:
                    (val) => val == null || val.isEmpty ? "Required" : null,
                onSaved: (val) => _name = val!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator:
                    (val) =>
                        (double.tryParse(val ?? '') ?? 0) <= 0
                            ? "Enter valid price"
                            : null,
                onSaved: (val) => _price = double.parse(val!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Stock"),
                keyboardType: TextInputType.number,
                validator:
                    (val) =>
                        (int.tryParse(val ?? '') ?? -1) < 0
                            ? "Enter valid stock"
                            : null,
                onSaved: (val) => _stock = int.parse(val!),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text("Create")),
            ],
          ),
        ),
      ),
    );
  }
}
