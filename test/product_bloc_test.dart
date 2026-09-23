import 'package:flutter_test/flutter_test.dart';
import 'package:mini_market_app/bloc/product_bloc/product_bloc.dart';
import 'package:mini_market_app/data/product_data_provider.dart';
import 'package:mini_market_app/models/product.dart';

class FakeProductDataProvider extends ProductDataProvider {
  final List<Product> _mockProducts = [
    const Product(
      id: 'p1',
      title: 'Phone X',
      price: 549.0,
      category: 'smartphones',
      description: 'Test phone',
    ),
    const Product(
      id: 'p2',
      title: 'Headphones',
      price: 89.0,
      category: 'audio',
      description: 'Test audio',
    ),
  ];

  @override
  Future<List<Product>> getProducts() async => List.from(_mockProducts);

  @override
  Future<Product> getProduct(dynamic id) async {
    return _mockProducts.firstWhere((p) => p.id == id.toString());
  }

  @override
  Future<Product> createProduct(Product product) async {
    _mockProducts.add(product);
    return product;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final idx = _mockProducts.indexWhere((p) => p.id == product.id);
    if (idx != -1) _mockProducts[idx] = product;
    return product;
  }

  @override
  Future<void> deleteProduct(dynamic id) async {
    _mockProducts.removeWhere((p) => p.id == id.toString());
  }
}

void main() {
  group('Product JSON serialization', () {
    test('fromJson correctly parses DummyJSON format', () {
      final json = {
        'id': 101,
        'title': 'Test Phone',
        'price': 499.99,
        'category': 'smartphones',
        'description': 'A high performance test smartphone',
      };

      final product = Product.fromJson(json);

      expect(product.id, '101');
      expect(product.title, 'Test Phone');
      expect(product.price, 499.99);
      expect(product.category, 'smartphones');
      expect(product.description, 'A high performance test smartphone');
    });

    test('toJson produces correct map', () {
      const product = Product(
        id: '202',
        title: 'Laptop Pro',
        price: 1299.0,
        category: 'laptops',
        description: 'Ultra thin laptop',
      );

      final map = product.toJson();

      expect(map['id'], '202');
      expect(map['title'], 'Laptop Pro');
      expect(map['price'], 1299.0);
      expect(map['category'], 'laptops');
      expect(map['description'], 'Ultra thin laptop');
    });
  });

  group('ProductBloc', () {
    late ProductBloc bloc;

    setUp(() {
      bloc = ProductBloc(dataProvider: FakeProductDataProvider());
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is ProductListState with default products', () {
      expect(bloc.state, isA<ProductListState>());
      expect((bloc.state as ProductListState).products, isNotEmpty);
    });

    test('GetProductsEvent emits ProductLoading then ProductListState', () async {
      bloc.add(GetProductsEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ProductLoading>(),
          isA<ProductListState>(),
        ]),
      );
    });

    test('GetProductEvent emits ProductLoading then ProductLoadedState', () async {
      bloc.add(GetProductEvent(productId: 'p1'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ProductLoading>(),
          isA<ProductLoadedState>(),
        ]),
      );
    });

    test('CreateProductEvent adds product and emits ProductListState', () async {
      const newProduct = Product(
        id: 'new_1',
        title: 'New Wireless Headphones',
        price: 150.0,
        category: 'audio',
        description: 'Noise cancelling',
      );

      bloc.add(CreateProductEvent(product: newProduct));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ProductLoading>(),
          predicate<dynamic>((state) =>
              state is ProductListState &&
              state.products.any((p) => p.id == 'new_1' && p.title == 'New Wireless Headphones')),
        ]),
      );
    });

    test('UpdateProductEvent updates product and emits ProductListState', () async {
      // First populate products
      bloc.add(GetProductsEvent());
      await bloc.stream.firstWhere((s) => s is ProductListState);

      const updated = Product(
        id: 'p1',
        title: 'Updated Phone X',
        price: 599.0,
        category: 'smartphones',
        description: 'Updated description',
      );

      bloc.add(UpdateProductEvent(product: updated));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ProductLoading>(),
          predicate<dynamic>((state) =>
              state is ProductListState &&
              state.products.any((p) => p.id == 'p1' && p.title == 'Updated Phone X')),
        ]),
      );
    });

    test('DeleteProductEvent removes product and emits ProductListState', () async {
      // First populate products
      bloc.add(GetProductsEvent());
      await bloc.stream.firstWhere((s) => s is ProductListState);

      bloc.add(DeleteProductEvent(productId: 'p1'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ProductLoading>(),
          predicate<dynamic>((state) =>
              state is ProductListState &&
              !state.products.any((p) => p.id == 'p1')),
        ]),
      );
    });
  });
}
