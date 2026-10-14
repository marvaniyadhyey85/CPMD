import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart' show usdToInr;

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.cart.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: cart.cart.values.map((product) {
                    return ListTile(
                      leading: Image.network(
                        product.image,
                        width: 50,
                        errorBuilder: (_, _, _) =>
                            const Icon(Icons.image),
                      ),
                      title: Text(product.title),
                      subtitle: Text(
                        '₹${(product.price * usdToInr).toStringAsFixed(2)}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          cart.removeFromCart(product.id);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Quantity: ${cart.quantity}'),
                    Text(
                      'Subtotal: ₹${(cart.subtotal * usdToInr).toStringAsFixed(2)}',
                    ),
                    Text(
                      'Total: ₹${(cart.total * usdToInr).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}