import 'package:flutter/material.dart';
import '../models/quote.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final bool isFavorite;
  final VoidCallback onFavorite;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.isFavorite,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Padding(
        padding: const EdgeInsets.all(25),

        child: Column(
          children: [

            const Icon(
              Icons.format_quote,
              size: 55,
              color: Colors.deepPurple,
            ),

            const SizedBox(height: 20),

            Text(
              '"${quote.text}"',
              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              '- ${quote.author}',
              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 15),

            Chip(
              label: Text(
                quote.category.toUpperCase(),
              ),
            ),

            const SizedBox(height: 10),

            IconButton(
              onPressed: onFavorite,

              icon: Icon(
                isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,

                color: isFavorite
                    ? Colors.red
                    : Colors.grey,

                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}