import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_market_app/bloc/product_bloc/product_bloc.dart';
import 'package:mini_market_app/cart_bloc/cart_bloc.dart';
import 'package:mini_market_app/cart_bloc/cart_event.dart';
import 'package:mini_market_app/market_bloc/market_bloc.dart';
import 'package:mini_market_app/market_bloc/market_event.dart';
import 'package:mini_market_app/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
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
        initialRoute: '/',
        title: 'Mini Market',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
