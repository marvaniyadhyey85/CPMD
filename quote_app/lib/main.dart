import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const QuoteApp());
}

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quote App',

      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),

      home: const HomeScreen(),
    );
  }
}