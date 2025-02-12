import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../modelos/mensaje.dart';

class MessageController {
  final IO.Socket socket;
  final List<Message> messages = [];

  MessageController(this.socket);

  void sendMessage(String username, String message) {
    final newMessage = Message(username: username, message: message, timestamp: DateTime.now());
    socket.emit('sendMessage', newMessage.toJson());
  }

  void listenMessages(Function(Message) onMessageReceived) {
    socket.on('receiveMessage', (data) {
      final message = Message.fromJson(data);
      messages.add(message);
      onMessageReceived(message);
    });
  }
}
