import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_details.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<Product> products = [
    Product(
      name: 'Smart Watch',
      image: 'https://picsum.photos/id/1/400/400',
      price: 2499,
    ),
    Product(
      name: 'Headphones',
      image: 'https://picsum.photos/id/20/400/400',
      price: 1999,
    ),
    Product(
      name: 'Shoes',
      image: 'https://picsum.photos/id/21/400/400',
      price: 2999,
    ),
    Product(
      name: 'Backpack',
      image: 'https://picsum.photos/id/26/400/400',
      price: 1499,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Products'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: products[index],
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return ProductDetails(
                      product: products[index],
                    );
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;

                    final tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(
                      CurveTween(curve: Curves.easeInOut),
                    );

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}