import 'package:flutter/material.dart';

import '../modles/product.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    return Scaffold(
      appBar: AppBar(title: const Text("Shopping Cart")),

      body: arguments is! Product
          ? const Center(
              child: Text("Cart is Empty", style: TextStyle(fontSize: 25)),
            )
          : buildCart(arguments),
    );
  }

  Widget buildCart(Product product) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
                  height: 160,
                  width: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 96, color: Color(0xFF0F766E)),
                ),
              ),

              const SizedBox(height: 15),

              Text(
                product.name,

                style: const TextStyle(
                  fontSize: 25,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "₹ ${product.price}",
                style: const TextStyle(
                  fontSize: 22,
                  color: Color(0xFF0F766E),
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(product.description),
            ],
          ),
        ),
      ),
    );
  }
}
