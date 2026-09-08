import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction.dart';

class StorageService {
  static const String key = 'transactions';

  // SAVE TRANSACTIONS
  static Future<void> saveTransactions(List<Transaction> transactions) async {
    final prefs = SharedPreferencesAsync();

    String data = jsonEncode(transactions.map((e) => e.toJson()).toList());

    await prefs.setString(key, data);
  }

  // LOAD TRANSACTIONS
  static Future<List<Transaction>> loadTransactions() async {
    final prefs = SharedPreferencesAsync();

    String? data = await prefs.getString(key);

    if (data == null || data.isEmpty) {
      return [];
    }

    try {
      List<dynamic> jsonData = jsonDecode(data);

      return jsonData
          .map((e) => Transaction.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // DELETE ALL TRANSACTIONS
  static Future<void> clearTransactions() async {
    final prefs = SharedPreferencesAsync();

    await prefs.remove(key);
  }
}
