import 'package:flutter/material.dart';
import 'package:mini_market_app/data/market_store.dart';
import 'package:mini_market_app/screens/add_product.dart';
import 'package:mini_market_app/screens/cart_page.dart';
import 'package:mini_market_app/screens/product_card.dart';
import 'package:mini_market_app/screens/product_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _openCart() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );

    setState(() {});
  }

  Future<void> _openProduct({required String id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetails(productId: id)),
    );

    setState(() {});
  }

  Future<void> _openProductForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProduct()),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = MarketStore.cartCount;
    final products = MarketStore.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mini Market"),
        actions: [
          IconButton(
            onPressed: _openCart,
            icon: Badge(
              isLabelVisible: itemCount > 0,
              label: Text(itemCount.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.all(8),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(),
        ),
      ),
      body: products.isEmpty
          ? const Center(
              child: Text(
                'No products yet.\nTap + to add your first one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final product = products[index];

                  return GestureDetector(
                    onTap: () => _openProduct(id: product.id),
                    child: ProductCard(product: product),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openProductForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
