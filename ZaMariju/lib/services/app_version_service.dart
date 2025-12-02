import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Service to check if fake version (file import login) is enabled via backend
class AppVersionService {
  // Backend URL - same as AIAnalyzer proxy URL
  static String? _backendUrl;
  
  // Cache the result to avoid multiple calls
  static bool? _cachedResult;
  static DateTime? _cacheTime;
  static const Duration _cacheDuration = Duration(minutes: 5);

  /// Set backend URL for checking version flag
  static void setBackendUrl(String? url) {
    _backendUrl = url;
    // Clear cache when URL changes
    _cachedResult = null;
    _cacheTime = null;
  }

  /// Check if fake version (import login) is enabled
  /// Returns true if fake version should be used, false for real web view login
  /// Defaults to false (real version) if check fails
  /// Uses caching to avoid multiple backend calls
  static Future<bool> isFakeVersionEnabled() async {
    // Return cached result if available and not expired
    if (_cachedResult != null && _cacheTime != null) {
      final age = DateTime.now().difference(_cacheTime!);
      if (age < _cacheDuration) {
        if (kDebugMode) {
          print('🔍 Using cached app version result: $_cachedResult (age: ${age.inSeconds}s)');
        }
        return _cachedResult!;
      }
    }
    try {
      // Get backend URL from proxy URL if not set
      String backendUrl = _backendUrl ?? 
          'https://openai-proxy-server-301757777366.europe-west1.run.app';
      
      // Remove /api/chat if present, add /api/app-version endpoint
      if (backendUrl.contains('/api/')) {
        backendUrl = backendUrl.split('/api/').first;
      }
      
      final url = Uri.parse('$backendUrl/api/app-version');
      
      if (kDebugMode) {
        print('🔍 Checking app version from: $url');
      }

      // Retry logic: try up to 3 times with increasing timeout
      http.Response? response;
      Exception? lastError;
      
      for (int attempt = 1; attempt <= 3; attempt++) {
        try {
          if (kDebugMode) {
            print('🔍 App version check attempt $attempt/3...');
          }
          
          response = await http.get(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
          ).timeout(
            Duration(seconds: 5 + (attempt * 2)), // 7s, 9s, 11s
            onTimeout: () {
              if (kDebugMode) {
                print('⏱️ App version check timeout on attempt $attempt');
              }
              throw TimeoutException('Request timeout');
            },
          );
          
          // If we got a response, break out of retry loop
          break;
        } catch (e) {
          lastError = e is Exception ? e : Exception(e.toString());
          if (kDebugMode) {
            print('⚠️ App version check attempt $attempt failed: $e');
          }
          
          // If this is the last attempt, rethrow
          if (attempt == 3) {
            if (kDebugMode) {
              print('❌ All 3 attempts failed, defaulting to real version');
            }
            throw lastError;
          }
          
          // Wait before retrying
          await Future.delayed(Duration(milliseconds: 500 * attempt));
        }
      }
      
      if (response == null) {
        throw Exception('No response after retries');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final useFakeVersion = data['useFakeVersion'] ?? false;
        
        if (kDebugMode) {
          print('✅ App version check: useFakeVersion = $useFakeVersion');
          print('   Response body: ${response.body}');
          print('   Parsed data: $data');
          print('   useFakeVersion type: ${useFakeVersion.runtimeType}');
        }
        
        // Ensure we return a boolean
        final result = useFakeVersion is bool ? useFakeVersion : (useFakeVersion == true || useFakeVersion == 'true');
        
        if (kDebugMode) {
          print('   Final result: $result (type: ${result.runtimeType})');
        }
        
        // Cache the result
        _cachedResult = result;
        _cacheTime = DateTime.now();
        
        return result;
      } else {
        if (kDebugMode) {
          print('⚠️ App version check failed with status ${response.statusCode}');
          print('   Response body: ${response.body}');
          print('   Defaulting to real version');
        }
        return false; // Default to real version on error
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking app version: $e');
        print('   Defaulting to real version (web view login)');
      }
      
      // Cache the error result (false) to avoid repeated failed calls
      _cachedResult = false;
      _cacheTime = DateTime.now();
      
      return false; // Default to real version on error
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  
  @override
  String toString() => message;
}




