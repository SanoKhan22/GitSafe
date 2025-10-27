#!/bin/bash

# Flutter Android Build Environment Setup - System Preparation
# This script prepares the Pop!_OS system with all necessary dependencies

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if running on supported system
check_system() {
    log_info "Checking system compatibility..."
    
    if [[ ! -f /etc/os-release ]]; then
        log_error "Cannot determine operating system"
        exit 1
    fi
    
    source /etc/os-release
    
    if [[ "$ID" != "pop" && "$ID_LIKE" != *"ubuntu"* && "$ID" != "ubuntu" ]]; then
        log_warning "This script is designed for Pop!_OS/Ubuntu. Current OS: $PRETTY_NAME"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Setup cancelled by user"
            exit 0
        fi
    else
        log_success "Running on compatible system: $PRETTY_NAME"
    fi
}

# Function to update system packages
update_system() {
    log_info "Updating system packages..."
    
    if ! sudo apt update; then
        log_error "Failed to update package lists"
        return 1
    fi
    
    log_info "Upgrading existing packages..."
    if ! sudo apt upgrade -y; then
        log_error "Failed to upgrade packages"
        return 1
    fi
    
    log_success "System packages updated successfully"
    return 0
}

# Function to install core dependencies
install_dependencies() {
    log_info "Installing core dependencies..."
    
    local dependencies=(
        "git"
        "curl" 
        "unzip"
        "zip"
        "openjdk-17-jdk"
    )
    
    local failed_packages=()
    
    for package in "${dependencies[@]}"; do
        log_info "Installing $package..."
        
        if sudo apt install -y "$package"; then
            log_success "$package installed successfully"
        else
            log_error "Failed to install $package"
            failed_packages+=("$package")
        fi
    done
    
    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        log_error "Failed to install the following packages: ${failed_packages[*]}"
        return 1
    fi
    
    log_success "All core dependencies installed successfully"
    return 0
}

# Function to validate installed packages
validate_installation() {
    log_info "Validating installed packages..."
    
    local validation_failed=false
    
    # Check Git
    if command -v git >/dev/null 2>&1; then
        local git_version=$(git --version)
        log_success "Git: $git_version"
    else
        log_error "Git not found in PATH"
        validation_failed=true
    fi
    
    # Check Curl
    if command -v curl >/dev/null 2>&1; then
        local curl_version=$(curl --version | head -n1)
        log_success "Curl: $curl_version"
    else
        log_error "Curl not found in PATH"
        validation_failed=true
    fi
    
    # Check Unzip
    if command -v unzip >/dev/null 2>&1; then
        local unzip_version=$(unzip -v | head -n1)
        log_success "Unzip: $unzip_version"
    else
        log_error "Unzip not found in PATH"
        validation_failed=true
    fi
    
    # Check Zip
    if command -v zip >/dev/null 2>&1; then
        local zip_version=$(zip -v | head -n2 | tail -n1)
        log_success "Zip: $zip_version"
    else
        log_error "Zip not found in PATH"
        validation_failed=true
    fi
    
    # Check Java
    if command -v java >/dev/null 2>&1; then
        local java_version=$(java -version 2>&1 | head -n1)
        log_success "Java: $java_version"
        
        # Verify Java 17
        if java -version 2>&1 | grep -q "17\."; then
            log_success "Java 17 confirmed"
        else
            log_warning "Java 17 not detected as default version"
        fi
    else
        log_error "Java not found in PATH"
        validation_failed=true
    fi
    
    # Check javac (Java compiler)
    if command -v javac >/dev/null 2>&1; then
        local javac_version=$(javac -version 2>&1)
        log_success "Java Compiler: $javac_version"
    else
        log_error "Java compiler (javac) not found in PATH"
        validation_failed=true
    fi
    
    if [[ "$validation_failed" == true ]]; then
        log_error "Some dependencies failed validation"
        return 1
    fi
    
    log_success "All dependencies validated successfully"
    return 0
}

# Function to set Java 17 as default (if multiple versions exist)
configure_java() {
    log_info "Configuring Java environment..."
    
    # Check if update-alternatives is available and Java 17 is installed
    if command -v update-alternatives >/dev/null 2>&1; then
        local java17_path="/usr/lib/jvm/java-17-openjdk-amd64"
        
        if [[ -d "$java17_path" ]]; then
            log_info "Setting Java 17 as default..."
            
            # Configure java
            sudo update-alternatives --install /usr/bin/java java "$java17_path/bin/java" 1700
            sudo update-alternatives --install /usr/bin/javac javac "$java17_path/bin/javac" 1700
            
            # Set as default
            sudo update-alternatives --set java "$java17_path/bin/java"
            sudo update-alternatives --set javac "$java17_path/bin/javac"
            
            log_success "Java 17 configured as default"
        else
            log_warning "Java 17 installation path not found at expected location"
        fi
    fi
    
    # Set JAVA_HOME if not already set
    if [[ -z "$JAVA_HOME" ]]; then
        local java_home=$(readlink -f $(which java) | sed "s:/bin/java::")
        echo "export JAVA_HOME=\"$java_home\"" >> ~/.bashrc
        export JAVA_HOME="$java_home"
        log_success "JAVA_HOME set to: $java_home"
    else
        log_info "JAVA_HOME already set to: $JAVA_HOME"
    fi
}

# Main execution function
main() {
    log_info "Starting Flutter Android Build Environment - System Preparation"
    log_info "============================================================"
    
    # Check system compatibility
    check_system
    
    # Update system packages
    if ! update_system; then
        log_error "System update failed"
        exit 1
    fi
    
    # Install dependencies
    if ! install_dependencies; then
        log_error "Dependency installation failed"
        exit 1
    fi
    
    # Configure Java
    configure_java
    
    # Validate installation
    if ! validate_installation; then
        log_error "Installation validation failed"
        exit 1
    fi
    
    log_success "============================================================"
    log_success "System preparation completed successfully!"
    log_info "Next step: Run Flutter SDK installation script"
    
    return 0
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi