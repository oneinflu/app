import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:influnew/home_screen.dart';
import 'package:influnew/providers/auth_provider.dart';
import 'dart:convert';
import 'app_theme.dart';

class UsernameSetupScreen extends StatefulWidget {
  const UsernameSetupScreen({super.key});

  @override
  State<UsernameSetupScreen> createState() => _UsernameSetupScreenState();
}

class _UsernameSetupScreenState extends State<UsernameSetupScreen> {
  final _usernameController = TextEditingController();
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isLoading = false;
  bool _isChecking = false;
  String _errorMessage = '';
  String _availabilityMessage = '';
  bool _isAvailable = false;

  // Debounce to avoid too many API calls while typing
  final _debounce = Debounce(milliseconds: 500);

  @override
  void dispose() {
    _usernameController.dispose();
    _debounce.dispose();
    super.dispose();
  }

  Future<void> _checkUsernameAvailability(String username) async {
    if (username.isEmpty) {
      setState(() {
        _availabilityMessage = '';
        _isAvailable = false;
      });
      return;
    }

    setState(() {
      _isChecking = true;
      _availabilityMessage = 'Checking availability...';
    });

    try {
      final token = await _storage.read(key: 'auth_token');

      if (token == null) {
        setState(() {
          _errorMessage = 'Authentication error. Please login again.';
          _isChecking = false;
        });
        return;
      }

      final dio = Dio();
      final response = await dio.request(
        'https://api.oneinflu.com/api/users/check-username/$username',
        options: Options(
          method: 'GET',
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          _isAvailable = data['available'] ?? false;
          _availabilityMessage =
              _isAvailable ? 'Username available' : 'Username unavailable';
          _isChecking = false;
        });
      } else {
        setState(() {
          _availabilityMessage = 'Error checking username';
          _isChecking = false;
          _isAvailable = false;
        });
      }
    } catch (e) {
      setState(() {
        _availabilityMessage = 'Error checking username';
        _isChecking = false;
        _isAvailable = false;
      });
      print('Error checking username: $e');
    }
  }

  Future<void> _setUsername() async {
    if (_usernameController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a username';
      });
      return;
    }

    if (!_isAvailable) {
      setState(() {
        _errorMessage = 'Please choose an available username';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final token = await _storage.read(key: 'auth_token');

      if (token == null) {
        setState(() {
          _errorMessage = 'Authentication error. Please login again.';
          _isLoading = false;
        });
        return;
      }

      final dio = Dio();
      final response = await dio.request(
        'https://api.oneinflu.com/api/users/set-username',
        options: Options(
          method: 'PUT',
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: json.encode({"username": _usernameController.text}),
      );

      if (response.statusCode == 200) {
        // Username set successfully, navigate to home screen
        Get.offAll(() => const HomeScreen());
      } else {
        setState(() {
          _errorMessage = 'Failed to set username. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error setting username: ${e.toString()}';
        _isLoading = false;
      });
      print('Error setting username: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Set Your Username',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Choose a unique username for your profile',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),

                // Username input field
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon:
                        _isChecking
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.primaryPurple,
                              ),
                            )
                            : _availabilityMessage.isNotEmpty
                            ? Icon(
                              _isAvailable ? Icons.check_circle : Icons.cancel,
                              color: _isAvailable ? Colors.green : Colors.red,
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    // Use debounce to avoid too many API calls
                    _debounce.run(() {
                      _checkUsernameAvailability(value);
                    });
                  },
                ),

                // Availability message
                if (_availabilityMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                    child: Text(
                      _availabilityMessage,
                      style: TextStyle(
                        color: _isAvailable ? Colors.green : Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),

                // Error message
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),

                const Spacer(),

                // Set Username Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          _isLoading || !_isAvailable ? null : _setUsername,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        disabledBackgroundColor: AppTheme.primaryPurple
                            .withOpacity(0.5),
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'Set Username',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
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
}

// Debounce class to limit API calls while typing
class Debounce {
  final int milliseconds;
  Timer? _timer;

  Debounce({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
