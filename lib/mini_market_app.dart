import 'package:flutter/material.dart';

// --- 1. Data Model & Mock Store ---
class Product {
  final String id;
  String title;
  double price;
  String category;
  String description;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
  });
}

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

// Helper functions for category icons and colors (matching slide designs)
IconData getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'smartphones':
      return Icons.phone_android;
    case 'audio':
      return Icons.headphones;
    case 'apparel':
      return Icons.checkroom;
    case 'computers':
      return Icons.laptop;
    case 'photography':
      return Icons.camera_alt;
    case 'accessories':
      return Icons.backpack;
    default:
      return Icons.category;
  }
}

Color getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'smartphones':
      return Colors.blue;
    case 'audio':
      return Colors.green;
    case 'apparel':
      return Colors.deepOrange;
    case 'computers':
      return Colors.deepPurple;
    case 'photography':
      return Colors.teal;
    case 'accessories':
      return Colors.pink;
    default:
      return Colors.indigo;
  }
}

class MarketStore {
  static const List<String> categories = [
    'smartphones',
    'audio',
    'apparel',
    'computers',
    'photography',
    'accessories',
    'general',
  ];

  static final List<Product> products = [
    Product(
      id: 'p1',
      title: 'Phone X',
      price: 549.0,
      category: 'smartphones',
      description: 'Latest flagship smartphone with stunning display.',
    ),
    Product(
      id: 'p2',
      title: 'Headphones',
      price: 89.0,
      category: 'audio',
      description: 'Over-ear headphones with 30 hours of battery life.',
    ),
    Product(
      id: 'p3',
      title: 'T-shirt',
      price: 15.0,
      category: 'apparel',
      description: '100% cotton comfortable casual t-shirt.',
    ),
    Product(
      id: 'p4',
      title: 'Laptop',
      price: 899.0,
      category: 'computers',
      description: 'High performance laptop for work and gaming.',
    ),
    Product(
      id: 'p5',
      title: 'Camera',
      price: 320.0,
      category: 'photography',
      description: 'Digital mirrorless camera with 4K video recording.',
    ),
    Product(
      id: 'p6',
      title: 'Backpack',
      price: 42.0,
      category: 'accessories',
      description: 'Durable waterproof travel backpack.',
    ),
  ];

  static final List<CartItem> cart = [];

  static Product? findProduct(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  static String newProductId() {
    return 'p${products.length + 1}';
  }

  static void addProduct(Product product) {
    products.add(product);
  }

  static void updateProduct(Product updated) {
    final index = products.indexWhere((p) => p.id == updated.id);
    if (index >= 0) {
      products[index] = updated;
    }
  }

  static void deleteProduct(String id) {
    products.removeWhere((p) => p.id == id);
    cart.removeWhere((item) => item.product.id == id);
  }

  static void addToCart(Product product, [int count = 1]) {
    final existingIndex = cart.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      cart[existingIndex].quantity += count;
    } else {
      cart.add(CartItem(product: product, quantity: count));
    }
  }

  static void removeFromCart(String productId) {
    cart.removeWhere((item) => item.product.id == productId);
  }

  static int get cartItemCount {
    return cart.fold(0, (sum, item) => sum + item.quantity);
  }

  static double get cartTotal {
    return cart.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }
}

// --- 2. Main App Entry Point & Named Routes ---
void main() {
  runApp(const MiniMarketApp());
}

class MiniMarketApp extends StatelessWidget {
  const MiniMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Market',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(),
        '/add': (context) => const ProductFormScreen(),
        '/product': (context) => const ProductDetailScreen(),
      },
    );
  }
}

// --- 3. Home Screen (Product Grid) ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Market', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: MarketStore.cartItemCount > 0,
              label: Text('${MarketStore.cartItemCount}'),
              backgroundColor: Colors.red,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            onPressed: () async {
              await Navigator.pushNamed(context, '/cart');
              setState(() {});
            },
          ),
        ],
      ),
      body: MarketStore.products.isEmpty
          ? const Center(
              child: Text(
                'No products yet.\nTap + to add your first one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.82,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: MarketStore.products.length,
              itemBuilder: (context, index) {
                final product = MarketStore.products[index];
                final categoryColor = getCategoryColor(product.category);
                final categoryIcon = getCategoryIcon(product.category);

                return GestureDetector(
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      '/product',
                      arguments: product.id,
                    );
                    setState(() {});
                  },
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: categoryColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Icon(categoryIcon, size: 48, color: categoryColor),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${product.price.toStringAsFixed(1)}',
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE8DEF8),
        foregroundColor: const Color(0xFF1D192B),
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// --- 4. Product Detail Screen ---
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailScreen> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    // Extract passed product ID
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final product = MarketStore.findProduct(productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Product not found.')),
      );
    }

    final categoryColor = getCategoryColor(product.category);
    final categoryIcon = getCategoryIcon(product.category);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // Edit product button (Pencil icon from slide 42/43)
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.grey),
            onPressed: () async {
              await Navigator.pushNamed(context, '/add', arguments: product.id);
              setState(() {});
            },
          ),
          // Delete product button (Trash icon from slide 42/43)
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete product?'),
                  content: const Text('This product will be removed from the market.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (shouldDelete == true) {
                MarketStore.deleteProduct(product.id);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large Product Image container (from slide 42 screen 3)
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Icon(categoryIcon, size: 90, color: categoryColor),
            ),
            const SizedBox(height: 20),
            Text(
              product.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              '\$${product.price.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            Text(
              product.description,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.3),
            ),
            const SizedBox(height: 24),
            // Quantity Selector Row
            Row(
              children: [
                const Text('Qty', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600)),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: () {
                          if (qty > 1) setState(() => qty--);
                        },
                      ),
                      Text('$qty', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () => setState(() => qty++),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  MarketStore.addToCart(product, qty);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added $qty ${product.title}(s) to cart!')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Add to cart', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 5. Product Form Screen (Add & Edit Product) ---
class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'smartphones';
  bool _isInit = false;
  String? _editingProductId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        final existing = MarketStore.findProduct(productId);
        if (existing != null) {
          _editingProductId = existing.id;
          _titleController.text = existing.title;
          _priceController.text = existing.price.toStringAsFixed(1);
          _selectedCategory = existing.category;
          _descriptionController.text = existing.description;
        }
      }
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (!_formKey.currentState!.validate()) return;

    if (_editingProductId != null) {
      MarketStore.updateProduct(
        Product(
          id: _editingProductId!,
          title: _titleController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          category: _selectedCategory,
          description: _descriptionController.text.trim(),
        ),
      );
    } else {
      MarketStore.addProduct(
        Product(
          id: MarketStore.newProductId(),
          title: _titleController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          category: _selectedCategory,
          description: _descriptionController.text.trim(),
        ),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingProductId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit product' : 'Add product', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const Text('Title', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Desk lamp',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a title' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('Price', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        hintText: '0',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Please enter a price';
                        if (double.tryParse(value.trim()) == null) return 'Please enter a valid number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Category', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: MarketStore.categories.contains(_selectedCategory)
                          ? _selectedCategory
                          : MarketStore.categories.first,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      items: MarketStore.categories.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat,
                          child: Text(cat),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCategory = val);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Description', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Short description',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      maxLines: 3,
                      validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a description' : null,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _saveProduct,
                  child: Text(
                    isEditing ? 'Save changes' : 'Save product',
                    style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 6. Cart Screen ---
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your cart', style: TextStyle(fontWeight: FontWeight.bold))),
      body: MarketStore.cart.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: MarketStore.cart.length,
                    itemBuilder: (context, index) {
                      final item = MarketStore.cart[index];
                      final categoryColor = getCategoryColor(item.product.category);
                      final categoryIcon = getCategoryIcon(item.product.category);

                      return ListTile(
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: categoryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(categoryIcon, color: categoryColor, size: 24),
                        ),
                        title: Text(item.product.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('Qty ${item.quantity}', style: const TextStyle(color: Colors.grey)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              MarketStore.removeFromCart(item.product.id);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            '\$${MarketStore.cartTotal.toStringAsFixed(1)}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Checkout'),
                                content: Text('Order placed successfully! Total: \$${MarketStore.cartTotal.toStringAsFixed(1)}'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        MarketStore.cart.clear();
                                      });
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text('Checkout', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}