import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import '../models/device_info.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isProcessing = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isProcessing || scanData.code == null) return;
      isProcessing = true;

      try {
        print('Raw QR code data: ${scanData.code}');

        // Parse the QR code data as JSON first
        final jsonData = jsonDecode(scanData.code!) as Map<String, dynamic>;
        print('Parsed JSON data: $jsonData');
        print('JSON data type: ${jsonData.runtimeType}');
        print('Fields in JSON:');
        jsonData.forEach((key, value) {
          print('  $key: $value (${value.runtimeType})');
        });

        // Validate required fields
        if (!jsonData.containsKey('device_name') ||
            !jsonData.containsKey('device_id') ||
            !jsonData.containsKey('webhook_url') ||
            !jsonData.containsKey('wattage') ||
            jsonData['device_name'] == null ||
            jsonData['device_id'] == null ||
            jsonData['webhook_url'] == null ||
            jsonData['wattage'] == null) {
          throw Exception('Invalid QR code format: Missing required fields');
        }

        // Validate field types
        if (jsonData['device_name'] is! String ||
            jsonData['device_id'] is! String ||
            jsonData['webhook_url'] is! String ||
            jsonData['wattage'] is! num) {
          throw Exception('Invalid QR code format: Invalid field types');
        }

        print('Creating DeviceInfo object from JSON...');
        final deviceInfo = DeviceInfo.fromJson(jsonData);
        print('DeviceInfo object created: $deviceInfo');

        await _processDeviceInfo(deviceInfo);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing QR code: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      } finally {
        isProcessing = false;
      }
    });
  }

  Future<void> _processDeviceInfo(DeviceInfo deviceInfo) async {
    try {
      // Fire webhook
      final response = await http.post(Uri.parse(deviceInfo.webhookUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to call webhook: ${response.statusCode}');
      }

      // Get current user and their post office ID
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User document not found');
      }

      final postOfficeId = userDoc.data()?['postOfficeId'];
      if (postOfficeId == null) throw Exception('Post office ID not found');

      // Check for existing device entry
      final appliancesRef =
          FirebaseFirestore.instance.collection('appliancesOn');
      final existingDeviceQuery = await appliancesRef
          .where('device_id', isEqualTo: deviceInfo.deviceId)
          .orderBy('on_timestamp', descending: true)
          .limit(1)
          .get();

      final now = DateTime.now();

      if (existingDeviceQuery.docs.isEmpty) {
        // No previous entry exists, create new entry with on_timestamp
        await appliancesRef.add({
          'device_name': deviceInfo.deviceName,
          'device_id': deviceInfo.deviceId,
          'on_timestamp': now,
          'user_id': user.uid,
          'postOfficeId': postOfficeId,
          'wattage': deviceInfo.wattage,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Device turned ON successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Get the most recent entry
        final latestDoc = existingDeviceQuery.docs.first;
        final latestData = latestDoc.data();

        // Check if the latest entry has an off_timestamp
        if (latestData['off_timestamp'] == null) {
          // Device is ON, so turn it OFF
          await latestDoc.reference.update({
            'off_timestamp': now,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Device turned OFF successfully'),
              backgroundColor: Colors.orange,
            ),
          );
        } else {
          // Device was OFF, create new entry to turn it ON
          await appliancesRef.add({
            'device_name': deviceInfo.deviceName,
            'device_id': deviceInfo.deviceId,
            'on_timestamp': now,
            'user_id': user.uid,
            'postOfficeId': postOfficeId,
            'wattage': deviceInfo.wattage,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Device turned ON successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Device QR Code'),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.green,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Scan a QR code containing device information',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
