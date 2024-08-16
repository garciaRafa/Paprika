import 'package:flutter/material.dart';
import 'package:paprika_app/services/spoonacular.dart';
import 'package:paprika_app/services/ingredients_storage.dart';
import 'package:paprika_app/screens/recipes_by_ingredients.dart';

class RegisterIngredientsScreen extends StatefulWidget {
  const RegisterIngredientsScreen({super.key});

  @override
  _RegisterIngredientsScreenState createState() =>
      _RegisterIngredientsScreenState();
}

class _RegisterIngredientsScreenState extends State<RegisterIngredientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _ingredients = [];
  final List<String> _ingredientSuggestions = [];
  final IngredientStorageService _storageService = IngredientStorageService();
  final SpoonacularService _apiService =
      SpoonacularService(); // Inicializando o _apiService

  @override
  void initState() {
    super.initState();
    _loadSavedIngredients();
  }

  void _loadSavedIngredients() async {
    List<String> savedIngredients = await _storageService.getIngredients();
    setState(() {
      _ingredients.addAll(savedIngredients);
    });
  }

  void _addIngredient(String ingredient) {
    if (!_ingredients.contains(ingredient)) {
      setState(() {
        _ingredients.add(ingredient);
      });
      _storageService.saveIngredients(_ingredients);
    }
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      _ingredients.remove(ingredient);
    });
    _storageService.saveIngredients(_ingredients);
  }

  void _searchIngredients(String query) async {
    try {
      final response = await _apiService
          .fetchData('food/ingredients/search?query=$query&number=10');

      // Limpando as sugestões anteriores
      _ingredientSuggestions.clear();

      // Acessando os resultados retornados pela API
      final results = response;

      for (var result in results) {
        _ingredientSuggestions.add(result['name']);
      }

      setState(() {});
    } catch (e) {
      print('Erro ao buscar ingredientes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Ingredientes'),
        backgroundColor: const Color.fromARGB(255, 135, 32, 27),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _searchIngredients,
              decoration: const InputDecoration(
                labelText: 'Pesquisar Ingredientes',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _ingredientSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _ingredientSuggestions[index];
                  return ListTile(
                    title: Text(suggestion),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _addIngredient(suggestion),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ingredientes Adicionados:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = _ingredients[index];
                  return ListTile(
                    title: Text(ingredient),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeIngredient(ingredient),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RecipesByIngredientsScreen(),
                  ),
                );
              },
              child: const Text('Gerar Receitas'),
            ),
          ],
        ),
      ),
    );
  }
}
