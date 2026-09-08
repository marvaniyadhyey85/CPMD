import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final Transaction? transaction;
  final Function(Transaction) onSave;

  const TransactionForm({super.key, this.transaction, required this.onSave});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  String type = 'expense';
  String category = 'Food';

  DateTime selectedDate = DateTime.now();

  final expenseCategories = [
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Entertainment',
    'Medical',
    'Education',
    'Other',
  ];

  final incomeCategories = [
    'Salary',
    'Business',
    'Freelance',
    'Investment',
    'Gift',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      amountController.text = widget.transaction!.amount.toString();

      descriptionController.text = widget.transaction!.description;

      type = widget.transaction!.type;

      category = widget.transaction!.category;

      selectedDate = widget.transaction!.date;
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void saveForm() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    Transaction transaction = Transaction(
      id:
          widget.transaction?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),

      amount: double.parse(amountController.text),

      category: category,

      description: descriptionController.text,

      date: selectedDate,

      type: type,
    );

    widget.onSave(transaction);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = type == 'expense'
        ? expenseCategories
        : incomeCategories;

    if (!categories.contains(category)) {
      category = categories.first;
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),

      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),

          child: Form(
            key: formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      widget.transaction == null
                          ? 'Add Transaction'
                          : 'Edit Transaction',

                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Income / Expense
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'expense',
                      label: Text('Expense'),
                      icon: Icon(Icons.arrow_upward),
                    ),

                    ButtonSegment(
                      value: 'income',
                      label: Text('Income'),
                      icon: Icon(Icons.arrow_downward),
                    ),
                  ],

                  selected: {type},

                  onSelectionChanged: (value) {
                    setState(() {
                      type = value.first;

                      category = type == 'expense'
                          ? expenseCategories.first
                          : incomeCategories.first;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Amount
                TextFormField(
                  controller: amountController,

                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),

                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '₹ ',
                    prefixIcon: Icon(Icons.currency_rupee),
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter amount';
                    }

                    if (double.tryParse(value) == null) {
                      return 'Enter valid amount';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // Category
                DropdownButtonFormField<String>(
                  initialValue: category,

                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),

                  items: categories.map((item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),

                  onChanged: (value) {
                    setState(() {
                      category = value!;
                    });
                  },
                ),

                const SizedBox(height: 15),

                // Description
                TextFormField(
                  controller: descriptionController,

                  maxLines: 3,

                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter description',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                // Date
                InkWell(
                  onTap: selectDate,

                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(Icons.calendar_month),
                      border: OutlineInputBorder(),
                    ),

                    child: Text(
                      '${selectedDate.day}/'
                      '${selectedDate.month}/'
                      '${selectedDate.year}',
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton.icon(
                    onPressed: saveForm,

                    icon: const Icon(Icons.save),

                    label: Text(
                      widget.transaction == null
                          ? 'Add Transaction'
                          : 'Update Transaction',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
