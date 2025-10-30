# GullyCric Configuration Guide

This document explains how to configure the GullyCric Flutter application for different environments and how to set up API keys and other sensitive data.

## Overview

GullyCric uses a multi-layered configuration system:

1. **Flavor Configuration** - Build variants (development, staging, production)
2. **Environment Configuration** - Environment-specific settings
3. **Secure Configuration** - API keys and sensitive data
4. **App Configuration** - Combined configuration management

## Build Flavors

### Development
- **Entry Point**: `lib/main_development.dart`
- **Features**: Debug tools, mock data, verbose logging
- **API**: Development API endpoints
- **Database**: `gullycric_dev.db`

### Staging
- **Entry Point**: `lib/main_staging.dart`
- **Features**: Testing features, analytics enabled
- **API**: Staging API endpoints
- **Database**: `gullycric_staging.db`

### Production
- **Entry Point**: `lib/main_production.dart`
- **Features**: Optimized, security enabled, minimal logging
- **API**: Production API endpoints
- **Database**: `gullycric.db`

## Configuration Files

### 1. Flavor Configuration (`lib/config/flavor_config.dart`)
Manages build-specific settings and feature flags.

### 2. Environment Configuration (`lib/app/env/`)
- `dev_config.dart` - Development environment settings
- `staging_config.dart` - Staging environment settings
- `production_config.dart` - Production environment settings

### 3. Secure Configuration (`lib/config/secure_config.dart`)
Manages API keys and sensitive data from `assets/config/secure_config.json`.

### 4. App Configuration (`lib/config/app_config.dart`)
Combines all configurations into a single interface.

## Setting Up API Keys

### Step 1: Create Secure Configuration File

Copy the template file:
```bash
cp assets/config/secure_config.json.template assets/config/secure_config.json
```

### Step 2: Configure API Keys

Edit `assets/config/secure_config.json`:

```json
{
  "api_keys": {
    "cricket_api": {
      "key": "your_actual_cricket_api_key",
      "secret": "your_actual_cricket_api_secret",
      "enabled": true
    },
    "weather_api": {
      "key": "your_actual_weather_api_key",
      "enabled": true
    },
    "maps_api": {
      "key": "your_actual_maps_api_key",
      "enabled": true
    },
    "news_api": {
      "key": "your_actual_news_api_key",
      "enabled": true
    }
  },
  "firebase": {
    "project_id": "your_firebase_project_id",
    "api_key": "your_firebase_api_key",
    "app_id": "your_firebase_app_id",
    "messaging_sender_id": "your_firebase_sender_id",
    "enabled": true
  }
}
```

### Step 3: Security Considerations

- **Never commit** `secure_config.json` to version control
- Add `assets/config/secure_config.json` to `.gitignore`
- Use environment variables in CI/CD pipelines
- Consider using Flutter's `--dart-define` for sensitive values

## Running Different Flavors

### Development
```bash
flutter run -t lib/main_development.dart
```

### Staging
```bash
flutter run -t lib/main_staging.dart
```

### Production
```bash
flutter run -t lib/main_production.dart --release
```

## Environment Variables

You can override configuration using environment variables:

```bash
export CRICKET_API_KEY="your_key_here"
export FIREBASE_PROJECT_ID="your_project_id"
flutter run -t lib/main_development.dart
```

## Configuration Access in Code

### Basic Usage
```dart
import 'package:flutter_hello_world/config/app_config.dart';

// Get current configuration
final config = AppConfig.instance;

// Check environment
if (config.isDevelopment) {
  // Development-specific code
}

// Get API endpoints
final apiUrl = config.getApiEndpoint('matches');
final fullUrl = config.getFullApiUrl('/api/v1/matches');

// Check feature flags
if (config.enableMockData) {
  // Use mock data
}

// Get API keys
if (config.isApiKeyConfigured('cricket')) {
  final apiKey = config.cricketApiKey;
  // Use API key
}
```

### Secure Configuration
```dart
import 'package:flutter_hello_world/config/secure_config.dart';

// Check if service is configured
if (SecureConfig.isApiKeyConfigured('cricket_api')) {
  final apiKey = SecureConfig.getApiKey('cricket_api');
  // Use API key
}

// Get Firebase configuration
final firebaseConfig = SecureConfig.getFirebaseConfig();
if (SecureConfig.isFirebaseConfigured()) {
  // Initialize Firebase
}
```

## Feature Flags

Feature flags are automatically set based on the build flavor:

### Development
- `enableDebugMode`: true
- `enableTestFeatures`: true
- `enableMockData`: true

### Staging
- `enableDebugMode`: true
- `enableTestFeatures`: true
- `enableMockData`: false

### Production
- `enableDebugMode`: false
- `enableTestFeatures`: false
- `enableMockData`: false

## API Endpoints

### Development
- Base URL: `https://dev-api.gullycric.com`
- Timeout: 30 seconds
- Retries: 3

### Staging
- Base URL: `https://staging-api.gullycric.com`
- Timeout: 20 seconds
- Retries: 3

### Production
- Base URL: `https://api.gullycric.com`
- Timeout: 15 seconds
- Retries: 3

## Database Configuration

### Development
- Name: `gullycric_dev.db`
- Encryption: Disabled
- Debug queries: Enabled

### Staging
- Name: `gullycric_staging.db`
- Encryption: Disabled
- Debug queries: Enabled

### Production
- Name: `gullycric.db`
- Encryption: Enabled
- Debug queries: Disabled

## Logging Configuration

### Development
- Level: DEBUG
- File logging: Enabled
- Console logging: Enabled

### Staging
- Level: INFO
- File logging: Enabled
- Console logging: Enabled

### Production
- Level: ERROR
- File logging: Disabled
- Console logging: Disabled

## Security Configuration

### Development
- Certificate pinning: Disabled
- Database encryption: Disabled
- Biometric auth: Enabled

### Staging
- Certificate pinning: Disabled
- Database encryption: Disabled
- Biometric auth: Enabled

### Production
- Certificate pinning: Enabled
- Database encryption: Enabled
- Biometric auth: Enabled

## Troubleshooting

### Configuration Not Loading
1. Check if `secure_config.json` exists in `assets/config/`
2. Verify the JSON syntax is valid
3. Ensure assets are declared in `pubspec.yaml`

### API Keys Not Working
1. Verify the API key is correct in `secure_config.json`
2. Check if the service is enabled (`"enabled": true`)
3. Ensure the API key doesn't contain placeholder text

### Build Flavor Issues
1. Make sure you're using the correct entry point (`-t` flag)
2. Check if the flavor configuration is initialized properly
3. Verify environment-specific configurations are correct

### Debug Information
Use these methods to debug configuration issues:

```dart
// Print configuration summary
AppConfig.instance.printFullConfigSummary();

// Print secure configuration status
SecureConfig.printConfigurationStatus();

// Validate configuration
final errors = SecureConfig.validateConfiguration();
if (errors.isNotEmpty) {
  print('Configuration errors: $errors');
}
```

## Best Practices

1. **Never commit sensitive data** to version control
2. **Use different API keys** for different environments
3. **Enable security features** in production
4. **Test configurations** in staging before production
5. **Monitor configuration errors** in production
6. **Use environment variables** in CI/CD pipelines
7. **Validate configurations** on app startup
8. **Document configuration changes** for team members

## CI/CD Integration

For automated builds, you can inject configuration using environment variables:

```yaml
# GitHub Actions example
- name: Create secure config
  run: |
    echo '{
      "api_keys": {
        "cricket_api": {
          "key": "${{ secrets.CRICKET_API_KEY }}",
          "enabled": true
        }
      }
    }' > assets/config/secure_config.json

- name: Build app
  run: flutter build apk -t lib/main_production.dart
```

This configuration system provides flexibility, security, and maintainability for the GullyCric application across different environments and deployment scenarios.