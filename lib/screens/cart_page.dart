import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_market_app/cart_bloc/cart_bloc.dart';
import 'package:mini_market_app/cart_bloc/cart_event.dart';
import 'package:mini_market_app/cart_bloc/cart_state.dart';
import 'package:mini_market_app/data/categories.dart';
import 'package:mini_market_app/market_bloc/market_bloc.dart';
import 'package:mini_market_app/market_bloc/market_event.dart';

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
      home: CartPage(),
    ),
  ));
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    final categoryColor = colorForCategory(item.product.category);
                    final categoryIcon = iconForCategory(item.product.category);

                    return ListTile(
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(categoryIcon, color: categoryColor, size: 24),
                      ),
                      title: Text(item.product.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('Qty ${item.quantity}', style: const TextStyle(color: Colors.grey)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.grey),
                        onPressed: () {
                          context.read<CartBloc>().add(RemoveFromCartEvent(item.product.id));
                        },
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          '\$${state.cartTotal.toStringAsFixed(1)}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          final currentTotal = state.cartTotal;
                          showDialog(
                            context: context,
                            builder: (dialogCtx) => AlertDialog(
                              title: const Text('Checkout'),
                              content: Text('Order placed successfully! Total: \$${currentTotal.toStringAsFixed(1)}'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    context.read<CartBloc>().add(const ClearCartEvent());
                                    Navigator.pop(dialogCtx);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Checkout', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
