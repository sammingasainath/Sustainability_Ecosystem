import 'package:esg_post_office/features/carbon_credits/presentation/models/walk_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/walk_activity_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esg_post_office/features/auth/presentation/providers/auth_provider.dart';

class WalkAndEarnPage extends ConsumerWidget {
  const WalkAndEarnPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walkActivityState = ref.watch(walkActivityProvider);
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Walk & Earn'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: user == null
          ? const Center(child: Text('Please login to continue'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.id)
                  .collection('walkActivities')
                  .orderBy('startTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final activities = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return WalkActivity.fromJson(data);
                }).toList();

                // Calculate today's stats
                final today = DateTime.now();
                final todayActivities = activities.where((activity) {
                  final activityDate = activity.startTime;
                  return activityDate.year == today.year &&
                      activityDate.month == today.month &&
                      activityDate.day == today.day;
                }).toList();

                final todaySteps = todayActivities.fold<int>(
                    0, (sum, activity) => sum + activity.steps);
                final todayDistance = todayActivities.fold<double>(
                    0, (sum, activity) => sum + activity.distance);
                final todayCredits = todayActivities.fold<double>(
                    0, (sum, activity) => sum + activity.carbonCredits);

                return walkActivityState.when(
                  data: (currentActivity) => _buildContent(
                    context,
                    ref,
                    currentActivity,
                    activities,
                    todaySteps,
                    todayDistance,
                    todayCredits,
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${error.toString()}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref
                              .read(walkActivityProvider.notifier)
                              .startWalking(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    WalkActivity? currentActivity,
    List<WalkActivity> allActivities,
    int todaySteps,
    double todayDistance,
    double todayCredits,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Stats',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        icon: Icons.directions_walk,
                        value: todaySteps.toString(),
                        label: 'Steps',
                      ),
                      _StatItem(
                        icon: Icons.straighten,
                        value: '${todayDistance.toStringAsFixed(2)} km',
                        label: 'Distance',
                      ),
                      _StatItem(
                        icon: Icons.eco,
                        value: (todayCredits * 1000).toStringAsFixed(3),
                        label: 'Atoms',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: currentActivity == null
                        ? ElevatedButton.icon(
                            onPressed: () => ref
                                .read(walkActivityProvider.notifier)
                                .startWalking(),
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Start Walking'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: () async {
                              await ref
                                  .read(walkActivityProvider.notifier)
                                  .stopWalking();
                              // Trigger a UI rebuild by setting the currentActivity to null
                              ref.refresh(walkActivityProvider);
                            },
                            icon: const Icon(Icons.stop),
                            label: const Text('Stop Walking'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 16),
          Text(
            'Activity Status',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentActivity != null) ...[
                    _StatusItem(
                      icon: Icons.timer,
                      label: 'Started at',
                      value: _formatDateTime(currentActivity!.startTime),
                    ),
                    const SizedBox(height: 8),
                    if (currentActivity.endTime != null)
                      _StatusItem(
                        icon: Icons.timer_off,
                        label: 'Ended at',
                        value: _formatDateTime(currentActivity.endTime!),
                      ),
                  ] else
                    const Center(
                      child: Text(
                        'Start walking to track your activity!',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity History',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // Makes the modal larger
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.7,
                      minChildSize: 0.5,
                      maxChildSize: 0.95,
                      expand: false,
                      builder: (_, scrollController) => Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Text(
                              'All Activities',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: allActivities.length,
                              itemBuilder: (context, index) {
                                final activity = allActivities[index];
                                return ListTile(
                                  leading: const Icon(Icons.directions_walk),
                                  title: Text(
                                    '${activity.steps} steps (${activity.distance.toStringAsFixed(2)} km)',
                                  ),
                                  subtitle: Text(
                                    '${_formatDateTime(activity.startTime)} - ${activity.endTime != null ? _formatDateTime(activity.endTime!) : 'Ongoing'}',
                                  ),
                                  trailing: Text(
                                    '${activity.carbonCredits.toStringAsFixed(3)} credits',
                                    style: const TextStyle(
                                      color: Color(0xFF1B5E20),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),
          Card(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allActivities.take(5).length, // Show only latest 5
              itemBuilder: (context, index) {
                final activity =
                    allActivities[index]; // Already sorted by latest
                return ListTile(
                  leading: const Icon(Icons.directions_walk),
                  title: Text(
                    '${activity.steps} steps (${activity.distance.toStringAsFixed(2)} km)',
                  ),
                  subtitle: Text(
                    '${_formatDateTime(activity.startTime)} - ${activity.endTime != null ? _formatDateTime(activity.endTime!) : 'Ongoing'}',
                  ),
                  trailing: Text(
                    '${(activity.carbonCredits * 1000).toStringAsFixed(3)} Atoms',
                    style: const TextStyle(
                      color: Color(0xFF1B5E20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatusItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
