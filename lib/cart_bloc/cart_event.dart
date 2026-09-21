import 'package:mini_market_app/models/product.dart';

abstract class CartEvent {
  const CartEvent();
}

class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

class AddToCartEvent extends CartEvent {
  final Product product;
  final int quantity;

  const AddToCartEvent(this.product, [this.quantity = 1]);
}

class RemoveFromCartEvent extends CartEvent {
  final String productId;

  const RemoveFromCartEvent(this.productId);
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
