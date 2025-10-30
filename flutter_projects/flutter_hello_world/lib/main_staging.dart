import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_config.dart' as config;
import 'config/flavor_config.dart';
import 'config/secure_config.dart';
import 'app/env/staging_config.dart';
import 'core/di/dependency_injection.dart';
import 'core/utils/logger.dart';
import 'app/app.dart';

/// GullyCric Staging Main Entry Point
/// 
/// Entry point for staging builds with testing features enabled
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logging with info level
  Logger.setLogLevel(LogLevel.info);
  Logger.i('Starting GullyCric application (Staging)', tag: 'Main');

  try {
    // Initialize secure configuration
    await SecureConfig.initialize();
    
    // Initialize app configuration with staging flavor
    config.AppConfig.initialize(
      flavor: Flavor.staging,
      envConfig: StagingConfig(),
      variables: {
        'STAGING_API_URL': 'https://staging-api.gullycric.com',
        'ENABLE_DEBUG_TOOLS': true,
        'MOCK_DATA_ENABLED': false,
        'ENABLE_PERFORMANCE_MONITORING': true,
      },
    );
    
    // Print configuration summary for staging
    if (config.AppConfig.instance.isDebug) {
      config.AppConfig.instance.printFullConfigSummary();
      SecureConfig.printConfigurationStatus();
    }
    
    // Initialize dependency injection
    await DependencyInjection.initialize();

    // Set preferred orientations (portrait for mobile cricket app)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Logger.i('GullyCric initialization completed successfully (Staging)', tag: 'Main');

    // Run the app with Riverpod provider scope
    runApp(
      const ProviderScope(
        child: GullyCricApp(),
      ),
    );
  } catch (error, stackTrace) {
    Logger.e(
      'Failed to initialize GullyCric application (Staging)',
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