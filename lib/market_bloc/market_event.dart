import 'package:mini_market_app/models/product.dart';

abstract class MarketEvent {
  const MarketEvent();
}

class LoadMarketEvent extends MarketEvent {
  const LoadMarketEvent();
}

class AddProductEvent extends MarketEvent {
  final Product product;
  const AddProductEvent(this.product);
}

class UpdateProductEvent extends MarketEvent {
  final Product product;
  const UpdateProductEvent(this.product);
}

class DeleteProductEvent extends MarketEvent {
  final String productId;
  const DeleteProductEvent(this.productId);
}
