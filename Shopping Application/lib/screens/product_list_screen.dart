import 'package:flutter/material.dart';

import '../modles/product.dart';

class ProductListScreen extends StatelessWidget {
  final String? category;

  const ProductListScreen({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    List<Product> products = [
      Product(
        name: "Smart Phone",
        category: "Electronics",
        price: 20000,
        description:
            "Latest Android Smart Phone with OLED display and high-res camera",
        image:
            "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500",
      ),
      Product(
        name: "Laptop",
        category: "Electronics",
        price: 50000,
        description:
            "High performance laptop with ultra-fast processor and sleek design",
        image:
            "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500",
      ),
      Product(
        name: "Wireless Headphones",
        category: "Electronics",
        price: 3500,
        description:
            "Comfortable noise-cancelling headphones with clear wireless sound",
        image:
            "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500",
      ),
      Product(
        name: "Smart Watch",
        category: "Electronics",
        price: 6500,
        description:
            "Fitness-focused smartwatch with heart-rate tracking and notifications",
        image:
            "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500",
      ),
      Product(
        name: "Sports Shoes",
        category: "Shoes",
        price: 2500,
        description:
            "Lightweight cushioned Sports Shoes for running & athletic training",
        image:
            "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500",
      ),
      Product(
        name: "Casual Sneakers",
        category: "Shoes",
        price: 3200,
        description: "Versatile everyday sneakers with a durable rubber sole",
        image:
            "https://images.unsplash.com/photo-1549298916-b41d501d3772?w=500",
      ),
    ];

    if (category != null) {
      products = products.where((product) {
        return product.category == category;
      }).toList();
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        Product product = products[index];

        return GestureDetector(
          // TAP GESTURE
          onTap: () {
            Navigator.pushNamed(context, '/details', arguments: product);
          },

          // LONG PRESS GESTURE
          onLongPress: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("${product.name} selected")));
          },

          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.image,
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.shopping_bag,
                    size: 40,
                    color: Color(0xFF0F766E),
                  ),
                ),
              ),
              title: Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                "₹ ${product.price}",
                style: const TextStyle(
                  color: Color(0xFF0F766E),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Color(0xFF0F766E),
              ),
            ),
          ),
        );
      },
    );
  }
}
