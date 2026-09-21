import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_market_app/data/market_store.dart';
import 'package:mini_market_app/models/product.dart';
import 'package:mini_market_app/screens/home_page.dart';
import 'cart_event.dart';
import 'cart_state.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Mini Market',
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(items: List<CartItem>.from(MarketStore.cart))) {
    on<LoadCartEvent>((event, emit) {
      emit(state.copyWith(items: List<CartItem>.from(MarketStore.cart)));
    });

    on<AddToCartEvent>((event, emit) {
      MarketStore.addToCart(event.product, event.quantity);
      emit(state.copyWith(
        items: List<CartItem>.from(MarketStore.cart),
        message: 'Added ${event.quantity} ${event.product.title}(s) to cart!',
      ));
    });

    on<RemoveFromCartEvent>((event, emit) {
      MarketStore.removeFromCart(event.productId);
      emit(state.copyWith(
        items: List<CartItem>.from(MarketStore.cart),
        message: 'Item removed from cart',
      ));
    });

    on<ClearCartEvent>((event, emit) {
      MarketStore.clearCart();
      emit(state.copyWith(
        items: const [],
        message: 'Order placed successfully!',
      ));
    });
  }
}
