//
// import 'package:http/http.dart' as http;
// import '../models/productsModels.dart';
//
// class RemoteService {
//   Future<ProductsModels> getProducts() async {
//     var client = http.Client();
//
//     var uri = Uri.parse('https://jsonplaceholder.typicode.com/products');
//     var response = await client.get(uri);
//     if (response.statusCode == 200) {
//       var json = response.body;
//       return productsModelsFromJson(json);
//     } else {
//       throw ('error');
//     }
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';


class RemoteService {
  Future<List<Product>> getProducts(int skip, int limit) async {
    final String url = 'https://dummyjson.com/products?skip=$skip&limit=$limit';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final products = (jsonData['products'] as List)
          .map((json) => Product.fromJson(json))
          .toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
