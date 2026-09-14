import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Shopping App",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
          primary: const Color(0xFF0F766E),
          secondary: const Color(0xFF10B981),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F766E),
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Color(0xFFCCFBF1),
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 3,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F766E),
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF0F766E),
          unselectedItemColor: Color(0xFF64748B),
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          elevation: 8,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/products': (context) => const ProductListScreen(),
        '/details': (context) => const ProductDetailsScreen(),
        '/cart': (context) => const CartScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
