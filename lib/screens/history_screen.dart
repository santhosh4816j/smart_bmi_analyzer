import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/bmi_record.dart';
import '../services/bmi_service.dart';
import '../services/history_service.dart';
import '../widgets/custom_card.dart';

/// Displays saved BMI history in a list, plus line & bar charts of trends.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<BmiRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() {
    setState(() => _records = HistoryService.getAllRecords());
  }

  Future<void> _deleteRecord(BmiRecord record) async {
    await HistoryService.deleteRecord(record);
    _loadRecords();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record deleted'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI History'),
        actions: [
          if (_records.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear all history',
              onPressed: _confirmClearAll,
            ),
        ],
      ),
      body: SafeArea(
        child: _records.isEmpty ? _buildEmptyState() : _buildContent(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_toggle_off_rounded,
                size: 64, color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
            const SizedBox(height: 16),
            const Text(
              'No history yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Calculate your BMI to start tracking your progress over time.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    // Charts read oldest -> newest for a natural left-to-right trend.
    final chronological = _records.reversed.toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (chronological.length > 1) ...[
          const Text('BMI Trend (Line Chart)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          CustomCard(child: SizedBox(height: 200, child: _buildLineChart(chronological))),
          const SizedBox(height: 20),
          const Text('BMI Comparison (Bar Chart)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          CustomCard(child: SizedBox(height: 200, child: _buildBarChart(chronological))),
          const SizedBox(height: 24),
        ],
        const Text('All Records', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ..._records.map((r) => _historyTile(r)),
      ],
    );
  }

  Widget _historyTile(BmiRecord record) {
    final color = BmiService.colorFor(record.category);
    return CustomCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Text(
              record.bmi.toStringAsFixed(0),
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${record.category} · BMI ${record.bmi.toStringAsFixed(1)}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  '${record.weight.toStringAsFixed(1)}kg · ${record.height.toStringAsFixed(0)}cm · '
                  '${DateFormat.yMMMd().add_jm().format(record.date)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => _deleteRecord(record),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<BmiRecord> records) {
    final spots = <FlSpot>[
      for (int i = 0; i < records.length; i++) FlSpot(i.toDouble(), records[i].bmi),
    ];
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(List<BmiRecord> records) {
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          for (int i = 0; i < records.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: records[i].bmi,
                  color: BmiService.colorFor(records[i].category),
                  width: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _confirmClearAll() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear all history?'),
        content: const Text('This will permanently delete all saved BMI records.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await HistoryService.clearAll();
              if (mounted) Navigator.pop(ctx);
              _loadRecords();
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
