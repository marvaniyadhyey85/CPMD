import 'package:flutter/material.dart';

import '../models/quote.dart';
import '../services/quote_service.dart';
import '../widgets/quote_card.dart';
import 'favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final QuoteService quoteService = QuoteService();

  late Future<Quote> quoteFuture;

  String selectedCategory = 'all';

 final List<String> categories = [
  'all',
  'success',
  'inspirational',
  'life',
  'education',
];

  final List<Quote> favoriteQuotes = [];

  @override
  void initState() {
    super.initState();

    quoteFuture = quoteService.fetchQuote(
      selectedCategory,
    );
  }

  // Fetch another quote
  void fetchNewQuote() {
    setState(() {
      quoteFuture = quoteService.fetchQuote(
        selectedCategory,
      );
    });
  }

  // Change category
  void changeCategory(String? category) {

    if (category == null) {
      return;
    }

    setState(() {
      selectedCategory = category;

      quoteFuture = quoteService.fetchQuote(
        selectedCategory,
      );
    });
  }

  // Add or remove favorite
  void toggleFavorite(Quote quote) {

    final index = favoriteQuotes.indexWhere(
      (item) => item.text == quote.text,
    );

    setState(() {

      if (index >= 0) {
        favoriteQuotes.removeAt(index);
      } else {
        favoriteQuotes.add(quote);
      }

    });
  }

  // Check favorite
  bool isFavorite(Quote quote) {

    return favoriteQuotes.any(
      (item) => item.text == quote.text,
    );
  }

  // Open favorite screen
  void openFavorites() {

    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) => FavoriteScreen(
          favoriteQuotes: favoriteQuotes,

          onRemove: (quote) {

            setState(() {
              favoriteQuotes.removeWhere(
                (item) => item.text == quote.text,
              );
            });

          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Quote App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        actions: [

          IconButton(
            onPressed: openFavorites,

            icon: const Icon(
              Icons.favorite,
            ),
          ),

        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // Category title
            const Align(
              alignment: Alignment.centerLeft,

              child: Text(
                'Select Category',

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Category Dropdown
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 15,
              ),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(12),
              ),

              child: DropdownButton<String>(

                value: selectedCategory,

                isExpanded: true,

                underline: const SizedBox(),

                items: categories.map(
                  (category) {

                    return DropdownMenuItem(
                      value: category,

                      child: Text(
                        category.toUpperCase(),
                      ),
                    );

                  },
                ).toList(),

                onChanged: changeCategory,
              ),
            ),

            const SizedBox(height: 25),

            // FutureBuilder
            Expanded(

              child: FutureBuilder<Quote>(

                future: quoteFuture,

                builder: (
                  context,
                  snapshot,
                ) {

                  // -------------------------
                  // LOADING STATE
                  // -------------------------

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {

                    return const Center(

                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [

                          CircularProgressIndicator(),

                          SizedBox(height: 15),

                          Text(
                            'Loading quote...',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),

                        ],
                      ),
                    );
                  }

                  // -------------------------
                  // ERROR STATE
                  // -------------------------

                  if (snapshot.hasError) {

                    return Center(

                      child: Column(

                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [

                          const Icon(
                            Icons.error_outline,
                            size: 70,
                            color: Colors.red,
                          ),

                          const SizedBox(height: 15),

                          const Text(
                            'Something went wrong!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton.icon(

                            onPressed:
                                fetchNewQuote,

                            icon: const Icon(
                              Icons.refresh,
                            ),

                            label: const Text(
                              'Try Again',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // -------------------------
                  // EMPTY STATE
                  // -------------------------

                  if (!snapshot.hasData ||
                      snapshot.data!.text.isEmpty) {

                    return const Center(

                      child: Text(
                        'No quote available.',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    );
                  }

                  // -------------------------
                  // SUCCESS STATE
                  // -------------------------

                  final quote = snapshot.data!;

                  return Column(

                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      QuoteCard(

                        quote: quote,

                        isFavorite:
                            isFavorite(quote),

                        onFavorite: () {
                          toggleFavorite(quote);
                        },
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 55,

                        child: ElevatedButton.icon(

                          onPressed:
                              fetchNewQuote,

                          icon: const Icon(
                            Icons.refresh,
                          ),

                          label: const Text(
                            'Get Another Quote',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}