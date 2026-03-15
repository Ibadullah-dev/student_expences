import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final dailyTotals = provider.last7DaysTotals;
    final dayLabels = provider.last7DayLabels;
    final byCategory = provider.currentMonthByCategory;
    final totalThisMonth = provider.currentMonthTotal;

    final maxY = dailyTotals.isEmpty
        ? 1000.0
        : dailyTotals.reduce((a, b) => a > b ? a : b).clamp(100.0, double.infinity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spending Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Monthly summary card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('This Month', '${totalThisMonth.toStringAsFixed(0)} PKR', Colors.blue),
                    _buildStatItem(
                      'Transactions',
                      '${provider.allExpenses.where((e) {
                        final now = DateTime.now();
                        return e.date.year == now.year && e.date.month == now.month;
                      }).length}',
                      Colors.purple,
                    ),
                    _buildStatItem(
                      'Categories',
                      '${byCategory.length}',
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bar chart card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Last 7 Days',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: maxY * 1.2,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                return BarTooltipItem(
                                  '${rod.toY.toStringAsFixed(0)} PKR',
                                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final idx = value.toInt();
                                  if (idx < 0 || idx >= dayLabels.length) return const SizedBox();
                                  return SideTitleWidget(
                                    meta: meta,
                                    child: Text(dayLabels[idx],
                                        style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                  );
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (v) =>
                                FlLine(color: Colors.grey.withValues(alpha: 0.2), strokeWidth: 1),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(7, (i) => _makeBar(i, dailyTotals[i])),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Pie chart card
            if (byCategory.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Category Breakdown (This Month)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 220,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 48,
                            sections: byCategory.entries.map((entry) {
                              final pct = totalThisMonth > 0
                                  ? (entry.value / totalThisMonth) * 100
                                  : 0.0;
                              return PieChartSectionData(
                                color: entry.key.color,
                                value: entry.value,
                                title: '${pct.toStringAsFixed(0)}%',
                                radius: 56,
                                titleStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: byCategory.entries.map((entry) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12, height: 12,
                                decoration: BoxDecoration(
                                  color: entry.key.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(entry.key.label,
                                  style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 4),
                              Text('${entry.value.toStringAsFixed(0)} PKR',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.pie_chart, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Add expenses to see category breakdown',
                            style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: y == 0 ? Colors.grey[300]! : const Color(0xFF1976D2),
          width: 20,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
