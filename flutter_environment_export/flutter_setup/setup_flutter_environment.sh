#!/bin/bash

# Master Flutter Android Build Environment Setup Script
# This script orchestrates the complete setup process

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[SETUP]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SETUP]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[SETUP]${NC} $1"
}

log_error() {
    echo -e "${RED}[SETUP]${NC} $1"
}

# Function to display menu
display_menu() {
    echo ""
    log_info "Flutter Android Build Environment Setup"
    log_info "======================================="
    echo ""
    echo "Choose an option:"
    echo "1. Complete Setup (recommended for new installations)"
    echo "2. System Preparation Only"
    echo "3. Flutter SDK Setup"
    echo "4. Create Hello World App"
    echo "5. Test on Android Device"
    echo "6. Build Production APK/AAB"
    echo "7. Export Environment Documentation"
    echo "8. Validate Environment"
    echo "9. Exit"
    echo ""
}

# Function to run system preparation
run_system_preparation() {
    log_info "Step 1: System Preparation"
    log_info "=========================="
    
    if [[ -f "flutter_setup/01_system_preparation.sh" ]]; then
        if bash flutter_setup/01_system_preparation.sh; then
            log_success "System preparation completed"
            return 0
        else
            log_error "System preparation failed"
            return 1
        fi
    else
        log_error "System preparation script not found"
        return 1
    fi
}

# Function to run Flutter SDK setup
run_flutter_setup() {
    log_info "Step 2: Flutter SDK Setup"
    log_info "========================="
    
    if [[ -f "flutter_setup/02_flutter_sdk.sh" ]]; then
        if bash flutter_setup/02_flutter_sdk.sh; then
            log_success "Flutter SDK setup completed"
        else
            log_error "Flutter SDK setup failed"
            return 1
        fi
    fi
    
    if [[ -f "flutter_setup/03_flutter_path_config.sh" ]]; then
        if bash flutter_setup/03_flutter_path_config.sh; then
            log_success "Flutter PATH configuration completed"
            return 0
        else
            log_error "Flutter PATH configuration failed"
            return 1
        fi
    else
        log_error "Flutter PATH configuration script not found"
        return 1
    fi
}

# Function to create Hello World app
run_hello_world_creation() {
    log_info "Step 3: Hello World App Creation"
    log_info "================================"
    
    if [[ -f "flutter_setup/04_hello_world_app.sh" ]]; then
        if bash flutter_setup/04_hello_world_app.sh; then
            log_success "Hello World app creation completed"
            return 0
        else
            log_error "Hello World app creation failed"
            return 1
        fi
    else
        log_error "Hello World app creation script not found"
        return 1
    fi
}

# Function to test on Android device
run_android_testing() {
    log_info "Step 4: Android Device Testing"
    log_info "=============================="
    
    if [[ -f "flutter_setup/06_test_android.sh" ]]; then
        if bash flutter_setup/06_test_android.sh; then
            log_success "Android device testing completed"
            return 0
        else
            log_error "Android device testing failed"
            return 1
        fi
    else
        log_error "Android testing script not found"
        return 1
    fi
}

# Function to build production packages
run_production_builds() {
    log_info "Step 5: Production Builds"
    log_info "========================="
    
    if [[ -f "flutter_setup/07_production_builds.sh" ]]; then
        if bash flutter_setup/07_production_builds.sh; then
            log_success "Production builds completed"
            return 0
        else
            log_error "Production builds failed"
            return 1
        fi
    else
        log_error "Production builds script not found"
        return 1
    fi
}

# Function to export environment documentation
run_environment_export() {
    log_info "Step 6: Environment Export"
    log_info "=========================="
    
    if [[ -f "flutter_setup/08_environment_export.sh" ]]; then
        if bash flutter_setup/08_environment_export.sh; then
            log_success "Environment export completed"
            return 0
        else
            log_error "Environment export failed"
            return 1
        fi
    else
        log_error "Environment export script not found"
        return 1
    fi
}

# Function to validate environment
run_environment_validation() {
    log_info "Environment Validation"
    log_info "====================="
    
    if [[ -f "flutter_setup/09_comprehensive_validation.sh" ]]; then
        if bash flutter_setup/09_comprehensive_validation.sh; then
            log_success "Environment validation completed"
            return 0
        else
            log_warning "Environment validation found issues"
            return 1
        fi
    else
        log_error "Environment validation script not found"
        return 1
    fi
}

# Function to run complete setup
run_complete_setup() {
    log_info "Running Complete Flutter Android Setup"
    log_info "======================================"
    
    # Step 1: System Preparation
    if ! run_system_preparation; then
        log_error "Complete setup failed at system preparation"
        return 1
    fi
    
    # Step 2: Flutter SDK Setup
    if ! run_flutter_setup; then
        log_error "Complete setup failed at Flutter SDK setup"
        return 1
    fi
    
    # Step 3: Hello World App
    if ! run_hello_world_creation; then
        log_error "Complete setup failed at Hello World app creation"
        return 1
    fi
    
    # Step 4: Android Testing (optional - may fail if no device)
    log_info "Testing Android device connectivity (optional)..."
    if run_android_testing; then
        log_success "Android device testing passed"
    else
        log_warning "Android device testing failed (device may not be connected)"
    fi
    
    # Step 5: Production Builds
    if ! run_production_builds; then
        log_error "Complete setup failed at production builds"
        return 1
    fi
    
    # Step 6: Environment Export
    if ! run_environment_export; then
        log_error "Complete setup failed at environment export"
        return 1
    fi
    
    # Step 7: Final Validation
    log_info "Running final environment validation..."
    if run_environment_validation; then
        log_success "Final validation passed"
    else
        log_warning "Final validation found some issues"
    fi
    
    log_success "======================================"
    log_success "Complete Flutter Android setup finished!"
    log_info "Your development environment is ready for Flutter Android development"
    
    return 0
}

# Function to handle user choice
handle_choice() {
    local choice="$1"
    
    case $choice in
        1)
            run_complete_setup
            ;;
        2)
            run_system_preparation
            ;;
        3)
            run_flutter_setup
            ;;
        4)
            run_hello_world_creation
            ;;
        5)
            run_android_testing
            ;;
        6)
            run_production_builds
            ;;
        7)
            run_environment_export
            ;;
        8)
            run_environment_validation
            ;;
        9)
            log_info "Exiting setup"
            exit 0
            ;;
        *)
            log_error "Invalid choice. Please select 1-9."
            return 1
            ;;
    esac
}

# Main setup function
main() {
    # Check if we're in the right directory
    if [[ ! -d "flutter_setup" ]]; then
        log_error "flutter_setup directory not found. Please run from the project root."
        exit 1
    fi
    
    # If arguments provided, run non-interactive mode
    if [[ $# -gt 0 ]]; then
        case "$1" in
            "complete"|"all")
                run_complete_setup
                ;;
            "system")
                run_system_preparation
                ;;
            "flutter")
                run_flutter_setup
                ;;
            "hello")
                run_hello_world_creation
                ;;
            "android")
                run_android_testing
                ;;
            "build")
                run_production_builds
                ;;
            "export")
                run_environment_export
                ;;
            "validate")
                run_environment_validation
                ;;
            *)
                log_error "Unknown command: $1"
                log_info "Available commands: complete, system, flutter, hello, android, build, export, validate"
                exit 1
                ;;
        esac
        return $?
    fi
    
    # Interactive mode
    while true; do
        display_menu
        read -p "Enter your choice (1-9): " choice
        
        if handle_choice "$choice"; then
            echo ""
            read -p "Press Enter to continue or Ctrl+C to exit..."
        else
            echo ""
            log_error "Operation failed. Check the output above for details."
            read -p "Press Enter to continue or Ctrl+C to exit..."
        fi
    done
}

# Run main function
main "$@"