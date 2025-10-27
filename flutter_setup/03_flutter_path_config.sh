#!/bin/bash

# Flutter Android Build Environment Setup - Flutter PATH Configuration
# This script ensures Flutter PATH is properly configured and persistent

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[PATH]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[PATH]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[PATH]${NC} $1"
}

log_error() {
    echo -e "${RED}[PATH]${NC} $1"
}

# Function to detect Flutter installation
detect_flutter_installation() {
    log_info "Detecting Flutter installation..."
    
    local flutter_paths=(
        "$HOME/flutter"
        "/opt/flutter"
        "/usr/local/flutter"
    )
    
    # First check if flutter is already in PATH
    if command -v flutter >/dev/null 2>&1; then
        local flutter_path=$(which flutter)
        local flutter_dir=$(dirname "$(dirname "$flutter_path")")
        log_success "Flutter found in PATH: $flutter_path"
        log_success "Flutter directory: $flutter_dir"
        echo "$flutter_dir"
        return 0
    fi
    
    # Check common installation paths
    for path in "${flutter_paths[@]}"; do
        if [[ -d "$path" && -f "$path/bin/flutter" ]]; then
            log_success "Flutter found at: $path"
            echo "$path"
            return 0
        fi
    done
    
    log_error "Flutter installation not found"
    return 1
}

# Function to get shell configuration files
get_shell_config_files() {
    local config_files=()
    
    # Add shell-specific configuration files
    if [[ -n "$ZSH_VERSION" ]] || [[ "$SHELL" == *"zsh"* ]]; then
        [[ -f "$HOME/.zshrc" ]] && config_files+=("$HOME/.zshrc")
    fi
    
    if [[ -n "$BASH_VERSION" ]] || [[ "$SHELL" == *"bash"* ]]; then
        [[ -f "$HOME/.bashrc" ]] && config_files+=("$HOME/.bashrc")
    fi
    
    # Always check .profile as a fallback
    [[ -f "$HOME/.profile" ]] && config_files+=("$HOME/.profile")
    
    # If no config files found, create .bashrc
    if [[ ${#config_files[@]} -eq 0 ]]; then
        touch "$HOME/.bashrc"
        config_files+=("$HOME/.bashrc")
    fi
    
    printf '%s\n' "${config_files[@]}"
}

# Function to check if Flutter PATH is configured
check_flutter_path_config() {
    local flutter_dir="$1"
    local flutter_bin_path="$flutter_dir/bin"
    
    log_info "Checking Flutter PATH configuration..."
    
    # Check current session PATH
    if echo "$PATH" | grep -F "$flutter_bin_path" >/dev/null 2>&1; then
        log_success "Flutter is in current session PATH"
    else
        log_warning "Flutter not in current session PATH"
    fi
    
    # Check shell configuration files
    local config_files
    readarray -t config_files < <(get_shell_config_files)
    
    local configured_files=()
    for config_file in "${config_files[@]}"; do
        if grep -F "$flutter_bin_path" "$config_file" >/dev/null 2>&1 || grep -F "flutter/bin" "$config_file" >/dev/null 2>&1; then
            configured_files+=("$config_file")
        fi
    done
    
    if [[ ${#configured_files[@]} -gt 0 ]]; then
        log_success "Flutter PATH configured in: ${configured_files[*]}"
        return 0
    else
        log_warning "Flutter PATH not configured in shell files"
        return 1
    fi
}

# Function to configure Flutter PATH
configure_flutter_path() {
    local flutter_dir="$1"
    local flutter_bin_path="$flutter_dir/bin"
    
    log_info "Configuring Flutter PATH..."
    
    # Get shell configuration files
    local config_files
    readarray -t config_files < <(get_shell_config_files)
    
    local primary_config="${config_files[0]}"
    log_info "Using primary configuration file: $primary_config"
    
    # Backup the configuration file
    if [[ -f "$primary_config" ]]; then
        cp "$primary_config" "$primary_config.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Backup created: $primary_config.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Check if Flutter PATH is already configured
    if grep -F "$flutter_bin_path" "$primary_config" >/dev/null 2>&1 || grep -F "flutter/bin" "$primary_config" >/dev/null 2>&1; then
        log_warning "Flutter PATH already configured in $primary_config"
        
        # Update the existing configuration if path is different
        if ! grep -F "$flutter_bin_path" "$primary_config" >/dev/null 2>&1; then
            log_info "Updating Flutter PATH configuration..."
            sed -i "s|export PATH=\"\$PATH:[^\"]*flutter/bin\"|export PATH=\"\$PATH:$flutter_bin_path\"|g" "$primary_config"
            log_success "Flutter PATH updated in $primary_config"
        fi
    else
        log_info "Adding Flutter PATH to $primary_config"
        
        # Add Flutter PATH configuration
        cat >> "$primary_config" << EOF

# Flutter SDK Path - Added by Flutter setup script
export PATH="\$PATH:$flutter_bin_path"
EOF
        
        log_success "Flutter PATH added to $primary_config"
    fi
    
    # Export PATH for current session
    export PATH="$PATH:$flutter_bin_path"
    
    return 0
}

# Function to configure additional Flutter environment variables
configure_flutter_environment() {
    local flutter_dir="$1"
    
    log_info "Configuring Flutter environment variables..."
    
    # Get primary shell configuration file
    local config_files
    readarray -t config_files < <(get_shell_config_files)
    local primary_config="${config_files[0]}"
    
    # Configure FLUTTER_ROOT (optional but useful)
    if ! grep -q "FLUTTER_ROOT" "$primary_config" 2>/dev/null; then
        log_info "Adding FLUTTER_ROOT environment variable..."
        cat >> "$primary_config" << EOF

# Flutter Root Directory
export FLUTTER_ROOT="$flutter_dir"
EOF
        log_success "FLUTTER_ROOT added to $primary_config"
    else
        log_info "FLUTTER_ROOT already configured"
    fi
    
    # Export for current session
    export FLUTTER_ROOT="$flutter_dir"
    
    # Configure Dart SDK path (Dart comes with Flutter)
    local dart_bin_path="$flutter_dir/bin/cache/dart-sdk/bin"
    if [[ -d "$dart_bin_path" ]] && ! echo "$PATH" | grep -q "$dart_bin_path"; then
        log_info "Adding Dart SDK to PATH..."
        export PATH="$PATH:$dart_bin_path"
        
        if ! grep -q "$dart_bin_path" "$primary_config" 2>/dev/null; then
            cat >> "$primary_config" << EOF

# Dart SDK Path (from Flutter)
export PATH="\$PATH:$dart_bin_path"
EOF
            log_success "Dart SDK PATH added to $primary_config"
        fi
    fi
    
    return 0
}

# Function to validate PATH configuration
validate_path_configuration() {
    local flutter_dir="$1"
    
    log_info "Validating PATH configuration..."
    
    # Test Flutter command availability
    if command -v flutter >/dev/null 2>&1; then
        local flutter_version=$(flutter --version | head -n1)
        log_success "Flutter command available: $flutter_version"
    else
        log_error "Flutter command not available in PATH"
        return 1
    fi
    
    # Test Dart command availability
    if command -v dart >/dev/null 2>&1; then
        local dart_version=$(dart --version 2>&1 | head -n1)
        log_success "Dart command available: $dart_version"
    else
        log_warning "Dart command not available in PATH (this may be normal)"
    fi
    
    # Verify PATH contains Flutter
    local flutter_bin_path="$flutter_dir/bin"
    if echo "$PATH" | grep -F "$flutter_bin_path" >/dev/null 2>&1; then
        log_success "Flutter directory is in PATH"
    else
        log_error "Flutter directory not found in PATH"
        return 1
    fi
    
    # Test Flutter functionality
    log_info "Testing Flutter functionality..."
    if flutter --version >/dev/null 2>&1; then
        log_success "Flutter is functional"
    else
        log_error "Flutter command failed"
        return 1
    fi
    
    return 0
}

# Function to display configuration summary
display_configuration_summary() {
    local flutter_dir="$1"
    
    log_info "Configuration Summary"
    log_info "===================="
    
    echo -e "${BLUE}Flutter Directory:${NC} $flutter_dir"
    echo -e "${BLUE}Flutter Binary:${NC} $flutter_dir/bin/flutter"
    
    if [[ -n "$FLUTTER_ROOT" ]]; then
        echo -e "${BLUE}FLUTTER_ROOT:${NC} $FLUTTER_ROOT"
    fi
    
    echo -e "${BLUE}Current PATH:${NC}"
    echo "$PATH" | tr ':' '\n' | grep -E "(flutter|dart)" | sed 's/^/  /' || echo "  No Flutter/Dart paths found"
    
    echo -e "${BLUE}Shell Configuration Files:${NC}"
    local config_files
    readarray -t config_files < <(get_shell_config_files)
    for config_file in "${config_files[@]}"; do
        if grep -F "flutter" "$config_file" >/dev/null 2>&1; then
            echo -e "  ${GREEN}✓${NC} $config_file"
        else
            echo -e "  ${YELLOW}-${NC} $config_file"
        fi
    done
}

# Main execution function
main() {
    log_info "Starting Flutter PATH Configuration"
    log_info "=================================="
    
    # Detect Flutter installation
    local flutter_dir
    if flutter_dir=$(detect_flutter_installation); then
        log_success "Flutter installation detected"
    else
        log_error "Flutter installation not found. Please install Flutter first."
        return 1
    fi
    
    # Check current PATH configuration
    if check_flutter_path_config "$flutter_dir"; then
        log_info "Flutter PATH is already configured"
    else
        log_info "Flutter PATH needs configuration"
        
        # Configure Flutter PATH
        if configure_flutter_path "$flutter_dir"; then
            log_success "Flutter PATH configuration completed"
        else
            log_error "Flutter PATH configuration failed"
            return 1
        fi
    fi
    
    # Configure additional environment variables
    if configure_flutter_environment "$flutter_dir"; then
        log_success "Flutter environment configuration completed"
    else
        log_error "Flutter environment configuration failed"
        return 1
    fi
    
    # Validate configuration
    if validate_path_configuration "$flutter_dir"; then
        log_success "PATH configuration validation passed"
    else
        log_error "PATH configuration validation failed"
        return 1
    fi
    
    # Display summary
    display_configuration_summary "$flutter_dir"
    
    log_success "=================================="
    log_success "Flutter PATH configuration completed successfully!"
    log_info "Please restart your terminal or run 'source ~/.bashrc' to ensure all changes take effect"
    
    return 0
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi