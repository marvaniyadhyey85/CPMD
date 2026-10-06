import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';
import 'teacher_page.dart';
import 'student_page.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<String> getRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'Student';

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data() as Map<String, dynamic>;
      return data['role'] ?? 'Student';
    }
    return 'Student';
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management System'),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().logout();

              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: getRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading user profile'));
          }

          String role = snapshot.data ?? 'Student';

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                const CircleAvatar(
                  radius: 45,
                  child: Icon(Icons.person, size: 50),
                ),

                const SizedBox(height: 15),

                Text(
                  user?.displayName ?? 'User',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(user?.email ?? '', style: const TextStyle(fontSize: 16)),

                const SizedBox(height: 5),

                Text('Role: $role', style: const TextStyle(fontSize: 18)),

                const SizedBox(height: 30),

                if (role == 'Teacher')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TeacherPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.school),
                      label: const Text('Teacher Interface'),
                    ),
                  ),

                if (role == 'Student')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StudentPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person),
                      label: const Text('Student Interface'),
                    ),
                  ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Update Profile'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
