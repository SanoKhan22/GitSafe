import 'package:dartz/dartz.dart';
import '../error/failure.dart';

/// Base Use Case Interface
/// 
/// All use cases in the application should implement this interface
/// Following Clean Architecture principles
abstract class UseCase<Type, Params> {
  /// Execute the use case with given parameters
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case with no parameters
class NoParams {
  const NoParams();
  
  @override
  bool operator ==(Object other) => other is NoParams;
  
  @override
  int get hashCode => 0;
  
  @override
  String toString() => 'NoParams()';
}

/// Stream Use Case Interface
/// 
/// For use cases that return streams (like real-time data)
abstract class StreamUseCase<Type, Params> {
  /// Execute the use case and return a stream
  Stream<Either<Failure, Type>> call(Params params);
}

/// Synchronous Use Case Interface
/// 
/// For use cases that don't require async operations
abstract class SyncUseCase<Type, Params> {
  /// Execute the use case synchronously
  Either<Failure, Type> call(Params params);
}

/// Future Use Case Interface (alias for UseCase)
/// 
/// More explicit naming for async use cases
abstract class FutureUseCase<Type, Params> extends UseCase<Type, Params> {}

/// Repository Use Case Interface
/// 
/// For use cases that directly interact with repositories
abstract class RepositoryUseCase<Type, Params> extends UseCase<Type, Params> {
  /// The repository this use case depends on
  /// Should be injected via constructor
}

/// Validation Use Case Interface
/// 
/// For use cases that perform validation without external dependencies
abstract class ValidationUseCase<Type, Params> extends SyncUseCase<Type, Params> {}

/// Utility functions for use cases
class UseCaseUtils {
  UseCaseUtils._();
  
  /// Execute multiple use cases in parallel
  static Future<List<Either<Failure, T>>> executeParallel<T>(
    List<Future<Either<Failure, T>>> useCases,
  ) async {
    return await Future.wait(useCases);
  }
  
  /// Execute use cases in sequence, stopping on first failure
  static Future<Either<Failure, List<T>>> executeSequential<T>(
    List<Future<Either<Failure, T>>> useCases,
  ) async {
    final results = <T>[];
    
    for (final useCase in useCases) {
      final result = await useCase;
      if (result.isLeft()) {
        return Left(result.fold((l) => l, (r) => throw Exception('Unexpected right value')));
      }
      results.add(result.fold((l) => throw Exception('Unexpected left value'), (r) => r));
    }
    
    return Right(results);
  }
  
  /// Combine multiple Either results
  static Either<Failure, List<T>> combineResults<T>(
    List<Either<Failure, T>> results,
  ) {
    final values = <T>[];
    
    for (final result in results) {
      if (result.isLeft()) {
        return Left(result.fold((l) => l, (r) => throw Exception('Unexpected right value')));
      }
      values.add(result.fold((l) => throw Exception('Unexpected left value'), (r) => r));
    }
    
    return Right(values);
  }
  
  /// Transform a list of values using a use case
  static Future<Either<Failure, List<R>>> transformList<T, R>(
    List<T> items,
    Future<Either<Failure, R>> Function(T) transformer,
  ) async {
    final results = <R>[];
    
    for (final item in items) {
      final result = await transformer(item);
      if (result.isLeft()) {
        return Left(result.fold((l) => l, (r) => throw Exception('Unexpected right value')));
      }
      results.add(result.fold((l) => throw Exception('Unexpected left value'), (r) => r));
    }
    
    return Right(results);
  }
}

/// Use Case Exception
/// 
/// Thrown when a use case encounters an unexpected error
class UseCaseException implements Exception {
  final String message;
  final dynamic cause;
  
  const UseCaseException(this.message, [this.cause]);
  
  @override
  String toString() {
    if (cause != null) {
      return 'UseCaseException: $message\nCaused by: $cause';
    }
    return 'UseCaseException: $message';
  }
}

/// Use Case Result
/// 
/// Wrapper for use case results with additional metadata
class UseCaseResult<T> {
  final T data;
  final DateTime executedAt;
  final Duration executionTime;
  final Map<String, dynamic>? metadata;
  
  const UseCaseResult({
    required this.data,
    required this.executedAt,
    required this.executionTime,
    this.metadata,
  });
  
  @override
  String toString() {
    return 'UseCaseResult(data: $data, executionTime: ${executionTime.inMilliseconds}ms)';
  }
}

/// Use Case Metrics
/// 
/// For tracking use case performance and usage
class UseCaseMetrics {
  final String useCaseName;
  final int executionCount;
  final Duration totalExecutionTime;
  final Duration averageExecutionTime;
  final int successCount;
  final int failureCount;
  final DateTime lastExecuted;
  
  const UseCaseMetrics({
    required this.useCaseName,
    required this.executionCount,
    required this.totalExecutionTime,
    required this.averageExecutionTime,
    required this.successCount,
    required this.failureCount,
    required this.lastExecuted,
  });
  
  /// Success rate as percentage
  double get successRate {
    if (executionCount == 0) return 0.0;
    return (successCount / executionCount) * 100;
  }
  
  /// Failure rate as percentage
  double get failureRate {
    if (executionCount == 0) return 0.0;
    return (failureCount / executionCount) * 100;
  }
  
  @override
  String toString() {
    return 'UseCaseMetrics(name: $useCaseName, executions: $executionCount, successRate: ${successRate.toStringAsFixed(1)}%)';
  }
}