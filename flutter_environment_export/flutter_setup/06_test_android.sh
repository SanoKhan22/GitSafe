#!/bin/bash

# Flutter Android Build Environment Setup - Android Device Testing
# This script tests Flutter application on connected Android device

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[ANDROID]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[ANDROID]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[ANDROID]${NC} $1"
}

log_error() {
    echo -e "${RED}[ANDROID]${NC} $1"
}

# Configuration
PROJECT_NAME="flutter_hello_world"
PROJECT_DIR="./flutter_projects/$PROJECT_NAME"
APP_PACKAGE="com.example.flutter_hello_world"

# Function to check if project exists
check_project_exists() {
    log_info "Checking if Flutter project exists..."
    
    if [[ ! -d "$PROJECT_DIR" ]]; then
        log_error "Flutter project not found at: $PROJECT_DIR"
        log_info "Please run the Hello World creation script first"
        return 1
    fi
    
    if [[ ! -f "$PROJECT_DIR/pubspec.yaml" ]]; then
        log_error "Invalid Flutter project: pubspec.yaml not found"
        return 1
    fi
    
    log_success "Flutter project found: $PROJECT_DIR"
    return 0
}

# Function to check ADB availability
check_adb_available() {
    log_info "Checking ADB availability..."
    
    if ! command -v adb >/dev/null 2>&1; then
        log_error "ADB not found in PATH"
        log_info "Please ensure Android SDK platform-tools are installed"
        return 1
    fi
    
    local adb_version=$(adb version | head -n1)
    log_success "ADB available: $adb_version"
    return 0
}

# Function to check connected devices
check_connected_devices() {
    log_info "Checking connected Android devices..."
    
    # Start ADB server if not running
    adb start-server >/dev/null 2>&1
    
    local devices_output
    if devices_output=$(adb devices 2>/dev/null); then
        log_info "ADB devices output:"
        echo "$devices_output"
        
        # Count connected devices (excluding header and empty lines)
        local device_count=$(echo "$devices_output" | grep -c "device$" || echo "0")
        
        if [[ "$device_count" -eq 0 ]]; then
            log_error "No Android devices connected"
            log_info "Please connect your Android device and enable USB debugging"
            return 1
        else
            log_success "Found $device_count connected device(s)"
        fi
    else
        log_error "Failed to check connected devices"
        return 1
    fi
    
    return 0
}

# Function to check Flutter devices
check_flutter_devices() {
    log_info "Checking Flutter-detected devices..."
    
    local flutter_devices
    if flutter_devices=$(flutter devices 2>/dev/null); then
        log_info "Flutter devices:"
        echo "$flutter_devices"
        
        # Check for Android devices
        if echo "$flutter_devices" | grep -q "android"; then
            log_success "Android device detected by Flutter"
        else
            log_warning "No Android devices detected by Flutter"
            return 1
        fi
    else
        log_error "Failed to check Flutter devices"
        return 1
    fi
    
    return 0
}

# Function to build APK for testing
build_debug_apk() {
    log_info "Building debug APK..."
    
    cd "$PROJECT_DIR"
    
    # Clean previous build
    log_info "Cleaning previous build..."
    flutter clean >/dev/null 2>&1 || true
    
    # Get dependencies
    log_info "Getting dependencies..."
    if flutter pub get; then
        log_success "Dependencies retrieved"
    else
        log_error "Failed to get dependencies"
        return 1
    fi
    
    # Build debug APK
    log_info "Building debug APK..."
    if flutter build apk --debug; then
        log_success "Debug APK build completed"
    else
        log_error "Debug APK build failed"
        return 1
    fi
    
    # Verify APK exists
    local apk_path="$PROJECT_DIR/build/app/outputs/flutter-apk/app-debug.apk"
    if [[ -f "$apk_path" ]]; then
        log_success "Debug APK created: $apk_path"
        
        local apk_size=$(du -sh "$apk_path" | cut -f1)
        log_info "APK size: $apk_size"
        
        echo "$apk_path"
        return 0
    else
        log_error "Debug APK not found"
        return 1
    fi
}

# Function to install APK on device
install_apk_on_device() {
    local apk_path="$1"
    
    log_info "Installing APK on Android device..."
    
    # Uninstall previous version if exists
    log_info "Uninstalling previous version (if exists)..."
    adb uninstall "$APP_PACKAGE" >/dev/null 2>&1 || log_info "No previous version to uninstall"
    
    # Install APK
    log_info "Installing APK: $apk_path"
    if adb install "$apk_path"; then
        log_success "APK installed successfully"
    else
        log_error "Failed to install APK"
        return 1
    fi
    
    return 0
}

# Function to launch app on device
launch_app_on_device() {
    log_info "Launching Flutter app on device..."
    
    # Launch the app
    local main_activity="$APP_PACKAGE/com.example.flutter_hello_world.MainActivity"
    
    log_info "Starting activity: $main_activity"
    if adb shell am start -n "$main_activity" >/dev/null 2>&1; then
        log_success "App launched successfully"
    else
        log_error "Failed to launch app"
        return 1
    fi
    
    # Wait a moment for app to start
    sleep 3
    
    # Check if app is running
    if adb shell "ps | grep $APP_PACKAGE" >/dev/null 2>&1 || adb shell "ps -A | grep $APP_PACKAGE" >/dev/null 2>&1; then
        log_success "App is running on device"
    else
        log_warning "Could not verify if app is running (this may be normal)"
    fi
    
    return 0
}

# Function to get Android device ID
get_android_device_id() {
    local flutter_devices
    if flutter_devices=$(flutter devices 2>/dev/null); then
        # Extract Android device ID (the serial number between • symbols)
        local device_id=$(echo "$flutter_devices" | grep "android-arm64\|android-arm\|android-x64" | head -n1 | sed 's/.*• \([^ ]*\) •.*/\1/')
        if [[ -n "$device_id" ]]; then
            echo "$device_id"
            return 0
        fi
    fi
    
    log_error "Could not find Android device ID"
    return 1
}

# Function to run Flutter app directly
run_flutter_app() {
    log_info "Running Flutter app directly on device..."
    
    cd "$PROJECT_DIR"
    
    # Get Android device ID
    local device_id
    if device_id=$(get_android_device_id); then
        log_info "Using device ID: $device_id"
    else
        log_error "Could not determine device ID"
        return 1
    fi
    
    log_info "Starting Flutter run for Android device..."
    log_info "This will build and install the app, then start it"
    log_info "You should see the app appear on your device screen"
    
    # Run Flutter app on specific Android device
    if timeout 60 flutter run -d "$device_id" --debug; then
        log_success "Flutter app ran successfully"
    else
        local exit_code=$?
        if [[ $exit_code -eq 124 ]]; then
            log_info "Flutter run timed out (this is normal - app should be running on device)"
        else
            log_error "Flutter run failed with exit code: $exit_code"
            return 1
        fi
    fi
    
    return 0
}

# Function to test app functionality
test_app_functionality() {
    log_info "Testing app functionality..."
    
    # Check if app is installed
    if adb shell pm list packages | grep -q "$APP_PACKAGE"; then
        log_success "App is installed on device"
    else
        log_error "App not found on device"
        return 1
    fi
    
    # Get app info
    local app_info
    if app_info=$(adb shell dumpsys package "$APP_PACKAGE" 2>/dev/null); then
        log_success "App package information retrieved"
        
        # Extract version info
        local version_name=$(echo "$app_info" | grep "versionName" | head -n1 | cut -d'=' -f2)
        if [[ -n "$version_name" ]]; then
            log_info "App version: $version_name"
        fi
    else
        log_warning "Could not retrieve app information"
    fi
    
    # Check device logs for Flutter app
    log_info "Checking device logs for Flutter activity..."
    local recent_logs
    if recent_logs=$(adb logcat -d -t 50 | grep -i flutter 2>/dev/null); then
        if [[ -n "$recent_logs" ]]; then
            log_success "Flutter activity detected in device logs"
            log_info "Recent Flutter logs:"
            echo "$recent_logs" | tail -5 | sed 's/^/  /'
        else
            log_info "No recent Flutter logs found"
        fi
    fi
    
    return 0
}

# Function to display device information
display_device_info() {
    log_info "Device Information"
    log_info "=================="
    
    # Get device properties
    local device_model=$(adb shell getprop ro.product.model 2>/dev/null || echo "Unknown")
    local device_brand=$(adb shell getprop ro.product.brand 2>/dev/null || echo "Unknown")
    local android_version=$(adb shell getprop ro.build.version.release 2>/dev/null || echo "Unknown")
    local api_level=$(adb shell getprop ro.build.version.sdk 2>/dev/null || echo "Unknown")
    
    echo -e "${BLUE}Device Model:${NC} $device_brand $device_model"
    echo -e "${BLUE}Android Version:${NC} $android_version (API $api_level)"
    
    # Get screen resolution
    local screen_size=$(adb shell wm size 2>/dev/null | cut -d' ' -f3 || echo "Unknown")
    if [[ "$screen_size" != "Unknown" ]]; then
        echo -e "${BLUE}Screen Resolution:${NC} $screen_size"
    fi
    
    # Get device serial
    local device_serial=$(adb get-serialno 2>/dev/null || echo "Unknown")
    echo -e "${BLUE}Device Serial:${NC} $device_serial"
}

# Function to display test results
display_test_results() {
    log_info "Android Test Results"
    log_info "==================="
    
    echo -e "${BLUE}Project:${NC} $PROJECT_NAME"
    echo -e "${BLUE}Package:${NC} $APP_PACKAGE"
    echo -e "${BLUE}Project Directory:${NC} $PROJECT_DIR"
    
    local apk_path="$PROJECT_DIR/build/app/outputs/flutter-apk/app-debug.apk"
    if [[ -f "$apk_path" ]]; then
        local apk_size=$(du -sh "$apk_path" | cut -f1)
        echo -e "${BLUE}APK Size:${NC} $apk_size"
        echo -e "${BLUE}APK Location:${NC} $apk_path"
    fi
    
    echo -e "${BLUE}Manual Testing:${NC}"
    echo -e "  1. Check your device screen - the Flutter app should be visible"
    echo -e "  2. Look for 'Flutter Demo Home Page' title"
    echo -e "  3. Try tapping the '+' button to increment the counter"
    echo -e "  4. Verify the counter increases when you tap the button"
    
    echo -e "${BLUE}Useful Commands:${NC}"
    echo -e "  Launch app: adb shell am start -n $APP_PACKAGE/com.example.flutter_hello_world.MainActivity"
    echo -e "  Uninstall: adb uninstall $APP_PACKAGE"
    echo -e "  View logs: adb logcat | grep flutter"
}

# Main execution function
main() {
    log_info "Starting Flutter Android Device Testing"
    log_info "======================================="
    
    # Check if project exists
    if ! check_project_exists; then
        log_error "Flutter project not found"
        return 1
    fi
    
    # Check ADB availability
    if ! check_adb_available; then
        log_error "ADB not available"
        return 1
    fi
    
    # Check connected devices
    if ! check_connected_devices; then
        log_error "No Android devices connected"
        return 1
    fi
    
    # Check Flutter devices
    if ! check_flutter_devices; then
        log_error "No Android devices detected by Flutter"
        return 1
    fi
    
    # Display device information
    display_device_info
    
    # Ask user for testing method
    echo
    log_info "Choose testing method:"
    echo "1. Use 'flutter run' (recommended - live reload, debugging)"
    echo "2. Build and install APK manually"
    
    read -p "Enter choice (1 or 2): " -n 1 -r
    echo
    
    if [[ $REPLY == "1" ]]; then
        # Method 1: Flutter run
        log_info "Using Flutter run method..."
        
        if run_flutter_app; then
            log_success "Flutter app deployment completed"
        else
            log_error "Flutter app deployment failed"
            return 1
        fi
        
    elif [[ $REPLY == "2" ]]; then
        # Method 2: Manual APK install
        log_info "Using manual APK install method..."
        
        # Build debug APK
        local apk_path
        if apk_path=$(build_debug_apk); then
            log_success "APK build completed"
        else
            log_error "APK build failed"
            return 1
        fi
        
        # Install APK
        if install_apk_on_device "$apk_path"; then
            log_success "APK installation completed"
        else
            log_error "APK installation failed"
            return 1
        fi
        
        # Launch app
        if launch_app_on_device; then
            log_success "App launch completed"
        else
            log_error "App launch failed"
            return 1
        fi
        
    else
        log_info "Invalid choice, using Flutter run method..."
        
        if run_flutter_app; then
            log_success "Flutter app deployment completed"
        else
            log_error "Flutter app deployment failed"
            return 1
        fi
    fi
    
    # Test app functionality
    test_app_functionality
    
    # Display results
    display_test_results
    
    log_success "======================================="
    log_success "Flutter Android device testing completed!"
    log_info "Check your device screen to see the Flutter Hello World app"
    
    return 0
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi