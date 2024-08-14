import 'package:flutter/material.dart';

class SearchRecipeScreen extends StatelessWidget {
  const SearchRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Procurar receitas com base nos ingredientes',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}
