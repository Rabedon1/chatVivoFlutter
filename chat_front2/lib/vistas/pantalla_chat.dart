import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pantalla_login.dart'; // Asegúrate de importar la pantalla de login
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../modelos/mensaje.dart';
import '../controladores/controlador_chat.dart';

class PantallaChat extends StatefulWidget {
  @override
  _PantallaChatState createState() => _PantallaChatState();
}

class _PantallaChatState extends State<PantallaChat> {
  late MessageController _controller;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    // Conectar con el servidor de WebSocket
    final socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    _controller = MessageController(socket);
    _controller.listenMessages(_onMessageReceived);
  }

  void _onMessageReceived(Message message) {
    setState(() {
      // Actualiza la lista de mensajes cuando un nuevo mensaje es recibido
    });
  }

  void _sendMessage() {
    if (_usernameController.text.isNotEmpty && _messageController.text.isNotEmpty) {
      _controller.sendMessage(_usernameController.text, _messageController.text);
      _messageController.clear(); // Limpiar el campo de mensaje
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PantallaLogin()), // Redirige al login
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat en Tiempo Real'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout, // Salir de la cuenta
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nombre de usuario'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _controller.messages.length,
                itemBuilder: (context, index) {
                  final message = _controller.messages[index];
                  return ListTile(
                    title: Text(message.username),
                    subtitle: Text(message.message),
                    trailing: Text(message.timestamp.toString()),
                  );
                },
              ),
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Escribe un mensaje'),
            ),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
