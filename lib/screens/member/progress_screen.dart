// lib/screens/member/progress_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/progress_model.dart';
import '../../utils/constants.dart';
import '../../utils/dummy_data.dart';
import '../../utils/runtime_storage.dart';
import '../../widgets/common/app_bar.dart';
import '../../widgets/common/bottom_navigation.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/progress/progress_chart.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 1; // Index for the 'Progress' tab
  late TabController _tabController;
  String _selectedExercise = 'Bench Press';
  String _timeRange = 'Monthly';

  late List<String> _exercises = ['Bench Press', 'Squats'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _exercises = RuntimeStorage.getTrackedExercises();
    if (_exercises.isNotEmpty) {
      _selectedExercise = _exercises.first;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/member/dashboard');
        break;
      case 1:
        // Already on progress screen
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/member/workouts');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/member/diets');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/member/more');
        break;
    }
  }

  void _addExercise() {
    final TextEditingController exerciseController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Exercise'),
          content: TextField(
            controller: exerciseController,
            decoration: const InputDecoration(
              labelText: 'Exercise Name',
              hintText: 'e.g., Deadlift, Pull-ups',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (exerciseController.text.isNotEmpty) {
                  RuntimeStorage.addTrackedExercise(exerciseController.text);
                  setState(() {
                    _exercises = RuntimeStorage.getTrackedExercises();
                    if (_selectedExercise.isEmpty && _exercises.isNotEmpty) {
                      _selectedExercise = _exercises.first;
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeExercise(String exercise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Exercise'),
          content: Text(
            'Are you sure you want to remove "$exercise" from tracked exercises?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                RuntimeStorage.removeTrackedExercise(exercise);
                setState(() {
                  _exercises = RuntimeStorage.getTrackedExercises();
                  if (_selectedExercise == exercise) {
                    _selectedExercise =
                        _exercises.isNotEmpty ? _exercises.first : '';
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppConstants.progressTitle,
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.black,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(text: 'Body Weight'),
                Tab(text: 'Exercise Progress'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Body Weight Tab
                _buildBodyWeightTab(),

                // Exercise Progress Tab
                _buildExerciseProgressTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProgressDialog();
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: MemberBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildBodyWeightTab() {
    // Get body weight data
    final progressData = DummyData.progressData;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Current Weight: ',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                '${progressData.last.bodyWeight} lbs',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Weight Change
          Row(
            children: [
              const Text(
                'Weight Change: ',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                '${(progressData.first.bodyWeight - progressData.last.bodyWeight).toStringAsFixed(1)} lbs',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Chart
          SizedBox(height: 200, child: _buildBodyWeightChart(progressData)),

          // History
          const SizedBox(height: 24),
          const Text(
            'Recent Entries',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildHistoryList(progressData)),
        ],
      ),
    );
  }

  Widget _buildExerciseProgressTab() {
    // Get exercise progress data
    final progressData = DummyData.progressData;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise Selector
          Row(
            children: [
              const Text(
                'Exercise: ',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(width: 8),
              _buildExerciseSelector(),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: _addExercise,
                tooltip: 'Add Exercise',
              ),
              if (_exercises.isNotEmpty)
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  onPressed: () => _removeExercise(_selectedExercise),
                  tooltip: 'Remove Exercise',
                ),
            ],
          ),
          const SizedBox(height: 32),

          // Current Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Current Weight',
                  value:
                      '${_getCurrentExerciseWeight(progressData, _selectedExercise)} lbs',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Current Reps',
                  value:
                      '${_getCurrentExerciseReps(progressData, _selectedExercise)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Chart
          SizedBox(
            height: 200,
            child: _buildExerciseProgressChart(progressData, _selectedExercise),
          ),

          // History
          const SizedBox(height: 24),
          const Text(
            'Recent Entries',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _buildExerciseHistoryList(progressData, _selectedExercise),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButton<String>(
        value: _timeRange,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        underline: const SizedBox(),
        dropdownColor: const Color(0xFF2A2A2A),
        items: const [
          DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
          DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
          DropdownMenuItem(value: 'All Time', child: Text('All Time')),
        ],
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _timeRange = newValue;
            });
          }
        },
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildExerciseSelector() {
    return Container(
      width: 200, // Fixed width instead of Expanded
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButton<String>(
        value:
            _exercises.isNotEmpty
                ? (_exercises.contains(_selectedExercise)
                    ? _selectedExercise
                    : _exercises.first)
                : null,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        underline: const SizedBox(),
        isExpanded: true,
        dropdownColor: const Color(0xFF2A2A2A),
        items:
            _exercises.map((String exercise) {
              return DropdownMenuItem<String>(
                value: exercise,
                child: Text(exercise),
              );
            }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedExercise = newValue;
            });
          }
        },
        style: const TextStyle(color: Colors.white),
        hint: const Text(
          'Select Exercise',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyWeightChart(List<ProgressEntry> progressData) {
    // For prototype, we'll use a simplified chart
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: SizedBox(
          height: 200,
          child: ProgressChart(
            progressData: progressData,
            lineColor: Colors.green,
            showLabels: false,
            showGrid: true,
            showDots: true,
            title: 'Weight Progress',
            height: 200,
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseProgressChart(
    List<ProgressEntry> progressData,
    String exerciseName,
  ) {
    // Filter progress entries that have data for the selected exercise
    final exerciseData =
        progressData.where((entry) {
          return entry.exerciseProgress.any(
            (ex) => ex.exerciseName == exerciseName,
          );
        }).toList();

    // If there's no data for this exercise yet, show a placeholder
    if (exerciseData.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'No progress data for this exercise yet',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _showAddProgressDialog,
                child: const Text('Add Progress'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Extract weight data for the selected exercise
    final weightSpots = List.generate(exerciseData.length, (index) {
      final exerciseProgress = exerciseData[index].exerciseProgress.firstWhere(
        (ex) => ex.exerciseName == exerciseName,
      );
      return FlSpot(index.toDouble(), exerciseProgress.weight);
    });

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
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
              show: true,
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
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
                        '${date.month}/${date.day}',
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
                  showTitles: true,
                  interval: 20,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
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
                                        (ex) => ex.exerciseName == exerciseName,
                                      )
                                      .weight,
                            )
                            .reduce((a, b) => a > b ? a : b) +
                        20)
                    .ceilToDouble(),
            lineBarsData: [
              LineChartBarData(
                spots: weightSpots,
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: Colors.blue,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<ProgressEntry> progressData) {
    return ListView.builder(
      itemCount: progressData.length,
      itemBuilder: (context, index) {
        final entry =
            progressData[progressData.length -
                1 -
                index]; // Reverse order to show newest first
        final date = entry.date;
        final formattedDate = '${date.month}/${date.day}/${date.year}';

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const Spacer(),
              Text(
                '${entry.bodyWeight} lbs',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExerciseHistoryList(
    List<ProgressEntry> progressData,
    String exerciseName,
  ) {
    // Filter progress entries that have data for the selected exercise
    final exerciseData =
        progressData.where((entry) {
          return entry.exerciseProgress.any(
            (ex) => ex.exerciseName == exerciseName,
          );
        }).toList();

    return ListView.builder(
      itemCount: exerciseData.length,
      itemBuilder: (context, index) {
        final entry =
            exerciseData[exerciseData.length -
                1 -
                index]; // Reverse order to show newest first
        final date = entry.date;
        final formattedDate = '${date.month}/${date.day}/${date.year}';

        final exerciseProgress = entry.exerciseProgress.firstWhere(
          (ex) => ex.exerciseName == exerciseName,
        );

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const Spacer(),
              Text(
                '${exerciseProgress.weight} lbs × ${exerciseProgress.reps} reps',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _getCurrentExerciseWeight(
    List<ProgressEntry> progressData,
    String exerciseName,
  ) {
    final entries =
        progressData
            .where(
              (entry) => entry.exerciseProgress.any(
                (ex) => ex.exerciseName == exerciseName,
              ),
            )
            .toList();

    if (entries.isEmpty) return 0.0;

    final latestEntry = entries.last;
    final exerciseProgress = latestEntry.exerciseProgress.firstWhere(
      (ex) => ex.exerciseName == exerciseName,
    );
    return exerciseProgress.weight;
  }

  int _getCurrentExerciseReps(
    List<ProgressEntry> progressData,
    String exerciseName,
  ) {
    final entries =
        progressData
            .where(
              (entry) => entry.exerciseProgress.any(
                (ex) => ex.exerciseName == exerciseName,
              ),
            )
            .toList();

    if (entries.isEmpty) return 0;

    final latestEntry = entries.last;
    final exerciseProgress = latestEntry.exerciseProgress.firstWhere(
      (ex) => ex.exerciseName == exerciseName,
    );
    return exerciseProgress.reps;
  }

  void _showAddProgressDialog() {
    final TextEditingController weightController = TextEditingController();
    final Map<String, TextEditingController> exerciseControllers = {};
    final Map<String, TextEditingController> repsControllers = {};

    // Pre-populate exercise fields for tracked exercises
    for (String exercise in _exercises) {
      exerciseControllers[exercise] = TextEditingController();
      repsControllers[exercise] = TextEditingController();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Progress Entry'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Body weight field
                const Text('Body Weight (lbs):'),
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter your current weight',
                  ),
                ),
                const SizedBox(height: 16),

                // Exercise progress fields
                const Text('Exercise Progress:'),
                ..._exercises.map((exercise) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: exerciseControllers[exercise],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Weight (lbs)',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: repsControllers[exercise],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Reps',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Create new progress entry
                final newEntry = ProgressEntry(
                  userId: '1', // Use current user's ID in a real app
                  date: DateTime.now(),
                  bodyWeight: double.tryParse(weightController.text) ?? 0.0,
                  exerciseProgress:
                      _exercises
                          .where(
                            (e) =>
                                exerciseControllers[e]!.text.isNotEmpty &&
                                repsControllers[e]!.text.isNotEmpty,
                          )
                          .map(
                            (e) => ExerciseProgress(
                              exerciseName: e,
                              weight:
                                  double.tryParse(
                                    exerciseControllers[e]!.text,
                                  ) ??
                                  0.0,
                              reps: int.tryParse(repsControllers[e]!.text) ?? 0,
                            ),
                          )
                          .toList(),
                );

                // Add to runtime storage
                RuntimeStorage.addProgressEntry(newEntry);

                Navigator.of(context).pop();
                setState(() {}); // Refresh the UI
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
