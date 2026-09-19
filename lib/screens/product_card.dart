import 'package:flutter/material.dart';
import 'package:mini_market_app/data/categories.dart';
import 'package:mini_market_app/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final productColor = colorForCategory(product.category);
    final productIcon = iconForCategory(product.category);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: productColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(productIcon, size: 30, color: productColor),
            ),
          ),
          const SizedBox(height: 10),
          Text(product.title, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Text(
            product.price.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
