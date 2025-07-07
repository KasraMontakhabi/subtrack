import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../theme/app_colors.dart';

class TrialCard extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback? onCancel;
  final VoidCallback? onConvertToPaid;

  const TrialCard({
    super.key,
    required this.subscription,
    this.onCancel,
    this.onConvertToPaid,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysLeft = subscription.daysUntilTrialEnd;
    final isUrgent = daysLeft <= 3;
    final categoryColor = AppColors.getCategoryColor(subscription.category);
    
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUrgent 
                ? AppColors.errorLight.withOpacity(0.3)
                : AppColors.trialColor.withOpacity(0.3),
            width: isUrgent ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: categoryColor.withOpacity(0.2),
                      ),
                    ),
                    child: Icon(
                      _getCategoryIcon(subscription.category),
                      color: categoryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                subscription.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.trialColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.trialColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                'FREE TRIAL',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.trialColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subscription.category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: categoryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Trial Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUrgent 
                      ? AppColors.errorLight.withOpacity(0.05)
                      : AppColors.trialColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isUrgent 
                        ? AppColors.errorLight.withOpacity(0.2)
                        : AppColors.trialColor.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isUrgent ? Icons.warning_amber : Icons.schedule,
                      size: 20,
                      color: isUrgent ? AppColors.errorLight : AppColors.trialColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trial ends ${_formatDate(subscription.trialEndDate!)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _getCountdownText(daysLeft),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isUrgent 
                                  ? AppColors.errorLight 
                                  : AppColors.trialColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Notes
              if (subscription.notes.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  subscription.notes,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              const SizedBox(height: 16),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onCancel,
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                        side: BorderSide(color: theme.colorScheme.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onConvertToPaid,
                      icon: const Icon(Icons.upgrade, size: 18),
                      label: const Text('Convert'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryLight,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'entertainment':
        return Icons.movie;
      case 'productivity':
        return Icons.work;
      case 'health':
        return Icons.favorite;
      case 'education':
        return Icons.school;
      case 'business':
        return Icons.business;
      case 'lifestyle':
        return Icons.people_alt;
      default:
        return Icons.apps;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    
    if (targetDate == today) {
      return 'today';
    } else if (targetDate == today.add(const Duration(days: 1))) {
      return 'tomorrow';
    } else {
      return 'on ${date.day}/${date.month}/${date.year}';
    }
  }

  String _getCountdownText(int daysLeft) {
    if (daysLeft == 0) {
      return 'Expires today!';
    } else if (daysLeft == 1) {
      return '1 day left';
    } else {
      return '$daysLeft days left';
    }
  }
}