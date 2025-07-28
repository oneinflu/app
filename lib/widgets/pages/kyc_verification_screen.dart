import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:influnew/widgets/pages/channel_creation_screen.dart';
import 'package:influnew/widgets/pages/store_creation_screen.dart';
import '../../app_theme.dart';
import 'social_media_connection_screen.dart';

class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({Key? key}) : super(key: key);

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idNumberController = TextEditingController();
  String _selectedIdType = 'Aadhaar Card'; // Default selected ID type
  bool _isOtpSent = false;

  // OTP related variables
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  int _focusedIndex = 0;
  int _remainingSeconds = 30; // For "Resent code in 0:30"
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Hide keyboard when screen initializes
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _idNumberController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _onOtpDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
        _focusedIndex = index + 1;
      } else {
        // Last field filled, hide keyboard
        _focusNodes[index].unfocus();
      }
    }
  }

  void _onKeyEvent(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace &&
          _otpControllers[index].text.isEmpty &&
          index > 0) {
        // Move to previous field on backspace if current field is empty
        _focusNodes[index - 1].requestFocus();
        _focusedIndex = index - 1;
      }
    }
  }

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isOtpSent = true;
        _remainingSeconds = 30;
      });

      // Set focus to first OTP field
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNodes[0]);
      });

      // Start countdown timer
      _startTimer();
    }
  }

  // Update the _verifyOtp method in kyc_verification_screen.dart

  void _verifyOtp() {
    // Collect OTP from all fields
    final otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length == 6) {
      // Check which screen navigated to KYC
      final route = ModalRoute.of(context);
      if (route != null && route.settings.arguments != null) {
        final screenType = route.settings.arguments as String;

        if (screenType == 'store') {
          // Navigate to store creation screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const StoreCreationScreen(),
            ),
          );
        } else if (screenType == 'channel') {
          // Navigate to channel creation screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ChannelCreationScreen(),
            ),
          );
        } else {
          // Default to social media connection
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SocialMediaConnectionScreen(),
            ),
          );
        }
      } else {
        // Default to social media connection
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SocialMediaConnectionScreen(),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Help?',
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Title
                const Text(
                  'KYC Verification',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPurple,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                const Text(
                  'Verify your identity to become our partner',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 24),

                if (!_isOtpSent)
                  ..._buildIdVerificationForm()
                else
                  ..._buildOtpVerificationForm(),

                // Bottom indicator
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20, top: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIdVerificationForm() {
    return [
      // ID Type Selection
      const Text(
        'ID Type',
        style: TextStyle(fontSize: 14, color: Colors.black87),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          _buildIdTypeOption('Aadhaar Card'),
          const SizedBox(width: 12),
          _buildIdTypeOption('PAN Card'),
        ],
      ),
      const SizedBox(height: 24),

      // ID Number Field
      Text(
        _selectedIdType == 'Aadhaar Card' ? 'Aadhaar Number' : 'PAN Number',
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
      const SizedBox(height: 4),
      TextFormField(
        controller: _idNumberController,
        keyboardType: TextInputType.text,
        maxLength: _selectedIdType == 'Aadhaar Card' ? 12 : 10,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          hintText:
              _selectedIdType == 'Aadhaar Card'
                  ? '12-digit Aadhaar Number'
                  : '10-digit PAN Number',
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppTheme.primaryPurple),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your ${_selectedIdType == 'Aadhaar Card' ? 'Aadhaar' : 'PAN'} number';
          }
          if (_selectedIdType == 'Aadhaar Card' && value.length != 12) {
            return 'Aadhaar number must be 12 digits';
          }
          if (_selectedIdType == 'PAN Card' && value.length != 10) {
            return 'PAN number must be 10 characters';
          }
          return null;
        },
      ),
      const SizedBox(height: 40),

      // Send OTP Button
      SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _sendOtp,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Send OTP',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildOtpVerificationForm() {
    return [
      // OTP sent message
      Text(
        'OTP sent to your ${_selectedIdType == 'Aadhaar Card' ? 'Aadhaar' : 'PAN'} registered mobile number',
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
      const SizedBox(height: 24),

      // OTP input fields
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          6,
          (index) => SizedBox(
            width: 45,
            height: 45,
            child: TextField(
              controller: _otpControllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color:
                        _focusedIndex == index
                            ? AppTheme.primaryPurple
                            : AppTheme.disabled.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color:
                        _otpControllers[index].text.isNotEmpty
                            ? AppTheme.primaryPurple
                            : AppTheme.disabled.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppTheme.primaryPurple,
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: (value) => _onOtpDigitChanged(index, value),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
        ),
      ),

      const SizedBox(height: 16),

      // Resend code timer
      Center(
        child: Text(
          'Resent code in 0:${_remainingSeconds.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),

      const SizedBox(height: 40),

      // Verify OTP button
      SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _verifyOtp,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Verify OTP',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildIdTypeOption(String idType) {
    final isSelected = _selectedIdType == idType;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIdType = idType;
            _idNumberController
                .clear(); // Clear the field when switching ID types
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryPurple : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isSelected
                      ? AppTheme.primaryPurple
                      : Colors.grey.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              idType,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
