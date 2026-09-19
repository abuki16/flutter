import 'package:flutter/material.dart';
import 'package:mini_market_app/data/categories.dart';
import 'package:mini_market_app/data/market_store.dart';
import 'package:mini_market_app/screens/add_product.dart';

class ProductDetails extends StatefulWidget {
  final String productId;

  const ProductDetails({super.key, required this.productId});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final product = MarketStore.findProduct(widget.productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Product not found.')),
      );
    }

    final categoryColor = colorForCategory(product.category);
    final categoryIcon = iconForCategory(product.category);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.grey),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProduct(product: product),
                ),
              );
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete product?'),
                  content: const Text('This product will be removed from the market.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (shouldDelete == true) {
                MarketStore.deleteProduct(product.id);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Icon(categoryIcon, size: 90, color: categoryColor),
            ),
            const SizedBox(height: 20),
            Text(
              product.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              '\$${product.price.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            Text(
              product.description,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.3),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Qty', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600)),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: () {
                          if (_qty > 1) setState(() => _qty--);
                        },
                      ),
                      Text('$_qty', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () => setState(() => _qty++),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  MarketStore.addToCart(product, _qty);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added $_qty ${product.title}(s) to cart!')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Add to cart', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
