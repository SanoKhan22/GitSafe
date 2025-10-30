import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_config.dart' as config;
import 'config/flavor_config.dart';
import 'config/secure_config.dart';
import 'app/env/production_config.dart';
import 'core/di/dependency_injection.dart';
import 'core/utils/logger.dart';
import 'app/app.dart';

/// GullyCric Production Main Entry Point
/// 
/// Entry point for production builds with optimized settings
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logging with error level for production
  Logger.setLogLevel(LogLevel.error);
  Logger.i('Starting GullyCric application (Production)', tag: 'Main');

  try {
    // Initialize secure configuration
    await SecureConfig.initialize();
    
    // Initialize app configuration with production flavor
    config.AppConfig.initialize(
      flavor: Flavor.production,
      envConfig: ProductionConfig(),
      variables: {
        'PROD_API_URL': 'https://api.gullycric.com',
        'ENABLE_DEBUG_TOOLS': false,
        'MOCK_DATA_ENABLED': false,
        'ENABLE_PERFORMANCE_MONITORING': true,
        'ENABLE_CRASH_REPORTING': true,
      },
    );
    
    // Validate configuration in production
    final configErrors = SecureConfig.validateConfiguration();
    if (configErrors.isNotEmpty) {
      Logger.w('Configuration warnings: ${configErrors.join(', ')}', tag: 'Main');
    }
    
    // Initialize dependency injection
    await DependencyInjection.initialize();

    // Set preferred orientations (portrait for mobile cricket app)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Hide system UI overlays for immersive experience
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );

    Logger.i('GullyCric initialization completed successfully (Production)', tag: 'Main');

    // Run the app with Riverpod provider scope
    runApp(
      const ProviderScope(
        child: GullyCricApp(),
      ),
    );
  } catch (error, stackTrace) {
    Logger.e(
      'Failed to initialize GullyCric application (Production)',
      tag: 'Main',
      error: error,
      stackTrace: stackTrace,
    );

    // Run a minimal error app (simplified for production)
    runApp(
      MaterialApp(
        title: 'GullyCric',
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.sports_cricket,
                  size: 64,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                const Text(
                  'GullyCric',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Something went wrong. Please try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Restart the app
                    main();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}