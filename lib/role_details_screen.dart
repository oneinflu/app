import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influnew/providers/auth_provider.dart';
import 'package:influnew/registration_screen.dart';

class RoleDetailsScreen extends StatefulWidget {
  final String phoneNumber;
  final String userType;
  final String tempToken;

  const RoleDetailsScreen({
    super.key,
    required this.phoneNumber,
    required this.userType,
    required this.tempToken,
  });

  @override
  State<RoleDetailsScreen> createState() => _RoleDetailsScreenState();
}

class _RoleDetailsScreenState extends State<RoleDetailsScreen> {
  final Set<String> selectedRoles = {};
  final AuthProvider _authProvider = Get.find<AuthProvider>();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _proceed() async {
    if (selectedRoles.isEmpty) {
      setState(() {
        _errorMessage = 'Please select at least one role';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _authProvider.setUserRoles(
        widget.tempToken,
        selectedRoles.toList(),
      );

      if (response.success && response.data != null) {
        final updatedTempToken = response.data!['tempToken'];
        // Fix: Handle null mappedRoles and ensure it's a List<String>
        final mappedRoles = response.data!['mappedRoles'];
        final userRolesList = mappedRoles != null 
            ? List<String>.from(mappedRoles) 
            : selectedRoles.toList();

        if (!mounted) return;

        Get.off(
          () => RegistrationScreen(
            phoneNumber: widget.phoneNumber,
            tempToken: updatedTempToken,
            userType: widget.userType,
            userRoles: userRolesList, // Use the safely converted list
          ),
        );
      } else {
        if (!mounted) return;
        setState(() {
          _errorMessage = response.message ?? 'Failed to set user roles';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  final List<Map<String, dynamic>> roles = [
    {'title': 'Store Owner', 'icon': Icons.store},
    {'title': 'Service Business Owner', 'icon': Icons.business_center},
    {'title': 'Course Provider', 'icon': Icons.school},
    {'title': 'Influencer or Content Creator', 'icon': Icons.camera_alt},
    {'title': 'Student or Working Professional', 'icon': Icons.work},
    {'title': 'Delivery Partner', 'icon': Icons.delivery_dining},
  ];

  void _onProceed() async {
    if (selectedRoles.isEmpty) {
      setState(() {
        _errorMessage = 'Please select at least one role';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _authProvider.setUserTypeAndRoles(
        widget.phoneNumber,
        widget.userType,
        selectedRoles.toList(),
      );

      if (result['success']) {
        Get.off(
          () => RegistrationScreen(
            phoneNumber: widget.phoneNumber,
            tempToken: result['data']['tempToken'],
            userType: widget.userType,
            userRoles: result['data']['mappedRoles'],
          ),
        );
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to set user roles';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: const Text('Help?', style: TextStyle(color: Colors.black54)),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Which role defines you?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A148C),
                  ),
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: roles.length,
                    itemBuilder: (context, index) {
                      final role = roles[index];
                      final isSelected = selectedRoles.contains(role['title']);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedRoles.remove(role['title']);
                              } else {
                                selectedRoles.add(role['title']);
                              }
                              _errorMessage = null;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    isSelected
                                        ? const Color(0xFF4A148C)
                                        : Colors.grey[300]!,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  role['icon'],
                                  color:
                                      isSelected
                                          ? const Color(0xFF4A148C)
                                          : Colors.grey[600],
                                  size: 24,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    role['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          isSelected
                                              ? const Color(0xFF4A148C)
                                              : Colors.black87,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF4A148C),
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _isLoading
                            ? null
                            : _proceed, // Changed from _onProceed to _proceed
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A148C),
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
                              'Proceed',
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
        ],
      ),
    );
  }
}
