import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PersonalExpenseApp());
}

class PersonalExpenseApp extends StatelessWidget {
  const PersonalExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Personal Expense Manager',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),

      home: const HomeScreen(),
    );
  }
}