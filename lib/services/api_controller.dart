import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiProduct {
  final int id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String thumbnail;

  const ApiProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.thumbnail,
  });

  factory ApiProduct.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final title = json['title'];
    final description = json['description'];
    final price = json['price'];
    final category = json['category'];
    final thumbnail = json['thumbnail'];

    if (id is! int ||
        title is! String ||
        description is! String ||
        price is! num ||
        category is! String ||
        thumbnail is! String) {
      throw const FormatException('Product data has an unexpected format.');
    }

    return ApiProduct(
      id: id,
      title: title,
      description: description,
      price: price.toDouble(),
      category: category,
      thumbnail: thumbnail,
    );
  }
}

class ApiController {
  ApiController({http.Client? client})
    : _client = client ?? http.Client(),
      _ownsClient = client == null;

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static final Uri productsUri = Uri.https(
    'dummyjson.com',
    '/products/category/sports-accessories',
  );

  static final Uri allProductsUri = Uri.https('dummyjson.com', '/products');

  final http.Client _client;
  final bool _ownsClient;

  static Uri productUri(int id) => Uri.https('dummyjson.com', '/products/$id');

  static ApiProduct _productFromResponse(http.Response response, {String? action}) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Products API ${action ?? 'request'} returned ${response.statusCode}.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Products API response is not a JSON object.');
    }

    return ApiProduct.fromJson(decoded);
  }

  Future<List<ApiProduct>> fetchProducts() async {
    final response = await _client.get(productsUri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Products API returned ${response.statusCode}.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic> || decoded['products'] is! List) {
      throw const FormatException(
        'Products API response does not contain a product list.',
      );
    }

    final products = (decoded['products'] as List<dynamic>).map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Product data has an unexpected format.');
      }
      return ApiProduct.fromJson(item);
    }).toList();

    return products
        .where((product) => product.category == 'sports-accessories')
        .toList();
  }

  Future<ApiProduct> createProduct(Map<String, dynamic> productData) async {
    final response = await _client.post(
      allProductsUri,
      headers: _jsonHeaders,
      body: jsonEncode(productData),
    );

    return _productFromResponse(response, action: 'create');
  }

  Future<ApiProduct> addProduct(Map<String, dynamic> productData) async {
    return createProduct(productData);
  }

  Future<ApiProduct> updateProduct(
    int id,
    Map<String, dynamic> productData,
  ) async {
    final response = await _client.put(
      productUri(id),
      headers: _jsonHeaders,
      body: jsonEncode(productData),
    );

    return _productFromResponse(response, action: 'update');
  }

  Future<Map<String, dynamic>> deleteProduct(int id) async {
    final response = await _client.delete(
      productUri(id),
      headers: _jsonHeaders,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Products API delete returned ${response.statusCode}.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Products API delete response is not a JSON object.',
      );
    }

    return decoded;
  }

  Future<Map<String, dynamic>> removeProduct(int id) async {
    return deleteProduct(id);
  }

  void dispose() {
    if (_ownsClient) _client.close();
  }
}
