import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_tecnica_exito/models/product_model.dart';

class StoreService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  // Traemos todass las categorias
  Future<List<String>> getCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/products/categories'));

    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e.toString()).toList();
    }else {
      throw Exception('Error al cargar categoria');
    }
  }
  // Trae productos por categoria
  Future<List<Product>> getProductByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products/category/$category'),
    );
    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    }else {
      throw Exception('Error al cargar productos');
    }
  }
}