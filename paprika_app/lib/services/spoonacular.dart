import 'dart:convert';
import 'package:http/http.dart' as http;

class SpoonacularService {
  final String _apiKey = '406150cb9f4d438ca1d3a7b66c75c685';
  final String _baseUrl = 'https://api.spoonacular.com/';

  Future<List<dynamic>> fetchData(String endpoint) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint?apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['recipes'] as List<dynamic>;
    } else {
      print('Erro: ${response.statusCode}');
      print('Resposta: ${response.body}');
      throw Exception('Falha ao carregar dados da API');
    }
  }

  Future<Map<String, dynamic>> fetchMealPlan(int numberOfDays) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/mealplanner/generate?apiKey=$_apiKey&timeFrame=day&number=$numberOfDays'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Status Code: ${response.statusCode}');
        print('Resposta: ${response.body}');
        throw Exception('Falha ao carregar dados do planejamento de refeições');
      }
    } catch (e) {
      print('Erro ao fazer a requisição: $e');
      throw e;
    }
  }
}