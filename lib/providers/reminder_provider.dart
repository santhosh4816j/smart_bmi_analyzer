import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/database/hive_boxes.dart';
import '../core/models/reminder.dart';
import '../core/services/notification_service.dart';

class RemindersNotifier extends StateNotifier<List<Reminder>> {
  RemindersNotifier() : super(_box.values.toList());

  static Box<Reminder> get _box => Hive.box<Reminder>(HiveBoxes.reminders);

  Future<void> addReminder(Reminder reminder) async {
    await _box.add(reminder);
    if (reminder.enabled) {
      await NotificationService.instance.scheduleReminder(reminder);
    }
    state = _box.values.toList();
  }

  Future<void> toggleReminder(Reminder reminder, bool enabled) async {
    reminder.enabled = enabled;
    await reminder.save();
    if (enabled) {
      await NotificationService.instance.scheduleReminder(reminder);
    } else {
      await NotificationService.instance.cancelReminder(reminder.notificationId);
    }
    state = _box.values.toList();
  }

  Future<void> deleteReminder(Reminder reminder) async {
    await NotificationService.instance.cancelReminder(reminder.notificationId);
    await reminder.delete();
    state = _box.values.toList();
  }
}

final remindersProvider =
    StateNotifierProvider<RemindersNotifier, List<Reminder>>((ref) {
  return RemindersNotifier();
});
