import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../models/subscription.dart';
import '../data/dummy_data.dart';

class AddSubscriptionScreen extends StatefulWidget {
  const AddSubscriptionScreen({super.key});

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedCategory = 'Entertainment';
  String _selectedBillingCycle = 'Monthly';
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedNextPaymentDate = DateTime.now().add(const Duration(days: 30));
  bool _isFreeTrial = false;
  DateTime? _selectedTrialEndDate;
  bool _autoRenew = true;
  int _remindBeforeDays = 3;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subscription'),
        actions: [
          TextButton(
            onPressed: _saveSubscription,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Info Section
              _buildSection(
                'Basic Information',
                [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Subscription Name *',
                      hintText: 'e.g. Netflix, Spotify',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a subscription name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Price *',
                            prefixText: '\$',
                            hintText: '9.99',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              if (!_isFreeTrial) {
                                return 'Please enter a price';
                              }
                            } else {
                              final price = double.tryParse(value);
                              if (price == null || price < 0) {
                                return 'Enter a valid price';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedBillingCycle,
                          decoration: const InputDecoration(
                            labelText: 'Billing Cycle',
                          ),
                          items: DummyData.billingCycles.map((cycle) {
                            return DropdownMenuItem(
                              value: cycle,
                              child: Text(cycle),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedBillingCycle = value!;
                              _updateNextPaymentDate();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                    ),
                    items: DummyData.categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Dates Section
              _buildSection(
                'Dates',
                [
                  _buildDateField(
                    'Start Date',
                    _selectedStartDate,
                    (date) {
                      setState(() {
                        _selectedStartDate = date;
                        _updateNextPaymentDate();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  _buildDateField(
                    'Next Payment Date',
                    _selectedNextPaymentDate,
                    (date) {
                      setState(() {
                        _selectedNextPaymentDate = date;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Free Trial Section
              _buildSection(
                'Free Trial',
                [
                  SwitchListTile(
                    title: const Text('This is a free trial'),
                    value: _isFreeTrial,
                    onChanged: (value) {
                      setState(() {
                        _isFreeTrial = value;
                        if (value) {
                          _priceController.text = '0.00';
                          _selectedTrialEndDate = DateTime.now().add(const Duration(days: 30));
                        } else {
                          _selectedTrialEndDate = null;
                        }
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  
                  if (_isFreeTrial) ...[
                    const SizedBox(height: 16),
                    _buildDateField(
                      'Trial End Date',
                      _selectedTrialEndDate ?? DateTime.now().add(const Duration(days: 30)),
                      (date) {
                        setState(() {
                          _selectedTrialEndDate = date;
                        });
                      },
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              
              // Settings Section
              _buildSection(
                'Settings',
                [
                  SwitchListTile(
                    title: const Text('Auto-renew'),
                    value: _autoRenew,
                    onChanged: (value) {
                      setState(() {
                        _autoRenew = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Remind me $_remindBeforeDays days before payment',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Slider(
                          value: _remindBeforeDays.toDouble(),
                          min: 1,
                          max: 14,
                          divisions: 13,
                          label: '$_remindBeforeDays days',
                          onChanged: (value) {
                            setState(() {
                              _remindBeforeDays = value.round();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Notes Section
              _buildSection(
                'Notes',
                [
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Additional Notes',
                      hintText: 'Any additional information...',
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildDateField(String label, DateTime selectedDate, Function(DateTime) onDateSelected) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
        ),
      ),
    );
  }

  void _updateNextPaymentDate() {
    if (_selectedBillingCycle == 'Monthly') {
      _selectedNextPaymentDate = DateTime(
        _selectedStartDate.year,
        _selectedStartDate.month + 1,
        _selectedStartDate.day,
      );
    } else if (_selectedBillingCycle == 'Yearly') {
      _selectedNextPaymentDate = DateTime(
        _selectedStartDate.year + 1,
        _selectedStartDate.month,
        _selectedStartDate.day,
      );
    }
  }

  void _saveSubscription() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final price = _isFreeTrial ? 0.0 : (double.tryParse(_priceController.text) ?? 0.0);
    
    final subscription = Subscription(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      price: price,
      billingCycle: _selectedBillingCycle,
      startDate: _selectedStartDate,
      nextPaymentDate: _selectedNextPaymentDate,
      category: _selectedCategory,
      isFreeTrial: _isFreeTrial,
      trialEndDate: _selectedTrialEndDate,
      autoRenew: _autoRenew,
      remindBeforeDays: _remindBeforeDays,
      notes: _notesController.text.trim(),
    );

    Provider.of<SubscriptionProvider>(context, listen: false)
        .addSubscription(subscription);

    Navigator.of(context).pop();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${subscription.title} added successfully'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            Provider.of<SubscriptionProvider>(context, listen: false)
                .deleteSubscription(subscription.id);
          },
        ),
      ),
    );
  }
}