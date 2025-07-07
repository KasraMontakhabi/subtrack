import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../widgets/trial_card.dart';
import '../theme/app_colors.dart';

class TrialWatchdogScreen extends StatelessWidget {
  const TrialWatchdogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        final freeTrials = subscriptionProvider.freeTrialSubscriptions;
        final trialsEndingThisWeek = subscriptionProvider.trialsEndingThisWeek;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Banner
              _buildSummaryBanner(context, freeTrials.length, trialsEndingThisWeek.length),
              const SizedBox(height: 24),
              
              // Free Trials List
              _buildTrialsList(context, freeTrials),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryBanner(BuildContext context, int totalTrials, int endingThisWeek) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.trialColor.withOpacity(0.1),
            AppColors.trialColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.trialColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.watch_later_rounded,
                size: 32,
                color: AppColors.trialColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Free Trial Watchdog',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.trialColor,
                      ),
                    ),
                    Text(
                      'Stay on top of your free trials',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Active Trials',
                  totalTrials.toString(),
                  Icons.play_circle_outline,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Ending This Week',
                  endingThisWeek.toString(),
                  Icons.warning_amber_rounded,
                  isUrgent: endingThisWeek > 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    bool isUrgent = false,
  }) {
    final theme = Theme.of(context);
    final color = isUrgent ? AppColors.errorLight : AppColors.trialColor;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTrialsList(BuildContext context, List freeTrials) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Free Trials',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        if (freeTrials.isEmpty)
          _buildEmptyState(context)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: freeTrials.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final trial = freeTrials[index];
              return TrialCard(
                subscription: trial,
                onCancel: () => _cancelTrial(context, trial),
                onConvertToPaid: () => _convertToPaid(context, trial),
              );
            },
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.celebration_outlined,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No active free trials',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All your free trials are managed!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _cancelTrial(BuildContext context, subscription) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Trial'),
          content: Text('Mark ${subscription.title} trial as cancelled?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<SubscriptionProvider>(context, listen: false)
                    .markTrialAsCancelled(subscription.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${subscription.title} trial cancelled')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: const Text('Cancel Trial'),
            ),
          ],
        );
      },
    );
  }

  void _convertToPaid(BuildContext context, subscription) {
    final priceController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Convert to Paid'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Convert ${subscription.title} to a paid subscription?'),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Monthly Price',
                  prefixText: '\$',
                  hintText: '9.99',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final price = double.tryParse(priceController.text) ?? 0.0;
                if (price > 0) {
                  Navigator.of(context).pop();
                  Provider.of<SubscriptionProvider>(context, listen: false)
                      .convertTrialToPaid(subscription.id, price);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${subscription.title} converted to paid')),
                  );
                }
              },
              child: const Text('Convert'),
            ),
          ],
        );
      },
    );
  }
}