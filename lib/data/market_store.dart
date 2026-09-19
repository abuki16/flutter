import '../models/product.dart';

class MarketStore {
  MarketStore._();

  static final List<Product> products = [
    const Product(
      id: 'p1',
      title: 'Phone X',
      price: 549,
      category: 'smartphones',
      description: '6.1-inch display, 128 GB storage, dual camera.',
    ),
    const Product(
      id: 'p2',
      title: 'Headphones',
      price: 89,
      category: 'audio',
      description: 'Over-ear headphones with 30 hours of battery life.',
    ),
    const Product(
      id: 'p3',
      title: 'T-shirt',
      price: 15,
      category: 'clothing',
      description: '100% cotton, regular fit, machine washable.',
    ),
    const Product(
      id: 'p4',
      title: 'Laptop',
      price: 899,
      category: 'computers',
      description: '14-inch laptop, 16 GB RAM, 512 GB SSD.',
    ),
    const Product(
      id: 'p5',
      title: 'Camera',
      price: 320,
      category: 'photography',
      description: 'Compact camera with 20x optical zoom.',
    ),
    const Product(
      id: 'p6',
      title: 'Backpack',
      price: 42,
      category: 'accessories',
      description: 'Water resistant backpack with a laptop pocket.',
    ),
  ];

  static final List<CartItem> cart = [];

  static Product? findProduct(String id) {
    for (final product in products) {
      if (product.id == id) return product;
    }
    return null;
  }

  static void addProduct(Product product) {
    products.add(product);
  }

  static void updateProduct(Product updated) {
    final index = products.indexWhere((product) => product.id == updated.id);
    if (index == -1) return;
    products[index] = updated;

    for (final item in cart) {
      if (item.product.id == updated.id) {
        cart[cart.indexOf(item)] = CartItem(
          product: updated,
          quantity: item.quantity,
        );
      }
    }
  }

  static void deleteProduct(String id) {
    products.removeWhere((product) => product.id == id);
    cart.removeWhere((item) => item.product.id == id);
  }

  static String newProductId() {
    return 'p${DateTime.now().millisecondsSinceEpoch}';
  }

  static void addToCart(Product product, int quantity) {
    final index = cart.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      cart.add(CartItem(product: product, quantity: quantity));
    } else {
      cart[index].quantity += quantity;
    }
  }

  static void removeFromCart(String productId) {
    cart.removeWhere((item) => item.product.id == productId);
  }

  static void clearCart() {
    cart.clear();
  }

  static int get cartCount {
    int count = 0;
    for (final item in cart) {
      count += item.quantity;
    }
    return count;
  }

  static double get cartTotal {
    double total = 0;
    for (final item in cart) {
      total += item.total;
    }
    return total;
  }
}
