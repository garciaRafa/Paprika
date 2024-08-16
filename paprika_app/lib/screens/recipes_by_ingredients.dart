import 'package:flutter/material.dart';
import 'package:paprika_app/services/spoonacular.dart';
import 'package:paprika_app/services/ingredients_storage.dart';

class RecipesByIngredientsScreen extends StatefulWidget {
  const RecipesByIngredientsScreen({super.key});

  @override
  _RecipesByIngredientsScreenState createState() =>
      _RecipesByIngredientsScreenState();
}

class _RecipesByIngredientsScreenState
    extends State<RecipesByIngredientsScreen> {
  final IngredientStorageService _storageService = IngredientStorageService();
  final SpoonacularService _apiService = SpoonacularService();
  List<Map<String, dynamic>> _recipes = [];
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Recupera os ingredientes salvos
      List<String> savedIngredients = await _storageService.getIngredients();

      // Converte a lista de ingredientes para uma string separada por vírgulas
      String ingredientsQuery = savedIngredients.join(',');

      // Busca receitas utilizando a API
      final response = await _apiService.fetchData(
        'recipes/findByIngredients?ingredients=$ingredientsQuery&number=5&offset=${(_currentPage - 1) * 5}',
      );

      setState(() {
        _recipes.addAll(List<Map<String, dynamic>>.from(response));
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao buscar receitas: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadMoreRecipes() {
    setState(() {
      _currentPage++;
    });
    _loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas por Ingredientes'),
        backgroundColor: const Color.fromARGB(255, 135, 32, 27),
      ),
      body: _isLoading && _recipes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _recipes.length + 1,
              itemBuilder: (context, index) {
                if (index == _recipes.length) {
                  // Botão de carregar mais receitas
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _loadMoreRecipes,
                      child: const Text('Carregar Mais'),
                    ),
                  );
                }

                final recipe = _recipes[index];
                return ListTile(
                  leading: recipe['image'] != null
                      ? Image.network(recipe['image'], width: 50, height: 50)
                      : const SizedBox(width: 50, height: 50),
                  title: Text(recipe['title']),
                );
              },
            ),
    );
  }
}
