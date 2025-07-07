import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import '../models/subscription.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Request permissions for iOS
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  static void _onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    // Handle notification tap
    debugPrint('Notification tapped: ${notificationResponse.payload}');
  }

  Future<void> schedulePaymentReminder(Subscription subscription) async {
    final scheduledDate = subscription.nextPaymentDate
        .subtract(Duration(days: subscription.remindBeforeDays));

    // Only schedule if the date is in the future
    if (scheduledDate.isAfter(DateTime.now())) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'payment_reminders',
        'Payment Reminders',
        channelDescription: 'Reminders for upcoming subscription payments',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        subscription.id.hashCode,
        'Payment Due Soon',
        '${subscription.title} payment of ${subscription.formattedPrice} is due in ${subscription.remindBeforeDays} days',
        _convertToTZDateTime(scheduledDate),
        platformChannelSpecifics,
        payload: 'payment_${subscription.id}',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> scheduleTrialReminder(Subscription subscription) async {
    if (!subscription.isFreeTrial || subscription.trialEndDate == null) return;

    final scheduledDate = subscription.trialEndDate!
        .subtract(Duration(days: subscription.remindBeforeDays));

    // Only schedule if the date is in the future
    if (scheduledDate.isAfter(DateTime.now())) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'trial_reminders',
        'Free Trial Reminders',
        channelDescription: 'Reminders for expiring free trials',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        'trial_${subscription.id}'.hashCode,
        'Free Trial Ending Soon',
        '${subscription.title} free trial ends in ${subscription.remindBeforeDays} days',
        _convertToTZDateTime(scheduledDate),
        platformChannelSpecifics,
        payload: 'trial_${subscription.id}',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> cancelNotification(String subscriptionId) async {
    await _flutterLocalNotificationsPlugin.cancel(subscriptionId.hashCode);
    await _flutterLocalNotificationsPlugin.cancel('trial_$subscriptionId'.hashCode);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  dynamic _convertToTZDateTime(DateTime dateTime) {

    return dateTime;
  }
}