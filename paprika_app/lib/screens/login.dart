import 'package:flutter/material.dart';
import 'package:paprika_app/services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();

  void _login() async {
    try {
      await _authService.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      // Navegar para a tela principal após login bem-sucedido
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Exibir mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login: $e')),
      );
    }
  }

  void _signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha no login com Google')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color.fromARGB(255, 135, 32, 27),
      ),
      backgroundColor: const Color(0xFFC7372F),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Entrar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 135, 32, 27),
              ),
            ),
            ElevatedButton(
                onPressed: _signInWithGoogle,
                child: const Text('Login com o Google')),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Não tem uma conta? Cadastre-se aqui.'),
            ),
          ],
        ),
      ),
    );
  }
}
