import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF0F766E),
            ),
            accountName: const Text("Shopping User", style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: const Text("user@gmail.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF0F766E)),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),

            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),

          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text("Products"),

            onTap: () {
              Navigator.pushNamed(context, '/products');
            },
          ),

          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text("Cart"),

            onTap: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),

            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
    );
  }
}
