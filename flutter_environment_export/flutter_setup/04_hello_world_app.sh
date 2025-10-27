#!/bin/bash

# Flutter Android Build Environment Setup - Hello World Application
# This script creates and tests a Flutter Hello World application

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[HELLO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[HELLO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[HELLO]${NC} $1"
}

log_error() {
    echo -e "${RED}[HELLO]${NC} $1"
}

# Configuration
PROJECT_NAME="flutter_hello_world"
PROJECT_DIR="./flutter_projects/$PROJECT_NAME"
TEST_TIMEOUT=30

# Function to ensure Flutter is available
ensure_flutter_available() {
    log_info "Checking Flutter availability..."
    
    if ! command -v flutter >/dev/null 2>&1; then
        log_error "Flutter command not found. Please ensure Flutter is installed and in PATH."
        return 1
    fi
    
    local flutter_version=$(flutter --version | head -n1)
    log_success "Flutter available: $flutter_version"
    return 0
}

# Function to create Flutter project directory
create_project_directory() {
    log_info "Creating project directory..."
    
    local projects_dir="./flutter_projects"
    
    # Create projects directory if it doesn't exist
    if [[ ! -d "$projects_dir" ]]; then
        mkdir -p "$projects_dir"
        log_success "Created projects directory: $projects_dir"
    fi
    
    # Handle existing project
    if [[ -d "$PROJECT_DIR" ]]; then
        log_warning "Project directory already exists: $PROJECT_DIR"
        
        read -p "Do you want to remove and recreate the project? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "Removing existing project..."
            rm -rf "$PROJECT_DIR"
            log_success "Existing project removed"
        else
            log_info "Using existing project directory"
            return 0
        fi
    fi
    
    return 0
}

# Function to create Flutter Hello World project
create_flutter_project() {
    log_info "Creating Flutter Hello World project..."
    
    local projects_dir="./flutter_projects"
    
    # Change to projects directory
    cd "$projects_dir"
    
    # Create Flutter project
    log_info "Running: flutter create $PROJECT_NAME"
    if flutter create "$PROJECT_NAME" --org com.example --description "Flutter Hello World test application"; then
        log_success "Flutter project created successfully"
    else
        log_error "Failed to create Flutter project"
        return 1
    fi
    
    # Verify project structure
    if [[ -d "$PROJECT_DIR" && -f "$PROJECT_DIR/pubspec.yaml" ]]; then
        log_success "Project structure verified"
    else
        log_error "Project structure validation failed"
        return 1
    fi
    
    return 0
}

# Function to validate project structure
validate_project_structure() {
    log_info "Validating project structure..."
    
    local required_files=(
        "pubspec.yaml"
        "lib/main.dart"
        "android/app/build.gradle"
        "android/app/src/main/AndroidManifest.xml"
    )
    
    local required_dirs=(
        "lib"
        "android"
        "web"
    )
    
    # Check required files
    for file in "${required_files[@]}"; do
        if [[ -f "$PROJECT_DIR/$file" ]]; then
            log_success "✓ $file"
        else
            log_error "✗ Missing: $file"
            return 1
        fi
    done
    
    # Check required directories
    for dir in "${required_dirs[@]}"; do
        if [[ -d "$PROJECT_DIR/$dir" ]]; then
            log_success "✓ $dir/"
        else
            log_error "✗ Missing directory: $dir/"
            return 1
        fi
    done
    
    log_success "Project structure validation passed"
    return 0
}

# Function to get Flutter dependencies
get_flutter_dependencies() {
    log_info "Getting Flutter dependencies..."
    
    cd "$PROJECT_DIR"
    
    if flutter pub get; then
        log_success "Flutter dependencies retrieved successfully"
    else
        log_error "Failed to get Flutter dependencies"
        return 1
    fi
    
    return 0
}

# Function to analyze Flutter project
analyze_flutter_project() {
    log_info "Analyzing Flutter project..."
    
    cd "$PROJECT_DIR"
    
    log_info "Running flutter analyze..."
    if flutter analyze; then
        log_success "Flutter analysis passed"
    else
        log_warning "Flutter analysis found issues (this may be normal for a new project)"
    fi
    
    return 0
}

# Function to check available devices
check_available_devices() {
    log_info "Checking available devices..."
    
    local devices_output
    if devices_output=$(flutter devices 2>/dev/null); then
        log_success "Available devices:"
        echo "$devices_output" | grep -E "^[•]" | sed 's/^/  /'
        
        # Count devices
        local device_count=$(echo "$devices_output" | grep -c "^[•]" || echo "0")
        log_info "Total devices found: $device_count"
        
        if [[ "$device_count" -eq 0 ]]; then
            log_warning "No devices available for testing"
            return 1
        fi
    else
        log_error "Failed to check available devices"
        return 1
    fi
    
    return 0
}

# Function to test web build
test_web_build() {
    log_info "Testing web build..."
    
    cd "$PROJECT_DIR"
    
    # Build for web
    log_info "Building for web..."
    if flutter build web; then
        log_success "Web build completed successfully"
    else
        log_error "Web build failed"
        return 1
    fi
    
    # Check if build output exists
    if [[ -d "$PROJECT_DIR/build/web" && -f "$PROJECT_DIR/build/web/index.html" ]]; then
        log_success "Web build artifacts verified"
        
        # Show build size
        local build_size=$(du -sh "$PROJECT_DIR/build/web" | cut -f1)
        log_info "Web build size: $build_size"
    else
        log_error "Web build artifacts not found"
        return 1
    fi
    
    return 0
}

# Function to test Android build
test_android_build() {
    log_info "Testing Android build..."
    
    cd "$PROJECT_DIR"
    
    # Build APK
    log_info "Building APK..."
    if flutter build apk; then
        log_success "APK build completed successfully"
    else
        log_error "APK build failed"
        return 1
    fi
    
    # Check if APK exists
    local apk_path="$PROJECT_DIR/build/app/outputs/flutter-apk/app-release.apk"
    if [[ -f "$apk_path" ]]; then
        log_success "APK build artifact verified"
        
        # Show APK size
        local apk_size=$(du -sh "$apk_path" | cut -f1)
        log_info "APK size: $apk_size"
        log_info "APK location: $apk_path"
    else
        log_error "APK build artifact not found"
        return 1
    fi
    
    return 0
}

# Function to run Flutter doctor
run_flutter_doctor() {
    log_info "Running Flutter doctor for project validation..."
    
    cd "$PROJECT_DIR"
    
    flutter doctor -v
    
    return 0
}

# Function to display project summary
display_project_summary() {
    log_info "Project Summary"
    log_info "==============="
    
    echo -e "${BLUE}Project Name:${NC} $PROJECT_NAME"
    echo -e "${BLUE}Project Directory:${NC} $PROJECT_DIR"
    
    if [[ -d "$PROJECT_DIR" ]]; then
        local project_size=$(du -sh "$PROJECT_DIR" | cut -f1)
        echo -e "${BLUE}Project Size:${NC} $project_size"
    fi
    
    # Show build artifacts
    echo -e "${BLUE}Build Artifacts:${NC}"
    
    if [[ -d "$PROJECT_DIR/build/web" ]]; then
        local web_size=$(du -sh "$PROJECT_DIR/build/web" | cut -f1)
        echo -e "  ${GREEN}✓${NC} Web build ($web_size)"
    else
        echo -e "  ${YELLOW}-${NC} Web build (not built)"
    fi
    
    local apk_path="$PROJECT_DIR/build/app/outputs/flutter-apk/app-release.apk"
    if [[ -f "$apk_path" ]]; then
        local apk_size=$(du -sh "$apk_path" | cut -f1)
        echo -e "  ${GREEN}✓${NC} Android APK ($apk_size)"
    else
        echo -e "  ${YELLOW}-${NC} Android APK (not built)"
    fi
    
    # Show available commands
    echo -e "${BLUE}Available Commands:${NC}"
    echo -e "  ${GREEN}Web:${NC} cd $PROJECT_DIR && flutter run -d chrome"
    echo -e "  ${GREEN}Android:${NC} cd $PROJECT_DIR && flutter run -d android"
    echo -e "  ${GREEN}Install APK:${NC} adb install $apk_path"
}

# Main execution function
main() {
    log_info "Starting Flutter Hello World Application Creation"
    log_info "================================================"
    
    # Ensure Flutter is available
    if ! ensure_flutter_available; then
        log_error "Flutter not available"
        return 1
    fi
    
    # Create project directory
    if ! create_project_directory; then
        log_error "Failed to create project directory"
        return 1
    fi
    
    # Create Flutter project (only if directory doesn't exist or was removed)
    if [[ ! -d "$PROJECT_DIR" ]]; then
        if ! create_flutter_project; then
            log_error "Failed to create Flutter project"
            return 1
        fi
    else
        log_info "Using existing Flutter project"
    fi
    
    # Validate project structure
    if ! validate_project_structure; then
        log_error "Project structure validation failed"
        return 1
    fi
    
    # Get dependencies
    if ! get_flutter_dependencies; then
        log_error "Failed to get Flutter dependencies"
        return 1
    fi
    
    # Analyze project
    analyze_flutter_project
    
    # Check available devices
    check_available_devices
    
    # Test builds
    log_info "Testing builds..."
    
    if test_web_build; then
        log_success "Web build test passed"
    else
        log_warning "Web build test failed"
    fi
    
    if test_android_build; then
        log_success "Android build test passed"
    else
        log_warning "Android build test failed"
    fi
    
    # Run Flutter doctor
    run_flutter_doctor
    
    # Display summary
    display_project_summary
    
    log_success "================================================"
    log_success "Flutter Hello World application created successfully!"
    log_info "You can now test the application using the commands shown above"
    
    return 0
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi