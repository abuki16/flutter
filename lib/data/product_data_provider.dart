import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class ProductDataProvider {
  static const String baseUrl = 'https://dummyjson.com/products';

  final http.Client _client;

  ProductDataProvider({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Product>> getProducts() async {
    final response = await _client.get(Uri.parse('$baseUrl?limit=30'));

    if (response.statusCode != 200) {
      throw ApiException(_errorMessage(response));
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final products = body['products'] as List<dynamic>;

    final result = <Product>[];
    for (final product in products) {
      result.add(Product.fromJson(product as Map<String, dynamic>));
    }

    return result;
  }

  Future<Product> getProduct(dynamic id) async {
    final response = await _client.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw ApiException(_errorMessage(response));
    }

    return Product.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<String>> getCategories() async {
    final response = await _client.get(Uri.parse('$baseUrl/category-list'));

    if (response.statusCode != 200) {
      throw ApiException(_errorMessage(response));
    }

    final categories = jsonDecode(response.body) as List<dynamic>;

    final result = <String>[];
    for (final category in categories) {
      result.add(category as String);
    }

    return result;
  }

  Future<Product> createProduct(Product product) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ApiException(_errorMessage(response));
    }

    return Product.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Product> updateProduct(Product product) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/${product.id}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw ApiException(_errorMessage(response));
    }

    return Product.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> deleteProduct(dynamic id) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode != 200) {
      throw ApiException(_errorMessage(response));
    }
  }

  String _errorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic> && body['message'] is String) {
        return body['message'] as String;
      }
    } catch (_) {}

    return 'The server said ${response.statusCode}.';
  }
}
