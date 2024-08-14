import 'package:flutter/material.dart';

class SearchRecipeScreen extends StatelessWidget {
  const SearchRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Procurar Receitas'),
        backgroundColor: const Color.fromARGB(255, 135, 32, 27),
      ),
      body: const Center(
        child: Text(
          'Procurar receitas com base nos ingredientes',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
