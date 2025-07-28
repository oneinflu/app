import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:influnew/home_screen.dart';
import 'package:influnew/role_selection_screen.dart';
import 'package:influnew/login_screen.dart';
import 'app_theme.dart';
import 'providers/auth_provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _storage = const FlutterSecureStorage();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  Timer? _timer;
  final AuthProvider _authProvider = Get.find<AuthProvider>();

  bool _isLoading = false;
  bool _isResendEnabled = false;
  String _errorMessage = '';
  int _remainingSeconds = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isResendEnabled = false;
      _remainingSeconds = 30;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isResendEnabled = true;
        });
      }
    });
  }

  Future<void> _resendOtp() async {
    if (!_isResendEnabled) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await _authProvider.sendOtp(widget.phoneNumber);

      if (result['success']) {
        // Clear existing OTP fields
        for (var controller in _otpControllers) {
          controller.clear();
        }
        FocusScope.of(context).requestFocus(_focusNodes[0]);
        _startTimer();
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to resend OTP';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onOtpDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    // Check if all digits are entered
    if (_getOtpValue().length == 6) {
      _verifyOtp();
    }
  }

  void _onKeyEvent(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace &&
          _otpControllers[index].text.isEmpty &&
          index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  String _getOtpValue() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOtp() async {
    final otp = _getOtpValue();
    if (otp.length != 6) {
      setState(() {
        _errorMessage = 'Please enter a valid 6-digit OTP';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await _authProvider.verifyOtp(widget.phoneNumber, otp);

      if (!result['success']) {
        setState(() {
          _errorMessage = result['message'] ?? 'Verification failed';
          // Clear OTP fields on failure
          for (var controller in _otpControllers) {
            controller.clear();
          }
          FocusScope.of(context).requestFocus(_focusNodes[0]);
        });
        return;
      }

      // Handle successful verification
      if (result['token'] != null) {
        await _storage.write(key: 'auth_token', value: result['token']);
      }

      if (mounted) {
        if (result['isNewUser'] == true) {
          Get.off(
            () => RoleSelectionScreen(phoneNumber: widget.phoneNumber),
            transition: Transition.rightToLeft,
          );
        } else {
          Get.offAll(
            () => const HomeScreen(),
            transition: Transition.rightToLeft,
          );
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
              onPressed: () {
                Get.to(() => LoginScreen());
              },
              child: const Text(
                'Help?',
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'OTP was sent to ${widget.phoneNumber}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.primaryPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
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
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppTheme.primaryPurple,
                            ),
                          ),
                        ),
                        onChanged: (value) => _onOtpDigitChanged(index, value),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: _isResendEnabled ? _resendOtp : null,
                    child: Text(
                      _isResendEnabled
                          ? 'Resend OTP'
                          : 'Resend OTP in ${_remainingSeconds}s',
                      style: TextStyle(
                        color:
                            _isResendEnabled
                                ? AppTheme.primaryPurple
                                : Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Center(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryPurple,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
