import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductApi {
  static const String _url =
      'https://troogood.in/api/V1/products/list';

  static Future<List<ProductModel>> getProducts() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List list = decoded['data'];

      return list.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
