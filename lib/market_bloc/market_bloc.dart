import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_market_app/data/market_store.dart';
import 'package:mini_market_app/models/product.dart';
import 'package:mini_market_app/screens/home_page.dart';
import 'market_event.dart';
import 'market_state.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Mini Market',
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  MarketBloc() : super(MarketState(products: List<Product>.from(MarketStore.products))) {
    on<LoadMarketEvent>((event, emit) {
      emit(state.copyWith(
        products: List<Product>.from(MarketStore.products),
        isLoading: false,
      ));
    });

    on<AddProductEvent>((event, emit) {
      MarketStore.addProduct(event.product);
      emit(state.copyWith(
        products: List<Product>.from(MarketStore.products),
        message: 'Product added successfully',
      ));
    });

    on<UpdateProductEvent>((event, emit) {
      MarketStore.updateProduct(event.product);
      emit(state.copyWith(
        products: List<Product>.from(MarketStore.products),
        message: 'Product updated successfully',
      ));
    });

    on<DeleteProductEvent>((event, emit) {
      MarketStore.deleteProduct(event.productId);
      emit(state.copyWith(
        products: List<Product>.from(MarketStore.products),
        message: 'Product deleted successfully',
      ));
    });
  }
}
