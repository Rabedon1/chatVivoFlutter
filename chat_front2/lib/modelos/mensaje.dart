class Message {
  final String username;
  final String message;
  final DateTime timestamp;

  Message({required this.username, required this.message, required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      username: json['username'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
