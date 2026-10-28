import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  static const List<CategoryModel> defaultCategories = [
    CategoryModel(
      id: 'food',
      name: 'Food & Dining',
      icon: Icons.fastfood_rounded,
      color: Colors.orange,
    ),
    CategoryModel(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag_rounded,
      color: Colors.pink,
    ),
    CategoryModel(
      id: 'transport',
      name: 'Transportation',
      icon: Icons.directions_car_rounded,
      color: Colors.blue,
    ),
    CategoryModel(
      id: 'bills',
      name: 'Bills & Utilities',
      icon: Icons.receipt_long_rounded,
      color: Colors.amber,
    ),
    CategoryModel(
      id: 'entertainment',
      name: 'Entertainment',
      icon: Icons.movie_rounded,
      color: Colors.purple,
    ),
    CategoryModel(
      id: 'salary',
      name: 'Salary',
      icon: Icons.account_balance_wallet_rounded,
      color: Colors.green,
    ),
    CategoryModel(
      id: 'health',
      name: 'Health & Medical',
      icon: Icons.medical_services_rounded,
      color: Colors.teal,
    ),
    CategoryModel(
      id: 'other',
      name: 'Other',
      icon: Icons.category_rounded,
      color: Colors.blueGrey,
    ),
  ];

  static CategoryModel getById(String id) {
    return defaultCategories.firstWhere(
      (c) => c.id == id,
      orElse: () => defaultCategories.last,
    );
  }
}
