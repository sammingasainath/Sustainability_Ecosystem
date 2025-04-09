import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:esg_post_office/features/auth/presentation/providers/auth_provider.dart';
import 'package:esg_post_office/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:restart_app/restart_app.dart';

class CompleteProfilePage extends ConsumerStatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  ConsumerState<CompleteProfilePage> createState() =>
      _CompleteProfilePageState();
}

class _CompleteProfilePageState extends ConsumerState<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEmployee = false;
  bool _isLoading = false;
  String? _employeeRole;
  String? _gender;
  bool? _isPhysicallyChallenged;
  String? _casteCategory;
  String? _employmentType;
  String? _vendorName;

  final List<String> _employeeRoles = [
    'Postmaster',
    'Postal Assistant',
    'Mail Guard',
    'Mail Carrier',
    'Other',
  ];

  final List<String> _genders = ['Male', 'Female', 'Other'];

  final List<String> _casteCategories = [
    'General',
    'OBC',
    'SC',
    'ST',
    'Other',
  ];

  final List<String> _employmentTypes = [
    'Permanent',
    'Contractual',
  ];

  final List<String> _availableResponsibilities = [
    'electricity',
    'water',
    'fuel',
    'others'
  ];
  final List<String> _selectedResponsibilities = [];

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw Exception('User not found');

      await ref.read(authStateProvider.notifier).updateUserProfile(
            userId: user.id,
            isEmployee: _isEmployee,
            employeeRole: _employeeRole,
            gender: _gender,
            isPhysicallyChallenged: _isPhysicallyChallenged,
            casteCategory: _casteCategory,
            employmentType: _employmentType,
            vendorName: _vendorName,
            responsibilities: _selectedResponsibilities,
          );

      Restart.restartApp();

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const DashboardPage(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SwitchListTile(
                title: const Text('Are you an employee?'),
                value: _isEmployee,
                onChanged: (value) => setState(() {
                  _isEmployee = value;
                  if (!value) {
                    _employeeRole = null;
                    _gender = null;
                    _isPhysicallyChallenged = null;
                    _casteCategory = null;
                    _employmentType = null;
                    _vendorName = null;
                  }
                }),
              ),
              if (_isEmployee) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Employee Role',
                    prefixIcon: Icon(Icons.work),
                  ),
                  value: _employeeRole,
                  items: _employeeRoles
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _employeeRole = value),
                  validator: (value) {
                    if (_isEmployee && value == null) {
                      return 'Please select your role';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  value: _gender,
                  items: _genders
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _gender = value),
                  validator: (value) {
                    if (_isEmployee && value == null) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Are you physically challenged?'),
                  value: _isPhysicallyChallenged ?? false,
                  onChanged: (value) =>
                      setState(() => _isPhysicallyChallenged = value),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Caste Category',
                    prefixIcon: Icon(Icons.category),
                  ),
                  value: _casteCategory,
                  items: _casteCategories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _casteCategory = value),
                  validator: (value) {
                    if (_isEmployee && value == null) {
                      return 'Please select your caste category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Employment Type',
                    prefixIcon: Icon(Icons.business_center),
                  ),
                  value: _employmentType,
                  items: _employmentTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() {
                    _employmentType = value;
                    if (value != 'Contractual') {
                      _vendorName = null;
                    }
                  }),
                  validator: (value) {
                    if (_isEmployee && value == null) {
                      return 'Please select your employment type';
                    }
                    return null;
                  },
                ),
                if (_employmentType == 'Contractual') ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Vendor Name',
                      prefixIcon: Icon(Icons.business),
                    ),
                    onChanged: (value) => _vendorName = value,
                    validator: (value) {
                      if (_employmentType == 'Contractual' &&
                          (value == null || value.isEmpty)) {
                        return 'Please enter vendor name';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 16),
                const Text('Responsibilities:', style: TextStyle(fontSize: 16)),
                ...(_availableResponsibilities.map((responsibility) =>
                    CheckboxListTile(
                      title: Text(responsibility),
                      value: _selectedResponsibilities.contains(responsibility),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedResponsibilities.add(responsibility);
                          } else {
                            _selectedResponsibilities.remove(responsibility);
                          }
                        });
                      },
                    ))),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                child: _isLoading
                    ? LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 24,
                      )
                    : const Text('Complete Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
