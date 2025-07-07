import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../widgets/subscription_card.dart';
import '../widgets/filter_chips.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        final subscriptions = subscriptionProvider.filteredSubscriptions;
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Chips
              const FilterChips(),
              const SizedBox(height: 16),
              
              // Subscription Count
              Text(
                '${subscriptions.length} Subscription${subscriptions.length != 1 ? 's' : ''}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
              
              // Subscriptions List
              Expanded(
                child: subscriptions.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.separated(
                        itemCount: subscriptions.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final subscription = subscriptions[index];
                          return SubscriptionCard(
                            subscription: subscription,
                            onTap: () => _editSubscription(context, subscription),
                            onDelete: () => _deleteSubscription(context, subscription),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.subscriptions_outlined,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No subscriptions found',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first subscription',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _editSubscription(BuildContext context, subscription) {
    // Navigate to edit screen (would pass subscription data)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit ${subscription.title} (Feature coming soon)'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _deleteSubscription(BuildContext context, subscription) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Subscription'),
          content: Text('Are you sure you want to delete ${subscription.title}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<SubscriptionProvider>(context, listen: false)
                    .deleteSubscription(subscription.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${subscription.title} deleted')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}