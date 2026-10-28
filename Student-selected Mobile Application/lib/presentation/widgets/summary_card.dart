import 'package:flutter/material.dart';
import 'package:spendwise_app/core/constants/app_colors.dart';
import 'package:spendwise_app/core/utils/formatters.dart';

class SummaryCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;
  final bool isOffline;
  final VoidCallback? onSyncTap;

  const SummaryCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
    this.isOffline = false,
    this.onSyncTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Offline/Online Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Net Balance',
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: onSyncTap,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOffline
                        ? Colors.orange.shade50
                        : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isOffline
                          ? Colors.orange.shade200
                          : AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isOffline
                            ? Icons.cloud_off_rounded
                            : Icons.cloud_done_rounded,
                        size: 14,
                        color: isOffline ? Colors.orange : AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isOffline ? 'Offline' : 'Online Sync',
                        style: TextStyle(
                          color: isOffline
                              ? Colors.orange.shade800
                              : AppColors.primaryDark,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Clean Bold Balance in Dark Slate on Light Surface
          Text(
            CurrencyFormatter.format(balance),
            style: const TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: 34,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 20),
          // Income & Expense Quick Metrics (Light pill cards)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.income.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_downward_rounded,
                          color: AppColors.income,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Income',
                              style: TextStyle(
                                color: AppColors.textSecondaryLight,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(income),
                              style: const TextStyle(
                                color: AppColors.income,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2), // Soft Rose light tint
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.expense.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          color: AppColors.expense,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Expense',
                              style: TextStyle(
                                color: AppColors.textSecondaryLight,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(expense),
                              style: const TextStyle(
                                color: AppColors.expense,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
