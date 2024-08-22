import 'package:flutter/material.dart';
import 'package:paprika_app/services/spoonacular.dart';

class RandomRecipeScreen extends StatefulWidget {
  const RandomRecipeScreen({super.key});

  @override
  _RandomRecipeScreenState createState() => _RandomRecipeScreenState();
}

class _RandomRecipeScreenState extends State<RandomRecipeScreen> {
  final SpoonacularService _spoonacularService = SpoonacularService();
  Future<List<dynamic>>? _recipes;

  void _loadRecipes() {
    setState(() {
      _recipes = _spoonacularService.fetchData('recipes/random');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas Aleatórias'),
        backgroundColor: const Color.fromARGB(255, 135, 32, 27),
      ),
      backgroundColor: const Color(0xFFC7372F),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _recipes,
              builder: (context, snapshot) {
                if (_recipes == null) {
                  return const Center(
                      child: Text('Clique no botão para gerar uma receita.'));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhuma receita encontrada.'));
                } else {
                  final recipe = snapshot.data![0];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe['title'],
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          recipe['instructions'] ??
                              'Instruções não disponíveis.',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        recipe['image'] != null
                            ? Image.network(recipe['image'])
                            : const Text('Imagem não disponível.'),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: _loadRecipes,
            child: const Text('Gerar Receita Aleatória'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 135, 32, 27),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}