import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/dashboard_stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Cards
              _buildStatsSection(context, subscriptionProvider),
              const SizedBox(height: 24),
              
              // Spending Chart
              _buildSpendingChart(context, subscriptionProvider),
              const SizedBox(height: 24),
              
              // Upcoming Payments
              _buildUpcomingPayments(context, subscriptionProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsSection(BuildContext context, SubscriptionProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DashboardStatCard(
                title: 'Monthly Spending',
                value: '\$${provider.monthlySpending.toStringAsFixed(2)}',
                icon: Icons.attach_money,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DashboardStatCard(
                title: 'Total Subscriptions',
                value: '${provider.subscriptions.length}',
                icon: Icons.subscriptions,
                color: AppColors.secondaryLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DashboardStatCard(
                title: 'Free Trials',
                value: '${provider.freeTrialSubscriptions.length}',
                icon: Icons.schedule,
                color: AppColors.trialColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DashboardStatCard(
                title: 'Upcoming Payments',
                value: '${provider.upcomingPayments.length}',
                icon: Icons.payment,
                color: AppColors.entertainmentColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpendingChart(BuildContext context, SubscriptionProvider provider) {
    final categorySpending = provider.categorySpending;
    
    if (categorySpending.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort categories by spending amount for better visualization
    final sortedEntries = categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spending by Category',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Chart selection toggle
                Row(
                  children: [
                    Expanded(
                      child: _buildHorizontalBarChart(context, sortedEntries),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Category breakdown list
                _buildCategoryBreakdown(context, sortedEntries),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalBarChart(BuildContext context, List<MapEntry<String, double>> sortedEntries) {
    final maxValue = sortedEntries.isNotEmpty ? sortedEntries.first.value : 0.0;
    
    return Column(
      children: [
        SizedBox(
          height: math.max(sortedEntries.length * 50.0, 200.0), // Dynamic height based on categories
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedEntries.length,
            itemBuilder: (context, index) {
              final entry = sortedEntries[index];
              final percentage = maxValue > 0 ? (entry.value / maxValue) : 0.0;
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    // Category name
                    SizedBox(
                      width: 120,
                      child: Text(
                        entry.key,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Bar
                    Expanded(
                      child: Container(
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: percentage,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.getCategoryColor(entry.key),
                                  AppColors.getCategoryColor(entry.key).withOpacity(0.8),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Value
                    SizedBox(
                      width: 60,
                      child: Text(
                        '\$${entry.value.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdown(BuildContext context, List<MapEntry<String, double>> sortedEntries) {
    final totalSpending = sortedEntries.fold<double>(0, (sum, entry) => sum + entry.value);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Breakdown',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...sortedEntries.map((entry) {
          final percentage = totalSpending > 0 ? (entry.value / totalSpending * 100) : 0.0;
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.getCategoryColor(entry.key),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.key,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '\$${entry.value.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Monthly Spending',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${totalSpending.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUpcomingPayments(BuildContext context, SubscriptionProvider provider) {
    final upcomingPayments = provider.upcomingPayments;
    
    if (upcomingPayments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Payments',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: upcomingPayments.map((subscription) {
              final isLast = upcomingPayments.indexOf(subscription) == upcomingPayments.length - 1;
              
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.getCategoryColor(subscription.category),
                      child: Text(
                        subscription.title.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(subscription.title),
                    subtitle: Text(
                      '${subscription.daysUntilNextPayment} days left',
                      style: TextStyle(
                        color: subscription.daysUntilNextPayment <= 3 
                            ? AppColors.errorLight 
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    trailing: Text(
                      subscription.formattedPrice,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  if (!isLast) const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
