import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'vistas/pantalla_login.dart'; // Asegúrate de que esta ruta esté bien
  
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
    apiKey: "AIzaSyBOJCaxk4TGEGVmsArI42pujSXp0RfrRD0",
    authDomain: "chat-vivo-9c8d7.firebaseapp.com",
    projectId: "chat-vivo-9c8d7",
    storageBucket: "chat-vivo-9c8d7.firebasestorage.app",
    messagingSenderId: "976914696962",
    appId: "1:976914696962:web:9f4671a9085d84936e901b",
    measurementId: "G-BSZWYHJV88"
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PantallaLogin(),
    );
  }
}