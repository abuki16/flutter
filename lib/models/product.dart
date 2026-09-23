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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] != null ? json['id'].toString() : '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'category': category,
      'description': description,
    };
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  double get total => product.price * quantity;
}
