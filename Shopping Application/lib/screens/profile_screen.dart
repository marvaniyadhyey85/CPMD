import 'package:flutter/material.dart';

class ProfileScreen
    extends StatelessWidget {

  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title:
            const Text(
          "Profile",
        ),

      ),


      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Color(0xFFCCFBF1),
              child: Icon(
                Icons.person,
                size: 65,
                color: Color(0xFF0F766E),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Shopping User",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "user@gmail.com",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}