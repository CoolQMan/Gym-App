// lib/widgets/progress/progress_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/progress_model.dart';

class ProgressChart extends StatelessWidget {
  final List<ProgressEntry> progressData;
  final Color lineColor;
  final bool showLabels;
  final bool showGrid;
  final bool showDots;
  final String title;
  final double height;

  const ProgressChart({
    Key? key,
    required this.progressData,
    this.lineColor = Colors.green,
    this.showLabels = true,
    this.showGrid = true,
    this.showDots = true,
    this.title = 'Weight Progress',
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty) ...[
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: showGrid,
                    drawVerticalLine: false,
                    horizontalInterval: 0.5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: showLabels,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: showLabels,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= progressData.length ||
                              value.toInt() < 0) {
                            return const Text('');
                          }
                          final date = progressData[value.toInt()].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${date.month}-${date.day}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: showLabels,
                        interval: 0.5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: progressData.length.toDouble() - 1,
                  minY:
                      (progressData
                                  .map((e) => e.bodyWeight)
                                  .reduce((a, b) => a < b ? a : b) -
                              0.5)
                          .floorToDouble(),
                  maxY:
                      (progressData
                                  .map((e) => e.bodyWeight)
                                  .reduce((a, b) => a > b ? a : b) +
                              0.5)
                          .ceilToDouble(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(progressData.length, (index) {
                        return FlSpot(
                          index.toDouble(),
                          progressData[index].bodyWeight,
                        );
                      }),
                      isCurved: true,
                      color: lineColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: showDots,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: lineColor,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: lineColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseProgressChart extends StatelessWidget {
  final List<ProgressEntry> progressData;
  final String exerciseName;
  final Color lineColor;
  final bool showLabels;
  final bool showGrid;
  final bool showDots;
  final double height;

  const ExerciseProgressChart({
    Key? key,
    required this.progressData,
    required this.exerciseName,
    this.lineColor = Colors.blue,
    this.showLabels = true,
    this.showGrid = true,
    this.showDots = true,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter progress entries that have data for the selected exercise
    final exerciseData =
        progressData.where((entry) {
          return entry.exerciseProgress.any(
            (ex) => ex.exerciseName == exerciseName,
          );
        }).toList();

    // Extract weight data for the selected exercise
    final weightSpots = List.generate(exerciseData.length, (index) {
      final exerciseProgress = exerciseData[index].exerciseProgress.firstWhere(
        (ex) => ex.exerciseName == exerciseName,
      );
      return FlSpot(index.toDouble(), exerciseProgress.weight);
    });

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$exerciseName Progress',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: showGrid,
                    drawVerticalLine: false,
                    horizontalInterval: 10,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: showLabels,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: showLabels,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= exerciseData.length ||
                              value.toInt() < 0) {
                            return const Text('');
                          }
                          final date = exerciseData[value.toInt()].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${date.month}-${date.day}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: showLabels,
                        interval: 10,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: exerciseData.length.toDouble() - 1,
                  minY: 0,
                  maxY:
                      (exerciseData
                                  .map(
                                    (e) =>
                                        e.exerciseProgress
                                            .firstWhere(
                                              (ex) =>
                                                  ex.exerciseName ==
                                                  exerciseName,
                                            )
                                            .weight,
                                  )
                                  .reduce((a, b) => a > b ? a : b) +
                              10)
                          .ceilToDouble(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: weightSpots,
                      isCurved: true,
                      color: lineColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: showDots,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: lineColor,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: lineColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
