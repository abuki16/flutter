import 'package:mini_market_app/models/product.dart';

class ProductDetailsState {
  final Product? product;
  final int quantity;
  final bool isLoading;
  final bool isDeleted;
  final bool isAddedToCart;
  final String? message;

  const ProductDetailsState({
    this.product,
    this.quantity = 1,
    this.isLoading = false,
    this.isDeleted = false,
    this.isAddedToCart = false,
    this.message,
  });

  ProductDetailsState copyWith({
    Product? product,
    int? quantity,
    bool? isLoading,
    bool? isDeleted,
    bool? isAddedToCart,
    String? message,
  }) {
    return ProductDetailsState(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isLoading: isLoading ?? this.isLoading,
      isDeleted: isDeleted ?? this.isDeleted,
      isAddedToCart: isAddedToCart ?? this.isAddedToCart,
      message: message ?? this.message,
    );
  }
}
