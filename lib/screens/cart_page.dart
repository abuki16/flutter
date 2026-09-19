import 'package:flutter/material.dart';
import 'package:mini_market_app/data/categories.dart';
import 'package:mini_market_app/data/market_store.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: MarketStore.cart.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: MarketStore.cart.length,
                    itemBuilder: (context, index) {
                      final item = MarketStore.cart[index];
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
                            setState(() {
                              MarketStore.removeFromCart(item.product.id);
                            });
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
                            '\$${MarketStore.cartTotal.toStringAsFixed(1)}',
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
                            showDialog(
                              context: context,
                              builder: (dialogCtx) => AlertDialog(
                                title: const Text('Checkout'),
                                content: Text('Order placed successfully! Total: \$${MarketStore.cartTotal.toStringAsFixed(1)}'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        MarketStore.clearCart();
                                      });
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
            ),
    );
  }
}
