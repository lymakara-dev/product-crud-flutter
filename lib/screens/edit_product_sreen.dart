import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/models/porduct.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  EditProductScreen({required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;
  late int _stock;

  @override
  void initState() {
    super.initState();
    _name = widget.product.name;
    _price = widget.product.price;
    _stock = widget.product.stock;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedProduct = Product(
        id: widget.product.id,
        name: _name,
        price: _price,
        stock: _stock,
      );

      await Provider.of<ProductProvider>(
        context,
        listen: false,
      ).updateProduct(widget.product.id!, updatedProduct);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Product",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: "Product Name"),
                validator:
                    (val) => val == null || val.isEmpty ? "Required" : null,
                onSaved: (val) => _name = val!,
              ),
              TextFormField(
                initialValue: _price.toString(),
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
                initialValue: _stock.toString(),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text("Save Changes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
