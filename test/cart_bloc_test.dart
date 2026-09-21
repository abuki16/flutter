import 'package:flutter_test/flutter_test.dart';
import 'package:mini_market_app/cart_bloc/cart_bloc.dart';
import 'package:mini_market_app/cart_bloc/cart_event.dart';
import 'package:mini_market_app/data/market_store.dart';
import 'package:mini_market_app/models/product.dart';

void main() {
  group('CartBloc', () {
    late CartBloc bloc;
    final testProduct = const Product(
      id: 'test_p1',
      title: 'Cart Test Product',
      price: 50.0,
      category: 'accessories',
      description: 'Cart test description',
    );

    setUp(() {
      MarketStore.clearCart();
      bloc = CartBloc();
    });

    tearDown(() {
      bloc.close();
      MarketStore.clearCart();
    });

    test('initial state has empty items when store cart is cleared', () {
      expect(bloc.state.items, isEmpty);
      expect(bloc.state.cartCount, 0);
      expect(bloc.state.cartTotal, 0.0);
    });

    test('AddToCartEvent adds product and calculates count and total', () async {
      bloc.add(AddToCartEvent(testProduct, 2));

      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) =>
            state.items.length == 1 &&
            state.cartCount == 2 &&
            state.cartTotal == 100.0 &&
            state.message != null)),
      );

      expect(MarketStore.cartCount, 2);
    });

    test('RemoveFromCartEvent removes product from cart', () async {
      MarketStore.addToCart(testProduct, 1);
      bloc.add(const LoadCartEvent());
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) => state.cartCount == 1)),
      );

      bloc.add(RemoveFromCartEvent(testProduct.id));
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) =>
            state.items.isEmpty &&
            state.cartCount == 0 &&
            state.message == 'Item removed from cart')),
      );

      expect(MarketStore.cartCount, 0);
    });

    test('ClearCartEvent clears all cart items', () async {
      MarketStore.addToCart(testProduct, 3);
      bloc.add(const LoadCartEvent());
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) => state.cartCount == 3)),
      );

      bloc.add(const ClearCartEvent());
      await expectLater(
        bloc.stream,
        emits(predicate<dynamic>((state) =>
            state.items.isEmpty &&
            state.cartCount == 0 &&
            state.message == 'Order placed successfully!')),
      );

      expect(MarketStore.cartCount, 0);
    });
  });
}
