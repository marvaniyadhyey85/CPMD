import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction_model.dart';

class ApiService {
  // Using JSONPlaceholder / mock REST endpoint
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  /// Simulates syncing a transaction to remote REST cloud
  Future<bool> syncTransaction(TransactionModel transaction) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(transaction.toMap()),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Simulates fetching remote transactions (for cloud backup/restore)
  Future<List<TransactionModel>> fetchRemoteTransactions() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/posts?_limit=2'));
      if (response.statusCode == 200) {
        // Return dummy mock data simulating remote entries
        return [];
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
