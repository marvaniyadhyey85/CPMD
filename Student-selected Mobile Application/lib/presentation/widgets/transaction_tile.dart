import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/category_model.dart';
import '../../data/models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final category = CategoryModel.getById(transaction.category);
    final isIncome = transaction.type == TransactionType.income;

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.expense,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (_) {
        if (onDelete != null) onDelete!();
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Category Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                // Title and Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            CurrencyFormatter.formatDate(transaction.date),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                          if (transaction.receiptImagePath != null) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.attachment_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                          ],
                          if (!transaction.isSynced) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.cloud_off_rounded,
                              size: 14,
                              color: Colors.orange,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Amount
                Text(
                  '${isIncome ? '+' : '-'}${CurrencyFormatter.format(transaction.amount)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isIncome ? AppColors.income : AppColors.expense,
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
