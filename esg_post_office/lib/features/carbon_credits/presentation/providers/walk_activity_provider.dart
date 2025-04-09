import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esg_post_office/features/auth/presentation/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/walk_activity.dart';

final walkActivityProvider =
    StateNotifierProvider<WalkActivityNotifier, AsyncValue<WalkActivity?>>(
        (ref) {
  return WalkActivityNotifier();
});

class WalkActivityNotifier extends StateNotifier<AsyncValue<WalkActivity?>> {
  WalkActivityNotifier() : super(const AsyncValue.data(null));

  late StreamSubscription<StepCount> _stepCountSubscription;
  late StreamSubscription<PedestrianStatus> _pedestrianStatusSubscription;
  bool _isWalking = false;
  int _initialSteps = 0;
  int _currentSteps = 0;
  DateTime? _startTime;

  Future<void> startWalking() async {
    try {
      // Request permission first
      final status = await Permission.activityRecognition.request();
      if (status.isDenied) {
        throw Exception('Activity recognition permission denied');
      }

      state = const AsyncValue.loading();
      _startTime = DateTime.now();

      // Initialize pedometer after permission granted
      await _initPedometer();

      state = AsyncValue.data(WalkActivity(
        steps: 0,
        distance: 0,
        carbonCredits: 0,
        startTime: _startTime!,
        endTime: null,
      ));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> _initPedometer() async {
    try {
      // Initialize pedestrian status stream
      _pedestrianStatusSubscription = Pedometer.pedestrianStatusStream.listen(
        (PedestrianStatus status) {
          _isWalking = status == PedestrianStatus;
        },
        onError: (error) {
          print('Pedestrian status error: $error');
          state = AsyncValue.error(error, StackTrace.current);
        },
      );

      // Initialize step count stream
      _stepCountSubscription = Pedometer.stepCountStream.listen(
        (StepCount event) {
          if (_initialSteps == 0) {
            _initialSteps = event.steps;
          }
          _currentSteps = event.steps;

          // Update state with new step count
          if (state.value != null) {
            final steps = _currentSteps - _initialSteps;
            final distance = steps / 1316; // Average steps per km
            state = AsyncValue.data(state.value!.copyWith(
              steps: steps,
              distance: distance,
            ));
          }
        },
        onError: (error) {
          print('Step count error: $error');
          state = AsyncValue.error(error, StackTrace.current);
        },
      );
    } catch (e) {
      print('Pedometer initialization error: $e');
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> stopWalking() async {
    if (state.value == null) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    final distanceToOffice =
        userDoc.data()?['distanceToOffice'] as double? ?? 0;
    final vehicleType = userDoc.data()?['vehicleType'] as String? ?? '';
    final vehicleMileage = userDoc.data()?['vehicleMileage'] as double? ?? 0;

    final steps = _currentSteps - _initialSteps;
    // Calculate distance based on average step length (using male average for simplicity)
    final distanceInKm = steps / 1316; // Using male average steps per km

    // Use the smaller of actual distance or distance to office
    final effectiveDistance =
        distanceInKm < distanceToOffice ? distanceInKm : distanceToOffice;

    // Calculate CO2 emissions saved (basic calculation)
    double emissionsSaved = 0;
    if (vehicleType.isNotEmpty && vehicleMileage > 0) {
      // Basic formula: distance * emission factor
      // Emission factor varies by vehicle type and mileage
      final emissionFactor = 2.31; // kg CO2 per liter
      final litersPerKm = 1 / vehicleMileage;
      emissionsSaved = effectiveDistance * litersPerKm * emissionFactor;
    }

    // Convert emissions to carbon credits (1 credit per 1000kg CO2)
    final carbonCredits = emissionsSaved / 1000;

    final walkActivity = WalkActivity(
      steps: steps,
      distance: effectiveDistance,
      carbonCredits: carbonCredits,
      startTime: _startTime!,
      endTime: DateTime.now(),
    );

    // Update Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({
      'carbonCredits': FieldValue.increment(carbonCredits),
      'totalSteps': FieldValue.increment(steps),
      'totalDistance': FieldValue.increment(effectiveDistance),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('walkActivities')
        .add(walkActivity.toJson());

    _stopPedometer();
    state = AsyncValue.data(walkActivity);
  }

  void _stopPedometer() {
    _stepCountSubscription.cancel();
    _pedestrianStatusSubscription.cancel();
    _initialSteps = 0;
    _currentSteps = 0;
    _isWalking = false;
    _startTime = null;
  }

  Future<void> _checkPermissions() async {
    if (await Permission.activityRecognition.status.isDenied) {
      await Permission.activityRecognition.request();
    }
  }

  @override
  void dispose() {
    if (state.value != null) {
      _stopPedometer();
    }
    super.dispose();
  }
}

final walkActivitiesProvider = StreamProvider<List<WalkActivity>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.id)
      .collection('walkActivities')
      .orderBy('startTime', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => WalkActivity.fromJson(doc.data()))
          .toList());
});
