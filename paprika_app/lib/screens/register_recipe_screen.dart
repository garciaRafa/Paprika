import 'package:flutter/material.dart';

class RegisterRecipeScreen extends StatelessWidget {
  const RegisterRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Receitas'),
        backgroundColor: const Color.fromARGB(255, 135, 32, 27),
      ),
      body: const Center(
        child: Text(
          'Cadastro de Receitas',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
