import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spendwise_app/core/constants/app_colors.dart';
import 'package:spendwise_app/presentation/providers/auth_provider.dart';
import 'package:spendwise_app/presentation/providers/expense_provider.dart';
import 'package:spendwise_app/presentation/providers/theme_provider.dart';
import 'package:spendwise_app/presentation/widgets/summary_card.dart';
import 'package:spendwise_app/presentation/widgets/transaction_tile.dart';
import 'package:spendwise_app/presentation/widgets/state_views.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello,',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              auth.userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return IconButton(
                tooltip: isDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: isDark ? Colors.amber : null,
                ),
                onPressed: () => themeProvider.toggleTheme(),
              );
            },
          ),
          IconButton(
            tooltip: 'Sync offline data',
            icon: const Icon(Icons.sync_rounded),
            onPressed: () async {
              final count = await expenseProvider.syncPendingData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      count > 0
                          ? 'Synced $count transactions to cloud!'
                          : 'All transactions already synced.',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => expenseProvider.loadTransactions(),
        child: expenseProvider.isLoading
            ? StateViews.loading()
            : expenseProvider.errorMessage != null
                ? StateViews.error(
                    message: expenseProvider.errorMessage!,
                    onRetry: () => expenseProvider.loadTransactions(),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dynamic Gradient Summary Card
                        SummaryCard(
                          balance: expenseProvider.netBalance,
                          income: expenseProvider.totalIncome,
                          expense: expenseProvider.totalExpense,
                          isOffline: expenseProvider.isOffline,
                          onSyncTap: () async {
                            final count =
                                await expenseProvider.syncPendingData();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    count > 0
                                        ? 'Successfully synced $count items.'
                                        : 'Up to date with server.',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 24),

                        // Quick Navigation Banner (Analytics shortcut)
                        InkWell(
                          onTap: () => context.go('/analytics'),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.pie_chart_outline_rounded,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'View Financial Analytics',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Text(
                                        'Explore monthly visual charts & breakdown',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Recent Transactions Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recent Activity',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/transactions'),
                              child: const Text('See All'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Recent Transactions List
                        if (expenseProvider.transactions.isEmpty)
                          StateViews.empty(
                            title: 'No recent transactions',
                            subtitle:
                                'Tap the + button below to log your first income or expense.',
                            onAction: () => context.push('/manage'),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                expenseProvider.transactions.take(5).length,
                            itemBuilder: (context, index) {
                              final tx = expenseProvider.transactions[index];
                              return Hero(
                                tag: 'tx_${tx.id}',
                                child: TransactionTile(
                                  transaction: tx,
                                  onTap: () => context.push('/manage', extra: tx),
                                  onDelete: () =>
                                      expenseProvider.deleteTransaction(tx.id),
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 70), // Bottom padding for FAB
                      ],
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Entry'),
        onPressed: () => context.push('/manage'),
      ),
    );
  }
}
