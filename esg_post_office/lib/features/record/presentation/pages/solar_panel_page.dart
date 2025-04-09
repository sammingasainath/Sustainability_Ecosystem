import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SolarPanelPage extends StatefulWidget {
  const SolarPanelPage({super.key});

  @override
  State<SolarPanelPage> createState() => _SolarPanelPageState();
}

class _SolarPanelPageState extends State<SolarPanelPage> {
  final _formKey = GlobalKey<FormState>();
  final _solarUnitsController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _solarUnitsController.dispose();
    super.dispose();
  }

  Future<void> _submitSolarUnits() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Get user's post office ID
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User document not found');
      }

      final postOfficeId = userDoc.data()?['postOfficeId'];
      if (postOfficeId == null) throw Exception('Post office ID not found');

      // Update the post office document with solar units
      await FirebaseFirestore.instance
          .collection('postOffices')
          .doc(postOfficeId)
          .update({
        'solarUnits': double.parse(_solarUnitsController.text),
        'lastSolarUpdateTimestamp': DateTime.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solar units recorded successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _solarUnitsController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solar Power Usage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter the total solar power units (kWh) consumed this month:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _solarUnitsController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Solar Power Units',
                  hintText: 'Enter kWh units',
                  suffixText: 'kWh',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the solar units';
                  }
                  final units = double.tryParse(value);
                  if (units == null) {
                    return 'Please enter a valid number';
                  }
                  if (units < 0) {
                    return 'Units cannot be negative';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitSolarUnits,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Submit',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 