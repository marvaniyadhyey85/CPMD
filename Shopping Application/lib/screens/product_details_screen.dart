import 'package:flutter/material.dart';

import '../modles/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(title: const Text("Product Details")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  product.image,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 120, color: Color(0xFF0F766E)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              product.name,

              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "Category: ${product.category}",

              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),

            Text(
              "Price: ₹ ${product.price}",
              style: const TextStyle(
                fontSize: 22,
                color: Color(0xFF0F766E),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(product.description, style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  // PASS PRODUCT TO CART

                  Navigator.pushNamed(context, '/cart', arguments: product);
                },

                child: const Text("Add To Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
