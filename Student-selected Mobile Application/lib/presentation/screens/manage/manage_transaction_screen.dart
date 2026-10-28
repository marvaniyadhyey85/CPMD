import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:spendwise_app/core/constants/app_colors.dart';
import 'package:spendwise_app/core/utils/formatters.dart';
import 'package:spendwise_app/core/utils/validators.dart';
import 'package:spendwise_app/data/models/category_model.dart';
import 'package:spendwise_app/data/models/transaction_model.dart';
import 'package:spendwise_app/presentation/providers/expense_provider.dart';
import 'package:spendwise_app/presentation/widgets/custom_button.dart';
import 'package:spendwise_app/presentation/widgets/custom_text_field.dart';

class ManageTransactionScreen extends StatefulWidget {
  final TransactionModel? initialTransaction;

  const ManageTransactionScreen({super.key, this.initialTransaction});

  @override
  State<ManageTransactionScreen> createState() =>
      _ManageTransactionScreenState();
}

class _ManageTransactionScreenState extends State<ManageTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;

  late TransactionType _type;
  late String _selectedCategory;
  late DateTime _selectedDate;
  String? _receiptImagePath;
  bool _isSaving = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final tx = widget.initialTransaction;
    _titleController = TextEditingController(text: tx?.title ?? '');
    _amountController = TextEditingController(
      text: tx != null ? tx.amount.toStringAsFixed(2) : '',
    );
    _noteController = TextEditingController(text: tx?.note ?? '');
    _type = tx?.type ?? TransactionType.expense;
    _selectedCategory = tx?.category ?? 'food';
    _selectedDate = tx?.date ?? DateTime.now();
    _receiptImagePath = tx?.receiptImagePath;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickReceiptImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _receiptImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final amount = double.parse(_amountController.text.replaceAll(',', ''));
    final isEditing = widget.initialTransaction != null;

    final tx = TransactionModel(
      id: isEditing ? widget.initialTransaction!.id : const Uuid().v4(),
      title: _titleController.text.trim(),
      amount: amount,
      type: _type,
      category: _selectedCategory,
      date: _selectedDate,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      receiptImagePath: _receiptImagePath,
      isSynced: false,
    );

    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);

    bool success;
    if (isEditing) {
      success = await expenseProvider.updateTransaction(tx);
    } else {
      success = await expenseProvider.addTransaction(tx);
    }

    setState(() => _isSaving = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialTransaction != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Transaction' : 'New Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Income / Expense Segment Switcher
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _type = TransactionType.expense),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _type == TransactionType.expense
                                ? AppColors.expense
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Expense',
                            style: TextStyle(
                              color: _type == TransactionType.expense
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _type = TransactionType.income),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _type == TransactionType.income
                                ? AppColors.income
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Income',
                            style: TextStyle(
                              color: _type == TransactionType.income
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Title Field
              CustomTextField(
                controller: _titleController,
                label: 'Title',
                hint: 'e.g. Grocery shopping, Salary',
                prefixIcon: Icons.title_rounded,
                validator: (val) =>
                    AppValidators.validateRequired(val, 'Title'),
              ),
              const SizedBox(height: 16),

              // Amount Field
              CustomTextField(
                controller: _amountController,
                label: 'Amount (₹)',
                hint: '0.00',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: Icons.currency_rupee_rounded,
                validator: AppValidators.validateAmount,
              ),
              const SizedBox(height: 16),

              // Category Selector
              const Text(
                'Category',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CategoryModel.defaultCategories.map((cat) {
                  final isSelected = _selectedCategory == cat.id;
                  return ChoiceChip(
                    label: Text(cat.name),
                    selected: isSelected,
                    selectedColor: cat.color.withValues(alpha: 0.2),
                    avatar: Icon(
                      cat.icon,
                      size: 16,
                      color: isSelected ? cat.color : Colors.grey,
                    ),
                    onSelected: (_) {
                      setState(() => _selectedCategory = cat.id);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Date Picker
              const Text(
                'Date',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded,
                          color: Colors.grey),
                      const SizedBox(width: 12),
                      Text(
                        CurrencyFormatter.formatDate(_selectedDate),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Receipt Image Picker (Native Device Feature)
              const Text(
                'Receipt / Attachment (Device Feature)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              if (_receiptImagePath != null) ...[
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_receiptImagePath!),
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 100,
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Text('Image preview not available'),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 14,
                        child: Icon(Icons.close, size: 16, color: Colors.red),
                      ),
                      onPressed: () => setState(() => _receiptImagePath = null),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ] else ...[
                OutlinedButton.icon(
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Pick Receipt from Gallery'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _pickReceiptImage,
                ),
                const SizedBox(height: 16),
              ],

              // Note Field
              CustomTextField(
                controller: _noteController,
                label: 'Note (Optional)',
                hint: 'Add additional details or remarks',
                prefixIcon: Icons.notes_rounded,
                maxLines: 2,
              ),
              const SizedBox(height: 28),

              // Save Action Button
              CustomButton(
                text: isEditing ? 'Update Transaction' : 'Save Transaction',
                icon: Icons.check_rounded,
                isLoading: _isSaving,
                onPressed: _saveTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
