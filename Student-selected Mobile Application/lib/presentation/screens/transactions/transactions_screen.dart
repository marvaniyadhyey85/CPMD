import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spendwise_app/core/constants/app_colors.dart';
import 'package:spendwise_app/data/models/category_model.dart';
import 'package:spendwise_app/data/models/transaction_model.dart';
import 'package:spendwise_app/presentation/providers/expense_provider.dart';
import 'package:spendwise_app/presentation/providers/filter_provider.dart';
import 'package:spendwise_app/presentation/widgets/transaction_tile.dart';
import 'package:spendwise_app/presentation/widgets/state_views.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer<FilterProvider>(
          builder: (context, filter, _) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Multi-Condition Filter',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            filter.resetFilters();
                            _searchController.clear();
                          },
                          child: const Text('Reset All'),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 10),

                    // Condition 1: Transaction Type
                    const Text(
                      'Transaction Type',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('All'),
                          selected: filter.selectedType == null,
                          onSelected: (_) => filter.setType(null),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Expenses Only'),
                          selected:
                              filter.selectedType == TransactionType.expense,
                          onSelected: (_) =>
                              filter.setType(TransactionType.expense),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Income Only'),
                          selected:
                              filter.selectedType == TransactionType.income,
                          onSelected: (_) =>
                              filter.setType(TransactionType.income),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Condition 2: Category
                    const Text(
                      'Category',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: CategoryModel.defaultCategories.map((cat) {
                        final isSelected = filter.selectedCategory == cat.id;
                        return FilterChip(
                          label: Text(cat.name),
                          selected: isSelected,
                          avatar: Icon(cat.icon, size: 16, color: cat.color),
                          onSelected: (val) {
                            filter.setCategory(val ? cat.id : null);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Condition 3: Date Range Picker
                    const Text(
                      'Date Range',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.date_range_rounded),
                      label: Text(
                        filter.selectedDateRange == null
                            ? 'Select Date Range'
                            : '${filter.selectedDateRange!.start.toLocal().toString().split(' ')[0]} - ${filter.selectedDateRange!.end.toLocal().toString().split(' ')[0]}',
                      ),
                      onPressed: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          initialDateRange: filter.selectedDateRange,
                        );
                        if (picked != null) {
                          filter.setDateRange(picked);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Apply Filters'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final filter = Provider.of<FilterProvider>(context);

    final filteredList = filter.applyFilter(expenseProvider.transactions);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        actions: [
          IconButton(
            tooltip: 'Filter',
            icon: Badge(
              isLabelVisible: filter.hasActiveFilters,
              child: const Icon(Icons.filter_list_rounded),
            ),
            onPressed: () => _showFilterModal(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by title, note, or category...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          filter.setSearchQuery('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (val) => filter.setSearchQuery(val),
            ),
          ),

          // Active filter indicator chip bar
          if (filter.hasActiveFilters)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  const Text(
                    'Filters Active',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      filter.resetFilters();
                      _searchController.clear();
                    },
                    child: const Text(
                      'Clear',
                      style: TextStyle(fontSize: 12, color: AppColors.expense),
                    ),
                  ),
                ],
              ),
            ),

          // Transactions List or Empty State
          Expanded(
            child: filteredList.isEmpty
                ? StateViews.empty(
                    title: 'No Matching Records',
                    subtitle: filter.hasActiveFilters
                        ? 'Try clearing some search or filter conditions.'
                        : 'No transactions found in your records.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final tx = filteredList[index];
                      return TransactionTile(
                        transaction: tx,
                        onTap: () => context.push('/manage', extra: tx),
                        onDelete: () =>
                            expenseProvider.deleteTransaction(tx.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
