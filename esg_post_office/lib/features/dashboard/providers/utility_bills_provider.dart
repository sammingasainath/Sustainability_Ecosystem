import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'utility_bills_provider.g.dart';

@riverpod
class UtilityBillsNotifier extends _$UtilityBillsNotifier {
  @override
  Future<Map<String, double>> build() async {
    return _fetchUtilityBills();
  }

  Future<Map<String, double>> _fetchUtilityBills() async {
    try {
      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Get user's post office ID
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final postOfficeId = userDoc.data()?['postOfficeId'];
      if (postOfficeId == null) throw Exception('Post office ID not found');

      // Reference to the post office document
      final postOfficeRef = FirebaseFirestore.instance
          .collection('postOffices')
          .doc(postOfficeId);

      // Fetch bills from each subcollection
      final electricityBills =
          await postOfficeRef.collection('electricityBills').get();

      final waterBills = await postOfficeRef.collection('waterBills').get();

      final fuelBills = await postOfficeRef.collection('fuelBills').get();

      // Calculate total units for each utility
      double totalElectricityUnits = 0;
      double totalWaterUnits = 0;
      double totalFuelUnits = 0;

      for (var doc in electricityBills.docs) {
        final data = doc.data();
        final units = data['unitsConsumed'];
        if (units != null) {
          totalElectricityUnits += (units as num).toDouble();
        }
      }

      for (var doc in waterBills.docs) {
        final data = doc.data();
        final units = data['unitsConsumed'];
        if (units != null) {
          totalWaterUnits += (units as num).toDouble();
        }
      }

      for (var doc in fuelBills.docs) {
        final data = doc.data();
        final units = data['litresConsumed'];
        if (units != null) {
          totalFuelUnits += (units as num).toDouble();
        }
      }

      print('Fetched utility bills:');
      print('Electricity: $totalElectricityUnits kWh');
      print('Water: $totalWaterUnits L');
      print('Fuel: $totalFuelUnits L');

      return {
        'electricity': totalElectricityUnits,
        'water': totalWaterUnits,
        'fuel': totalFuelUnits,
      };
    } catch (e) {
      print('Error fetching utility bills: $e');
      rethrow;
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
