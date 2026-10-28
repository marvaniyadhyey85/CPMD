import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';

class FilterProvider extends ChangeNotifier {
  String _searchQuery = '';
  String? _selectedCategory;
  TransactionType? _selectedType;
  DateTimeRange? _selectedDateRange;
  double? _minAmount;
  double? _maxAmount;

  // Getters
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  TransactionType? get selectedType => _selectedType;
  DateTimeRange? get selectedDateRange => _selectedDateRange;
  double? get minAmount => _minAmount;
  double? get maxAmount => _maxAmount;

  bool get hasActiveFilters =>
      _searchQuery.isNotEmpty ||
      _selectedCategory != null ||
      _selectedType != null ||
      _selectedDateRange != null ||
      _minAmount != null ||
      _maxAmount != null;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setType(TransactionType? type) {
    _selectedType = type;
    notifyListeners();
  }

  void setDateRange(DateTimeRange? range) {
    _selectedDateRange = range;
    notifyListeners();
  }

  void setAmountRange(double? min, double? max) {
    _minAmount = min;
    _maxAmount = max;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _selectedType = null;
    _selectedDateRange = null;
    _minAmount = null;
    _maxAmount = null;
    notifyListeners();
  }

  /// Evaluates transactions across multiple conditions
  List<TransactionModel> applyFilter(List<TransactionModel> items) {
    return items.where((tx) {
      // 1. Text Query Filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = tx.title.toLowerCase().contains(q);
        final matchesNote = (tx.note ?? '').toLowerCase().contains(q);
        final matchesCategory = tx.category.toLowerCase().contains(q);
        if (!matchesTitle && !matchesNote && !matchesCategory) return false;
      }

      // 2. Type Filter (Income / Expense)
      if (_selectedType != null && tx.type != _selectedType) {
        return false;
      }

      // 3. Category Filter
      if (_selectedCategory != null && tx.category != _selectedCategory) {
        return false;
      }

      // 4. Date Range Filter
      if (_selectedDateRange != null) {
        final start = DateTime(
          _selectedDateRange!.start.year,
          _selectedDateRange!.start.month,
          _selectedDateRange!.start.day,
        );
        final end = DateTime(
          _selectedDateRange!.end.year,
          _selectedDateRange!.end.month,
          _selectedDateRange!.end.day,
          23,
          59,
          59,
        );
        if (tx.date.isBefore(start) || tx.date.isAfter(end)) {
          return false;
        }
      }

      // 5. Min Amount Filter
      if (_minAmount != null && tx.amount < _minAmount!) {
        return false;
      }

      // 6. Max Amount Filter
      if (_maxAmount != null && tx.amount > _maxAmount!) {
        return false;
      }

      return true;
    }).toList();
  }
}
