part of 'product_bloc.dart';

abstract class ProductState {}

class ProductInitialState extends ProductState {}

class ProductLoading extends ProductState {}

class ProductListState extends ProductState {
  final List<Product> products;

  ProductListState({required this.products});
}

class ProductLoadedState extends ProductState {
  final Product? product;

  ProductLoadedState({this.product});
}

class ProductErrorState extends ProductState {
  final String message;

  ProductErrorState({required this.message});
}
