import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_market_app/cart_bloc/cart_bloc.dart';
import 'package:mini_market_app/cart_bloc/cart_event.dart' show LoadCartEvent;
import 'package:mini_market_app/data/categories.dart';
import 'package:mini_market_app/market_bloc/market_bloc.dart';
import 'package:mini_market_app/market_bloc/market_event.dart' as market_evt;
import 'package:mini_market_app/product_details_bloc/product_details_bloc.dart';
import 'package:mini_market_app/product_details_bloc/product_details_event.dart';
import 'package:mini_market_app/product_details_bloc/product_details_state.dart';
import 'package:mini_market_app/screens/add_product.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<MarketBloc>(
        create: (context) => MarketBloc()..add(const market_evt.LoadMarketEvent()),
      ),
      BlocProvider<CartBloc>(
        create: (context) => CartBloc()..add(const LoadCartEvent()),
      ),
    ],
    child: const MaterialApp(
      title: 'Mini Market',
      debugShowCheckedModeBanner: false,
      home: ProductDetails(productId: 'p1'),
    ),
  ));
}

class ProductDetails extends StatelessWidget {
  final String productId;

  const ProductDetails({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsBloc()..add(LoadProductDetailsEvent(productId)),
      child: ProductDetailsView(productId: productId),
    );
  }
}

class ProductDetailsView extends StatelessWidget {
  final String productId;

  const ProductDetailsView({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
      listener: (context, state) {
        if (state.isAddedToCart) {
          try {
            context.read<CartBloc>().add(const LoadCartEvent());
          } catch (_) {}
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Added to cart!')),
          );
          Navigator.pop(context);
        } else if (state.isDeleted) {
          try {
            context.read<MarketBloc>().add(market_evt.DeleteProductEvent(productId));
            context.read<CartBloc>().add(const LoadCartEvent());
          } catch (_) {}
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final product = state.product;

        if (product == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Product not found.')),
          );
        }

        final categoryColor = colorForCategory(product.category);
        final categoryIcon = iconForCategory(product.category);
        final bloc = context.read<ProductDetailsBloc>();

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
                  bloc.add(LoadProductDetailsEvent(productId));
                  if (context.mounted) {
                    try {
                      context.read<MarketBloc>().add(const market_evt.LoadMarketEvent());
                    } catch (_) {}
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () async {
                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (dialogCtx) => AlertDialog(
                      title: const Text('Delete product?'),
                      content: const Text('This product will be removed from the market.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogCtx, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(dialogCtx, true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (shouldDelete == true) {
                    bloc.add(const DeleteProductEvent());
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
                              bloc.add(const DecrementQuantityEvent());
                            },
                          ),
                          Text('${state.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add, size: 18),
                            onPressed: () {
                              bloc.add(const IncrementQuantityEvent());
                            },
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
                      bloc.add(const AddToCartEvent());
                    },
                    child: const Text('Add to cart', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
