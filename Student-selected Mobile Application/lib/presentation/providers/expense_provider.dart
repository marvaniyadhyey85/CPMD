import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/expense_repository.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseRepository _repository;

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isOffline = false;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isOffline => _isOffline;

  // Computed summary properties
  double get totalIncome => _transactions
      .where((tx) => tx.type == TransactionType.income)
      .fold(0.0, (sum, tx) => sum + tx.amount);

  double get totalExpense => _transactions
      .where((tx) => tx.type == TransactionType.expense)
      .fold(0.0, (sum, tx) => sum + tx.amount);

  double get netBalance => totalIncome - totalExpense;

  ExpenseProvider({ExpenseRepository? repository})
      : _repository = repository ?? ExpenseRepository() {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _isOffline = !await _repository.isOnline();
      _transactions = await _repository.getTransactions();
    } catch (e) {
      _errorMessage = 'Failed to load transactions: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTransaction(TransactionModel tx) async {
    try {
      final created = await _repository.addTransaction(tx);
      _transactions.insert(0, created);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to save transaction: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTransaction(TransactionModel tx) async {
    try {
      await _repository.updateTransaction(tx);
      final index = _transactions.indexWhere((t) => t.id == tx.id);
      if (index != -1) {
        _transactions[index] = tx;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update transaction: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTransaction(String id) async {
    try {
      await _repository.deleteTransaction(id);
      _transactions.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete transaction: $e';
      notifyListeners();
      return false;
    }
  }

  Future<int> syncPendingData() async {
    final count = await _repository.syncPendingData();
    if (count > 0) {
      await loadTransactions();
    }
    return count;
  }
}
