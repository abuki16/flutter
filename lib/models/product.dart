class Product {
  final String id;
  final String title;
  final String description;
  final String category;
  final double price;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
  });

  Product copyWith({
    String? title,
    String? description,
    String? category,
    double? price,
  }) {
    return Product(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
    );
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  double get total => product.price * quantity;
}
