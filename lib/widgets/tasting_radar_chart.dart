import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/tasting.dart';

class TastingRadarChart extends StatelessWidget {
  final Tasting tasting;
  final List<Tasting>? previousTastings;
  final double size;

  const TastingRadarChart({
    Key? key,
    required this.tasting,
    this.previousTastings,
    this.size = 300,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: size,
      height: size,
      child: RadarChart(
        RadarChartData(
          radarBorderData: const BorderSide(color: Colors.transparent),
          tickCount: 5,
          ticksTextStyle: const TextStyle(
            color: Colors.transparent,
            fontSize: 10,
          ),
          gridBorderData: BorderSide(color: theme.dividerColor.withOpacity(0.3), width: 1),
          titleTextStyle: TextStyle(
            color: theme.textTheme.bodyMedium?.color ?? Colors.black,
            fontSize: 14,
          ),
          // Define the radar shape attributes
          dataSets: [
            // Current tasting
            RadarDataSet(
              dataEntries: [
                RadarEntry(value: tasting.aroma),
                RadarEntry(value: tasting.flavor),
                RadarEntry(value: tasting.acidity),
                RadarEntry(value: tasting.body),
                RadarEntry(value: tasting.sweetness),
                RadarEntry(value: tasting.overall),
              ],
              fillColor: theme.colorScheme.primary.withOpacity(0.3),
              borderColor: theme.colorScheme.primary,
              borderWidth: 2,
            ),
            // If we have previous tastings, show them in a different color
            if (previousTastings != null && previousTastings!.isNotEmpty)
              RadarDataSet(
                dataEntries: _getAverageTastingEntries(),
                fillColor: theme.colorScheme.secondary.withOpacity(0.1),
                borderColor: theme.colorScheme.secondary.withOpacity(0.7),
                borderWidth: 1.5,
              ),
          ],
          // Customize titles (categories)
          getTitle: (index, angle) {
            switch (index) {
              case 0:
                return RadarChartTitle(text: 'Aroma', angle: angle);
              case 1:
                return RadarChartTitle(text: 'Flavor', angle: angle);
              case 2:
                return RadarChartTitle(text: 'Acidity', angle: angle);
              case 3:
                return RadarChartTitle(text: 'Body', angle: angle);
              case 4:
                return RadarChartTitle(text: 'Sweetness', angle: angle);
              case 5:
                return RadarChartTitle(text: 'Overall', angle: angle);
              default:
                return const RadarChartTitle(text: '');
            }
          },
          tickBorderData: const BorderSide(color: Colors.transparent, width: 0),
          titlePositionPercentageOffset: 0.2,
        ),
        swapAnimationDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  // Calculate average values from previous tastings
  List<RadarEntry> _getAverageTastingEntries() {
    if (previousTastings == null || previousTastings!.isEmpty) {
      return [];
    }

    double avgAroma = 0;
    double avgFlavor = 0;
    double avgAcidity = 0;
    double avgBody = 0;
    double avgSweetness = 0;
    double avgOverall = 0;

    for (var tasting in previousTastings!) {
      avgAroma += tasting.aroma;
      avgFlavor += tasting.flavor;
      avgAcidity += tasting.acidity;
      avgBody += tasting.body;
      avgSweetness += tasting.sweetness;
      avgOverall += tasting.overall;
    }

    final count = previousTastings!.length;
    return [
      RadarEntry(value: avgAroma / count),
      RadarEntry(value: avgFlavor / count),
      RadarEntry(value: avgAcidity / count),
      RadarEntry(value: avgBody / count),
      RadarEntry(value: avgSweetness / count),
      RadarEntry(value: avgOverall / count),
    ];
  }
}

// A simple widget to show a score legend
class TastingScoreLegend extends StatelessWidget {
  final Map<String, double> scores;
  final Color color;

  const TastingScoreLegend({
    Key? key,
    required this.scores,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: scores.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${entry.key}: ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    entry.value.toStringAsFixed(1),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// A widget to display multiple tastings in a historical view
class TastingHistoryChart extends StatelessWidget {
  final List<Tasting> tastings;
  final double size;

  const TastingHistoryChart({
    Key? key,
    required this.tastings,
    this.size = 300,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tastings.isEmpty) {
      return const Center(
        child: Text('No tasting history available'),
      );
    }

    final theme = Theme.of(context);
    
    // Group tastings by month for trend analysis
    final groupedTastings = _groupTastingsByMonth();
    
    return Column(
      children: [
        const Text(
          'Tasting Score Trends',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 2,
                verticalInterval: 1,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      // Show month as title
                      final months = groupedTastings.keys.toList();
                      if (value.toInt() >= 0 && value.toInt() < months.length) {
                        final month = months[value.toInt()];
                        return Text(
                          month.substring(0, 3), // First 3 letters of month
                          style: const TextStyle(fontSize: 12),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 2,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                    reservedSize: 40,
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: theme.dividerColor, width: 1),
              ),
              minX: 0,
              maxX: groupedTastings.length - 1.0,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                _createLineChartData('Overall', groupedTastings, theme.colorScheme.primary),
                _createLineChartData('Aroma', groupedTastings, theme.colorScheme.secondary),
                _createLineChartData('Flavor', groupedTastings, Colors.green),
                _createLineChartData('Acidity', groupedTastings, Colors.orange),
                _createLineChartData('Body', groupedTastings, Colors.purple),
                _createLineChartData('Sweetness', groupedTastings, Colors.teal),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Overall', theme.colorScheme.primary),
            _buildLegendItem('Aroma', theme.colorScheme.secondary),
            _buildLegendItem('Flavor', Colors.green),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Acidity', Colors.orange),
            _buildLegendItem('Body', Colors.purple),
            _buildLegendItem('Sweetness', Colors.teal),
          ],
        ),
      ],
    );
  }
  
  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  LineChartBarData _createLineChartData(
    String attribute, 
    Map<String, List<Tasting>> groupedTastings,
    Color color
  ) {
    final spots = <FlSpot>[];
    final months = groupedTastings.keys.toList();
    
    for (int i = 0; i < months.length; i++) {
      final month = months[i];
      final monthTastings = groupedTastings[month]!;
      
      // Calculate average value for this attribute in this month
      double sum = 0;
      for (var tasting in monthTastings) {
        double value;
        switch (attribute) {
          case 'Overall':
            value = tasting.overall;
            break;
          case 'Aroma':
            value = tasting.aroma;
            break;
          case 'Flavor':
            value = tasting.flavor;
            break;
          case 'Acidity':
            value = tasting.acidity;
            break;
          case 'Body':
            value = tasting.body;
            break;
          case 'Sweetness':
            value = tasting.sweetness;
            break;
          default:
            value = 0;
        }
        sum += value;
      }
      final average = sum / monthTastings.length;
      spots.add(FlSpot(i.toDouble(), average));
    }
    
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.1),
      ),
    );
  }

  Map<String, List<Tasting>> _groupTastingsByMonth() {
    final Map<String, List<Tasting>> grouped = {};
    
    for (var tasting in tastings) {
      final date = tasting.date;
      final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      
      if (!grouped.containsKey(monthKey)) {
        grouped[monthKey] = [];
      }
      
      grouped[monthKey]!.add(tasting);
    }
    
    // Sort by date
    final sortedKeys = grouped.keys.toList()..sort();
    final sortedMap = {
      for (var key in sortedKeys) key: grouped[key]!,
    };
    
    return sortedMap;
  }
}