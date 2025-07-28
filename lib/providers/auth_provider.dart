import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../home_screen.dart';
import '../registration_screen.dart';

class AuthProvider extends GetxController {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final isLoggedIn = false.obs;
  final isLoading = false.obs;
  final user = Rxn<Map<String, dynamic>>();

  // Add these getters
  String? get userType => user.value?['userType'];
  Map<String, dynamic>? get userData => user.value;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    isLoading.value = true;
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null) {
        isLoggedIn.value = true;
        await getUserProfile();
      }
    } catch (e) {
      print('Error checking auth status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<ApiResponse> setUserType(String phoneNumber, String userType) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/api/users/set-user-type',
      data: {'phoneNumber': phoneNumber, 'userType': userType},
    );
    return response;
  }

  Future<ApiResponse> setUserRoles(
    String tempToken,
    List<String> userRoles,
  ) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/api/users/set-user-roles',
      data: {
        'tempToken': tempToken,
        'userRoles': userRoles.map((role) => role).toList(),
      },
    );
    return response;
  }

  Future<ApiResponse> completeRegistration(
    Map<String, dynamic> userData,
  ) async {
    final formData = dio.FormData.fromMap({
      'tempToken': userData['tempToken'],
      'name': userData['fullName'],
      'email': userData['email'],
      'phoneNumber': userData['phoneNumber'],
      'gender': userData['gender'].toString().toLowerCase(),
      'dob': userData['dob'],
    });

    if (userData['profileImage'] != null) {
      final file = await dio.MultipartFile.fromFile(
        userData['profileImage'],
        filename: userData['profileImage'].split('/').last,
      );
      formData.files.add(MapEntry('profileImage', file));
    }

    final response = await _apiService.post<Map<String, dynamic>>(
      '/api/users/complete-registration',
      data: formData,
    );

    if (response.success && response.data != null) {
      await _storage.write(key: 'auth_token', value: response.data!['token']);
      user.value = response.data!['user'];
      isLoggedIn.value = true;
    }

    return response;
  }

  Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    try {
      final response = await _apiService.post(
        '/api/users/send-otp',
        data: {'phoneNumber': phoneNumber},
      );

      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    try {
      // Log the request details
      print('\n=== OTP Verification Request ===');
      print('Endpoint: POST /api/users/verify-otp');
      print('Request Body: {"phoneNumber": "$phoneNumber", "otp": "$otp"}');

      final apiResponse = await _apiService.post(
        '/api/users/verify-otp',
        data: {'phoneNumber': phoneNumber, 'otp': otp},
      );

      // Log the response
      print('\n=== OTP Verification Response ===');
      print('Status Code: ${apiResponse.statusCode}');
      print('ApiResponse Success: ${apiResponse.success}');
      print('ApiResponse Data: ${apiResponse.data}');
      print('ApiResponse Message: ${apiResponse.message}');

      // The actual API response data is in apiResponse.data
      final responseData = apiResponse.data ?? {};

      // For invalid OTP case
      if (apiResponse.success == false || responseData['success'] == false) {
        print(
          'Verification Failed: ${apiResponse.message ?? responseData['message']}',
        );
        return {
          'success': false,
          'message':
              apiResponse.message ??
              responseData['message'] ??
              'Invalid or expired OTP',
        };
      }

      // For valid OTP case (both new and existing users)
      final result = {
        'success': responseData['success'] ?? apiResponse.success,
        'isNewUser': responseData['isNewUser'],
        'message': responseData['message'] ?? apiResponse.message,
        'data': responseData['data'],
        'user': responseData['user'],
        'token': responseData['token'],
      };

      print('Verification Result: $result');
      return result;
    } catch (e) {
      print('\n=== OTP Verification Error ===');
      print('Error: $e');
      return {'success': false, 'message': 'Failed to verify OTP'};
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      // Create a map for the registration data
      final Map<String, dynamic> registrationData = {
        'name': userData['fullName'],
        'email': userData['email'],
        'phoneNumber': userData['phoneNumber'] ?? '',
        'gender': userData['gender'].toString().toLowerCase(),
        'dob': userData['dob'],
      };

      // Use ApiService instead of direct Dio instance
      final response = await _apiService.post(
        '/api/users/register',
        data: registrationData,
      );

      final responseData = response.data;

      if (response.statusCode == 201 && responseData['success'] == true) {
        // Store token and user data
        await _storage.write(key: 'auth_token', value: responseData['token']);
        user.value = responseData['user'];
        isLoggedIn.value = true;
      }

      return {'success': response.statusCode == 201, 'data': responseData};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: 'auth_token');
      isLoggedIn.value = false;
      user.value = null;
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Add these methods to the AuthProvider class

  Future<Map<String, dynamic>> checkUsernameAvailability(
    String username,
  ) async {
    try {
      final response = await _apiService.get(
        '/api/users/check-username/$username',
      );

      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> setUsername(String username) async {
    try {
      final response = await _apiService.put(
        '/api/users/set-username',
        data: {'username': username},
      );

      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _apiService.get('/api/users/profile');

      if (response.statusCode == 200 && response.data['success'] == true) {
        // Update the user data in the provider
        user.value = response.data['user'];
      }

      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateProfilePicture(String filePath) async {
    try {
      // Create a MultipartFile from the image file
      final file = await dio.MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      );

      // Create form data with the image file in an array as shown in the curl example
      final formData = dio.FormData.fromMap({
        'files': [file],
      });

      // Log the request details for debugging
      print('Uploading file: ${filePath.split('/').last}');
      print('Request URL: ${_apiService.baseUrl}/api/users/profile');

      // Use ApiService to make the PUT request
      final response = await _apiService.uploadFile(
        '/api/users/profile',
        formData,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        // Update the user data in the provider
        user.value = response.data['user'];
      }

      return {'success': true, 'data': response.data};
    } catch (e) {
      print('Profile picture upload error: $e');
      // Check if it's a DioException to get more details
      if (e is dio.DioException) {
        final dioError = e as dio.DioException;
        final statusCode = dioError.response?.statusCode;
        final responseData = dioError.response?.data;

        print('Status code: $statusCode');
        print('Response data: $responseData');

        return {
          'success': false,
          'message':
              'Server error ($statusCode): ${responseData ?? dioError.message}',
        };
      }
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> createInfluencerProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await _apiService.post(
        '/api/influencer/profile',
        data: profileData,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        // You might want to store the influencer profile data somewhere
        // For example: influencerProfile.value = response.data['influencerProfile'];
      }

      return {'success': true, 'data': response.data};
    } catch (e) {
      print('Create influencer profile error: $e');
      // Check if it's a DioException to get more details
      if (e is dio.DioException) {
        final dioError = e as dio.DioException;
        final statusCode = dioError.response?.statusCode;
        final responseData = dioError.response?.data;

        print('Status code: $statusCode');
        print('Response data: $responseData');

        return {
          'success': false,
          'message':
              'Server error ($statusCode): ${responseData ?? dioError.message}',
        };
      }
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> setUserTypeAndRoles(
    String phoneNumber,
    String userType,
    List<String> userRoles,
  ) async {
    try {
      final response = await _apiService.post(
        '/api/users/set-user-type',
        data: {
          'phoneNumber': phoneNumber,
          'userType': userType,
          'userRoles': userRoles,
        },
      );

      return {'success': true, 'data': response.data};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Aadhaar Verification Methods
  Future<Map<String, dynamic>> sendAadhaarOtp(String aadhaarNumber) async {
    try {
      final response = await _apiService.post(
        '/api/users/verify-aadhaar/send-otp',
        data: {'aadhaar_number': aadhaarNumber},
      );

      return {
        'success': response.data['success'] ?? false,
        'message': response.data['message'] ?? 'OTP sent successfully',
        'referenceId': response.data['data']?['data']?['reference_id'],
        'transactionId': response.data['data']?['transaction_id'],
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> verifyAadhaarOtp(
    String referenceId,
    String otp,
  ) async {
    try {
      final response = await _apiService.post(
        '/api/users/verify-aadhaar/verify-otp',
        data: {'reference_id': referenceId, 'otp': otp},
      );

      // Update user data if verification successful
      if (response.data['success'] == true) {
        await getUserProfile(); // Refresh user data
        update(); // Notify GetBuilder widgets
      }

      return {
        'success': response.data['success'] ?? false,
        'message': response.data['message'] ?? 'Aadhaar verified successfully',
        'data': response.data['data']?['data'],
        'transactionId': response.data['data']?['transaction_id'],
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // PAN Verification Method
  Future<Map<String, dynamic>> verifyPan(
    String pan,
    String nameAsPerPan,
    String dateOfBirth,
  ) async {
    try {
      print('=== PAN Verification Debug ===');
      print('PAN: $pan');
      print('Name: $nameAsPerPan');
      print('DOB: $dateOfBirth');
      
      final response = await _apiService.post(
        '/api/users/verify-pan',
        data: {
          'pan': pan,
          'name_as_per_pan': nameAsPerPan,
          'date_of_birth': dateOfBirth,
        },
      );
  
      print('API Response: ${response.data}');
      print('Response Success: ${response.success}');
      print('Status Code: ${response.statusCode}');
  
      // Handle null response data
      if (response.data == null) {
        print('Response data is null');
        return {
          'success': false,
          'message': 'Server returned empty response. Please try again.',
        };
      }
  
      final responseData = response.data as Map<String, dynamic>;
      final isSuccess = responseData['success'] == true;
      
      if (isSuccess) {
        // Update user data with PAN verification status
        if (user.value != null) {
          final updatedUser = Map<String, dynamic>.from(user.value!);
          updatedUser['kyc'] = updatedUser['kyc'] ?? {};
          updatedUser['kyc']['pan'] = responseData['data']?['pan'];
          user.value = updatedUser;
          
          // Refresh user profile to ensure data is updated
          await getUserProfile();
          update(); // Notify GetBuilder widgets
        }
      }
  
      return {
        'success': isSuccess,
        'message': responseData['message'] ?? (isSuccess ? 'PAN verification completed' : 'PAN verification failed'),
        'data': responseData['data'],
      };
    } catch (e) {
      print('PAN Verification Error: $e');
      if (e is DioException) {
        final dioError = e as DioException;
        final statusCode = dioError.response?.statusCode;
        final responseData = dioError.response?.data;
        
        print('Status code: $statusCode');
        print('Response data: $responseData');
        
        return {
          'success': false, 
          'message': responseData?['message'] ?? 'Server error ($statusCode): ${dioError.message}'
        };
      }
      return {'success': false, 'message': e.toString()};
    }
  }

  // Update influencer profile
  Future<Map<String, dynamic>> updateInfluencerProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await _apiService.put(
        '/api/influencer/profile',
        data: profileData,
      );

      if (response.success) {
        // Refresh user profile to get updated data
        await getUserProfile();
        update(); // Notify GetBuilder widgets
      }

      return {
        'success': response.success,
        'message': response.data?['message'] ?? 'Profile updated successfully',
        'data': response.data,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get influencer profile data
  Map<String, dynamic>? get influencerProfile {
    return user.value?['influencerProfile'];
  }

  // Check if user has completed influencer profile
  bool get hasCompletedInfluencerProfile {
    final profile = influencerProfile;
    return profile != null &&
        profile['bio'] != null &&
        profile['categories'] != null &&
        profile['platforms'] != null;
  }
}
