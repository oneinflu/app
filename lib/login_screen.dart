import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app_theme.dart';
import 'otp_verification_screen.dart';
import 'providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final LoginController controller = Get.put(LoginController());
    
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside the text field
        FocusScope.of(context).unfocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Title
              const Text(
                'Verify your mobile number',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                ),
              ),
              const SizedBox(height: 24),

              // Phone input field
              const Text(
                '10-digit mobile number',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '+91',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        hintText: 'XXXXXXXXX',
                        hintStyle: const TextStyle(
                          color: AppTheme.disabled,
                          fontWeight: FontWeight.w500,
                        ),
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
                    ),
                  ),
                ],
              ),

              // Error message
              Obx(() => controller.errorMessage.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    )
                  : const SizedBox.shrink()),

              const SizedBox(height: 16),

              // WhatsApp updates toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Switch(
                        value: controller.getWhatsAppUpdates.value,
                        onChanged: (value) => controller.toggleWhatsAppUpdates(),
                        activeColor: AppTheme.primaryPurple,
                      )),
                  const Text(
                    'Get WhatsApp Updates',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),

              const Spacer(),

              // Send OTP button
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.sendOtp(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Send OTP',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      )),
                ),
              ),

              // Bottom indicator
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
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
    );
  }
}

// Controller for login screen using GetX
class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final getWhatsAppUpdates = true.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final AuthProvider authProvider = Get.find<AuthProvider>();
  
  void toggleWhatsAppUpdates() {
    getWhatsAppUpdates.value = !getWhatsAppUpdates.value;
  }
  
  Future<void> sendOtp() async {
    if (phoneController.text.isEmpty) {
      errorMessage.value = 'Please enter your phone number';
      return;
    }
    
    if (phoneController.text.length != 10) {
      errorMessage.value = 'Please enter a valid 10-digit phone number';
      return;
    }
    
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final result = await authProvider.sendOtp(phoneController.text);
      
      if (result['success']) {
        Get.to(() => OtpVerificationScreen(phoneNumber: phoneController.text));
      } else {
        errorMessage.value = result['message'] ?? 'Failed to send OTP';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      print('Error sending OTP: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
