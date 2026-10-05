import 'package:flutter/material.dart';

import 'chat_room_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> rooms = const ['general', 'flutter', 'college', 'friends'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Rooms'), centerTitle: true),

      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          String room = rooms[index];

          return Card(
            margin: const EdgeInsets.all(8),

            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.chat)),

              title: Text(room.toUpperCase()),

              subtitle: const Text('Join this chat room'),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatRoomScreen(roomId: room),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
