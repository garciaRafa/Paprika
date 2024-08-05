import 'package:flutter/material.dart';
import 'package:paprika_app/services/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationService _authService = AuthenticationService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paprika'),
        backgroundColor: const Color.fromARGB(255, 135, 32, 27),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      backgroundColor: const Color(0xFFC7372F),
      body: Center(
        child: Text(
          'Bem-vindo ao Paprika!',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
