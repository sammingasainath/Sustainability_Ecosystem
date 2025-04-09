import 'package:esg_post_office/features/image_to_json/presentation/widgets/image_to_json_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esg_post_office/features/auth/presentation/providers/auth_provider.dart';

class PublicTransportPage extends ConsumerStatefulWidget {
  const PublicTransportPage({super.key});

  @override
  ConsumerState<PublicTransportPage> createState() =>
      _PublicTransportPageState();
}

class _PublicTransportPageState extends ConsumerState<PublicTransportPage> {
  Map<String, dynamic>? _pendingTicketData;
  bool _isProcessing = false;
  Stream<QuerySnapshot>? _activitiesStream;

  @override
  void initState() {
    super.initState();
    _setupStream();
  }

  void _setupStream() {
    final user = ref.read(authStateProvider).value;
    if (user != null) {
      _activitiesStream = FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .collection('travelActivities')
          .orderBy('timestamp', descending: true)
          .where('type', isEqualTo: 'bus')
          .snapshots();
    }
  }

  void _handleBusTicket(Map<String, dynamic> jsonResponse) {
    // Use post-frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _pendingTicketData = jsonResponse;
          _isProcessing = false; // Reset processing state for new ticket
        });
      }
    });
  }

  Future<void> _processTicket() async {
    if (_pendingTicketData == null || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) {
        setState(() {
          _pendingTicketData = null;
          _isProcessing = false;
        });
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .get();

      if (!userDoc.exists) {
        setState(() {
          _pendingTicketData = null;
          _isProcessing = false;
        });
        return;
      }

      final distanceToOffice =
          userDoc.data()?['distanceToOffice'] as double? ?? 0;
      final vehicleType = userDoc.data()?['vehicleType'] as String? ?? '';
      final vehicleMileage = userDoc.data()?['vehicleMileage'] as double? ?? 0;

      // Get distance from JSON response
      final distance =
          (_pendingTicketData!['distance'] as num?)?.toDouble() ?? 0;

      // Use the smaller of actual distance or distance to office
      final effectiveDistance =
          distance < distanceToOffice ? distance : distanceToOffice;

      // Calculate CO2 emissions saved
      double emissionsSaved = 0;
      if (vehicleType.isNotEmpty && vehicleMileage > 0) {
        // Emission factors in kg CO2 per liter
        final emissionFactors = {
          'Petrol': 2.31,
          'Diesel': 2.68,
          'CNG': 1.89,
          'Electric': 0.0,
        };

        final emissionFactor = emissionFactors[vehicleType] ?? 2.31;
        final litersPerKm = 1 / vehicleMileage;
        emissionsSaved = effectiveDistance * litersPerKm * emissionFactor;
      }

      // Convert emissions to carbon credits (1 credit per 1000kg CO2)
      // Only give 82% of the calculated credits
      final carbonCredits = (emissionsSaved / 1000) * 0.82;

      // Store travel activity as a subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .collection('travelActivities')
          .add({
        'timestamp': FieldValue.serverTimestamp(),
        'distance': effectiveDistance,
        'emissionsSaved': emissionsSaved,
        'carbonCredits': carbonCredits,
        'type': 'bus',
      });

      // Update user's total carbon credits
      await FirebaseFirestore.instance.collection('users').doc(user.id).update({
        'carbonCredits': FieldValue.increment(carbonCredits),
      });

      // Clear the pending ticket data to hide the confirmation UI
      if (mounted) {
        setState(() {
          _pendingTicketData = null;
          _isProcessing = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Bus ticket processed! Earned ${carbonCredits.toStringAsFixed(3)} carbon credits'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _pendingTicketData = null;
          _isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to process ticket. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Transport'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _activitiesStream,
        builder: (context, snapshot) {
          // Calculate stats from activities
          int totalTrips = 0;
          double totalCO2Saved = 0;
          double totalCredits = 0;

          if (snapshot.hasData) {
            final activities = snapshot.data!.docs;
            totalTrips = activities.length;
            for (var doc in activities) {
              final data = doc.data() as Map<String, dynamic>;
              totalCO2Saved +=
                  (data['emissionsSaved'] as num?)?.toDouble() ?? 0;
              totalCredits += (data['carbonCredits'] as num?)?.toDouble() ?? 0;
            }
          }

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
                          'Transport Stats',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(
                              icon: Icons.directions_bus,
                              value: totalTrips.toString(),
                              label: 'Trips',
                            ),
                            _StatItem(
                              icon: Icons.co2,
                              value: '${totalCO2Saved.toStringAsFixed(1)} kg',
                              label: 'CO₂ Saved',
                            ),
                            _StatItem(
                              icon: Icons.eco,
                              value: (totalCredits * 1000).toStringAsFixed(2),
                              label: 'Atoms',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Transport Options',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        const ListTile(
                          leading: Icon(Icons.directions_bus),
                          title: Text('Bus'),
                          subtitle: Text('Earn Atoms per trip'),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Upload Bus Ticket',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        ImageToJsonWidget(
                          key: ValueKey(_pendingTicketData == null),
                          customPrompt:
                              "Give distance travelled in km in JSON response, it should be in the format of {'distance': 10} and it is found after the text : KMs ussualy ",
                          onJsonResult: _handleBusTicket,
                        ),
                        if (_pendingTicketData != null) ...[
                          const SizedBox(height: 16),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Detected Distance: ${_pendingTicketData!['distance']} km',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed:
                                        _isProcessing ? null : _processTicket,
                                    icon: _isProcessing
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          )
                                        : const Icon(Icons.check),
                                    label: Text(_isProcessing
                                        ? 'Processing...'
                                        : 'Confirm and Process Ticket'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Recent Trips',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                if (!snapshot.hasData)
                  const Center(child: CircularProgressIndicator())
                else if (snapshot.data!.docs.isEmpty)
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.history),
                      title: Text('No recent trips'),
                      subtitle:
                          Text('Start using public transport to earn credits!'),
                    ),
                  )
                else
                  Column(
                    children: snapshot.data!.docs.take(5).map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final timestamp =
                          (data['timestamp'] as Timestamp?)?.toDate() ??
                              DateTime.now();
                      final distance =
                          (data['distance'] as num?)?.toDouble() ?? 0;
                      final credits =
                          (data['carbonCredits'] as num?)?.toDouble() ?? 0;

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.directions_bus),
                          title: Text(
                              'Bus Trip - ${distance.toStringAsFixed(1)} km'),
                          subtitle: Text(
                              '${(credits * 1000).toStringAsFixed(2)} atoms earned\n${timestamp.toString().split('.')[0]}'),
                          isThreeLine: true,
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
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
