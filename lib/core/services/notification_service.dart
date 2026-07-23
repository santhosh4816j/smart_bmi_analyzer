import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

import '../models/reminder.dart';

/// Wraps flutter_local_notifications so the rest of the app never touches
/// the plugin directly. All scheduling is done with the device's local
/// timezone and works fully offline.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(tz.local.name));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );
    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    final notif = await Permission.notification.request();
    return notif.isGranted;
  }

  Future<void> scheduleReminder(Reminder reminder) async {
    await init();
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      reminder.hour,
      reminder.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'health_reminders',
        'Health Reminders',
        channelDescription: 'Daily health reminders from Smart BMI Analyzer',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      reminder.notificationId,
      '${reminder.type.emoji} ${reminder.label}',
      _bodyFor(reminder.type),
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: reminder.repeatDays.isEmpty
          ? DateTimeComponents.time
          : DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> cancelReminder(int notificationId) async {
    await _plugin.cancel(notificationId);
  }

  String _bodyFor(ReminderType type) {
    switch (type) {
      case ReminderType.water:
        return "Time for a glass of water — stay hydrated!";
      case ReminderType.exercise:
        return "A few minutes of movement makes a big difference today.";
      case ReminderType.measureWeight:
        return "Log today's weight to keep your progress on track.";
      case ReminderType.eatHealthy:
        return "Time for a balanced, nutritious meal.";
      case ReminderType.protein:
        return "Don't forget your protein intake for today.";
      case ReminderType.custom:
        return "You have a reminder.";
    }
  }
}
