import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_market_app/cart_bloc/cart_bloc.dart';
import 'package:mini_market_app/cart_bloc/cart_event.dart';
import 'package:mini_market_app/data/categories.dart';
import 'package:mini_market_app/data/market_store.dart';
import 'package:mini_market_app/market_bloc/market_bloc.dart';
import 'package:mini_market_app/market_bloc/market_event.dart';
import 'package:mini_market_app/models/product.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<MarketBloc>(
        create: (context) => MarketBloc()..add(const LoadMarketEvent()),
      ),
      BlocProvider<CartBloc>(
        create: (context) => CartBloc()..add(const LoadCartEvent()),
      ),
    ],
    child: const MaterialApp(
      title: 'Mini Market',
      debugShowCheckedModeBanner: false,
      home: AddProduct(),
    ),
  ));
}

class AddProduct extends StatefulWidget {
  final Product? product;

  const AddProduct({super.key, this.product});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _titleController = TextEditingController(text: p?.title ?? '');
    _priceController = TextEditingController(text: p != null ? p.price.toStringAsFixed(1) : '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _selectedCategory = (p != null && kCategories.contains(p.category))
        ? p.category
        : kCategories.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final price = double.parse(_priceController.text.trim());
    final description = _descriptionController.text.trim();

    if (widget.product != null) {
      final updated = widget.product!.copyWith(
        title: title,
        price: price,
        category: _selectedCategory,
        description: description,
      );
      try {
        context.read<MarketBloc>().add(UpdateProductEvent(updated));
      } catch (_) {
        MarketStore.updateProduct(updated);
      }
    } else {
      final newProduct = Product(
        id: MarketStore.newProductId(),
        title: title,
        price: price,
        category: _selectedCategory,
        description: description,
      );
      try {
        context.read<MarketBloc>().add(AddProductEvent(newProduct));
      } catch (_) {
        MarketStore.addProduct(newProduct);
      }
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit product' : 'Add product', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const Text('Title', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Desk lamp',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a title' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('Price', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        hintText: '0',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Please enter a price';
                        if (double.tryParse(value.trim()) == null) return 'Please enter a valid number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Category', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      items: kCategories.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat,
                          child: Text(cat),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCategory = val);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Description', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Short description',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      maxLines: 3,
                      validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a description' : null,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _save,
                  child: Text(
                    isEditing ? 'Save changes' : 'Save product',
                    style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
