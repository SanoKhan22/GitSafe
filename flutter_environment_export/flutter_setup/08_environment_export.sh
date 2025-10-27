#!/bin/bash

# Flutter Android Build Environment Setup - Environment Export and Documentation
# This script exports environment configuration and creates documentation

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[EXPORT]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[EXPORT]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[EXPORT]${NC} $1"
}

log_error() {
    echo -e "${RED}[EXPORT]${NC} $1"
}

# Configuration
EXPORT_DIR="./flutter_environment_export"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Function to create export directory
create_export_directory() {
    log_info "Creating export directory..."
    
    if [[ -d "$EXPORT_DIR" ]]; then
        log_warning "Export directory already exists: $EXPORT_DIR"
        
        # Create timestamped backup
        local backup_dir="${EXPORT_DIR}_backup_$TIMESTAMP"
        mv "$EXPORT_DIR" "$backup_dir"
        log_info "Previous export backed up to: $backup_dir"
    fi
    
    mkdir -p "$EXPORT_DIR"
    log_success "Export directory created: $EXPORT_DIR"
    
    return 0
}

# Function to export environment variables
export_environment_variables() {
    log_info "Exporting environment variables..."
    
    local env_file="$EXPORT_DIR/environment_variables.sh"
    
    cat > "$env_file" << 'EOF'
#!/bin/bash
# Flutter Android Development Environment Variables
# Generated automatically - do not edit manually

# System Information
EOF
    
    echo "export FLUTTER_ENV_EXPORT_DATE=\"$(date)\"" >> "$env_file"
    echo "export FLUTTER_ENV_SYSTEM=\"$(uname -a)\"" >> "$env_file"
    echo "" >> "$env_file"
    
    # Flutter environment
    echo "# Flutter SDK Configuration" >> "$env_file"
    if command -v flutter >/dev/null 2>&1; then
        local flutter_path=$(which flutter)
        local flutter_dir=$(dirname "$(dirname "$flutter_path")")
        echo "export PATH=\"\$PATH:$flutter_dir/bin\"" >> "$env_file"
        echo "export FLUTTER_ROOT=\"$flutter_dir\"" >> "$env_file"
        
        # Dart SDK (if separate)
        local dart_sdk_path="$flutter_dir/bin/cache/dart-sdk/bin"
        if [[ -d "$dart_sdk_path" ]]; then
            echo "export PATH=\"\$PATH:$dart_sdk_path\"" >> "$env_file"
        fi
    fi
    echo "" >> "$env_file"
    
    # Android SDK environment
    echo "# Android SDK Configuration" >> "$env_file"
    if [[ -n "$ANDROID_HOME" ]]; then
        echo "export ANDROID_HOME=\"$ANDROID_HOME\"" >> "$env_file"
        echo "export ANDROID_SDK_ROOT=\"$ANDROID_HOME\"" >> "$env_file"
        echo "export PATH=\"\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin\"" >> "$env_file"
        echo "export PATH=\"\$PATH:\$ANDROID_HOME/platform-tools\"" >> "$env_file"
        echo "export PATH=\"\$PATH:\$ANDROID_HOME/build-tools/latest\"" >> "$env_file"
    elif [[ -d "/usr/lib/android-sdk" ]]; then
        echo "export ANDROID_HOME=\"/usr/lib/android-sdk\"" >> "$env_file"
        echo "export ANDROID_SDK_ROOT=\"/usr/lib/android-sdk\"" >> "$env_file"
        echo "export PATH=\"\$PATH:/usr/lib/android-sdk/cmdline-tools/latest/bin\"" >> "$env_file"
        echo "export PATH=\"\$PATH:/usr/lib/android-sdk/platform-tools\"" >> "$env_file"
        echo "export PATH=\"\$PATH:/usr/lib/android-sdk/build-tools/latest\"" >> "$env_file"
    fi
    echo "" >> "$env_file"
    
    # Java environment
    echo "# Java Configuration" >> "$env_file"
    if [[ -n "$JAVA_HOME" ]]; then
        echo "export JAVA_HOME=\"$JAVA_HOME\"" >> "$env_file"
    elif command -v java >/dev/null 2>&1; then
        local java_home=$(readlink -f $(which java) | sed "s:/bin/java::")
        echo "export JAVA_HOME=\"$java_home\"" >> "$env_file"
    fi
    echo "" >> "$env_file"
    
    # Chrome for web development
    echo "# Chrome Configuration" >> "$env_file"
    if command -v google-chrome >/dev/null 2>&1; then
        echo "export CHROME_EXECUTABLE=\"$(which google-chrome)\"" >> "$env_file"
    elif command -v chromium >/dev/null 2>&1; then
        echo "export CHROME_EXECUTABLE=\"$(which chromium)\"" >> "$env_file"
    fi
    
    chmod +x "$env_file"
    log_success "Environment variables exported to: $env_file"
    
    return 0
}

# Function to export version information
export_version_information() {
    log_info "Exporting version information..."
    
    local versions_file="$EXPORT_DIR/versions.txt"
    
    cat > "$versions_file" << EOF
Flutter Android Development Environment - Version Information
Generated: $(date)
System: $(uname -a)

EOF
    
    # Flutter version
    if command -v flutter >/dev/null 2>&1; then
        echo "=== Flutter ===" >> "$versions_file"
        flutter --version >> "$versions_file" 2>&1
        echo "" >> "$versions_file"
    fi
    
    # Dart version
    if command -v dart >/dev/null 2>&1; then
        echo "=== Dart ===" >> "$versions_file"
        dart --version >> "$versions_file" 2>&1
        echo "" >> "$versions_file"
    fi
    
    # Java version
    if command -v java >/dev/null 2>&1; then
        echo "=== Java ===" >> "$versions_file"
        java -version >> "$versions_file" 2>&1
        echo "" >> "$versions_file"
    fi
    
    # Android SDK
    if command -v adb >/dev/null 2>&1; then
        echo "=== Android SDK ===" >> "$versions_file"
        adb version >> "$versions_file" 2>&1
        echo "" >> "$versions_file"
    fi
    
    # Git version
    if command -v git >/dev/null 2>&1; then
        echo "=== Git ===" >> "$versions_file"
        git --version >> "$versions_file" 2>&1
        echo "" >> "$versions_file"
    fi
    
    # Chrome version
    if command -v google-chrome >/dev/null 2>&1; then
        echo "=== Chrome ===" >> "$versions_file"
        google-chrome --version >> "$versions_file" 2>&1
        echo "" >> "$versions_file"
    fi
    
    log_success "Version information exported to: $versions_file"
    
    return 0
}

# Function to export Flutter doctor output
export_flutter_doctor() {
    log_info "Exporting Flutter doctor output..."
    
    local doctor_file="$EXPORT_DIR/flutter_doctor.txt"
    
    if command -v flutter >/dev/null 2>&1; then
        echo "Flutter Doctor Output - $(date)" > "$doctor_file"
        echo "======================================" >> "$doctor_file"
        echo "" >> "$doctor_file"
        
        flutter doctor -v >> "$doctor_file" 2>&1
        
        log_success "Flutter doctor output exported to: $doctor_file"
    else
        log_warning "Flutter not available, skipping doctor export"
    fi
    
    return 0
}

# Function to create setup documentation
create_setup_documentation() {
    log_info "Creating setup documentation..."
    
    local readme_file="$EXPORT_DIR/README.md"
    
    cat > "$readme_file" << 'EOF'
# Flutter Android Development Environment

This directory contains the exported configuration for a complete Flutter Android development environment.

## Generated Files

- `environment_variables.sh` - Environment variables to source in your shell
- `versions.txt` - Version information for all installed tools
- `flutter_doctor.txt` - Complete Flutter doctor output
- `setup_instructions.md` - Step-by-step setup instructions
- `troubleshooting.md` - Common issues and solutions

## Quick Setup

1. Source the environment variables:
   ```bash
   source environment_variables.sh
   ```

2. Verify the setup:
   ```bash
   flutter doctor -v
   ```

## Requirements

- Pop!_OS 22.04 LTS (or compatible Ubuntu-based system)
- Git, Curl, Unzip, Zip utilities
- OpenJDK 17
- Android SDK with platform-tools and build-tools
- Chrome browser for web development

## Project Structure

```
flutter_projects/
└── flutter_hello_world/          # Test application
    ├── android/                   # Android-specific code
    ├── lib/                       # Flutter/Dart source code
    ├── web/                       # Web-specific code
    └── build/                     # Build outputs
        ├── app/outputs/flutter-apk/app-release.apk    # Release APK
        └── app/outputs/bundle/release/app-release.aab  # App Bundle
```

## Build Commands

### Development
```bash
# Run on connected Android device
flutter run -d android

# Run in Chrome browser
flutter run -d chrome

# Hot reload (during development)
# Press 'r' in the terminal while flutter run is active
```

### Production Builds
```bash
# Build release APK
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle --release
```

## Device Testing

### Android Device
1. Enable Developer Options on your Android device
2. Enable USB Debugging
3. Connect device via USB
4. Run: `flutter devices` to verify detection
5. Run: `flutter run -d android` to deploy and test

### Web Browser
1. Run: `flutter run -d chrome`
2. App will open automatically in Chrome
3. Test functionality in browser developer tools

## Security Notes

- Keep your keystore file secure: `~/.android/release-key.jks`
- Backup your keystore - it cannot be recovered if lost
- Never commit keystore files or passwords to version control

## Support

For issues and troubleshooting, see `troubleshooting.md` or refer to:
- Flutter documentation: https://docs.flutter.dev/
- Android developer documentation: https://developer.android.com/
EOF
    
    log_success "Setup documentation created: $readme_file"
    
    return 0
}

# Function to create setup instructions
create_setup_instructions() {
    log_info "Creating detailed setup instructions..."
    
    local instructions_file="$EXPORT_DIR/setup_instructions.md"
    
    cat > "$instructions_file" << 'EOF'
# Flutter Android Development Environment Setup Instructions

## System Preparation

### 1. Update System
```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Install Core Dependencies
```bash
sudo apt install git curl unzip zip openjdk-17-jdk -y
```

### 3. Configure Java
```bash
# Set Java 17 as default
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-17-openjdk-amd64/bin/java 1700
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-17-openjdk-amd64/bin/javac 1700

# Set JAVA_HOME
echo 'export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"' >> ~/.bashrc
```

## Flutter SDK Installation

### 1. Download Flutter
```bash
# Create installation directory
mkdir -p ~/flutter

# Download Flutter (replace URL with latest stable)
curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz -o flutter.tar.xz

# Extract Flutter
tar -xf flutter.tar.xz -C ~/
```

### 2. Configure Flutter PATH
```bash
# Add to shell configuration
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc

# Reload shell configuration
source ~/.bashrc
```

### 3. Initialize Flutter
```bash
# Run Flutter doctor
flutter doctor

# Accept Android licenses (if Android SDK is available)
flutter doctor --android-licenses
```

## Android SDK Setup

### Option 1: Using Flutter (Recommended)
```bash
# Flutter will prompt to install Android SDK
flutter doctor

# Follow prompts to install Android SDK
```

### Option 2: Manual Installation
```bash
# Download Android command line tools
mkdir -p ~/Android/Sdk/cmdline-tools
cd ~/Android/Sdk/cmdline-tools

# Download and extract command line tools
curl -L https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -o cmdline-tools.zip
unzip cmdline-tools.zip
mv cmdline-tools latest

# Set environment variables
echo 'export ANDROID_HOME="$HOME/Android/Sdk"' >> ~/.bashrc
echo 'export ANDROID_SDK_ROOT="$ANDROID_HOME"' >> ~/.bashrc
echo 'export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"' >> ~/.bashrc
echo 'export PATH="$PATH:$ANDROID_HOME/platform-tools"' >> ~/.bashrc

# Reload shell
source ~/.bashrc

# Install SDK components
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.1"

# Accept licenses
yes | sdkmanager --licenses
```

## Chrome Installation

### Install Google Chrome
```bash
# Download and install Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install google-chrome-stable -y
```

## Verification

### 1. Run Flutter Doctor
```bash
flutter doctor -v
```

### 2. Create Test Project
```bash
# Create new Flutter project
flutter create hello_world
cd hello_world

# Test web build
flutter run -d chrome

# Test Android build (with device connected)
flutter run -d android
```

### 3. Build Production Packages
```bash
# Build release APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

## Android Device Setup

### 1. Enable Developer Options
1. Go to Settings > About Phone
2. Tap "Build Number" 7 times
3. Developer Options will appear in Settings

### 2. Enable USB Debugging
1. Go to Settings > Developer Options
2. Enable "USB Debugging"
3. Connect device via USB
4. Accept debugging prompt on device

### 3. Verify Device Connection
```bash
# Check ADB connection
adb devices

# Check Flutter device detection
flutter devices
```

## Troubleshooting

### Common Issues

1. **Flutter not found in PATH**
   - Restart terminal or run `source ~/.bashrc`
   - Verify PATH contains Flutter bin directory

2. **Android licenses not accepted**
   - Run `flutter doctor --android-licenses`
   - Accept all license agreements

3. **Device not detected**
   - Check USB debugging is enabled
   - Try different USB cable/port
   - Run `adb kill-server && adb start-server`

4. **Build failures**
   - Run `flutter clean && flutter pub get`
   - Check Java version: `java -version`
   - Verify Android SDK installation

### Getting Help

- Flutter documentation: https://docs.flutter.dev/
- Flutter community: https://flutter.dev/community
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
EOF
    
    log_success "Setup instructions created: $instructions_file"
    
    return 0
}

# Function to create troubleshooting guide
create_troubleshooting_guide() {
    log_info "Creating troubleshooting guide..."
    
    local troubleshooting_file="$EXPORT_DIR/troubleshooting.md"
    
    cat > "$troubleshooting_file" << 'EOF'
# Flutter Android Development - Troubleshooting Guide

## Common Issues and Solutions

### Flutter Issues

#### Flutter command not found
**Problem:** `flutter: command not found`

**Solutions:**
1. Check if Flutter is in PATH:
   ```bash
   echo $PATH | grep flutter
   ```
2. Add Flutter to PATH:
   ```bash
   echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
   source ~/.bashrc
   ```
3. Verify Flutter installation:
   ```bash
   ls -la ~/flutter/bin/flutter
   ```

#### Flutter doctor issues
**Problem:** Flutter doctor reports issues

**Solutions:**
1. Accept Android licenses:
   ```bash
   flutter doctor --android-licenses
   ```
2. Install missing components:
   ```bash
   flutter doctor
   # Follow the suggestions provided
   ```

### Android SDK Issues

#### Android SDK not found
**Problem:** Android toolchain issues in flutter doctor

**Solutions:**
1. Set ANDROID_HOME:
   ```bash
   export ANDROID_HOME="$HOME/Android/Sdk"
   export ANDROID_SDK_ROOT="$ANDROID_HOME"
   ```
2. Install Android SDK:
   ```bash
   flutter doctor
   # Follow Android SDK installation prompts
   ```

#### ADB not found
**Problem:** `adb: command not found`

**Solutions:**
1. Install platform-tools:
   ```bash
   sdkmanager "platform-tools"
   ```
2. Add to PATH:
   ```bash
   export PATH="$PATH:$ANDROID_HOME/platform-tools"
   ```

### Device Connection Issues

#### Device not detected
**Problem:** `flutter devices` shows no Android devices

**Solutions:**
1. Enable USB debugging on device
2. Check USB connection:
   ```bash
   adb devices
   ```
3. Restart ADB:
   ```bash
   adb kill-server
   adb start-server
   ```
4. Check device permissions:
   ```bash
   lsusb
   # Look for your device
   ```

#### Permission denied
**Problem:** Permission errors when accessing device

**Solutions:**
1. Add user to plugdev group:
   ```bash
   sudo usermod -a -G plugdev $USER
   ```
2. Create udev rules:
   ```bash
   sudo nano /etc/udev/rules.d/51-android.rules
   # Add: SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"
   sudo udevadm control --reload-rules
   ```

### Build Issues

#### Gradle build failures
**Problem:** Build fails with Gradle errors

**Solutions:**
1. Clean and rebuild:
   ```bash
   flutter clean
   flutter pub get
   flutter build apk
   ```
2. Check Java version:
   ```bash
   java -version
   # Should be Java 17
   ```
3. Clear Gradle cache:
   ```bash
   rm -rf ~/.gradle/caches/
   ```

#### Out of memory errors
**Problem:** Build fails with out of memory

**Solutions:**
1. Increase Gradle memory:
   ```bash
   echo "org.gradle.jvmargs=-Xmx4g" >> ~/.gradle/gradle.properties
   ```
2. Close other applications during build

#### Signing errors
**Problem:** App signing failures

**Solutions:**
1. Check keystore file exists:
   ```bash
   ls -la ~/.android/release-key.jks
   ```
2. Verify key.properties:
   ```bash
   cat android/key.properties
   ```
3. Regenerate keystore if needed:
   ```bash
   keytool -genkey -v -keystore ~/.android/release-key.jks -alias release -keyalg RSA -keysize 2048 -validity 10000
   ```

### Web Development Issues

#### Chrome not launching
**Problem:** Flutter web doesn't open in Chrome

**Solutions:**
1. Check Chrome installation:
   ```bash
   which google-chrome
   ```
2. Set Chrome executable:
   ```bash
   export CHROME_EXECUTABLE="/usr/bin/google-chrome"
   ```
3. Use specific port:
   ```bash
   flutter run -d chrome --web-port=8080
   ```

### Performance Issues

#### Slow builds
**Problem:** Flutter builds are very slow

**Solutions:**
1. Enable Gradle daemon:
   ```bash
   echo "org.gradle.daemon=true" >> ~/.gradle/gradle.properties
   ```
2. Use build cache:
   ```bash
   echo "org.gradle.caching=true" >> ~/.gradle/gradle.properties
   ```
3. Increase parallel builds:
   ```bash
   echo "org.gradle.parallel=true" >> ~/.gradle/gradle.properties
   ```

#### Hot reload not working
**Problem:** Hot reload doesn't update app

**Solutions:**
1. Check if running in debug mode
2. Restart Flutter:
   ```bash
   # Press 'R' in terminal for hot restart
   # Press 'r' for hot reload
   ```
3. Full restart:
   ```bash
   flutter run
   ```

## Diagnostic Commands

### System Information
```bash
# System info
uname -a
lsb_release -a

# Java info
java -version
javac -version
echo $JAVA_HOME

# Flutter info
flutter --version
flutter doctor -v
flutter devices

# Android info
adb version
adb devices
echo $ANDROID_HOME
```

### Log Collection
```bash
# Flutter logs
flutter logs

# Android device logs
adb logcat

# Gradle logs (during build)
flutter build apk --verbose
```

## Getting Additional Help

### Official Resources
- Flutter documentation: https://docs.flutter.dev/
- Flutter GitHub issues: https://github.com/flutter/flutter/issues
- Android developer docs: https://developer.android.com/

### Community Support
- Flutter community: https://flutter.dev/community
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
- Reddit: https://www.reddit.com/r/FlutterDev/

### Reporting Issues
When reporting issues, include:
1. Output of `flutter doctor -v`
2. Complete error messages
3. Steps to reproduce
4. System information (`uname -a`)
5. Flutter and Dart versions
EOF
    
    log_success "Troubleshooting guide created: $troubleshooting_file"
    
    return 0
}

# Function to create installation summary
create_installation_summary() {
    log_info "Creating installation summary..."
    
    local summary_file="$EXPORT_DIR/installation_summary.txt"
    
    cat > "$summary_file" << EOF
Flutter Android Development Environment - Installation Summary
Generated: $(date)
System: $(uname -a)

=== INSTALLED COMPONENTS ===

EOF
    
    # Check each component
    if command -v flutter >/dev/null 2>&1; then
        echo "✓ Flutter SDK: $(flutter --version | head -n1)" >> "$summary_file"
    else
        echo "✗ Flutter SDK: Not installed" >> "$summary_file"
    fi
    
    if command -v dart >/dev/null 2>&1; then
        echo "✓ Dart SDK: $(dart --version 2>&1 | head -n1)" >> "$summary_file"
    else
        echo "✗ Dart SDK: Not installed" >> "$summary_file"
    fi
    
    if command -v java >/dev/null 2>&1; then
        echo "✓ Java: $(java -version 2>&1 | head -n1)" >> "$summary_file"
    else
        echo "✗ Java: Not installed" >> "$summary_file"
    fi
    
    if command -v adb >/dev/null 2>&1; then
        echo "✓ Android SDK: $(adb version | head -n1)" >> "$summary_file"
    else
        echo "✗ Android SDK: Not installed" >> "$summary_file"
    fi
    
    if command -v git >/dev/null 2>&1; then
        echo "✓ Git: $(git --version)" >> "$summary_file"
    else
        echo "✗ Git: Not installed" >> "$summary_file"
    fi
    
    if command -v google-chrome >/dev/null 2>&1; then
        echo "✓ Chrome: $(google-chrome --version)" >> "$summary_file"
    else
        echo "✗ Chrome: Not installed" >> "$summary_file"
    fi
    
    echo "" >> "$summary_file"
    echo "=== ENVIRONMENT PATHS ===" >> "$summary_file"
    echo "PATH: $PATH" >> "$summary_file"
    echo "JAVA_HOME: ${JAVA_HOME:-Not set}" >> "$summary_file"
    echo "ANDROID_HOME: ${ANDROID_HOME:-Not set}" >> "$summary_file"
    echo "FLUTTER_ROOT: ${FLUTTER_ROOT:-Not set}" >> "$summary_file"
    
    echo "" >> "$summary_file"
    echo "=== PROJECT LOCATIONS ===" >> "$summary_file"
    if [[ -d "./flutter_projects/flutter_hello_world" ]]; then
        echo "✓ Test Project: ./flutter_projects/flutter_hello_world" >> "$summary_file"
        
        # Check build artifacts
        local apk_path="./flutter_projects/flutter_hello_world/build/app/outputs/flutter-apk/app-release.apk"
        local aab_path="./flutter_projects/flutter_hello_world/build/app/outputs/bundle/release/app-release.aab"
        
        if [[ -f "$apk_path" ]]; then
            local apk_size=$(du -sh "$apk_path" | cut -f1)
            echo "  ✓ Release APK: $apk_path ($apk_size)" >> "$summary_file"
        fi
        
        if [[ -f "$aab_path" ]]; then
            local aab_size=$(du -sh "$aab_path" | cut -f1)
            echo "  ✓ App Bundle: $aab_path ($aab_size)" >> "$summary_file"
        fi
    else
        echo "✗ Test Project: Not created" >> "$summary_file"
    fi
    
    if [[ -f "./flutter_projects/.android/release-key.jks" ]]; then
        echo "✓ Keystore: ./flutter_projects/.android/release-key.jks" >> "$summary_file"
    else
        echo "✗ Keystore: Not created" >> "$summary_file"
    fi
    
    echo "" >> "$summary_file"
    echo "=== SETUP SCRIPTS ===" >> "$summary_file"
    if [[ -d "./flutter_setup" ]]; then
        echo "✓ Setup Scripts Directory: ./flutter_setup" >> "$summary_file"
        local script_count=$(find ./flutter_setup -name "*.sh" -type f | wc -l)
        echo "  Script Count: $script_count files" >> "$summary_file"
        
        # List all setup scripts
        find ./flutter_setup -name "*.sh" -type f | sort | while read script; do
            local script_name=$(basename "$script")
            echo "  ✓ $script_name" >> "$summary_file"
        done
    else
        echo "✗ Setup Scripts: Directory not found" >> "$summary_file"
    fi
    
    log_success "Installation summary created: $summary_file"
    
    return 0
}

# Function to copy setup scripts
copy_setup_scripts() {
    log_info "Copying setup scripts..."
    
    local scripts_dir="$EXPORT_DIR/flutter_setup"
    
    if [[ -d "./flutter_setup" ]]; then
        # Create scripts directory in export
        mkdir -p "$scripts_dir"
        
        # Copy all shell scripts
        cp ./flutter_setup/*.sh "$scripts_dir/" 2>/dev/null || true
        
        # Make scripts executable
        chmod +x "$scripts_dir"/*.sh 2>/dev/null || true
        
        local script_count=$(find "$scripts_dir" -name "*.sh" -type f | wc -l)
        log_success "Copied $script_count setup scripts to export"
        
        # Create a script index
        local index_file="$scripts_dir/README.md"
        cat > "$index_file" << 'EOF'
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
EOF
        
        log_success "Setup scripts documentation created"
    else
        log_warning "Setup scripts directory not found, skipping copy"
    fi
    
    return 0
}

# Function to display export summary
display_export_summary() {
    log_info "Export Summary"
    log_info "=============="
    
    echo -e "${BLUE}Export Directory:${NC} $EXPORT_DIR"
    echo -e "${BLUE}Generated Files:${NC}"
    
    if [[ -f "$EXPORT_DIR/environment_variables.sh" ]]; then
        echo -e "  ${GREEN}✓${NC} environment_variables.sh - Environment setup script"
    fi
    
    if [[ -f "$EXPORT_DIR/versions.txt" ]]; then
        echo -e "  ${GREEN}✓${NC} versions.txt - Version information"
    fi
    
    if [[ -f "$EXPORT_DIR/flutter_doctor.txt" ]]; then
        echo -e "  ${GREEN}✓${NC} flutter_doctor.txt - Flutter doctor output"
    fi
    
    if [[ -f "$EXPORT_DIR/README.md" ]]; then
        echo -e "  ${GREEN}✓${NC} README.md - Overview and quick start"
    fi
    
    if [[ -f "$EXPORT_DIR/setup_instructions.md" ]]; then
        echo -e "  ${GREEN}✓${NC} setup_instructions.md - Detailed setup guide"
    fi
    
    if [[ -f "$EXPORT_DIR/troubleshooting.md" ]]; then
        echo -e "  ${GREEN}✓${NC} troubleshooting.md - Problem solving guide"
    fi
    
    if [[ -f "$EXPORT_DIR/installation_summary.txt" ]]; then
        echo -e "  ${GREEN}✓${NC} installation_summary.txt - Component status"
    fi
    
    if [[ -d "$EXPORT_DIR/flutter_setup" ]]; then
        local script_count=$(find "$EXPORT_DIR/flutter_setup" -name "*.sh" -type f | wc -l)
        echo -e "  ${GREEN}✓${NC} flutter_setup/ - Setup scripts directory ($script_count scripts)"
    fi
    
    echo -e "${BLUE}Usage:${NC}"
    echo -e "  1. Copy the export directory to another system"
    echo -e "  2. Run: source $EXPORT_DIR/environment_variables.sh"
    echo -e "  3. Follow setup instructions in README.md"
}

# Main execution function
main() {
    log_info "Starting Flutter Environment Export"
    log_info "=================================="
    
    # Create export directory
    if ! create_export_directory; then
        log_error "Failed to create export directory"
        return 1
    fi
    
    # Export environment variables
    if ! export_environment_variables; then
        log_error "Failed to export environment variables"
        return 1
    fi
    
    # Export version information
    if ! export_version_information; then
        log_error "Failed to export version information"
        return 1
    fi
    
    # Export Flutter doctor output
    if ! export_flutter_doctor; then
        log_error "Failed to export Flutter doctor output"
        return 1
    fi
    
    # Create documentation
    if ! create_setup_documentation; then
        log_error "Failed to create setup documentation"
        return 1
    fi
    
    if ! create_setup_instructions; then
        log_error "Failed to create setup instructions"
        return 1
    fi
    
    if ! create_troubleshooting_guide; then
        log_error "Failed to create troubleshooting guide"
        return 1
    fi
    
    # Create installation summary
    if ! create_installation_summary; then
        log_error "Failed to create installation summary"
        return 1
    fi
    
    # Copy setup scripts
    if ! copy_setup_scripts; then
        log_error "Failed to copy setup scripts"
        return 1
    fi
    
    # Display summary
    display_export_summary
    
    log_success "=================================="
    log_success "Environment export completed successfully!"
    log_info "Export location: $EXPORT_DIR"
    
    return 0
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi