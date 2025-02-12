import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'pantalla_chat.dart'; // Asegúrate de importar la pantalla de chat
import 'pantalla_login.dart';

class PantallaRegistro extends StatefulWidget {
  @override
  _PantallaRegistroState createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PantallaChat()), // Redirige al chat
        );
      }
    } catch (e) {
      print('Error al registrar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Registrarme'),
            ),
            TextButton(
              onPressed: () {
                // Si el usuario ya tiene cuenta, lo redirigimos a la pantalla de login
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PantallaLogin()),
                );
              },
              child: Text('¿Ya tienes cuenta? Inicia sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
