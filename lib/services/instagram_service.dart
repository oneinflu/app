import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class InstagramService {
  static final InstagramService _instance = InstagramService._internal();
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Replace with your actual Instagram App credentials
  static const String _appId = '1235728284825308';
  static const String _appSecret = '83b99457a5a788941885058be294262c';
  static const String _redirectUri = 'https://influ.in/auth/instagram/callback';

  factory InstagramService() {
    return _instance;
  }

  InstagramService._internal() {
    _dio.options.baseUrl = 'https://graph.instagram.com';
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
  }

  // Generate Instagram OAuth URL
  String getInstagramAuthUrl() {
    final state = _generateRandomString(32);
    _storage.write(key: 'instagram_oauth_state', value: state);

    final params = {
      'client_id': _appId,
      'redirect_uri': _redirectUri,
      'scope': 'user_profile,user_media',
      'response_type': 'code',
      'state': state,
    };

    final queryString = params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');

    return 'https://api.instagram.com/oauth/authorize?$queryString';
  }

  // Exchange authorization code for access token
  Future<Map<String, dynamic>> exchangeCodeForToken(
    String code,
    String state,
  ) async {
    try {
      // Verify state parameter
      final storedState = await _storage.read(key: 'instagram_oauth_state');
      if (storedState != state) {
        throw Exception('Invalid state parameter');
      }

      final response = await _dio.post(
        'https://api.instagram.com/oauth/access_token',
        data: {
          'client_id': _appId,
          'client_secret': _appSecret,
          'grant_type': 'authorization_code',
          'redirect_uri': _redirectUri,
          'code': code,
        },
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _storage.write(
          key: 'instagram_access_token',
          value: data['access_token'],
        );
        await _storage.write(
          key: 'instagram_user_id',
          value: data['user_id'].toString(),
        );

        return {
          'success': true,
          'access_token': data['access_token'],
          'user_id': data['user_id'],
        };
      }

      return {'success': false, 'message': 'Failed to get access token'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get user profile information
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final accessToken = await _storage.read(key: 'instagram_access_token');
      final userId = await _storage.read(key: 'instagram_user_id');

      if (accessToken == null || userId == null) {
        return {'success': false, 'message': 'No access token found'};
      }

      final response = await _dio.get(
        '/$userId',
        queryParameters: {
          'fields': 'id,username,account_type,media_count',
          'access_token': accessToken,
        },
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': response.data};
      }

      return {'success': false, 'message': 'Failed to get user profile'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get user media count and basic insights
  Future<Map<String, dynamic>> getUserInsights() async {
    try {
      final accessToken = await _storage.read(key: 'instagram_access_token');
      final userId = await _storage.read(key: 'instagram_user_id');

      if (accessToken == null || userId == null) {
        return {'success': false, 'message': 'No access token found'};
      }

      // Get recent media
      final mediaResponse = await _dio.get(
        '/$userId/media',
        queryParameters: {
          'fields': 'id,media_type,media_url,permalink,timestamp',
          'limit': 25,
          'access_token': accessToken,
        },
      );

      if (mediaResponse.statusCode == 200) {
        return {
          'success': true,
          'media_count': mediaResponse.data['data']?.length ?? 0,
          'recent_media': mediaResponse.data['data'],
        };
      }

      return {'success': false, 'message': 'Failed to get user insights'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Check if user is connected
  Future<bool> isConnected() async {
    final accessToken = await _storage.read(key: 'instagram_access_token');
    return accessToken != null;
  }

  // Disconnect Instagram account
  Future<void> disconnect() async {
    await _storage.delete(key: 'instagram_access_token');
    await _storage.delete(key: 'instagram_user_id');
    await _storage.delete(key: 'instagram_oauth_state');
  }

  String _generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(
      length,
      (index) => chars[random % chars.length],
    ).join();
  }
}
