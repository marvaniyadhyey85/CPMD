import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import 'product_list_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;

  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Application"),

        bottom: selectedIndex == 0
            ? TabBar(
                controller: tabController,
                tabs: const [
                  Tab(text: "Electronics"),

                  Tab(text: "Shoes"),
                ],
              )
            : null,
      ),

      drawer: const AppDrawer(),

      body: selectedIndex == 0
          ? TabBarView(
              controller: tabController,

              children: const [
                ProductListScreen(category: "Electronics"),

                ProductListScreen(category: "Shoes"),
              ],
            )
          : selectedIndex == 1
          ? const Center(
              child: Text("Shopping Cart", style: TextStyle(fontSize: 25)),
            )
          : const ProfileScreen(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,

        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),

            label: "Cart",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
