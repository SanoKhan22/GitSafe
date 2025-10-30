import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../utils/logger.dart';
import '../../features/auth/data/datasources/auth_mock_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/cricket/data/datasources/cricket_simple_datasource.dart';
import '../../features/cricket/data/repositories/cricket_simple_repository.dart';
import '../../features/cricket/domain/repositories/cricket_repository.dart';

/// GullyCric Service Locator using GetIt
/// 
/// Alternative dependency injection approach using GetIt service locator
/// Can be used alongside or instead of Riverpod providers
class ServiceLocator {
  ServiceLocator._();

  static final GetIt _getIt = GetIt.instance;

  /// Get service locator instance
  static GetIt get instance => _getIt;

  /// Initialize all services
  static Future<void> initialize() async {
    Logger.i('Initializing service locator', tag: 'ServiceLocator');

    try {
      // Register network services
      await _registerNetworkServices();

      // Register core services
      await _registerCoreServices();

      // Register repositories
      await _registerRepositories();

      Logger.i('Service locator initialized successfully', tag: 'ServiceLocator');
    } catch (e, stackTrace) {
      Logger.e(
        'Failed to initialize service locator',
        tag: 'ServiceLocator',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Register network services
  static Future<void> _registerNetworkServices() async {
    Logger.d('Registering network services', tag: 'ServiceLocator');

    // Register Dio
    _getIt.registerLazySingleton<Dio>(() => Dio());

    // Register DioClient
    _getIt.registerLazySingleton<DioClient>(
      () => DioClient.instance,
    );

    // Register Connectivity
    _getIt.registerLazySingleton<Connectivity>(() => Connectivity());

    // Register NetworkInfo
    _getIt.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(_getIt<Connectivity>()),
    );
  }

  /// Register core services
  static Future<void> _registerCoreServices() async {
    Logger.d('Registering core services', tag: 'ServiceLocator');

    // Register SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    _getIt.registerSingleton<SharedPreferences>(sharedPreferences);

    // Register FlutterSecureStorage
    _getIt.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    );
  }

  /// Register repositories
  static Future<void> _registerRepositories() async {
    Logger.d('Registering repositories', tag: 'ServiceLocator');

    // Register Auth datasources
    _getIt.registerLazySingleton<AuthMockDataSource>(
      () => AuthMockDataSource(),
    );

    // Register Auth repository
    _getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        mockDataSource: _getIt<AuthMockDataSource>(),
        networkInfo: _getIt<NetworkInfo>(),
      ),
    );

    // Register Cricket datasources
    _getIt.registerLazySingleton<CricketSimpleDataSource>(
      () => CricketSimpleDataSource(),
    );

    // Register Cricket repository
    _getIt.registerLazySingleton<CricketRepository>(
      () => CricketSimpleRepository(
        dataSource: _getIt<CricketSimpleDataSource>(),
      ),
    );
  }

  /// Reset service locator (useful for testing)
  static Future<void> reset() async {
    await _getIt.reset();
  }
}