import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/bmi_record_model.dart';
import '../../models/profile_model.dart';
import '../../providers/profile_provider.dart';
import '../../providers/unit_provider.dart';
import '../../widgets/glass_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileProvider provider = context.watch<ProfileProvider>();
    final UnitProvider unitProvider = context.watch<UnitProvider>();
    final ProfileModel? profile = provider.activeProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: <Widget>[
          if (profile != null)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Log weight',
              onPressed: () => _showLogWeightSheet(context, profile.id),
            ),
        ],
      ),
      body: profile == null
          ? const Center(child: Text('Create a profile first'))
          : _HistoryList(profileId: profile.id, unitProvider: unitProvider),
    );
  }

  static Future<void> _showLogWeightSheet(
    BuildContext context,
    String profileId,
  ) async {
    final TextEditingController controller = TextEditingController();
    final ProfileProvider provider = context.read<ProfileProvider>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Log today\'s weight',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  final double? weight = double.tryParse(controller.text);
                  if (weight == null || weight <= 0) return;
                  await provider.logWeight(profileId, weight);
                  if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.profileId, required this.unitProvider});

  final String profileId;
  final UnitProvider unitProvider;

  @override
  Widget build(BuildContext context) {
    final List<BmiRecordModel> records =
        context.watch<ProfileProvider>().historyFor(profileId);

    if (records.isEmpty) {
      return const Center(child: Text('No history yet — log a weigh-in.'));
    }

    final DateFormat formatter = DateFormat('MMM d, yyyy • h:mm a');

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: records.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) {
        final BmiRecordModel record = records[index];
        return GlassCard(
          child: Row(
            children: <Widget>[
              CircleAvatar(
                child: Text(record.bmi.toStringAsFixed(0)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${unitProvider.displayWeight(record.weightKg).toStringAsFixed(1)} ${unitProvider.weightUnitLabel} · BMI ${record.bmi.toStringAsFixed(1)}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      formatter.format(record.recordedAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (record.note != null && record.note!.isNotEmpty)
                      Text(record.note!, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
