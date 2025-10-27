# Flutter Setup Scripts

This directory contains all the setup scripts for the Flutter Android development environment.

## Scripts Overview

- `01_system_preparation.sh` - Install system dependencies (Git, Java, etc.)
- `02_flutter_sdk.sh` - Download and install Flutter SDK
- `03_flutter_path_config.sh` - Configure Flutter PATH and environment
- `04_hello_world_app.sh` - Create and test Hello World Flutter app
- `05_test_web.sh` - Test Flutter app in web browser
- `06_test_android.sh` - Test Flutter app on Android device
- `07_production_builds.sh` - Build production APK and AAB files
- `08_environment_export.sh` - Export environment configuration and docs
- `09_comprehensive_validation.sh` - Validate complete environment setup
- `setup_flutter_environment.sh` - Master orchestration script (interactive)
- `validate_system.sh` - Quick system validation

## Usage

### Interactive Setup (Recommended)
```bash
./flutter_setup/setup_flutter_environment.sh
```

### Command Line Setup
```bash
# Complete setup
./flutter_setup/setup_flutter_environment.sh complete

# Individual steps
./flutter_setup/setup_flutter_environment.sh system
./flutter_setup/setup_flutter_environment.sh flutter
./flutter_setup/setup_flutter_environment.sh hello
./flutter_setup/setup_flutter_environment.sh android
./flutter_setup/setup_flutter_environment.sh build
```

### Manual Step-by-Step
```bash
# 1. System preparation
./flutter_setup/01_system_preparation.sh

# 2. Flutter SDK setup
./flutter_setup/02_flutter_sdk.sh
./flutter_setup/03_flutter_path_config.sh

# 3. Create test app
./flutter_setup/04_hello_world_app.sh

# 4. Test on devices
./flutter_setup/06_test_android.sh  # Android device
./flutter_setup/05_test_web.sh      # Web browser

# 5. Build production packages
./flutter_setup/07_production_builds.sh

# 6. Validate environment
./flutter_setup/09_comprehensive_validation.sh
```

## Requirements

- Pop!_OS 22.04 LTS (or compatible Ubuntu-based system)
- Internet connection for downloads
- Android device with USB debugging enabled (for Android testing)
- Chrome browser (for web testing)

## Notes

- All scripts are designed to be run from the project root directory
- Scripts include comprehensive error handling and validation
- Each script can be run independently or as part of the complete setup
- The master script provides both interactive and command-line interfaces
