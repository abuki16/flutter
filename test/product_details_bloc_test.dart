import 'package:flutter_test/flutter_test.dart';
import 'package:mini_market_app/data/market_store.dart';
import 'package:mini_market_app/product_details_bloc/product_details_bloc.dart';
import 'package:mini_market_app/product_details_bloc/product_details_event.dart';

void main() {
  group('ProductDetailsBloc', () {
    late ProductDetailsBloc bloc;

    setUp(() {
      bloc = ProductDetailsBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state has default quantity of 1 and null product', () {
      expect(bloc.state.quantity, 1);
      expect(bloc.state.product, isNull);
      expect(bloc.state.isDeleted, isFalse);
      expect(bloc.state.isAddedToCart, isFalse);
    });

    test('LoadProductDetailsEvent loads product from MarketStore', () async {
      bloc.add(const LoadProductDetailsEvent('p1'));
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) => state.product != null && state.product.id == 'p1')),
      );
    });

    test('increments and decrements quantity properly', () async {
      bloc.add(const IncrementQuantityEvent());
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) => state.quantity == 2)),
      );

      bloc.add(const DecrementQuantityEvent());
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) => state.quantity == 1)),
      );

      // Decrementing when quantity is 1 should not reduce below 1
      bloc.add(const DecrementQuantityEvent());
      // No new state should be emitted with quantity < 1
    });

    test('AddToCartEvent adds item to MarketStore cart and emits isAddedToCart', () async {
      bloc.add(const LoadProductDetailsEvent('p1'));
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) => state.product?.id == 'p1')),
      );

      final initialCartCount = MarketStore.cartCount;
      bloc.add(const AddToCartEvent());
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) => state.isAddedToCart == true)),
      );

      expect(MarketStore.cartCount, initialCartCount + 1);
    });

    test('DeleteProductEvent removes product from MarketStore and emits isDeleted', () async {
      // Find a product to delete
      final product = MarketStore.products.last;
      bloc.add(LoadProductDetailsEvent(product.id));
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) => state.product?.id == product.id)),
      );

      bloc.add(const DeleteProductEvent());
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) => state.isDeleted == true)),
      );

      expect(MarketStore.findProduct(product.id), isNull);
    });
  });
}
