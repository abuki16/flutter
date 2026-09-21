import 'package:mini_market_app/models/product.dart';

class MarketState {
  final List<Product> products;
  final bool isLoading;
  final String? message;

  const MarketState({
    this.products = const [],
    this.isLoading = false,
    this.message,
  });

  MarketState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? message,
  }) {
    return MarketState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
    );
  }
}
