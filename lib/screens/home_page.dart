import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_market_app/bloc/product_bloc/product_bloc.dart';
import 'package:mini_market_app/cart_bloc/cart_bloc.dart';
import 'package:mini_market_app/cart_bloc/cart_event.dart';
import 'package:mini_market_app/cart_bloc/cart_state.dart';
import 'package:mini_market_app/market_bloc/market_bloc.dart';
import 'package:mini_market_app/market_bloc/market_event.dart';
import 'package:mini_market_app/market_bloc/market_state.dart';
import 'package:mini_market_app/screens/add_product.dart';
import 'package:mini_market_app/screens/cart_page.dart';
import 'package:mini_market_app/screens/product_card.dart';
import 'package:mini_market_app/screens/product_details.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ProductBloc>(
        create: (context) => ProductBloc()..add(GetProductsEvent()),
      ),
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
      home: HomePage(),
    ),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartPage()),
    );
  }

  void _openProduct(BuildContext context, {required String id}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetails(productId: id)),
    );
  }

  void _openProductForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProduct()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mini Market"),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              final itemCount = cartState.cartCount;
              return IconButton(
                onPressed: () => _openCart(context),
                icon: Badge(
                  isLabelVisible: itemCount > 0,
                  label: Text(itemCount.toString()),
                  child: const Icon(Icons.shopping_cart),
                ),
              );
            },
          ),
        ],
        actionsPadding: const EdgeInsets.all(8),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(),
        ),
      ),
      body: BlocBuilder<MarketBloc, MarketState>(
        builder: (context, marketState) {
          final products = marketState.products;

          if (products.isEmpty) {
            return const Center(
              child: Text(
                'No products yet.\nTap + to add your first one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return Padding(
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
                  onTap: () => _openProduct(context, id: product.id),
                  child: ProductCard(product: product),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openProductForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
