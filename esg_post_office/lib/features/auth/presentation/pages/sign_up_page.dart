import 'package:esg_post_office/core/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:esg_post_office/features/auth/presentation/pages/complete_profile_page.dart';
import 'package:esg_post_office/features/auth/presentation/providers/auth_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esg_post_office/features/auth/domain/models/post_office_model.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();

  final _pincodeController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  List<PostOfficeModel> _postOffices = [];
  PostOfficeModel? _selectedPostOffice;
  bool _isLoadingPostOffices = false;

  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(bottomNavVisibilityProvider.notifier).state = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();

    _pincodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fetchPostOffices(String pincode) async {
    if (pincode.length != 6) return;

    setState(() {
      _isLoadingPostOffices = true;
      _postOffices = [];
      _selectedPostOffice = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://api.postalpincode.in/pincode/$pincode'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0]['Status'] == 'Success') {
          final postOffices = (data[0]['PostOffice'] as List)
              .map((po) => PostOfficeModel.fromJson(po))
              .toList();

          setState(() {
            _postOffices = postOffices;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching post offices: $e')),
      );
    } finally {
      setState(() => _isLoadingPostOffices = false);
    }
  }

  Future<void> _savePostOfficeToFirestore(PostOfficeModel postOffice) async {
    final firestore = FirebaseFirestore.instance;
    final docId = '${postOffice.pincode}${postOffice.name}';

    try {
      final docRef = firestore.collection('postOffices').doc(docId);
      final doc = await docRef.get();

      if (!doc.exists) {
        await docRef.set(postOffice.toJson());
      }
    } catch (e) {
      print('Error saving post office: $e');
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPostOffice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a post office')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _savePostOfficeToFirestore(_selectedPostOffice!);

      await ref.read(authStateProvider.notifier).signUp(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            mobile: _mobileController.text.trim(),
            postOfficeId:
                '${_selectedPostOffice!.pincode}${_selectedPostOffice!.name}',
            pincode: _pincodeController.text.trim(),
            password: _passwordController.text,
          );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const CompleteProfilePage(),
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
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  if (value.length != 10) {
                    return 'Please enter a valid 10-digit mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pincodeController,
                decoration: const InputDecoration(
                  labelText: 'Pincode',
                  prefixIcon: Icon(Icons.pin_drop),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _fetchPostOffices(value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pincode';
                  }
                  if (value.length != 6) {
                    return 'Please enter a valid 6-digit pincode';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_isLoadingPostOffices)
                const Center(child: CircularProgressIndicator())
              else if (_postOffices.isNotEmpty)
                DropdownButtonFormField<PostOfficeModel>(
                  decoration: const InputDecoration(
                    labelText: 'Select Post Office',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  value: _selectedPostOffice,
                  items: _postOffices
                      .map((po) => DropdownMenuItem(
                            value: po,
                            child: Text(po.name),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedPostOffice = value),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a post office';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                child: _isLoading
                    ? LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 24,
                      )
                    : const Text('Sign Up'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Already have an account? Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
