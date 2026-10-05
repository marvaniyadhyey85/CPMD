import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send message
  Future<void> sendMessage(String roomId, String text, String sender) async {
    if (text.trim().isEmpty) {
      return;
    }

    await _firestore.collection('rooms').doc(roomId).collection('messages').add(
      {
        'text': text.trim(),
        'sender': sender,
        'timestamp': FieldValue.serverTimestamp(),
      },
    );
  }

  // Get real-time messages
  Stream<List<Message>> getMessages(String roomId) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Message.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  // Update message
  Future<void> updateMessage(
    String roomId,
    String messageId,
    String newText,
  ) async {
    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(messageId)
        .update({'text': newText.trim()});
  }

  // Delete message
  Future<void> deleteMessage(String roomId, String messageId) async {
    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }
}
