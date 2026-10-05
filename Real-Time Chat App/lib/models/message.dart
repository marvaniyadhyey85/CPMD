class Message {
  final String id;
  final String text;
  final String sender;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
  });

  factory Message.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return Message(
      id: id,
      text: data['text'] ?? '',
      sender: data['sender'] ?? 'Unknown',
      timestamp: data['timestamp'] != null
          ? data['timestamp'].toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'sender': sender,
      'timestamp': timestamp,
    };
  }
}