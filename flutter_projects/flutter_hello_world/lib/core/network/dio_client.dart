import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_endpoints.dart';
import '../error/exceptions.dart';
import '../utils/logger.dart';
import '../services/mock_api_service.dart';
import 'api_response.dart';

/// GullyCric HTTP Client using Dio
/// 
/// Provides configured HTTP client with interceptors, error handling,
/// and support for multiple API endpoints (cricket, weather, maps, news)
class DioClient {
  late final Dio _dio;
  late final Dio _cricketApiDio;
  late final Dio _weatherApiDio;
  late final Dio _mapsApiDio;

  // Singleton instance
  static DioClient? _instance;
  static DioClient get instance => _instance ??= DioClient._internal();

  DioClient._internal() {
    _initializeMainDio();
    _initializeExternalApiClients();
  }

  /// Initialize main app API client
  void _initializeMainDio() {
    _dio = Dio(BaseOptions(
      baseUrl: _getBaseUrl(),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _addInterceptors(_dio, 'MainAPI');
  }

  /// Initialize external API clients
  void _initializeExternalApiClients() {
    // Cricket API client
    _cricketApiDio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.cricketApiBase,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    _addInterceptors(_cricketApiDio, 'CricketAPI');

    // Weather API client
    _weatherApiDio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.weatherApiBase,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    _addInterceptors(_weatherApiDio, 'WeatherAPI');

    // Maps API client
    _mapsApiDio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.mapsApiBase,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    _addInterceptors(_mapsApiDio, 'MapsAPI');
  }

  /// Add interceptors to Dio instance
  void _addInterceptors(Dio dio, String apiName) {
    // Add mock API interceptor for main API only
    if (apiName == 'MainAPI') {
      dio.interceptors.add(MockApiInterceptor());
    }
    
    // Request interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        Logger.d('API Request: ${options.method} ${options.path}', tag: apiName);
        handler.next(options);
      },
      onResponse: (response, handler) {
        Logger.d('API Response: ${response.statusCode} ${response.requestOptions.path}', tag: apiName);
        handler.next(response);
      },
      onError: (error, handler) {
        Logger.e('API Error: ${error.requestOptions.path} - ${error.message}', tag: apiName);
        handler.next(error);
      },
    ));

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
        logPrint: (object) => Logger.d(object.toString(), tag: apiName),
      ));
    }
  }

  /// Get base URL based on environment
  String _getBaseUrl() {
    // TODO: Replace with actual environment detection
    if (kDebugMode) {
      return ApiEndpoints.baseUrlDev;
    } else {
      return ApiEndpoints.baseUrlProd;
    }
  }

  /// Set authentication token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authentication token
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Set API key for external services
  void setCricketApiKey(String apiKey) {
    _cricketApiDio.options.headers['X-API-Key'] = apiKey;
  }

  void setWeatherApiKey(String apiKey) {
    _weatherApiDio.options.queryParameters['appid'] = apiKey;
  }

  void setMapsApiKey(String apiKey) {
    _mapsApiDio.options.queryParameters['key'] = apiKey;
  }

  // Main API methods
  
  /// GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH request
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // External API methods

  /// Cricket API request
  Future<ApiResponse<T>> cricketApiGet<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _cricketApiDio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Weather API request
  Future<ApiResponse<T>> weatherApiGet<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _weatherApiDio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Maps API request
  Future<ApiResponse<T>> mapsApiGet<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _mapsApiDio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Upload file
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...?data,
        fieldName: await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
      );
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Download file
  Future<void> downloadFile(
    String endpoint,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        endpoint,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle response and convert to ApiResponse
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    if (response.statusCode != null && 
        response.statusCode! >= 200 && 
        response.statusCode! < 300) {
      
      T? data;
      if (fromJson != null && response.data != null) {
        data = fromJson(response.data);
      } else {
        data = response.data as T?;
      }

      return ApiResponse<T>(
        data: data,
        statusCode: response.statusCode!,
        message: 'Success',
        success: true,
      );
    } else {
      throw ServerException(
        'Server error: ${response.statusMessage}',
        response.statusCode,
      );
    }
  }

  /// Handle errors and convert to appropriate exceptions
  AppException _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const TimeoutException();
          
        case DioExceptionType.connectionError:
          return const ConnectionException();
          
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ?? 
                          error.response?.statusMessage ?? 
                          'Server error';
          
          if (statusCode == 401) {
            return const UnauthorizedException();
          } else if (statusCode == 403) {
            return const ForbiddenException();
          } else if (statusCode == 404) {
            return NotFoundException('Resource', null, message);
          } else if (statusCode == 409) {
            return ConflictException(message);
          } else if (statusCode != null && statusCode >= 400 && statusCode < 500) {
            return ValidationException(message);
          } else {
            return ServerException(message, statusCode);
          }
          
        case DioExceptionType.cancel:
          return const NetworkException('Request was cancelled');
          
        case DioExceptionType.unknown:
          return NetworkException('Network error: ${error.message}');
          
        case DioExceptionType.badCertificate:
          return const NetworkException('SSL certificate error');
      }
    }
    
    return GenericException('Unexpected error: ${error.toString()}');
  }

  /// Cancel all requests
  void cancelRequests() {
    _dio.close();
    _cricketApiDio.close();
    _weatherApiDio.close();
    _mapsApiDio.close();
  }

  /// Get Dio instance for custom operations
  Dio get dio => _dio;
  Dio get cricketApiDio => _cricketApiDio;
  Dio get weatherApiDio => _weatherApiDio;
  Dio get mapsApiDio => _mapsApiDio;
}