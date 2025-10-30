import 'package:equatable/equatable.dart';

/// GullyCric API Response Wrapper
/// 
/// Standardized response format for all API calls with
/// success/error handling and metadata
class ApiResponse<T> extends Equatable {
  final T? data;
  final int statusCode;
  final String message;
  final bool success;
  final Map<String, dynamic>? metadata;
  final List<String>? errors;
  final DateTime timestamp;

  ApiResponse({
    this.data,
    required this.statusCode,
    required this.message,
    required this.success,
    this.metadata,
    this.errors,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Creates a successful response
  factory ApiResponse.success({
    T? data,
    int statusCode = 200,
    String message = 'Success',
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      data: data,
      statusCode: statusCode,
      message: message,
      success: true,
      metadata: metadata,
    );
  }

  /// Creates an error response
  factory ApiResponse.error({
    int statusCode = 500,
    String message = 'An error occurred',
    List<String>? errors,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      statusCode: statusCode,
      message: message,
      success: false,
      errors: errors,
      metadata: metadata,
    );
  }

  /// Creates response from JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic)? fromJsonT,
  }) {
    return ApiResponse<T>(
      data: json['data'] != null && fromJsonT != null 
          ? fromJsonT(json['data']) 
          : json['data'] as T?,
      statusCode: json['statusCode'] ?? json['status'] ?? 200,
      message: json['message'] ?? json['msg'] ?? 'Success',
      success: json['success'] ?? json['ok'] ?? true,
      metadata: json['metadata'] as Map<String, dynamic>?,
      errors: json['errors'] != null 
          ? List<String>.from(json['errors']) 
          : null,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : DateTime.now(),
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson({
    Map<String, dynamic> Function(T)? toJsonT,
  }) {
    return {
      'data': data != null && toJsonT != null ? toJsonT(data as T) : data,
      'statusCode': statusCode,
      'message': message,
      'success': success,
      'metadata': metadata,
      'errors': errors,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Checks if response is successful
  bool get isSuccess => success && statusCode >= 200 && statusCode < 300;

  /// Checks if response is an error
  bool get isError => !success || statusCode >= 400;

  /// Checks if response is a client error (4xx)
  bool get isClientError => statusCode >= 400 && statusCode < 500;

  /// Checks if response is a server error (5xx)
  bool get isServerError => statusCode >= 500;

  /// Gets the first error message
  String? get firstError => errors?.isNotEmpty == true ? errors!.first : null;

  /// Gets all error messages as a single string
  String get allErrors => errors?.join(', ') ?? message;

  /// Maps the data to a different type
  ApiResponse<R> map<R>(R Function(T) mapper) {
    return ApiResponse<R>(
      data: data != null ? mapper(data as T) : null,
      statusCode: statusCode,
      message: message,
      success: success,
      metadata: metadata,
      errors: errors,
      timestamp: timestamp,
    );
  }

  /// Maps the data to a different type (nullable)
  ApiResponse<R> mapNullable<R>(R? Function(T?) mapper) {
    return ApiResponse<R>(
      data: mapper(data),
      statusCode: statusCode,
      message: message,
      success: success,
      metadata: metadata,
      errors: errors,
      timestamp: timestamp,
    );
  }

  /// Copies the response with new values
  ApiResponse<T> copyWith({
    T? data,
    int? statusCode,
    String? message,
    bool? success,
    Map<String, dynamic>? metadata,
    List<String>? errors,
    DateTime? timestamp,
  }) {
    return ApiResponse<T>(
      data: data ?? this.data,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      success: success ?? this.success,
      metadata: metadata ?? this.metadata,
      errors: errors ?? this.errors,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [
        data,
        statusCode,
        message,
        success,
        metadata,
        errors,
        timestamp,
      ];

  @override
  String toString() {
    return 'ApiResponse(data: $data, statusCode: $statusCode, message: $message, success: $success)';
  }
}

/// Paginated API Response
class PaginatedApiResponse<T> extends ApiResponse<List<T>> {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedApiResponse({
    List<T>? data,
    required int statusCode,
    required String message,
    required bool success,
    Map<String, dynamic>? metadata,
    List<String>? errors,
    DateTime? timestamp,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  }) : super(
          data: data,
          statusCode: statusCode,
          message: message,
          success: success,
          metadata: metadata,
          errors: errors,
          timestamp: timestamp,
        );

  /// Creates paginated response from JSON
  factory PaginatedApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic)? fromJsonT,
  }) {
    final pagination = json['pagination'] ?? json['meta'] ?? {};
    
    return PaginatedApiResponse<T>(
      data: json['data'] != null && fromJsonT != null
          ? (json['data'] as List).map((item) => fromJsonT(item)).toList()
          : json['data'] as List<T>?,
      statusCode: json['statusCode'] ?? json['status'] ?? 200,
      message: json['message'] ?? json['msg'] ?? 'Success',
      success: json['success'] ?? json['ok'] ?? true,
      metadata: json['metadata'] as Map<String, dynamic>?,
      errors: json['errors'] != null 
          ? List<String>.from(json['errors']) 
          : null,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : DateTime.now(),
      currentPage: pagination['currentPage'] ?? pagination['page'] ?? 1,
      totalPages: pagination['totalPages'] ?? pagination['pages'] ?? 1,
      totalItems: pagination['totalItems'] ?? pagination['total'] ?? 0,
      itemsPerPage: pagination['itemsPerPage'] ?? pagination['limit'] ?? 10,
      hasNextPage: pagination['hasNextPage'] ?? false,
      hasPreviousPage: pagination['hasPreviousPage'] ?? false,
    );
  }

  /// Converts to JSON
  @override
  Map<String, dynamic> toJson({
    Map<String, dynamic> Function(List<T>)? toJsonT,
  }) {
    final json = <String, dynamic>{
      'data': data != null && toJsonT != null ? toJsonT(data!) : data,
      'statusCode': statusCode,
      'message': message,
      'success': success,
      'metadata': metadata,
      'errors': errors,
      'timestamp': timestamp.toIso8601String(),
    };
    json['pagination'] = {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
    return json;
  }

  /// Gets pagination info as a string
  String get paginationInfo {
    final start = (currentPage - 1) * itemsPerPage + 1;
    final end = (currentPage * itemsPerPage).clamp(0, totalItems);
    return 'Showing $start-$end of $totalItems items';
  }

  /// Checks if this is the first page
  bool get isFirstPage => currentPage == 1;

  /// Checks if this is the last page
  bool get isLastPage => currentPage == totalPages;

  /// Gets the next page number (null if no next page)
  int? get nextPage => hasNextPage ? currentPage + 1 : null;

  /// Gets the previous page number (null if no previous page)
  int? get previousPage => hasPreviousPage ? currentPage - 1 : null;

  @override
  List<Object?> get props => [
        ...super.props,
        currentPage,
        totalPages,
        totalItems,
        itemsPerPage,
        hasNextPage,
        hasPreviousPage,
      ];
}

/// API Response utilities
class ApiResponseUtils {
  ApiResponseUtils._();

  /// Combines multiple API responses
  static ApiResponse<List<T>> combine<T>(List<ApiResponse<T>> responses) {
    final allData = <T>[];
    final allErrors = <String>[];
    var allSuccess = true;
    var highestStatusCode = 200;

    for (final response in responses) {
      if (response.data != null) {
        allData.add(response.data!);
      }
      
      if (response.errors != null) {
        allErrors.addAll(response.errors!);
      }
      
      if (!response.success) {
        allSuccess = false;
      }
      
      if (response.statusCode > highestStatusCode) {
        highestStatusCode = response.statusCode;
      }
    }

    return ApiResponse<List<T>>(
      data: allData,
      statusCode: highestStatusCode,
      message: allSuccess ? 'All requests successful' : 'Some requests failed',
      success: allSuccess,
      errors: allErrors.isNotEmpty ? allErrors : null,
    );
  }

  /// Transforms API response data
  static ApiResponse<R> transform<T, R>(
    ApiResponse<T> response,
    R Function(T) transformer,
  ) {
    return ApiResponse<R>(
      data: response.data != null ? transformer(response.data as T) : null,
      statusCode: response.statusCode,
      message: response.message,
      success: response.success,
      metadata: response.metadata,
      errors: response.errors,
      timestamp: response.timestamp,
    );
  }

  /// Filters API response data
  static ApiResponse<List<T>> filter<T>(
    ApiResponse<List<T>> response,
    bool Function(T) predicate,
  ) {
    return ApiResponse<List<T>>(
      data: response.data?.where(predicate).toList(),
      statusCode: response.statusCode,
      message: response.message,
      success: response.success,
      metadata: response.metadata,
      errors: response.errors,
      timestamp: response.timestamp,
    );
  }

  /// Sorts API response data
  static ApiResponse<List<T>> sort<T>(
    ApiResponse<List<T>> response,
    int Function(T, T) compare,
  ) {
    final sortedData = response.data != null 
        ? (List<T>.from(response.data!)..sort(compare))
        : null;
        
    return ApiResponse<List<T>>(
      data: sortedData,
      statusCode: response.statusCode,
      message: response.message,
      success: response.success,
      metadata: response.metadata,
      errors: response.errors,
      timestamp: response.timestamp,
    );
  }

  /// Checks if response indicates authentication error
  static bool isAuthError(ApiResponse response) {
    return response.statusCode == 401 || response.statusCode == 403;
  }

  /// Checks if response indicates network error
  static bool isNetworkError(ApiResponse response) {
    return response.statusCode == 0 || 
           response.statusCode >= 500 ||
           response.message.toLowerCase().contains('network') ||
           response.message.toLowerCase().contains('connection');
  }

  /// Checks if response indicates validation error
  static bool isValidationError(ApiResponse response) {
    return response.statusCode == 400 || response.statusCode == 422;
  }

  /// Gets user-friendly error message
  static String getUserFriendlyMessage(ApiResponse response) {
    if (response.isSuccess) {
      return response.message;
    }

    if (isAuthError(response)) {
      return 'Authentication required. Please login again.';
    }

    if (isNetworkError(response)) {
      return 'Network error. Please check your connection and try again.';
    }

    if (isValidationError(response)) {
      return response.firstError ?? 'Please check your input and try again.';
    }

    if (response.statusCode == 404) {
      return 'The requested resource was not found.';
    }

    if (response.statusCode >= 500) {
      return 'Server error. Please try again later.';
    }

    return response.message.isNotEmpty 
        ? response.message 
        : 'Something went wrong. Please try again.';
  }
}