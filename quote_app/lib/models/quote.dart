class Quote {
  final String text;
  final String author;
  final String category;

  Quote({
    required this.text,
    required this.author,
    required this.category,
  });

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        text: json['quote'] ?? json['q'] ?? '',
        author: json['author'] ?? json['a'] ?? 'Unknown',
        category: json['category'] ?? json['c'] ?? 'General',
      );
}

