import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_market_app/cart_bloc/cart_bloc.dart';
import 'package:mini_market_app/cart_bloc/cart_event.dart';
import 'package:mini_market_app/data/market_store.dart';
import 'package:mini_market_app/data/product_data_provider.dart';
import 'package:mini_market_app/market_bloc/market_bloc.dart';
import 'package:mini_market_app/market_bloc/market_event.dart';
import 'package:mini_market_app/models/product.dart';
import 'package:mini_market_app/screens/home_screen.dart';

part 'product_event.dart';
part 'product_state.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ProductBloc>(
        create: (context) => ProductBloc()..add(GetProductsEvent()),
      ),
      BlocProvider<MarketBloc>(
        create: (context) => MarketBloc()..add(const LoadMarketEvent()),
      ),
      BlocProvider<CartBloc>(
        create: (context) => CartBloc()..add(const LoadCartEvent()),
      ),
    ],
    child: const MaterialApp(
      title: 'Mini Market',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  ));
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductDataProvider dataProvider;
  List<Product> _products;

  ProductBloc({ProductDataProvider? dataProvider})
      : dataProvider = dataProvider ?? ProductDataProvider(),
        _products = List<Product>.from(MarketStore.products),
        super(ProductListState(products: List.unmodifiable(MarketStore.products))) {
    on<GetProductsEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        _products = await this.dataProvider.getProducts();
        emit(ProductListState(products: List.unmodifiable(_products)));
      } catch (e) {
        _products = List<Product>.from(MarketStore.products);
        emit(ProductListState(products: List.unmodifiable(_products)));
      }
    });

    on<GetProductEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final product = await this.dataProvider.getProduct(event.productId);
        emit(ProductLoadedState(product: product));
      } catch (e) {
        final product = MarketStore.findProduct(event.productId);
        emit(ProductLoadedState(product: product));
      }
    });

    on<CreateProductEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final created = await this.dataProvider.createProduct(event.product);
        _products = [created, ..._products];
        MarketStore.addProduct(created);
        emit(ProductListState(products: List.unmodifiable(_products)));
      } catch (e) {
        MarketStore.addProduct(event.product);
        _products = [event.product, ..._products];
        emit(ProductListState(products: List.unmodifiable(_products)));
      }
    });

    on<UpdateProductEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final updated = await this.dataProvider.updateProduct(event.product);
        final index = _products.indexWhere((p) => p.id == updated.id);
        if (index != -1) {
          _products[index] = updated;
        }
        MarketStore.updateProduct(updated);
        emit(ProductListState(products: List.unmodifiable(_products)));
      } catch (e) {
        final index = _products.indexWhere((p) => p.id == event.product.id);
        if (index != -1) {
          _products[index] = event.product;
        }
        MarketStore.updateProduct(event.product);
        emit(ProductListState(products: List.unmodifiable(_products)));
      }
    });

    on<DeleteProductEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        await this.dataProvider.deleteProduct(event.productId);
        _products.removeWhere((p) => p.id == event.productId);
        MarketStore.deleteProduct(event.productId);
        emit(ProductListState(products: List.unmodifiable(_products)));
      } catch (e) {
        _products.removeWhere((p) => p.id == event.productId);
        MarketStore.deleteProduct(event.productId);
        emit(ProductListState(products: List.unmodifiable(_products)));
      }
    });
  }
}
