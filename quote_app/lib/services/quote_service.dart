import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuoteService {
  static const String apiUrl =
      'https://api.api-ninjas.com/v1/quotes';

  static const String apiKey = '9FZNJlirdtHsPIUn5yG13mykth7GcA4lWqrxeBJk';

  Future<Quote> fetchQuote(String category) async {
    final String cleanCategory = category.trim().toLowerCase();
    Uri url;

    if (cleanCategory.isEmpty || cleanCategory == 'all') {
      url = Uri.parse(apiUrl);
    } else {
      url = Uri.parse('$apiUrl?category=$cleanCategory');
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'X-Api-Key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          return Quote.fromJson(data[0]);
        } else if (data is Map<String, dynamic>) {
          return Quote.fromJson(data);
        } else {
          throw Exception('No quote found');
        }
      }

      // API Ninjas category query requires premium plan.
      // Fallback to fetching random quote without category param.
      if (response.statusCode == 400 && cleanCategory != 'all') {
        final fallbackResponse = await http.get(
          Uri.parse(apiUrl),
          headers: {'X-Api-Key': apiKey},
        );

        if (fallbackResponse.statusCode == 200) {
          final data = jsonDecode(fallbackResponse.body);
          if (data is List && data.isNotEmpty) {
            return Quote.fromJson(data[0]);
          }
        }
      }

      return await _fetchFallbackQuote();
    } catch (e) {
      try {
        return await _fetchFallbackQuote();
      } catch (_) {
        throw Exception(
          'Unable to load quote. Check your internet connection.',
        );
      }
    }
  }

  Future<Quote> _fetchFallbackQuote() async {
    final response = await http.get(
      Uri.parse('https://zenquotes.io/api/random'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        return Quote.fromJson(data[0]);
      }
    }

    throw Exception('Failed to load quote');
  }
}