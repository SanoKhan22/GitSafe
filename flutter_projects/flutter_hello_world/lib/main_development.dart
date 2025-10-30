import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_config.dart' as config;
import 'config/flavor_config.dart';
import 'config/secure_config.dart';
import 'app/env/dev_config.dart';
import 'core/di/dependency_injection.dart';
import 'core/utils/logger.dart';
import 'app/app.dart';

/// GullyCric Development Main Entry Point
/// 
/// Entry point for development builds with debug features enabled
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logging with debug level
  Logger.setLogLevel(LogLevel.debug);
  Logger.i('Starting GullyCric application (Development)', tag: 'Main');

  try {
    // Initialize secure configuration
    await SecureConfig.initialize();
    
    // Initialize app configuration with development flavor
    config.AppConfig.initialize(
      flavor: Flavor.development,
      envConfig: DevelopmentConfig(),
      variables: {
        'DEV_API_URL': 'https://dev-api.gullycric.com',
        'ENABLE_DEBUG_TOOLS': true,
        'MOCK_DATA_ENABLED': true,
        'ENABLE_PERFORMANCE_OVERLAY': true,
        'ENABLE_INSPECTOR': true,
      },
    );
    
    // Print configuration summary for development
    config.AppConfig.instance.printFullConfigSummary();
    SecureConfig.printConfigurationStatus();
    
    // Initialize dependency injection
    await DependencyInjection.initialize();

    // Set preferred orientations (portrait for mobile cricket app)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Logger.i('GullyCric initialization completed successfully (Development)', tag: 'Main');

    // Run the app with Riverpod provider scope
    runApp(
      const ProviderScope(
        child: GullyCricApp(),
      ),
    );
  } catch (error, stackTrace) {
    Logger.e(
      'Failed to initialize GullyCric application (Development)',
      tag: 'Main',
      error: error,
      stackTrace: stackTrace,
    );

    // Run a minimal error app
    runApp(
      MaterialApp(
        title: 'GullyCric Error',
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Failed to initialize GullyCric',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Error: $error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
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