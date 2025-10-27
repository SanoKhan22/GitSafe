#!/bin/bash

# Flutter Android Build Environment Setup - Flutter SDK Installation
# This script downloads, installs, and configures Flutter SDK

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[FLUTTER]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[FLUTTER]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[FLUTTER]${NC} $1"
}

log_error() {
    echo -e "${RED}[FLUTTER]${NC} $1"
}

# Configuration
FLUTTER_VERSION="stable"
FLUTTER_INSTALL_DIR="$HOME/flutter"
FLUTTER_DOWNLOAD_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.1-stable.tar.xz"
FLUTTER_CHECKSUM="b9b2b5b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8b8"  # This would be the actual checksum

# Function to check if Flutter is already installed
check_existing_flutter() {
    log_info "Checking for existing Flutter installation..."
    
    if command -v flutter >/dev/null 2>&1; then
        local flutter_version=$(flutter --version | head -n1)
        log_warning "Flutter already found in PATH: $flutter_version"
        
        read -p "Do you want to reinstall Flutter? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Using existing Flutter installation"
            return 1  # Skip installation
        fi
    fi
    
    if [[ -d "$FLUTTER_INSTALL_DIR" ]]; then
        log_warning "Flutter directory already exists at $FLUTTER_INSTALL_DIR"
        
        read -p "Do you want to remove and reinstall? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "Removing existing Flutter directory..."
            rm -rf "$FLUTTER_INSTALL_DIR"
        else
            log_info "Keeping existing installation"
            return 1  # Skip installation
        fi
    fi
    
    return 0  # Proceed with installation
}

# Function to get the latest Flutter download URL
get_flutter_download_url() {
    log_info "Getting latest Flutter stable release information..."
    
    # Use the Flutter releases API to get the latest stable version
    local releases_url="https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json"
    
    if command -v jq >/dev/null 2>&1; then
        # If jq is available, parse JSON properly
        local latest_url=$(curl -s "$releases_url" | jq -r '.releases[] | select(.channel=="stable") | .archive' | head -n1)
        if [[ -n "$latest_url" && "$latest_url" != "null" ]]; then
            FLUTTER_DOWNLOAD_URL="https://storage.googleapis.com/flutter_infra_release/releases/$latest_url"
            log_success "Found latest Flutter URL: $FLUTTER_DOWNLOAD_URL"
        else
            log_warning "Could not parse latest Flutter URL, using default"
        fi
    else
        log_warning "jq not available, using default Flutter download URL"
        # Install jq for future use
        if command -v apt >/dev/null 2>&1; then
            log_info "Installing jq for JSON parsing..."
            sudo apt install -y jq >/dev/null 2>&1 || log_warning "Failed to install jq"
        fi
    fi
}

# Function to download Flutter SDK
download_flutter() {
    log_info "Downloading Flutter SDK..."
    
    local download_dir="/tmp/flutter_download"
    local flutter_archive="$download_dir/flutter.tar.xz"
    
    # Create download directory
    mkdir -p "$download_dir"
    
    # Download Flutter
    log_info "Downloading from: $FLUTTER_DOWNLOAD_URL"
    if curl -L --progress-bar -o "$flutter_archive" "$FLUTTER_DOWNLOAD_URL"; then
        log_success "Flutter SDK downloaded successfully"
    else
        log_error "Failed to download Flutter SDK"
        return 1
    fi
    
    # Verify download (basic size check)
    local file_size=$(stat -c%s "$flutter_archive" 2>/dev/null || echo "0")
    if [[ $file_size -lt 100000000 ]]; then  # Less than 100MB seems wrong
        log_error "Downloaded file seems too small ($file_size bytes). Download may have failed."
        return 1
    fi
    
    log_success "Download verification passed (size: $file_size bytes)"
    echo "$flutter_archive"
    return 0
}

# Function to extract and install Flutter
install_flutter() {
    local flutter_archive="$1"
    
    log_info "Installing Flutter SDK to $FLUTTER_INSTALL_DIR..."
    
    # Create parent directory
    mkdir -p "$(dirname "$FLUTTER_INSTALL_DIR")"
    
    # Extract Flutter
    log_info "Extracting Flutter SDK..."
    if tar -xf "$flutter_archive" -C "$(dirname "$FLUTTER_INSTALL_DIR")"; then
        log_success "Flutter SDK extracted successfully"
    else
        log_error "Failed to extract Flutter SDK"
        return 1
    fi
    
    # Verify installation
    if [[ -d "$FLUTTER_INSTALL_DIR" && -f "$FLUTTER_INSTALL_DIR/bin/flutter" ]]; then
        log_success "Flutter SDK installed successfully at $FLUTTER_INSTALL_DIR"
    else
        log_error "Flutter installation verification failed"
        return 1
    fi
    
    # Make flutter executable
    chmod +x "$FLUTTER_INSTALL_DIR/bin/flutter"
    
    # Clean up download
    rm -f "$flutter_archive"
    
    return 0
}

# Function to configure Flutter PATH
configure_flutter_path() {
    log_info "Configuring Flutter PATH..."
    
    local flutter_bin_path="$FLUTTER_INSTALL_DIR/bin"
    local shell_rc=""
    
    # Determine which shell configuration file to use
    if [[ -n "$ZSH_VERSION" ]]; then
        shell_rc="$HOME/.zshrc"
    elif [[ -n "$BASH_VERSION" ]]; then
        shell_rc="$HOME/.bashrc"
    else
        # Default to .bashrc
        shell_rc="$HOME/.bashrc"
    fi
    
    log_info "Using shell configuration file: $shell_rc"
    
    # Check if Flutter path is already in the configuration
    if grep -q "flutter/bin" "$shell_rc" 2>/dev/null; then
        log_warning "Flutter PATH already configured in $shell_rc"
    else
        log_info "Adding Flutter to PATH in $shell_rc"
        
        # Backup the shell configuration file
        cp "$shell_rc" "$shell_rc.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
        
        # Add Flutter to PATH
        echo "" >> "$shell_rc"
        echo "# Flutter SDK Path" >> "$shell_rc"
        echo "export PATH=\"\$PATH:$flutter_bin_path\"" >> "$shell_rc"
        
        log_success "Flutter PATH added to $shell_rc"
    fi
    
    # Export PATH for current session
    export PATH="$PATH:$flutter_bin_path"
    
    # Verify PATH configuration
    if echo "$PATH" | grep -q "$flutter_bin_path"; then
        log_success "Flutter PATH configured for current session"
    else
        log_error "Failed to configure Flutter PATH for current session"
        return 1
    fi
    
    return 0
}

# Function to run initial Flutter setup
initialize_flutter() {
    log_info "Initializing Flutter..."
    
    # Add Flutter to PATH for this script
    export PATH="$PATH:$FLUTTER_INSTALL_DIR/bin"
    
    # Run flutter doctor to initialize and check setup
    log_info "Running flutter doctor for initial setup..."
    if flutter doctor; then
        log_success "Flutter doctor completed"
    else
        log_warning "Flutter doctor found some issues (this is normal for initial setup)"
    fi
    
    # Accept Android licenses (if Android SDK is available)
    log_info "Attempting to accept Android licenses..."
    if command -v sdkmanager >/dev/null 2>&1; then
        yes | flutter doctor --android-licenses 2>/dev/null || log_warning "Could not accept Android licenses (Android SDK may not be installed yet)"
    else
        log_info "Android SDK not found, skipping license acceptance"
    fi
    
    # Disable analytics (optional, for privacy)
    log_info "Configuring Flutter analytics..."
    flutter config --no-analytics
    
    log_success "Flutter initialization completed"
    return 0
}

# Function to validate Flutter installation
validate_flutter_installation() {
    log_info "Validating Flutter installation..."
    
    # Add Flutter to PATH for validation
    export PATH="$PATH:$FLUTTER_INSTALL_DIR/bin"
    
    # Check if flutter command is available
    if command -v flutter >/dev/null 2>&1; then
        local flutter_version=$(flutter --version | head -n1)
        log_success "Flutter command available: $flutter_version"
    else
        log_error "Flutter command not found in PATH"
        return 1
    fi
    
    # Check Dart SDK (included with Flutter)
    if command -v dart >/dev/null 2>&1; then
        local dart_version=$(dart --version 2>&1 | head -n1)
        log_success "Dart SDK available: $dart_version"
    else
        log_error "Dart SDK not found"
        return 1
    fi
    
    # Verify Flutter installation directory
    if [[ -d "$FLUTTER_INSTALL_DIR" ]]; then
        local flutter_size=$(du -sh "$FLUTTER_INSTALL_DIR" | cut -f1)
        log_success "Flutter installation directory: $FLUTTER_INSTALL_DIR ($flutter_size)"
    else
        log_error "Flutter installation directory not found"
        return 1
    fi
    
    # Run flutter doctor for comprehensive check
    log_info "Running comprehensive Flutter doctor check..."
    flutter doctor -v
    
    log_success "Flutter installation validation completed"
    return 0
}

# Main execution function
main() {
    log_info "Starting Flutter SDK Installation"
    log_info "================================"
    
    # Check for existing installation
    if ! check_existing_flutter; then
        log_info "Skipping Flutter installation"
        
        # Still validate the existing installation
        if validate_flutter_installation; then
            log_success "Existing Flutter installation is valid"
            return 0
        else
            log_error "Existing Flutter installation has issues"
            return 1
        fi
    fi
    
    # Get latest Flutter download URL
    get_flutter_download_url
    
    # Download Flutter SDK
    local flutter_archive
    if flutter_archive=$(download_flutter); then
        log_success "Flutter SDK download completed"
    else
        log_error "Flutter SDK download failed"
        return 1
    fi
    
    # Install Flutter SDK
    if install_flutter "$flutter_archive"; then
        log_success "Flutter SDK installation completed"
    else
        log_error "Flutter SDK installation failed"
        return 1
    fi
    
    # Configure PATH
    if configure_flutter_path; then
        log_success "Flutter PATH configuration completed"
    else
        log_error "Flutter PATH configuration failed"
        return 1
    fi
    
    # Initialize Flutter
    if initialize_flutter; then
        log_success "Flutter initialization completed"
    else
        log_error "Flutter initialization failed"
        return 1
    fi
    
    # Validate installation
    if validate_flutter_installation; then
        log_success "Flutter installation validation passed"
    else
        log_error "Flutter installation validation failed"
        return 1
    fi
    
    log_success "================================"
    log_success "Flutter SDK installation completed successfully!"
    log_info "Please restart your terminal or run 'source ~/.bashrc' to use Flutter commands"
    log_info "Next step: Run Android SDK installation script"
    
    return 0
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi