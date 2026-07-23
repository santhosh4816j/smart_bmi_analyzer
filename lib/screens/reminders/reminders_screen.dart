import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/reminder.dart';
import '../../core/services/notification_service.dart';
import '../../core/themes/app_theme.dart';
import '../../providers/reminder_provider.dart';

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(remindersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddReminderSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Reminder'),
      ),
      body: reminders.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications_none, size: 64, color: AppColors.ocean.withValues(alpha: 0.4)),
                    const SizedBox(height: 16),
                    Text('No reminders yet', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Add reminders for water, exercise, meals, and more — all delivered offline.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
              itemCount: reminders.length,
              itemBuilder: (context, i) {
                final r = reminders[i];
                final time = TimeOfDay(hour: r.hour, minute: r.minute).format(context);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(r.type.emoji, style: const TextStyle(fontSize: 24)),
                    title: Text(r.label),
                    subtitle: Text(time),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: r.enabled,
                          onChanged: (v) => ref.read(remindersProvider.notifier).toggleReminder(r, v),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => ref.read(remindersProvider.notifier).deleteReminder(r),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showAddReminderSheet(BuildContext context, WidgetRef ref) {
    ReminderType type = ReminderType.water;
    TimeOfDay time = TimeOfDay.now();
    final labelController = TextEditingController(text: type.label);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('New Reminder', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ReminderType.values.map((t) {
                      return ChoiceChip(
                        label: Text('${t.emoji} ${t.label}'),
                        selected: type == t,
                        onSelected: (_) => setState(() {
                          type = t;
                          labelController.text = t.label;
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: labelController,
                    decoration: const InputDecoration(labelText: 'Label'),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Time'),
                    trailing: TextButton(
                      onPressed: () async {
                        final picked = await showTimePicker(context: context, initialTime: time);
                        if (picked != null) setState(() => time = picked);
                      },
                      child: Text(time.format(context)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await NotificationService.instance.requestPermissions();
                        final reminder = Reminder(
                          notificationId: DateTime.now().millisecondsSinceEpoch.remainder(100000),
                          type: type,
                          label: labelController.text.trim().isEmpty ? type.label : labelController.text.trim(),
                          hour: time.hour,
                          minute: time.minute,
                        );
                        ref.read(remindersProvider.notifier).addReminder(reminder);
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      child: const Text('Save Reminder'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
