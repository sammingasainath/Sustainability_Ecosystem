import 'package:cloud_firestore/cloud_firestore.dart';

class BillsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitElectricityBill({
    required String postOfficeId,
    required Map<String, dynamic> billData,
  }) async {
    final String documentId = '${billData['billingMonth']}_${billData['year']}';
    final billsRef = _firestore
        .collection('postOffices')
        .doc(postOfficeId)
        .collection('electricityBills');

    // Check if bill for this month already exists
    final existingBill = await billsRef.doc(documentId).get();
    if (existingBill.exists) {
      throw Exception('Electricity bill for ${billData['billingMonth']} ${billData['year']} already exists');
    }

    // Add timestamp to bill data
    final dataToSubmit = {
      ...billData,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await billsRef.doc(documentId).set(dataToSubmit);
  }

  Future<void> submitWaterBill({
    required String postOfficeId,
    required Map<String, dynamic> billData,
  }) async {
    // Create a document ID based on billing period
    final String documentId = '${billData['billingPeriodStart']}_${billData['billingPeriodEnd']}';
    final billsRef = _firestore
        .collection('postOffices')
        .doc(postOfficeId)
        .collection('waterBills');

    // Check if bill for this period already exists
    final existingBill = await billsRef.doc(documentId).get();
    if (existingBill.exists) {
      throw Exception('Water bill for this period already exists');
    }

    // Add timestamp to bill data
    final dataToSubmit = {
      ...billData,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await billsRef.doc(documentId).set(dataToSubmit);
  }

  Future<void> submitFuelBill({
    required String postOfficeId,
    required Map<String, dynamic> billData,
  }) async {
    // Create a document ID based on bill number
    final String documentId = billData['billNumber'];
    final billsRef = _firestore
        .collection('postOffices')
        .doc(postOfficeId)
        .collection('fuelBills');

    // Check if bill already exists
    final existingBill = await billsRef.doc(documentId).get();
    if (existingBill.exists) {
      throw Exception('Fuel bill with number ${billData['billNumber']} already exists');
    }

    // Add timestamp to bill data
    final dataToSubmit = {
      ...billData,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await billsRef.doc(documentId).set(dataToSubmit);
  }
} 