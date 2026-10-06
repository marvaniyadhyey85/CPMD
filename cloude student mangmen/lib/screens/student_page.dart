import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Interface'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 55,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              user?.displayName ?? 'Student',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              user?.email ?? '',
              style: const TextStyle(
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 30),

            const Card(
              child: ListTile(
                leading: Icon(Icons.school),
                title: Text('Student Dashboard'),
                subtitle: Text(
                  'View your student information',
                ),
              ),
            ),

            const Card(
              child: ListTile(
                leading: Icon(Icons.menu_book),
                title: Text('Course'),
                subtitle: Text(
                  'View your course information',
                ),
              ),
            ),

            const Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                subtitle: Text(
                  'Manage your profile',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
