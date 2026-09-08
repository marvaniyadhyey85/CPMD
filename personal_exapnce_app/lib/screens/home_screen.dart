import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../services/storage_service.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_card.dart';
import 'transaction_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Transaction> transactions = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  // LOAD DATA

  Future<void> loadData() async {
    final data =
        await StorageService.loadTransactions();

    setState(() {
      transactions = data;
      isLoading = false;
    });
  }

  // ADD

  void addTransaction(Transaction transaction) {
    setState(() {
      transactions.add(transaction);
    });

    StorageService.saveTransactions(transactions);
  }

  // UPDATE

  void updateTransaction(Transaction transaction) {
    int index = transactions.indexWhere(
      (item) => item.id == transaction.id,
    );

    if (index != -1) {
      setState(() {
        transactions[index] = transaction;
      });

      StorageService.saveTransactions(transactions);
    }
  }

  // DELETE

  void deleteTransaction(String id) {
    setState(() {
      transactions.removeWhere(
        (item) => item.id == id,
      );
    });

    StorageService.saveTransactions(transactions);
  }

  // TOTAL EXPENSE

  double get totalExpense {
    return transactions
        .where((item) => item.type == 'expense')
        .fold(
          0,
          (sum, item) => sum + item.amount,
        );
  }

  // TOTAL INCOME

  double get totalIncome {
    return transactions
        .where((item) => item.type == 'income')
        .fold(
          0,
          (sum, item) => sum + item.amount,
        );
  }

  // BALANCE

  double get balance {
    return totalIncome - totalExpense;
  }

  // OPEN FORM

  void openForm({Transaction? transaction}) {
    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.transparent,

      builder: (context) {
        return TransactionForm(
          transaction: transaction,

          onSave: (newTransaction) {
            if (transaction == null) {
              addTransaction(newTransaction);
            } else {
              updateTransaction(newTransaction);
            }
          },
        );
      },
    );
  }

  // DELETE DIALOG

  void showDeleteDialog(Transaction transaction) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Transaction?',
          ),

          content: const Text(
            'Are you sure you want to delete this transaction?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                deleteTransaction(
                  transaction.id,
                );

                Navigator.pop(context);
              },

              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personal Expense Manager',
        ),

        centerTitle: true,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )

          : Column(
              children: [
                // SUMMARY

                Padding(
                  padding: const EdgeInsets.all(12),

                  child: Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Income',
                          amount: totalIncome,
                          icon: Icons.arrow_downward,
                          color: Colors.green,
                        ),
                      ),

                      Expanded(
                        child: SummaryCard(
                          title: 'Expense',
                          amount: totalExpense,
                          icon: Icons.arrow_upward,
                          color: Colors.red,
                        ),
                      ),

                      Expanded(
                        child: SummaryCard(
                          title: 'Balance',
                          amount: balance,
                          icon: Icons.account_balance_wallet,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),

                // TOTAL EXPENDITURE

                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),

                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(
                        Icons.receipt_long,
                      ),
                    ),

                    title: const Text(
                      'Total Expenditure',
                    ),

                    trailing: Text(
                      '₹${totalExpense.toStringAsFixed(2)}',

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // TITLE

                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  child: Align(
                    alignment: Alignment.centerLeft,

                    child: Text(
                      'All Transactions',

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // LISTVIEW

                Expanded(
                  child: transactions.isEmpty
                      ? const Center(
                          child: Text(
                            'No transactions found',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )

                      : ListView.builder(
                          padding:
                              const EdgeInsets.all(12),

                          itemCount:
                              transactions.length,

                          itemBuilder:
                              (context, index) {
                            final transaction =
                                transactions[index];

                            return TransactionCard(
                              transaction:
                                  transaction,

                              onEdit: () {
                                openForm(
                                  transaction:
                                      transaction,
                                );
                              },

                              onDelete: () {
                                showDeleteDialog(
                                  transaction,
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),

      // ADD BUTTON

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () {
          openForm();
        },

        icon: const Icon(Icons.add),

        label: const Text('Add'),
      ),
    );
  }
}