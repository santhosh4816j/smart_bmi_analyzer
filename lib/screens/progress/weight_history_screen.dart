import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../core/themes/app_theme.dart';
import '../../providers/weight_provider.dart';

enum _Range { week, month, year }

class WeightHistoryScreen extends ConsumerStatefulWidget {
  const WeightHistoryScreen({super.key});

  @override
  ConsumerState<WeightHistoryScreen> createState() => _WeightHistoryScreenState();
}

class _WeightHistoryScreenState extends ConsumerState<WeightHistoryScreen> {
  _Range _range = _Range.week;
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(weightHistoryProvider.notifier);
    final duration = switch (_range) {
      _Range.week => const Duration(days: 7),
      _Range.month => const Duration(days: 30),
      _Range.year => const Duration(days: 365),
    };
    final records = notifier.recordsSince(duration);

    return Scaffold(
      appBar: AppBar(title: const Text('Weight History')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SegmentedButton<_Range>(
            segments: const [
              ButtonSegment(value: _Range.week, label: Text('Weekly')),
              ButtonSegment(value: _Range.month, label: Text('Monthly')),
              ButtonSegment(value: _Range.year, label: Text('Yearly')),
            ],
            selected: {_range},
            onSelectionChanged: (s) => setState(() => _range = s.first),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 20, 12),
              child: SizedBox(
                height: 220,
                child: records.length < 2
                    ? Center(
                        child: Text('Log a couple more entries to see your trend', style: Theme.of(context).textTheme.bodyMedium),
                      )
                    : LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: true, drawVerticalLine: false),
                          titlesData: FlTitlesData(
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget: (value, meta) {
                                  final i = value.toInt();
                                  if (i < 0 || i >= records.length) return const SizedBox.shrink();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(DateFormat('d MMM').format(records[i].date), style: const TextStyle(fontSize: 10)),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                for (int i = 0; i < records.length; i++)
                                  FlSpot(i.toDouble(), records[i].weightKg),
                              ],
                              isCurved: true,
                              color: AppColors.ocean,
                              barWidth: 3,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(show: true, color: AppColors.ocean.withValues(alpha: 0.12)),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Log Today\'s Weight', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(labelText: 'Weight (kg)'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          final value = double.tryParse(_weightController.text);
                          if (value == null || value < 20 || value > 400) return;
                          ref.read(weightHistoryProvider.notifier).addRecord(value);
                          _weightController.clear();
                          FocusScope.of(context).unfocus();
                        },
                        child: const Text('Log'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('All Entries', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...records.reversed.map(
            (r) => ListTile(
              leading: const Icon(Icons.monitor_weight_outlined),
              title: Text('${r.weightKg.toStringAsFixed(1)} kg'),
              subtitle: Text(DateFormat('EEEE, d MMM yyyy').format(r.date)),
            ),
          ),
        ],
      ),
    );
  }
}
