import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_market_app/data/market_store.dart';
import 'package:mini_market_app/screens/product_details.dart';
import 'product_details_event.dart';
import 'product_details_state.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Mini Market',
    debugShowCheckedModeBanner: false,
    home: ProductDetails(productId: 'p1'),
  ));
}

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc() : super(const ProductDetailsState()) {
    on<LoadProductDetailsEvent>((event, emit) {
      final product = MarketStore.findProduct(event.productId);
      emit(state.copyWith(
        product: product,
        isDeleted: false,
        isAddedToCart: false,
      ));
    });

    on<IncrementQuantityEvent>((event, emit) {
      emit(state.copyWith(quantity: state.quantity + 1));
    });

    on<DecrementQuantityEvent>((event, emit) {
      if (state.quantity > 1) {
        emit(state.copyWith(quantity: state.quantity - 1));
      }
    });

    on<AddToCartEvent>((event, emit) {
      if (state.product != null) {
        MarketStore.addToCart(state.product!, state.quantity);
        emit(state.copyWith(
          isAddedToCart: true,
          message: 'Added ${state.quantity} ${state.product!.title}(s) to cart!',
        ));
      }
    });

    on<DeleteProductEvent>((event, emit) {
      if (state.product != null) {
        MarketStore.deleteProduct(state.product!.id);
        emit(state.copyWith(
          isDeleted: true,
          message: 'Product deleted successfully',
        ));
      }
    });
  }
}
