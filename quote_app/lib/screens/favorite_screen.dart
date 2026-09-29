import 'package:flutter/material.dart';
import '../models/quote.dart';

class FavoriteScreen extends StatefulWidget {

  final List<Quote> favoriteQuotes;

  final Function(Quote) onRemove;

  const FavoriteScreen({
    super.key,
    required this.favoriteQuotes,
    required this.onRemove,
  });

  @override
  State<FavoriteScreen> createState() =>
      _FavoriteScreenState();
}

class _FavoriteScreenState
    extends State<FavoriteScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Favorite Quotes',
        ),

        centerTitle: true,
      ),

      body: widget.favoriteQuotes.isEmpty

          // EMPTY FAVORITE STATE
          ? const Center(

              child: Column(

                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 15),

                  Text(
                    'No favorite quotes yet.',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            )

          // FAVORITE LIST
          : ListView.builder(

              padding:
                  const EdgeInsets.all(15),

              itemCount:
                  widget.favoriteQuotes.length,

              itemBuilder: (context, index) {

                final quote =
                    widget.favoriteQuotes[index];

                return Card(

                  margin:
                      const EdgeInsets.only(
                    bottom: 15,
                  ),

                  elevation: 4,

                  child: Padding(

                    padding:
                        const EdgeInsets.all(18),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Icon(
                          Icons.format_quote,
                          color: Colors.deepPurple,
                          size: 35,
                        ),

                        const SizedBox(height: 10),

                        Text(
                          '"${quote.text}"',

                          style:
                              const TextStyle(
                            fontSize: 18,
                            height: 1.4,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          '- ${quote.author}',

                          style:
                              const TextStyle(
                            color: Colors.grey,
                            fontStyle:
                                FontStyle.italic,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(

                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                          children: [

                            Chip(
                              label: Text(
                                quote.category
                                    .toUpperCase(),
                              ),
                            ),

                            IconButton(

                              onPressed: () {

                                widget.onRemove(
                                  quote,
                                );

                                setState(() {});
                              },

                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}