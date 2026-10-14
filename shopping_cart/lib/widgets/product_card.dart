import 'package:flutter/material.dart';
import '../models/product.dart';

const double usdToInr = 84.0;

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;
  final VoidCallback onWishlist;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
    required this.onWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              product.image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stack) {
                return const Icon(Icons.image_not_supported);
              },
            ),
          ),
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text('₹${(product.price * usdToInr).toStringAsFixed(2)}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onWishlist,
                icon: const Icon(Icons.favorite_border),
              ),
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_shopping_cart),
              ),
            ],
          ),
        ],
      ),
    );
  }
}