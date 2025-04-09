import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:esg_post_office/features/auth/presentation/providers/auth_provider.dart';
import 'package:esg_post_office/features/carbon_credits/presentation/models/lat_lng.dart';
import 'package:esg_post_office/features/carbon_credits/presentation/pages/walk_and_earn_page.dart';
import 'package:esg_post_office/features/carbon_credits/presentation/pages/public_transport_page.dart';

class CarbonCreditsPage extends ConsumerStatefulWidget {
  const CarbonCreditsPage({super.key});

  @override
  ConsumerState<CarbonCreditsPage> createState() => _CarbonCreditsPageState();
}

class _CarbonCreditsPageState extends ConsumerState<CarbonCreditsPage> {
  bool _isLoading = false;
  final _mileageController = TextEditingController();
  String? _selectedVehicleType;
  Position? _currentPosition;
  double? _distance;
  bool _locationError = false;
  String? _errorMessage;

  final List<String> _vehicleTypes = ['Petrol', 'Diesel', 'Electric', 'CNG'];

  @override
  void dispose() {
    _mileageController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _locationError = false;
      _errorMessage = null;
    });

    try {
      print('DEBUG: Checking location services...');
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }
      print('DEBUG: Location services are enabled');

      print('DEBUG: Requesting location permission...');
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }
      print('DEBUG: Location permission granted: $permission');

      print('DEBUG: Getting current position...');
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print(
          'DEBUG: Current position obtained: ${position.latitude}, ${position.longitude}');
      setState(() => _currentPosition = position);

      final user = ref.read(authStateProvider).value;
      if (user == null) throw Exception('User not found');
      print('DEBUG: User found with postOfficeId: ${user.postOfficeId}');

      print('DEBUG: Making API call to get post office location...');
      final response = await http.get(
        Uri.parse(
            'https://api.olamaps.io/places/v1/geocode?address=${user.postOfficeId.substring(6)} post office ${user.pincode}&language=hi&api_key=7S6iKlbHxNGCdcb8pdIrDnbwIIU8IoBG74TMC93i'),
      );
      print('DEBUG: API Response status code: ${response.statusCode}');
      debugPrint('DEBUG: API Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('DEBUG: Decoded API response: $data');

        final postOfficeLocation = LatLng(
          data['geocodingResults'][0]['geometry']['location']['lat'] as double,
          data['geocodingResults'][0]['geometry']['location']['lng'] as double,
        );
        print(
            'DEBUG: Post office location: ${postOfficeLocation.latitude}, ${postOfficeLocation.longitude}');

        print('DEBUG: Making route API call...');
        final routeResponse = await http.post(
          Uri.parse(
            'https://api.olamaps.io/routing/v1/directions?origin=${position.latitude},${position.longitude}&destination=${postOfficeLocation.latitude},${postOfficeLocation.longitude}&api_key=7S6iKlbHxNGCdcb8pdIrDnbwIIU8IoBG74TMC93i',
          ),
        );
        print(
            'DEBUG: Route API Response status code: ${routeResponse.statusCode}');
        print('DEBUG: Route API Response body: ${routeResponse.body}');

        if (routeResponse.statusCode == 200) {
          final routeData = json.decode(routeResponse.body);
          print('DEBUG: Decoded route response: $routeData');

          setState(() {
            _distance = routeData['routes'][0]['legs'][0]['distance'] / 1000;
          });
          print('DEBUG: Distance calculated: $_distance km');

          await ref.read(authStateProvider.notifier).updateUserProfile(
                userId: user.id,
                isEmployee: user.isEmployee,
                homeLatitude: position.latitude,
                homeLongitude: position.longitude,
                distanceToOffice: _distance,
              );
          print('DEBUG: User profile updated successfully');
        } else {
          throw Exception('Failed to get route: ${routeResponse.statusCode}');
        }
      } else {
        throw Exception(
            'Failed to get post office location: ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG: Error occurred: $e');
      setState(() {
        _locationError = true;
        _errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      print('DEBUG: Finishing location fetch process');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveVehicleDetails() async {
    if (_mileageController.text.isEmpty || _selectedVehicleType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (_distance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please get your location first')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw Exception('User not found');

      await ref.read(authStateProvider.notifier).updateUserProfile(
            userId: user.id,
            isEmployee: user.isEmployee,
            vehicleMileage: double.parse(_mileageController.text),
            vehicleType: _selectedVehicleType,
            homeLatitude: _currentPosition?.latitude,
            homeLongitude: _currentPosition?.longitude,
            distanceToOffice: _distance,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehicle details saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) return const SizedBox();

        final hasRequiredData = user.distanceToOffice != null &&
            user.vehicleMileage != null &&
            user.vehicleType != null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Carbon Credits'),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              ref.refresh(authStateProvider);
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child:
                  hasRequiredData ? _buildDataDisplay(user) : _buildDataInput(),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildDataDisplay(user) {
    final carbonFootprint = _calculateCarbonFootprint(
      distance: user.distanceToOffice!,
      mileage: user.vehicleMileage!,
      vehicleType: user.vehicleType!,
    );

    // Format carbon credits for better readability
    final formattedCarbonCredits = _formatNumber(user.carbonCredits ?? 0);
    final formattedEmissions = _formatNumber((user.carbonCredits ?? 0) * 1000);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.eco,
                        size: 48,
                        color: Color(0xFF1B5E20),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${carbonFootprint.toStringAsFixed(1)}',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: const Color(0xFF1B5E20),
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        'Potential Daily CO₂ Savings',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.stars,
                        size: 48,
                        color: Color(0xFF1B5E20),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        formattedCarbonCredits,
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: const Color(0xFF1B5E20),
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        'Carbon Credits',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                      ),
                      if ((user.carbonCredits ?? 0) < 1) ...[
                        const SizedBox(height: 8),
                        Text(
                          '(${(user.carbonCredits ?? 0).toStringAsFixed(8)})',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 10,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                icon: Icons.directions_car,
                title: 'Vehicle Type',
                value: user.vehicleType!,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                icon: Icons.speed,
                title: 'Mileage',
                value: '${user.vehicleMileage?.toStringAsFixed(1)} km/l',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          icon: Icons.route,
          title: 'Daily Travel Distance',
          value: '${(user.distanceToOffice! * 2).toStringAsFixed(1)} km',
          subtitle: '(Round trip)',
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Environmental Impact',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                _buildImpactRow(
                  'Monthly CO₂ Emissions',
                  '${(carbonFootprint * 30).toStringAsFixed(1)} kg',
                ),
                const SizedBox(height: 8),
                _buildImpactRow(
                  'Yearly CO₂ Emissions',
                  '${(carbonFootprint * 365).toStringAsFixed(1)} kg',
                ),
                const SizedBox(height: 8),
                _buildImpactRow(
                  'Trees needed to offset',
                  '${(carbonFootprint * 365 / 22).round()}',
                  tooltip: 'Average tree absorbs 22 kg CO₂ per year',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emissions Analysis',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: CircularProgressIndicator(
                          value: (user.carbonCredits ?? 0) /
                              (carbonFootprint / 1000),
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF1B5E20)),
                          strokeWidth: 12,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${((user.carbonCredits ?? 0) / (carbonFootprint / 1000) * 100).toStringAsFixed(1)}%',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1B5E20),
                                ),
                          ),
                          const Text(
                            'Progress',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildImpactRow(
                  'Potential Daily CO₂ Savings',
                  '${_formatNumber(carbonFootprint)} kg',
                ),
                // _buildImpactRow(
                //   'Equivalent CO₂ from Credits',
                //   '$formattedEmissions kg',
                //   tooltip: 'CO₂ equivalent (1 credit = 1000kg CO₂)',
                // ),
                _buildImpactRow(
                  'Carbon Atoms',
                  '$formattedEmissions Atoms',
                  tooltip: 'CO₂ equivalent (1 credit = 1000kg CO₂)',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.eco,
                      color: Color(0xFF1B5E20),
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Earn Atoms',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildEarnOptionCard(
                        context,
                        icon: Icons.directions_walk,
                        title: 'Walk & Earn',
                        subtitle: 'Earn atoms by walking to work',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WalkAndEarnPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildEarnOptionCard(
                        context,
                        icon: Icons.directions_bus,
                        title: 'Public Transport',
                        subtitle: 'Use public transport to earn atoms',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PublicTransportPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF1B5E20)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImpactRow(String label, String value, {String? tooltip}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (tooltip != null) ...[
                    const SizedBox(width: 4),
                    Tooltip(
                      message: tooltip,
                      child: const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDataInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step 1: Get Location',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'We need your location to calculate the distance to your post office.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _getCurrentLocation,
                  icon: const Icon(Icons.location_on),
                  label: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Get Current Location'),
                ),
                if (_locationError && _errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                if (_distance != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Distance to office: ${_distance?.toStringAsFixed(2)} km',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step 2: Vehicle Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _mileageController,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Mileage (km/l)',
                    prefixIcon: Icon(Icons.speed),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Type',
                    prefixIcon: Icon(Icons.directions_car),
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedVehicleType,
                  items: _vehicleTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedVehicleType = value),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveVehicleDetails,
                  icon: const Icon(Icons.save),
                  label: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Vehicle Details'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _calculateCarbonFootprint({
    required double distance,
    required double mileage,
    required String vehicleType,
  }) {
    // CO2 emissions in kg/L for different fuel types
    const emissionFactors = {
      'Petrol': 2.31,
      'Diesel': 2.68,
      'CNG': 1.89,
      'Electric': 0.0,
    };

    if (vehicleType == 'Electric') return 0.0;

    // Calculate daily fuel consumption in liters
    final fuelConsumption = (distance * 2) / mileage; // *2 for round trip

    // Calculate daily CO2 emissions in kg
    return fuelConsumption * (emissionFactors[vehicleType] ?? 2.31);
  }

  // Helper method to format large numbers
  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    } else if (number >= 1) {
      return number.toStringAsFixed(2);
    } else {
      // For very small numbers, use scientific notation
      return number.toStringAsFixed(3);
    }
  }

  Widget _buildEarnOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: const Color(0xFF1B5E20),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
