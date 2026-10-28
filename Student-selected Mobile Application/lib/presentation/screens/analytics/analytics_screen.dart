import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:spendwise_app/core/constants/app_colors.dart';
import 'package:spendwise_app/core/utils/formatters.dart';
import 'package:spendwise_app/data/models/category_model.dart';
import 'package:spendwise_app/data/models/transaction_model.dart';
import 'package:spendwise_app/presentation/providers/expense_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final expenseTransactions = expenseProvider.transactions
        .where((tx) => tx.type == TransactionType.expense)
        .toList();

    // Group expenses by category
    final Map<String, double> categorySums = {};
    for (final tx in expenseTransactions) {
      categorySums[tx.category] =
          (categorySums[tx.category] ?? 0.0) + tx.amount;
    }

    final totalExpense = expenseProvider.totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spending Analytics'),
      ),
      body: expenseTransactions.isEmpty
          ? const Center(
              child: Text('No expense data available for analytics.'),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Cards Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Net Savings',
                          value: CurrencyFormatter.format(
                            expenseProvider.netBalance,
                          ),
                          color: expenseProvider.netBalance >= 0
                              ? AppColors.income
                              : AppColors.expense,
                          icon: Icons.savings_outlined,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildMetricCard(
                          title: 'Total Expense',
                          value: CurrencyFormatter.format(totalExpense),
                          color: AppColors.expense,
                          icon: Icons.credit_card_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Chart Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Expense Breakdown by Category',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 220,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback: (event, response) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          response == null ||
                                          response.touchedSection == null) {
                                        _touchedIndex = -1;
                                        return;
                                      }
                                      _touchedIndex = response
                                          .touchedSection!
                                          .touchedSectionIndex;
                                    });
                                  },
                                ),
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                                sections: categorySums.entries
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final index = entry.key;
                                  final catEntry = entry.value;
                                  final isTouched = index == _touchedIndex;
                                  final radius = isTouched ? 65.0 : 55.0;
                                  final category =
                                      CategoryModel.getById(catEntry.key);
                                  final pct = totalExpense > 0
                                      ? (catEntry.value / totalExpense * 100)
                                      : 0.0;

                                  return PieChartSectionData(
                                    color: category.color,
                                    value: catEntry.value,
                                    title: '${pct.toStringAsFixed(0)}%',
                                    radius: radius,
                                    titleStyle: TextStyle(
                                      fontSize: isTouched ? 16 : 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Detailed Category Breakdown List
                  const Text(
                    'Category Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...categorySums.entries.map((entry) {
                    final cat = CategoryModel.getById(entry.key);
                    final pct = totalExpense > 0
                        ? (entry.value / totalExpense * 100)
                        : 0.0;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: cat.color.withValues(alpha: 0.15),
                          child: Icon(cat.icon, color: cat.color),
                        ),
                        title: Text(
                          cat.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: pct / 100,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(cat.color),
                            minHeight: 6,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              CurrencyFormatter.format(entry.value),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${pct.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
