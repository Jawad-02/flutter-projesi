import 'dart:convert';

import '../http/http_client.dart';
import '../models/product.dart';

class ApiService {
  static Future<List<Product>> fetchProducts() async {
    final body = await HttpClientService.getString('https://wantapi.com/products.php');
    final json = jsonDecode(body) as Map<String, dynamic>;
    final data = json['data'] as List<dynamic>;
    return data
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
