class Subscription {
  final String id;
  final String title;
  final double price;
  final String billingCycle; // Monthly, Yearly, Custom
  final DateTime startDate;
  final DateTime nextPaymentDate;
  final String category;
  final bool isFreeTrial;
  final DateTime? trialEndDate;
  final bool autoRenew;
  final int remindBeforeDays;
  final String notes;

  Subscription({
    required this.id,
    required this.title,
    required this.price,
    required this.billingCycle,
    required this.startDate,
    required this.nextPaymentDate,
    required this.category,
    this.isFreeTrial = false,
    this.trialEndDate,
    this.autoRenew = true,
    this.remindBeforeDays = 3,
    this.notes = '',
  });

  Subscription copyWith({
    String? id,
    String? title,
    double? price,
    String? billingCycle,
    DateTime? startDate,
    DateTime? nextPaymentDate,
    String? category,
    bool? isFreeTrial,
    DateTime? trialEndDate,
    bool? autoRenew,
    int? remindBeforeDays,
    String? notes,
  }) {
    return Subscription(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      billingCycle: billingCycle ?? this.billingCycle,
      startDate: startDate ?? this.startDate,
      nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
      category: category ?? this.category,
      isFreeTrial: isFreeTrial ?? this.isFreeTrial,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      autoRenew: autoRenew ?? this.autoRenew,
      remindBeforeDays: remindBeforeDays ?? this.remindBeforeDays,
      notes: notes ?? this.notes,
    );
  }

  int get daysUntilNextPayment {
    final now = DateTime.now();
    final difference = nextPaymentDate.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }

  int get daysUntilTrialEnd {
    if (trialEndDate == null) return 0;
    final now = DateTime.now();
    final difference = trialEndDate!.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }

  bool get isTrialExpired {
    if (trialEndDate == null || !isFreeTrial) return false;
    return DateTime.now().isAfter(trialEndDate!);
  }

  bool get isTrialEndingSoon {
    if (trialEndDate == null || !isFreeTrial) return false;
    return daysUntilTrialEnd <= remindBeforeDays;
  }

  String get formattedPrice {
    return '\$${price.toStringAsFixed(2)}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'billingCycle': billingCycle,
      'startDate': startDate.toIso8601String(),
      'nextPaymentDate': nextPaymentDate.toIso8601String(),
      'category': category,
      'isFreeTrial': isFreeTrial,
      'trialEndDate': trialEndDate?.toIso8601String(),
      'autoRenew': autoRenew,
      'remindBeforeDays': remindBeforeDays,
      'notes': notes,
    };
  }

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      billingCycle: json['billingCycle'],
      startDate: DateTime.parse(json['startDate']),
      nextPaymentDate: DateTime.parse(json['nextPaymentDate']),
      category: json['category'],
      isFreeTrial: json['isFreeTrial'] ?? false,
      trialEndDate: json['trialEndDate'] != null 
          ? DateTime.parse(json['trialEndDate']) 
          : null,
      autoRenew: json['autoRenew'] ?? true,
      remindBeforeDays: json['remindBeforeDays'] ?? 3,
      notes: json['notes'] ?? '',
    );
  }
}