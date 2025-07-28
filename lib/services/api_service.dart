import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  final Dio _dio = Dio();
  final String baseUrl = "https://api.oneinflu.com";
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            await _storage.delete(key: 'auth_token');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<ApiResponse<T>> handleResponse<T>(
    Future<Response> Function() request,
  ) async {
    try {
      print('Making API request...');
      final response = await request();
      print('Response received - Status: ${response.statusCode}');
      print('Response data: ${response.data}');
      print('Response headers: ${response.headers}');
      
      return ApiResponse(
        success: response.data?['success'] ?? (response.statusCode == 200),
        data: response.data,
        message: response.data?['message'],
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      print('DioException caught:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response?.data}');
      print('Status Code: ${e.response?.statusCode}');
      print('Headers: ${e.response?.headers}');
      
      return ApiResponse(
        success: false,
        message: e.response?.data?['message'] ?? e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    } catch (e) {
      print('General exception: $e');
      return ApiResponse(
        success: false, 
        message: 'Unexpected error: $e'
      );
    }
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return handleResponse(
      () => _dio.get(path, queryParameters: queryParameters),
    );
  }

  Future<ApiResponse<T>> post<T>(String path, {dynamic data}) async {
    return handleResponse(() => _dio.post(path, data: data));
  }

  Future<ApiResponse<T>> put<T>(String path, {dynamic data}) async {
    return handleResponse(() => _dio.put(path, data: data));
  }

  Future<ApiResponse<T>> delete<T>(String path) async {
    return handleResponse(() => _dio.delete(path));
  }

  Future<ApiResponse<T>> uploadFile<T>(String path, FormData formData) async {
    final options = Options(
      headers: {
        'Content-Type': 'multipart/form-data',
        'Accept': _dio.options.headers['Accept'],
      },
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );

    return handleResponse(
      () => _dio.put(path, data: formData, options: options),
    );
  }

  // Save social media connections
  Future<ApiResponse<T>> saveSocialMediaConnections<T>(
    Map<String, dynamic> connections,
  ) async {
    return handleResponse(
      () => _dio.post('/api/users/social-media-connections', data: connections),
    );
  }

  // Get social media connections
  Future<ApiResponse<T>> getSocialMediaConnections<T>() async {
    return handleResponse(
      () => _dio.get('/api/users/social-media-connections'),
    );
  }

  // Rate Cards API methods
  Future<ApiResponse> getRateCards() async {
    return handleResponse(() => _dio.get('/api/ratecards'));
  }

  // Get influencer profile
  Future<ApiResponse> getInfluencerProfile() async {
    return handleResponse(() => _dio.get('/api/influencer/profile'));
  }

  Future<ApiResponse> createRateCard(Map<String, dynamic> rateCardData) async {
    return handleResponse(
      () => _dio.post('/api/ratecards', data: rateCardData),
    );
  }

  Future<ApiResponse> updateRateCard(
    String rateCardId,
    Map<String, dynamic> rateCardData,
  ) async {
    return handleResponse(
      () => _dio.put('/api/ratecards/$rateCardId', data: rateCardData),
    );
  }

  Future<ApiResponse> deleteRateCard(String rateCardId) async {
    return handleResponse(() => _dio.delete('/api/ratecards/$rateCardId'));
  }

  // Categories API methods
  Future<ApiResponse> getCategories() async {
    return handleResponse(() => _dio.get('/api/categories/parents'));
  }

  // Stores API methods
  Future<ApiResponse> createStore(FormData formData) async {
    final token = await _storage.read(key: 'auth_token');

    final options = Options(
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $token', // This expects just the token value
      },
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );

    return handleResponse(
      () => _dio.post('/api/users/stores', data: formData, options: options),
    );
  }
  // Add these methods to your existing ApiService class
  Future<ApiResponse> getUserStores() async {
    return handleResponse(() => _dio.get('/api/users/stores'));
  }

  // Products API methods
  Future<ApiResponse> createProduct(FormData formData) async {
    final token = await _storage.read(key: 'auth_token');
  
    final options = Options(
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $token',
      },
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );
  
    return handleResponse(
      () => _dio.post('/api/products', data: formData, options: options),
    );
  }
  
  // Services API methods
  Future<ApiResponse> createService(FormData formData) async {
    final token = await _storage.read(key: 'auth_token');
  
    final options = Options(
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $token',
      },
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );
  
    return handleResponse(
      () => _dio.post('/api/services', data: formData, options: options),
    );
  }
  
  // Link item to store
  Future<ApiResponse> linkItemToStore(String storeId, Map<String, dynamic> itemData) async {
    return handleResponse(
      () => _dio.post('/api/users/stores/$storeId/items', data: itemData),
    );
  }
  
  // Remove item from store
  Future<ApiResponse> removeItemFromStore(String storeId, String itemId) async {
    return handleResponse(
      () => _dio.delete('/api/users/stores/$storeId/items/$itemId'),
    );
  }
  
  // Get store details with items
  Future<ApiResponse> getStoreDetails(String storeId) async {
    return handleResponse(
      () => _dio.get('/api/users/stores/$storeId'),
    );
  }

  Future<bool> checkConnectivity() async {
    try {
      final response = await _dio.get('/api/health');
      return response.statusCode == 200;
    } catch (e) {
      print('Connectivity check failed: $e');
      return false;
    }
  }
}
