#!/bin/bash

# Flutter Android Build Environment Setup - Comprehensive Validation
# This script performs complete validation of the Flutter Android development environment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[VALIDATE]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[VALIDATE]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[VALIDATE]${NC} $1"
}

log_error() {
    echo -e "${RED}[VALIDATE]${NC} $1"
}

# Global validation results
VALIDATION_RESULTS=()
VALIDATION_ERRORS=0
VALIDATION_WARNINGS=0
VALIDATION_SUCCESS=0

# Function to add validation result
add_validation_result() {
    local status="$1"
    local component="$2"
    local message="$3"
    
    VALIDATION_RESULTS+=("$status|$component|$message")
    
    case "$status" in
        "SUCCESS")
            ((VALIDATION_SUCCESS++))
            log_success "$component: $message"
            ;;
        "WARNING")
            ((VALIDATION_WARNINGS++))
            log_warning "$component: $message"
            ;;
        "ERROR")
            ((VALIDATION_ERRORS++))
            log_error "$component: $message"
            ;;
    esac
}

# Function to validate system requirements
validate_system_requirements() {
    log_info "Validating system requirements..."
    
    # Check operating system
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        if [[ "$ID" == "pop" || "$ID_LIKE" == *"ubuntu"* || "$ID" == "ubuntu" ]]; then
            add_validation_result "SUCCESS" "Operating System" "$PRETTY_NAME"
        else
            add_validation_result "WARNING" "Operating System" "$PRETTY_NAME (not officially supported)"
        fi
    else
        add_validation_result "ERROR" "Operating System" "Cannot determine OS"
    fi
    
    # Check core utilities
    local utilities=("git" "curl" "unzip" "zip")
    for util in "${utilities[@]}"; do
        if command -v "$util" >/dev/null 2>&1; then
            local version=$($util --version 2>/dev/null | head -n1 || echo "Available")
            add_validation_result "SUCCESS" "$util" "$version"
        else
            add_validation_result "ERROR" "$util" "Not installed"
        fi
    done
}

# Function to validate Java installation
validate_java_installation() {
    log_info "Validating Java installation..."
    
    if command -v java >/dev/null 2>&1; then
        local java_version=$(java -version 2>&1 | head -n1)
        add_validation_result "SUCCESS" "Java Runtime" "$java_version"
        
        # Check for Java 17
        if java -version 2>&1 | grep -q "17\."; then
            add_validation_result "SUCCESS" "Java Version" "Java 17 detected"
        else
            add_validation_result "WARNING" "Java Version" "Java 17 recommended for Android development"
        fi
    else
        add_validation_result "ERROR" "Java Runtime" "Not installed"
    fi
    
    if command -v javac >/dev/null 2>&1; then
        local javac_version=$(javac -version 2>&1)
        add_validation_result "SUCCESS" "Java Compiler" "$javac_version"
    else
        add_validation_result "ERROR" "Java Compiler" "Not installed"
    fi
    
    # Check JAVA_HOME
    if [[ -n "$JAVA_HOME" ]]; then
        if [[ -d "$JAVA_HOME" ]]; then
            add_validation_result "SUCCESS" "JAVA_HOME" "$JAVA_HOME"
        else
            add_validation_result "ERROR" "JAVA_HOME" "Directory does not exist: $JAVA_HOME"
        fi
    else
        add_validation_result "WARNING" "JAVA_HOME" "Not set (may cause build issues)"
    fi
}

# Function to validate Flutter installation
validate_flutter_installation() {
    log_info "Validating Flutter installation..."
    
    if command -v flutter >/dev/null 2>&1; then
        local flutter_version=$(flutter --version | head -n1)
        add_validation_result "SUCCESS" "Flutter SDK" "$flutter_version"
        
        # Check Flutter path
        local flutter_path=$(which flutter)
        local flutter_dir=$(dirname "$(dirname "$flutter_path")")
        add_validation_result "SUCCESS" "Flutter Path" "$flutter_dir"
        
        # Check if Flutter is in PATH
        if echo "$PATH" | grep -q "flutter"; then
            add_validation_result "SUCCESS" "Flutter PATH" "Configured in PATH"
        else
            add_validation_result "WARNING" "Flutter PATH" "Not found in PATH"
        fi
        
        # Validate Flutter installation
        log_info "Running Flutter doctor validation..."
        local doctor_output=$(flutter doctor 2>&1)
        
        if echo "$doctor_output" | grep -q "No issues found"; then
            add_validation_result "SUCCESS" "Flutter Doctor" "No issues found"
        elif echo "$doctor_output" | grep -q "\[✓\].*Flutter"; then
            add_validation_result "SUCCESS" "Flutter Doctor" "Flutter SDK validated"
        else
            add_validation_result "WARNING" "Flutter Doctor" "Issues detected (see flutter doctor output)"
        fi
        
    else
        add_validation_result "ERROR" "Flutter SDK" "Not installed or not in PATH"
    fi
    
    # Check Dart SDK
    if command -v dart >/dev/null 2>&1; then
        local dart_version=$(dart --version 2>&1 | head -n1)
        add_validation_result "SUCCESS" "Dart SDK" "$dart_version"
    else
        add_validation_result "WARNING" "Dart SDK" "Not found in PATH (included with Flutter)"
    fi
}

# Function to validate Android SDK
validate_android_sdk() {
    log_info "Validating Android SDK..."
    
    # Check ANDROID_HOME
    if [[ -n "$ANDROID_HOME" ]]; then
        if [[ -d "$ANDROID_HOME" ]]; then
            add_validation_result "SUCCESS" "ANDROID_HOME" "$ANDROID_HOME"
        else
            add_validation_result "ERROR" "ANDROID_HOME" "Directory does not exist: $ANDROID_HOME"
        fi
    else
        # Check common locations
        local common_paths=("/usr/lib/android-sdk" "$HOME/Android/Sdk" "/opt/android-sdk")
        local found_sdk=false
        
        for path in "${common_paths[@]}"; do
            if [[ -d "$path" ]]; then
                add_validation_result "WARNING" "ANDROID_HOME" "Not set, but SDK found at: $path"
                found_sdk=true
                break
            fi
        done
        
        if [[ "$found_sdk" == false ]]; then
            add_validation_result "ERROR" "ANDROID_HOME" "Not set and SDK not found"
        fi
    fi
    
    # Check ADB
    if command -v adb >/dev/null 2>&1; then
        local adb_version=$(adb version | head -n1)
        add_validation_result "SUCCESS" "Android Debug Bridge" "$adb_version"
    else
        add_validation_result "ERROR" "Android Debug Bridge" "ADB not found in PATH"
    fi
    
    # Check SDK Manager
    if command -v sdkmanager >/dev/null 2>&1; then
        add_validation_result "SUCCESS" "SDK Manager" "Available"
        
        # Check installed packages
        local installed_packages=$(sdkmanager --list_installed 2>/dev/null | grep -c "^  " || echo "0")
        if [[ "$installed_packages" -gt 0 ]]; then
            add_validation_result "SUCCESS" "SDK Packages" "$installed_packages packages installed"
        else
            add_validation_result "WARNING" "SDK Packages" "No packages detected"
        fi
    else
        add_validation_result "WARNING" "SDK Manager" "Not found in PATH"
    fi
    
    # Check Flutter's Android toolchain
    if command -v flutter >/dev/null 2>&1; then
        local android_toolchain=$(flutter doctor 2>&1 | grep "Android toolchain")
        if echo "$android_toolchain" | grep -q "\[✓\]"; then
            add_validation_result "SUCCESS" "Android Toolchain" "Validated by Flutter"
        elif echo "$android_toolchain" | grep -q "\[!\]"; then
            add_validation_result "WARNING" "Android Toolchain" "Issues detected by Flutter"
        else
            add_validation_result "ERROR" "Android Toolchain" "Not detected by Flutter"
        fi
    fi
}

# Function to validate web development setup
validate_web_development() {
    log_info "Validating web development setup..."
    
    # Check Chrome
    local chrome_commands=("google-chrome" "chrome" "chromium" "chromium-browser")
    local chrome_found=false
    
    for cmd in "${chrome_commands[@]}"; do
        if command -v "$cmd" >/dev/null 2>&1; then
            local chrome_version=$($cmd --version 2>/dev/null || echo "Available")
            add_validation_result "SUCCESS" "Chrome Browser" "$chrome_version"
            chrome_found=true
            break
        fi
    done
    
    if [[ "$chrome_found" == false ]]; then
        add_validation_result "ERROR" "Chrome Browser" "Not found (required for web development)"
    fi
    
    # Check Flutter web support
    if command -v flutter >/dev/null 2>&1; then
        if flutter doctor 2>&1 | grep -q "\[✓\].*Chrome"; then
            add_validation_result "SUCCESS" "Flutter Web Support" "Chrome detected by Flutter"
        else
            add_validation_result "WARNING" "Flutter Web Support" "Chrome not detected by Flutter"
        fi
    fi
}

# Function to validate device connectivity
validate_device_connectivity() {
    log_info "Validating device connectivity..."
    
    # Check connected devices via ADB
    if command -v adb >/dev/null 2>&1; then
        adb start-server >/dev/null 2>&1
        local adb_devices=$(adb devices 2>/dev/null | grep -c "device$" || echo "0")
        
        if [[ "$adb_devices" -gt 0 ]]; then
            add_validation_result "SUCCESS" "ADB Devices" "$adb_devices device(s) connected"
        else
            add_validation_result "WARNING" "ADB Devices" "No devices connected"
        fi
    fi
    
    # Check Flutter devices
    if command -v flutter >/dev/null 2>&1; then
        local flutter_devices=$(flutter devices 2>/dev/null)
        local android_devices=$(echo "$flutter_devices" | grep -c "android" || echo "0")
        local web_devices=$(echo "$flutter_devices" | grep -c "chrome\|web" || echo "0")
        local desktop_devices=$(echo "$flutter_devices" | grep -c "linux\|desktop" || echo "0")
        
        if [[ "$android_devices" -gt 0 ]]; then
            add_validation_result "SUCCESS" "Flutter Android Devices" "$android_devices device(s) detected"
        else
            add_validation_result "WARNING" "Flutter Android Devices" "No Android devices detected"
        fi
        
        if [[ "$web_devices" -gt 0 ]]; then
            add_validation_result "SUCCESS" "Flutter Web Devices" "$web_devices target(s) available"
        else
            add_validation_result "WARNING" "Flutter Web Devices" "No web targets available"
        fi
        
        if [[ "$desktop_devices" -gt 0 ]]; then
            add_validation_result "SUCCESS" "Flutter Desktop Devices" "$desktop_devices target(s) available"
        else
            add_validation_result "WARNING" "Flutter Desktop Devices" "No desktop targets available"
        fi
    fi
}

# Function to validate project setup
validate_project_setup() {
    log_info "Validating project setup..."
    
    local project_dir="./flutter_projects/flutter_hello_world"
    
    if [[ -d "$project_dir" ]]; then
        add_validation_result "SUCCESS" "Test Project" "Flutter Hello World project exists"
        
        # Check project structure
        local required_files=("pubspec.yaml" "lib/main.dart" "android/app/build.gradle")
        for file in "${required_files[@]}"; do
            if [[ -f "$project_dir/$file" ]]; then
                add_validation_result "SUCCESS" "Project Structure" "$file exists"
            else
                add_validation_result "ERROR" "Project Structure" "$file missing"
            fi
        done
        
        # Check build artifacts
        local apk_path="$project_dir/build/app/outputs/flutter-apk/app-release.apk"
        local aab_path="$project_dir/build/app/outputs/bundle/release/app-release.aab"
        
        if [[ -f "$apk_path" ]]; then
            local apk_size=$(du -sh "$apk_path" | cut -f1)
            add_validation_result "SUCCESS" "Release APK" "Built ($apk_size)"
        else
            add_validation_result "WARNING" "Release APK" "Not built"
        fi
        
        if [[ -f "$aab_path" ]]; then
            local aab_size=$(du -sh "$aab_path" | cut -f1)
            add_validation_result "SUCCESS" "App Bundle" "Built ($aab_size)"
        else
            add_validation_result "WARNING" "App Bundle" "Not built"
        fi
        
    else
        add_validation_result "WARNING" "Test Project" "Flutter Hello World project not found"
    fi
    
    # Check keystore
    local keystore_path="./flutter_projects/.android/release-key.jks"
    if [[ -f "$keystore_path" ]]; then
        add_validation_result "SUCCESS" "Release Keystore" "Created for app signing"
    else
        add_validation_result "WARNING" "Release Keystore" "Not created (needed for release builds)"
    fi
}

# Function to validate environment variables
validate_environment_variables() {
    log_info "Validating environment variables..."
    
    # Check PATH
    if [[ -n "$PATH" ]]; then
        add_validation_result "SUCCESS" "PATH Variable" "Set (${#PATH} characters)"
        
        # Check Flutter in PATH
        if echo "$PATH" | grep -q "flutter"; then
            add_validation_result "SUCCESS" "Flutter in PATH" "Configured"
        else
            add_validation_result "WARNING" "Flutter in PATH" "Not found"
        fi
        
        # Check Android tools in PATH
        if echo "$PATH" | grep -q "android"; then
            add_validation_result "SUCCESS" "Android Tools in PATH" "Configured"
        else
            add_validation_result "WARNING" "Android Tools in PATH" "Not found"
        fi
    else
        add_validation_result "ERROR" "PATH Variable" "Not set"
    fi
    
    # Check other important variables
    local env_vars=("JAVA_HOME" "ANDROID_HOME" "ANDROID_SDK_ROOT")
    for var in "${env_vars[@]}"; do
        if [[ -n "${!var}" ]]; then
            add_validation_result "SUCCESS" "$var" "${!var}"
        else
            add_validation_result "WARNING" "$var" "Not set"
        fi
    done
}

# Function to run comprehensive Flutter doctor
run_flutter_doctor_validation() {
    log_info "Running comprehensive Flutter doctor validation..."
    
    if command -v flutter >/dev/null 2>&1; then
        local doctor_output=$(flutter doctor -v 2>&1)
        
        # Parse Flutter doctor output
        local flutter_status=$(echo "$doctor_output" | grep "^\[" | grep "Flutter")
        local android_status=$(echo "$doctor_output" | grep "^\[" | grep "Android toolchain")
        local chrome_status=$(echo "$doctor_output" | grep "^\[" | grep "Chrome")
        local devices_status=$(echo "$doctor_output" | grep "^\[" | grep "Connected device")
        
        # Analyze each component
        if echo "$flutter_status" | grep -q "\[✓\]"; then
            add_validation_result "SUCCESS" "Flutter Doctor - Flutter" "OK"
        elif echo "$flutter_status" | grep -q "\[!\]"; then
            add_validation_result "WARNING" "Flutter Doctor - Flutter" "Issues detected"
        else
            add_validation_result "ERROR" "Flutter Doctor - Flutter" "Failed"
        fi
        
        if echo "$android_status" | grep -q "\[✓\]"; then
            add_validation_result "SUCCESS" "Flutter Doctor - Android" "OK"
        elif echo "$android_status" | grep -q "\[!\]"; then
            add_validation_result "WARNING" "Flutter Doctor - Android" "Issues detected"
        else
            add_validation_result "ERROR" "Flutter Doctor - Android" "Failed"
        fi
        
        if echo "$chrome_status" | grep -q "\[✓\]"; then
            add_validation_result "SUCCESS" "Flutter Doctor - Chrome" "OK"
        elif echo "$chrome_status" | grep -q "\[!\]"; then
            add_validation_result "WARNING" "Flutter Doctor - Chrome" "Issues detected"
        else
            add_validation_result "WARNING" "Flutter Doctor - Chrome" "Not available"
        fi
        
        if echo "$devices_status" | grep -q "\[✓\]"; then
            add_validation_result "SUCCESS" "Flutter Doctor - Devices" "OK"
        elif echo "$devices_status" | grep -q "\[!\]"; then
            add_validation_result "WARNING" "Flutter Doctor - Devices" "Issues detected"
        else
            add_validation_result "WARNING" "Flutter Doctor - Devices" "No devices"
        fi
        
    else
        add_validation_result "ERROR" "Flutter Doctor" "Flutter not available"
    fi
}

# Function to display validation summary
display_validation_summary() {
    log_info "Validation Summary"
    log_info "=================="
    
    echo -e "${BLUE}Total Checks:${NC} $((VALIDATION_SUCCESS + VALIDATION_WARNINGS + VALIDATION_ERRORS))"
    echo -e "${GREEN}Successful:${NC} $VALIDATION_SUCCESS"
    echo -e "${YELLOW}Warnings:${NC} $VALIDATION_WARNINGS"
    echo -e "${RED}Errors:${NC} $VALIDATION_ERRORS"
    echo ""
    
    # Display detailed results
    echo -e "${BLUE}Detailed Results:${NC}"
    for result in "${VALIDATION_RESULTS[@]}"; do
        IFS='|' read -r status component message <<< "$result"
        case "$status" in
            "SUCCESS")
                echo -e "  ${GREEN}✓${NC} $component: $message"
                ;;
            "WARNING")
                echo -e "  ${YELLOW}!${NC} $component: $message"
                ;;
            "ERROR")
                echo -e "  ${RED}✗${NC} $component: $message"
                ;;
        esac
    done
    
    echo ""
    
    # Overall assessment
    if [[ $VALIDATION_ERRORS -eq 0 ]]; then
        if [[ $VALIDATION_WARNINGS -eq 0 ]]; then
            echo -e "${GREEN}🎉 EXCELLENT!${NC} Your Flutter Android development environment is perfectly configured!"
        else
            echo -e "${YELLOW}⚠️  GOOD!${NC} Your environment is functional but has some minor issues to address."
        fi
    else
        echo -e "${RED}❌ ISSUES DETECTED!${NC} Your environment has critical issues that need to be resolved."
    fi
    
    echo ""
    echo -e "${BLUE}Next Steps:${NC}"
    
    if [[ $VALIDATION_ERRORS -gt 0 ]]; then
        echo -e "  1. ${RED}Fix critical errors${NC} listed above"
        echo -e "  2. Run validation again to verify fixes"
    fi
    
    if [[ $VALIDATION_WARNINGS -gt 0 ]]; then
        echo -e "  1. ${YELLOW}Address warnings${NC} for optimal performance"
        echo -e "  2. Consider running setup scripts to resolve issues"
    fi
    
    if [[ $VALIDATION_ERRORS -eq 0 && $VALIDATION_WARNINGS -eq 0 ]]; then
        echo -e "  1. ${GREEN}Start developing!${NC} Create new Flutter projects"
        echo -e "  2. Test on connected devices"
        echo -e "  3. Build and distribute your apps"
    fi
    
    echo -e "  • Run ${BLUE}flutter doctor -v${NC} for detailed Flutter diagnostics"
    echo -e "  • Check troubleshooting guide for common solutions"
}

# Main execution function
main() {
    log_info "Starting Comprehensive Flutter Environment Validation"
    log_info "===================================================="
    
    # Run all validation checks
    validate_system_requirements
    validate_java_installation
    validate_flutter_installation
    validate_android_sdk
    validate_web_development
    validate_device_connectivity
    validate_project_setup
    validate_environment_variables
    run_flutter_doctor_validation
    
    # Display summary
    display_validation_summary
    
    log_info "===================================================="
    log_info "Validation completed!"
    
    # Return appropriate exit code
    if [[ $VALIDATION_ERRORS -gt 0 ]]; then
        return 1
    else
        return 0
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi