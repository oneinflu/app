import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influnew/app_theme.dart';
import 'package:influnew/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class PanVerificationScreen extends StatefulWidget {
  const PanVerificationScreen({super.key});

  @override
  State<PanVerificationScreen> createState() => _PanVerificationScreenState();
}

class _PanVerificationScreenState extends State<PanVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _panController = TextEditingController();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userData = _authProvider.user.value;
    if (userData != null) {
      // Auto-populate name from user data
      _nameController.text = userData['name'] ?? '';
      
      // Auto-populate and format DOB from user data
      if (userData['dob'] != null) {
        try {
          // Parse the DOB and format it to DD/MM/YYYY
          DateTime dobDate = DateTime.parse(userData['dob']);
          String formattedDob = DateFormat('dd/MM/yyyy').format(dobDate);
          _dobController.text = formattedDob;
        } catch (e) {
          print('Error parsing DOB: $e');
        }
      }
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dobController.text.isNotEmpty 
          ? DateFormat('dd/MM/yyyy').parse(_dobController.text)
          : DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Birth',
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        _dobController.text = formattedDate;
      });
    }
  }

  @override
  void dispose() {
    _panController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _verifyPan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
  
    setState(() {
      _isLoading = true;
    });
  
    try {
      // Keep the original DD/MM/YYYY format as the API expects it
      String dobForApi = _dobController.text.trim();
      
      print('=== PAN Verification Request ===');
      print('PAN: ${_panController.text.trim()}');
      print('Name: ${_nameController.text.trim()}');
      print('DOB: $dobForApi');
      
      final result = await _authProvider.verifyPan(
        _panController.text.trim().toUpperCase(),
        _nameController.text.trim(),
        dobForApi, // Use original DD/MM/YYYY format
      );
  
      setState(() {
        _isLoading = false;
      });
  
      print('Verification result: $result');
  
      if (result['success']) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'PAN verification completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'PAN verification failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      print('PAN verification exception: $e');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'PAN Verification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Enter your PAN details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Verify your PAN card to complete your profile.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _panController,
                textCapitalization: TextCapitalization.characters,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: 'PAN Number',
                  hintText: 'Enter 10-character PAN number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.account_balance_wallet),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your PAN number';
                  }
                  if (value.length != 10) {
                    return 'PAN number must be 10 characters';
                  }
                  // Basic PAN format validation
                  final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
                  if (!panRegex.hasMatch(value)) {
                    return 'Please enter a valid PAN number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Name as per PAN',
                  hintText: 'Enter name exactly as on PAN card',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name as per PAN';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                onTap: _selectDate,
                decoration: InputDecoration(
                  labelText: 'Date of Birth (as per PAN)',
                  hintText: 'DD/MM/YYYY',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: const Icon(Icons.edit_calendar),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your date of birth';
                  }
                  // Validate date format
                  try {
                    DateFormat('dd/MM/yyyy').parse(value);
                  } catch (e) {
                    return 'Please enter a valid date (DD/MM/YYYY)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyPan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Verify PAN',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}