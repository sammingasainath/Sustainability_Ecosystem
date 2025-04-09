import 'package:esg_post_office/features/record/presentation/pages/solar_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esg_post_office/features/record/presentation/pages/electricity_bill_page.dart';
import 'package:esg_post_office/features/record/presentation/pages/water_bill_page.dart';
import 'package:esg_post_office/features/record/presentation/pages/fuel_bill_page.dart';

class RecordPage extends ConsumerWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Bills'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select Bill Type',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _BillTypeCard(
              title: 'Electricity Bill',
              icon: Icons.electric_bolt,
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ElectricityBillPage(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _BillTypeCard(
              title: 'Water Bill',
              icon: Icons.water_drop,
              color: Colors.cyan,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WaterBillPage(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _BillTypeCard(
              title: 'Fuel Bill',
              icon: Icons.local_gas_station,
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FuelBillPage(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _BillTypeCard(
              title: 'Solar Panel',
              icon: Icons.qr_code_scanner_rounded,
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SolarPanelPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillTypeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _BillTypeCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
