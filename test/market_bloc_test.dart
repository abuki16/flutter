import 'package:flutter_test/flutter_test.dart';
import 'package:mini_market_app/data/market_store.dart';
import 'package:mini_market_app/market_bloc/market_bloc.dart';
import 'package:mini_market_app/market_bloc/market_event.dart';
import 'package:mini_market_app/models/product.dart';

void main() {
  group('MarketBloc', () {
    late MarketBloc bloc;

    setUp(() {
      bloc = MarketBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state contains products from MarketStore', () {
      expect(bloc.state.products.isNotEmpty, isTrue);
      expect(bloc.state.isLoading, isFalse);
    });

    test('LoadMarketEvent reloads products from MarketStore', () async {
      bloc.add(const LoadMarketEvent());
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) => state.products.isNotEmpty)),
      );
    });

    test('AddProductEvent adds product to MarketStore and emits new state', () async {
      final newProd = Product(
        id: MarketStore.newProductId(),
        title: 'Test Gadget',
        price: 99.9,
        category: 'smartphones',
        description: 'Testing product addition',
      );

      bloc.add(AddProductEvent(newProd));
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) =>
            state.products.any((p) => p.id == newProd.id) &&
            state.message == 'Product added successfully')),
      );

      expect(MarketStore.findProduct(newProd.id), isNotNull);
    });

    test('UpdateProductEvent updates product in MarketStore and emits new state', () async {
      final existing = MarketStore.products.first;
      final updated = existing.copyWith(title: 'Updated Title');

      bloc.add(UpdateProductEvent(updated));
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) =>
            state.products.firstWhere((p) => p.id == existing.id).title == 'Updated Title' &&
            state.message == 'Product updated successfully')),
      );

      expect(MarketStore.findProduct(existing.id)?.title, 'Updated Title');
    });

    test('DeleteProductEvent removes product from MarketStore and emits new state', () async {
      final toDelete = MarketStore.products.last;

      bloc.add(DeleteProductEvent(toDelete.id));
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) =>
            !state.products.any((p) => p.id == toDelete.id) &&
            state.message == 'Product deleted successfully')),
      );

      expect(MarketStore.findProduct(toDelete.id), isNull);
    });
  });
}
