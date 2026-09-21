import 'package:mini_market_app/models/product.dart';

class CartState {
  final List<CartItem> items;
  final String? message;

  const CartState({
    this.items = const [],
    this.message,
  });

  int get cartCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get cartTotal => items.fold(0.0, (sum, item) => sum + item.total);

  CartState copyWith({
    List<CartItem>? items,
    String? message,
  }) {
    return CartState(
      items: items ?? this.items,
      message: message ?? this.message,
    );
  }
}
