import 'package:flutter/material.dart';

import '../models/message.dart';
import '../services/chat_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ChatRoomScreen extends StatefulWidget {
  final String roomId;

  const ChatRoomScreen({super.key, required this.roomId});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ChatService _chatService = ChatService();

  final TextEditingController _messageController = TextEditingController();

  final TextEditingController _searchController = TextEditingController();

  String username = 'Dhyey';

  String searchText = '';

  @override
  void dispose() {
    _messageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Send message
  void sendMessage() async {
    await _chatService.sendMessage(
      widget.roomId,
      _messageController.text,
      username,
    );

    _messageController.clear();
  }

  // Edit message
  void editMessage(Message message) {
    TextEditingController editController = TextEditingController(
      text: message.text,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Message'),

          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: 'Enter new message'),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                await _chatService.updateMessage(
                  widget.roomId,
                  message.id,
                  editController.text,
                );

                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Delete message
  void deleteMessage(Message message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Message'),

          content: const Text('Are you sure you want to delete this message?'),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                await _chatService.deleteMessage(widget.roomId, message.id);

                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.roomId.toUpperCase())),

      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,

              decoration: InputDecoration(
                hintText: 'Search messages...',

                prefixIcon: const Icon(Icons.search),

                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),

                  onPressed: () {
                    _searchController.clear();

                    setState(() {
                      searchText = '';
                    });
                  },
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),

          // Messages
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatService.getMessages(widget.roomId),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                List<Message> messages = snapshot.data ?? [];

                // Search filter
                if (searchText.isNotEmpty) {
                  messages = messages.where((message) {
                    return message.text.toLowerCase().contains(searchText);
                  }).toList();
                }

                if (messages.isEmpty) {
                  return const Center(child: Text('No messages found'));
                }

                return ListView.builder(
                  itemCount: messages.length,

                  itemBuilder: (context, index) {
                    Message message = messages[index];

                    bool isMe = message.sender == username;

                    return MessageBubble(
                      message: message,
                      isMe: isMe,

                      onEdit: () {
                        editMessage(message);
                      },

                      onDelete: () {
                        deleteMessage(message);
                      },
                    );
                  },
                );
              },
            ),
          ),

          // Message input
          MessageInput(controller: _messageController, onSend: sendMessage),
        ],
      ),
    );
  }
}
