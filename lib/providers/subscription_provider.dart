import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../data/dummy_data.dart';

class SubscriptionProvider extends ChangeNotifier {
  List<Subscription> _subscriptions = [];
  String _currentFilter = 'All';

  List<Subscription> get subscriptions => _subscriptions;
  String get currentFilter => _currentFilter;

  SubscriptionProvider() {
    _loadDummyData();
  }

  void _loadDummyData() {
    _subscriptions = DummyData.subscriptions;
    notifyListeners();
  }

  List<Subscription> get filteredSubscriptions {
    switch (_currentFilter) {
      case 'Monthly':
        return _subscriptions.where((s) => s.billingCycle == 'Monthly').toList();
      case 'Yearly':
        return _subscriptions.where((s) => s.billingCycle == 'Yearly').toList();
      case 'Free Trials':
        return _subscriptions.where((s) => s.isFreeTrial).toList();
      default:
        return _subscriptions;
    }
  }

  List<Subscription> get freeTrialSubscriptions {
    return _subscriptions.where((s) => s.isFreeTrial).toList();
  }

  List<Subscription> get trialsEndingThisWeek {
    final now = DateTime.now();
    final weekFromNow = now.add(const Duration(days: 7));
    
    return freeTrialSubscriptions.where((s) {
      if (s.trialEndDate == null) return false;
      return s.trialEndDate!.isBefore(weekFromNow) && 
             s.trialEndDate!.isAfter(now);
    }).toList();
  }

  double get monthlySpending {
    double total = 0;
    for (var subscription in _subscriptions) {
      if (subscription.billingCycle == 'Monthly') {
        total += subscription.price;
      } else if (subscription.billingCycle == 'Yearly') {
        total += subscription.price / 12;
      }
    }
    return total;
  }

  Map<String, double> get categorySpending {
    Map<String, double> spending = {};
    
    for (var subscription in _subscriptions) {
      double monthlyPrice = subscription.price;
      if (subscription.billingCycle == 'Yearly') {
        monthlyPrice = subscription.price / 12;
      }
      
      spending[subscription.category] = 
          (spending[subscription.category] ?? 0) + monthlyPrice;
    }
    
    return spending;
  }

  List<Subscription> get upcomingPayments {
    final now = DateTime.now();
    final weekFromNow = now.add(const Duration(days: 7));
    
    return _subscriptions.where((s) {
      return s.nextPaymentDate.isBefore(weekFromNow) && 
             s.nextPaymentDate.isAfter(now);
    }).toList()
      ..sort((a, b) => a.nextPaymentDate.compareTo(b.nextPaymentDate));
  }

  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void addSubscription(Subscription subscription) {
    _subscriptions.add(subscription);
    notifyListeners();
  }

  void updateSubscription(Subscription subscription) {
    final index = _subscriptions.indexWhere((s) => s.id == subscription.id);
    if (index != -1) {
      _subscriptions[index] = subscription;
      notifyListeners();
    }
  }

  void deleteSubscription(String id) {
    _subscriptions.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void markTrialAsCancelled(String id) {
    final index = _subscriptions.indexWhere((s) => s.id == id);
    if (index != -1) {
      _subscriptions[index] = _subscriptions[index].copyWith(
        isFreeTrial: false,
        trialEndDate: null,
      );
      notifyListeners();
    }
  }

  void convertTrialToPaid(String id, double newPrice) {
    final index = _subscriptions.indexWhere((s) => s.id == id);
    if (index != -1) {
      _subscriptions[index] = _subscriptions[index].copyWith(
        isFreeTrial: false,
        trialEndDate: null,
        price: newPrice,
      );
      notifyListeners();
    }
  }
}