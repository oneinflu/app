import 'dart:io';
import 'package:get/get.dart';
import '../services/api_service.dart';

class StoreProvider extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  final stores = <Map<String, dynamic>>[].obs;
  final categories = <Map<String, dynamic>>[].obs;

  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await _apiService.getCategories();

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData.containsKey('data') && responseData['data'] is List) {
          final categoriesList = responseData['data'] as List;
          final formattedCategories =
              categoriesList
                  .map(
                    (category) => {
                      'id': category['_id'],
                      'name': category['name'],
                      'slug': category['slug'],
                      'type': category['type'],
                      'isActive': category['isActive'],
                    },
                  )
                  .toList();

          categories.value = formattedCategories;
          return formattedCategories;
        } else {
          throw Exception('Invalid response format: expected data array');
        }
      } else {
        throw Exception(response.message ?? 'Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to load categories: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> createStore({
    required String storeName,
    required String description,
    required String storeType,
    required List<String> categories,
    File? bannerImage,
  }) async {
    try {
      isLoading.value = true;

      // Create a simple map with store data
      final storeData = {
        'storeName': storeName,
        'description': description,
        'storeType': storeType,
        'categories': categories,
      };

      // Use the post method instead of createStore to avoid FormData issues
      final response = await _apiService.post(
        '/api/users/stores',
        data: storeData,
      );

      if (response.success) {
        // Refresh stores list
        await getStores();
      }

      return {
        'success': response.success,
        'message':
            response.message ??
            (response.success
                ? 'Store created successfully'
                : 'Failed to create store'),
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error creating store: ${e.toString()}',
      };
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getStores() async {
    try {
      final response = await _apiService.getUserStores();

      if (response.success && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData.containsKey('data') && responseData['data'] is List) {
          stores.value = List<Map<String, dynamic>>.from(responseData['data']);
        }
      }
    } catch (e) {
      print('Error fetching stores: $e');
    }
  }
}
