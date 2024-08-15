import 'package:flutter/material.dart';
import 'package:paprika_app/services/spoonacular.dart';
import 'package:paprika_app/services/ingredients_storage.dart';

class RegisterIngredientsScreen extends StatefulWidget {
  const RegisterIngredientsScreen({super.key});

  @override
  _RegisterIngredientsScreenState createState() =>
      _RegisterIngredientsScreenState();
}

class _RegisterIngredientsScreenState extends State<RegisterIngredientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _ingredients = [];
  final List<String> _suggestions = [];
  final IngredientStorageService _storageService = IngredientStorageService();

  // Dados mock para ingredientes
  /*
  final List<String> mockIngredients = [
    'Tomato',
    'Onion',
    'Garlic',
    'Basil',
    'Oregano',
    'Carrot',
    'Pepper',
    'Olive Oil',
    'Salt',
    'Pepper',
  ];
  */

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
    if (query.isEmpty) {
      setState(() {
        _suggestions.clear();
      });
      return;
    }

    final SpoonacularService apiService = SpoonacularService();
    try {
      final response =
          await apiService.fetchData('food/ingredients/search?query=$query');
      setState(() {
        _suggestions.clear();
        for (var result in response['results']) {
          _suggestions.add(result['name']);
        }
      });
    } catch (e) {
      print('Erro ao buscar ingredientes: $e');
    }
  }

  /*
  void _searchIngredients(String query) {
    if (query.isEmpty) {
      setState(() {
        _suggestions.clear();
      });
      return;
    }

    setState(() {
      _suggestions.clear();
      _suggestions.addAll(mockIngredients.where((ingredient) =>
          ingredient.toLowerCase().contains(query.toLowerCase())));
    });
  }*/

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
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
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
          ],
        ),
      ),
    );
  }
}
