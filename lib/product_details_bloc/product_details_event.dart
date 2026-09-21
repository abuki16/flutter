abstract class ProductDetailsEvent {
  const ProductDetailsEvent();
}

class LoadProductDetailsEvent extends ProductDetailsEvent {
  final String productId;
  const LoadProductDetailsEvent(this.productId);
}

class IncrementQuantityEvent extends ProductDetailsEvent {
  const IncrementQuantityEvent();
}

class DecrementQuantityEvent extends ProductDetailsEvent {
  const DecrementQuantityEvent();
}

class AddToCartEvent extends ProductDetailsEvent {
  const AddToCartEvent();
}

class DeleteProductEvent extends ProductDetailsEvent {
  const DeleteProductEvent();
}
