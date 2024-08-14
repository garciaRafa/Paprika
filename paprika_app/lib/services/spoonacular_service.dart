import 'dart:convert';
import 'package:http/http.dart' as http;

class SpoonacularService {
  final String _apiKey = '406150cb9f4d438ca1d3a7b66c75c685';
  final String _baseUrl = 'https://api.spoonacular.com/recipes';

  Future<Map<String, dynamic>> fetchData(String endpoint) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint?apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao carregar dados da API');
    }
  }
}
