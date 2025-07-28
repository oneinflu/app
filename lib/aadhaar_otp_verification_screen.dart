import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influnew/app_theme.dart';
import 'package:influnew/providers/auth_provider.dart';

class AadhaarOtpVerificationScreen extends StatefulWidget {
  final String referenceId;
  final String aadhaarNumber;
  final String transactionId;

  const AadhaarOtpVerificationScreen({
    super.key,
    required this.referenceId,
    required this.aadhaarNumber,
    required this.transactionId,
  });

  @override
  State<AadhaarOtpVerificationScreen> createState() =>
      _AadhaarOtpVerificationScreenState();
}

class _AadhaarOtpVerificationScreenState
    extends State<AadhaarOtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authProvider.verifyAadhaarOtp(
        widget.referenceId,
        _otpController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        // Show success message with user details
        final userData = result['data'];
        _showSuccessDialog(userData);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Verification failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccessDialog(Map<String, dynamic>? userData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aadhaar Verified Successfully!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userData != null) ...[
                Text('Name: ${userData['name'] ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Date of Birth: ${userData['date_of_birth'] ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Gender: ${userData['gender'] ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Status: ${userData['status'] ?? 'N/A'}'),
              ],
              const SizedBox(height: 16),
              const Text(
                'Your Aadhaar has been successfully verified.',
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
                Navigator.of(context).pop(); // Go back to verification screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
          'Verify Aadhaar OTP',
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
                'Enter OTP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'We have sent a 6-digit OTP to your Aadhaar registered mobile number for ${widget.aadhaarNumber.replaceRange(4, 8, 'XXXX')}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  hintText: 'Enter 6-digit OTP',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the OTP';
                  }
                  if (value.length != 6) {
                    return 'OTP must be 6 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text(
                            'Verify OTP',
                            style: TextStyle(fontSize: 16, color: Colors.white),
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
