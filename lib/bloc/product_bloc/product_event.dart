part of 'product_bloc.dart';

abstract class ProductEvent {}

class GetProductsEvent extends ProductEvent {
  GetProductsEvent();
}

class GetProductEvent extends ProductEvent {
  final String productId;

  GetProductEvent({required this.productId});
}

class CreateProductEvent extends ProductEvent {
  final Product product;

  CreateProductEvent({required this.product});
}

class UpdateProductEvent extends ProductEvent {
  final Product product;

  UpdateProductEvent({required this.product});
}

class DeleteProductEvent extends ProductEvent {
  final String productId;

  DeleteProductEvent({required this.productId});
}
