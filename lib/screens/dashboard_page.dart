import 'package:flutter/cupertino.dart';
import 'dart:async';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Dummy data for the dashboard
  final Map<String, dynamic> foodData = {
    'meals': [
      {'name': 'Breakfast', 'calories': 350},
      {'name': 'Lunch', 'calories': 500},
      {'name': 'Dinner', 'calories': 600},
    ],
    'totalCalories': 1450,
  };

  final Map<String, dynamic> exerciseData = {
    'steps': 8500,
    'workoutMinutes': 45,
  };

  final Map<String, dynamic> sleepData = {
    'duration': 7.5,
    'quality': 'Good',
  };

  DateTime lastUpdated = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Immediately poll for data when the page loads.
    _pollDashboardData();
  }

  /// Simulates polling an API to fetch the user's dashboard data.
  Future<void> _pollDashboardData() async {
    // Simulate network delay.
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      lastUpdated = DateTime.now();
      // Here you could update the dummy data to simulate new API results.
      // For now, the data remains static.
    });
  }

  /// Called when the user pulls to refresh.
  Future<void> _handleRefresh() async {
    await _pollDashboardData();
  }

  /// A helper method to build a thin divider using Cupertino colors.
  Widget _buildDivider() {
    return Container(
      height: 1,
      color: CupertinoColors.separator,
    );
  }

  /// Helper method to build a summary card.
  Widget _buildSummaryCard({
    required String title,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemGroupedBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CupertinoTheme.of(context)
                .textTheme
                .textStyle
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Dashboard'),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Pull-to-refresh control.
            CupertinoSliverRefreshControl(
              onRefresh: _handleRefresh,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dashboard title
                    Text(
                      'Today\'s Summary',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .navLargeTitleTextStyle,
                    ),
                    const SizedBox(height: 16),
                    // Food Summary Card
                    _buildSummaryCard(
                      title: 'Food',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...foodData['meals'].map<Widget>((meal) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                '${meal['name']}: ${meal['calories']} kcal',
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .textStyle,
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 8),
                          _buildDivider(),
                          const SizedBox(height: 8),
                          Text(
                            'Total: ${foodData['totalCalories']} kcal',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Exercise Summary Card
                    _buildSummaryCard(
                      title: 'Exercise',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Steps: ${exerciseData['steps']}',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Workout: ${exerciseData['workoutMinutes']} mins',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Sleep Summary Card
                    _buildSummaryCard(
                      title: 'Sleep',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Duration: ${sleepData['duration']} hrs',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Quality: ${sleepData['quality']}',
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Last updated information.
                    Text(
                      'Last Updated: ${lastUpdated.hour}:${lastUpdated.minute}:${lastUpdated.second}',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(
                            fontSize: 12,
                            color: CupertinoColors.systemGrey,
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
