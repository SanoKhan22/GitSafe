import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/simple_mock_api.dart';
import '../network/network_info.dart';
import '../../features/auth/data/datasources/auth_mock_datasource.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/domain/usecases/password_usecase.dart';

/// Simple service locator for GullyCric
/// 
/// Provides easy access to services and dependencies
final GetIt sl = GetIt.instance;

/// Setup simple service locator
Future<void> setupServiceLocator() async {
  // Core services
  sl.registerLazySingleton<SimpleMockApi>(() => SimpleMockApi());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl.instance);
  
  // Data sources
  sl.registerLazySingleton<AuthMockDataSource>(
    () => AuthMockDataSource(mockApiService: sl()),
  );
  
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorage: const FlutterSecureStorage(),
    ),
  );
  
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthMockDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  
  // Use cases
  sl.registerLazySingleton<LoginWithEmailUseCase>(
    () => LoginWithEmailUseCase(sl()),
  );
  
  sl.registerLazySingleton<SignUpWithEmailUseCase>(
    () => SignUpWithEmailUseCase(sl()),
  );
  
  sl.registerLazySingleton<SendPasswordResetEmailUseCase>(
    () => SendPasswordResetEmailUseCase(sl()),
  );
}