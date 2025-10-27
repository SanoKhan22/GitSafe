#!/bin/bash

# Flutter Android Build Environment Setup - Web Browser Testing
# This script tests Flutter web application in Chrome browser

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[WEB]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[WEB]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WEB]${NC} $1"
}

log_error() {
    echo -e "${RED}[WEB]${NC} $1"
}

# Configuration
PROJECT_NAME="flutter_hello_world"
PROJECT_DIR="./flutter_projects/$PROJECT_NAME"
WEB_PORT=8080
TEST_TIMEOUT=30

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

# Function to check if Chrome is available
check_chrome_available() {
    log_info "Checking Chrome availability..."
    
    local chrome_commands=("google-chrome" "chrome" "chromium" "chromium-browser")
    
    for cmd in "${chrome_commands[@]}"; do
        if command -v "$cmd" >/dev/null 2>&1; then
            log_success "Chrome found: $cmd"
            echo "$cmd"
            return 0
        fi
    done
    
    log_error "Chrome browser not found"
    log_info "Please install Google Chrome or Chromium"
    return 1
}

# Function to check if port is available
check_port_available() {
    local port="$1"
    
    log_info "Checking if port $port is available..."
    
    if netstat -tuln 2>/dev/null | grep -q ":$port "; then
        log_warning "Port $port is already in use"
        
        # Try to find an available port
        for ((p=port+1; p<=port+10; p++)); do
            if ! netstat -tuln 2>/dev/null | grep -q ":$p "; then
                log_info "Using alternative port: $p"
                echo "$p"
                return 0
            fi
        done
        
        log_error "No available ports found in range $port-$((port+10))"
        return 1
    else
        log_success "Port $port is available"
        echo "$port"
        return 0
    fi
}

# Function to build web application
build_web_app() {
    log_info "Building Flutter web application..."
    
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
    
    # Build for web
    log_info "Building for web..."
    if flutter build web --web-renderer html; then
        log_success "Web build completed"
    else
        log_error "Web build failed"
        return 1
    fi
    
    # Verify build output
    if [[ -d "$PROJECT_DIR/build/web" && -f "$PROJECT_DIR/build/web/index.html" ]]; then
        log_success "Web build artifacts verified"
        
        local build_size=$(du -sh "$PROJECT_DIR/build/web" | cut -f1)
        log_info "Web build size: $build_size"
    else
        log_error "Web build artifacts not found"
        return 1
    fi
    
    return 0
}

# Function to start Flutter web server
start_web_server() {
    local port="$1"
    
    log_info "Starting Flutter web server on port $port..."
    
    cd "$PROJECT_DIR"
    
    # Start Flutter web server in background
    log_info "Running: flutter run -d chrome --web-port=$port"
    
    # Create a temporary file to capture the server process
    local server_log="/tmp/flutter_web_server.log"
    local server_pid_file="/tmp/flutter_web_server.pid"
    
    # Start server in background and capture PID
    nohup flutter run -d chrome --web-port="$port" --web-hostname=localhost > "$server_log" 2>&1 &
    local server_pid=$!
    echo "$server_pid" > "$server_pid_file"
    
    log_info "Flutter web server started with PID: $server_pid"
    log_info "Server log: $server_log"
    
    # Wait for server to start
    log_info "Waiting for server to start..."
    local wait_count=0
    while [[ $wait_count -lt $TEST_TIMEOUT ]]; do
        if curl -s "http://localhost:$port" >/dev/null 2>&1; then
            log_success "Web server is responding"
            break
        fi
        
        # Check if process is still running
        if ! kill -0 "$server_pid" 2>/dev/null; then
            log_error "Flutter web server process died"
            cat "$server_log" | tail -20
            return 1
        fi
        
        sleep 1
        ((wait_count++))
        
        if [[ $((wait_count % 5)) -eq 0 ]]; then
            log_info "Still waiting for server... ($wait_count/$TEST_TIMEOUT)"
        fi
    done
    
    if [[ $wait_count -ge $TEST_TIMEOUT ]]; then
        log_error "Server failed to start within $TEST_TIMEOUT seconds"
        
        # Show server log for debugging
        log_info "Server log contents:"
        cat "$server_log" | tail -20
        
        # Kill the server process
        kill "$server_pid" 2>/dev/null || true
        return 1
    fi
    
    echo "$server_pid"
    return 0
}

# Function to test web application
test_web_application() {
    local port="$1"
    local server_pid="$2"
    
    log_info "Testing web application..."
    
    local app_url="http://localhost:$port"
    
    # Test if the application loads
    log_info "Testing application load at $app_url"
    
    local response
    if response=$(curl -s -w "%{http_code}" "$app_url"); then
        local http_code="${response: -3}"
        if [[ "$http_code" == "200" ]]; then
            log_success "Application loads successfully (HTTP $http_code)"
        else
            log_error "Application returned HTTP $http_code"
            return 1
        fi
    else
        log_error "Failed to connect to application"
        return 1
    fi
    
    # Test if it's a Flutter app by checking for Flutter-specific content
    log_info "Verifying Flutter application content..."
    
    local page_content
    if page_content=$(curl -s "$app_url"); then
        if echo "$page_content" | grep -q "flutter"; then
            log_success "Flutter application content verified"
        else
            log_warning "Flutter-specific content not found (this may be normal)"
        fi
        
        # Check for basic HTML structure
        if echo "$page_content" | grep -q "<html"; then
            log_success "Valid HTML structure found"
        else
            log_error "Invalid HTML structure"
            return 1
        fi
    else
        log_error "Failed to retrieve application content"
        return 1
    fi
    
    # Test application functionality (basic check)
    log_info "Testing application functionality..."
    
    # Check if main.dart content is accessible
    if echo "$page_content" | grep -q "Flutter Demo Home Page\|Counter"; then
        log_success "Flutter counter app content detected"
    else
        log_info "Default Flutter content not detected (custom app may be running)"
    fi
    
    return 0
}

# Function to launch Chrome browser
launch_chrome_browser() {
    local port="$1"
    local chrome_cmd="$2"
    
    log_info "Launching Chrome browser..."
    
    local app_url="http://localhost:$port"
    
    # Launch Chrome in a new window
    log_info "Opening $app_url in Chrome"
    
    if "$chrome_cmd" --new-window "$app_url" >/dev/null 2>&1 &; then
        log_success "Chrome browser launched"
        log_info "You should see the Flutter Hello World app in your browser"
        log_info "Look for a counter app with a '+' button"
    else
        log_error "Failed to launch Chrome browser"
        return 1
    fi
    
    return 0
}

# Function to stop web server
stop_web_server() {
    local server_pid="$1"
    
    log_info "Stopping web server..."
    
    if [[ -n "$server_pid" ]] && kill -0 "$server_pid" 2>/dev/null; then
        log_info "Stopping server process $server_pid"
        kill "$server_pid" 2>/dev/null || true
        
        # Wait for process to stop
        local wait_count=0
        while kill -0 "$server_pid" 2>/dev/null && [[ $wait_count -lt 10 ]]; do
            sleep 1
            ((wait_count++))
        done
        
        # Force kill if still running
        if kill -0 "$server_pid" 2>/dev/null; then
            log_warning "Force killing server process"
            kill -9 "$server_pid" 2>/dev/null || true
        fi
        
        log_success "Web server stopped"
    else
        log_info "Web server not running"
    fi
    
    # Clean up temporary files
    rm -f "/tmp/flutter_web_server.log" "/tmp/flutter_web_server.pid"
}

# Function to display test results
display_test_results() {
    local port="$1"
    
    log_info "Web Test Results"
    log_info "================"
    
    echo -e "${BLUE}Application URL:${NC} http://localhost:$port"
    echo -e "${BLUE}Project Directory:${NC} $PROJECT_DIR"
    echo -e "${BLUE}Build Directory:${NC} $PROJECT_DIR/build/web"
    
    if [[ -d "$PROJECT_DIR/build/web" ]]; then
        local build_size=$(du -sh "$PROJECT_DIR/build/web" | cut -f1)
        echo -e "${BLUE}Build Size:${NC} $build_size"
    fi
    
    echo -e "${BLUE}Manual Testing:${NC}"
    echo -e "  1. Open http://localhost:$port in your browser"
    echo -e "  2. Verify the Flutter counter app loads"
    echo -e "  3. Click the '+' button to test functionality"
    echo -e "  4. Check browser developer tools for any errors"
}

# Main execution function
main() {
    log_info "Starting Flutter Web Browser Testing"
    log_info "===================================="
    
    # Check if project exists
    if ! check_project_exists; then
        log_error "Flutter project not found"
        return 1
    fi
    
    # Check Chrome availability
    local chrome_cmd
    if chrome_cmd=$(check_chrome_available); then
        log_success "Chrome browser available"
    else
        log_error "Chrome browser not available"
        return 1
    fi
    
    # Check port availability
    local port
    if port=$(check_port_available "$WEB_PORT"); then
        log_success "Using port: $port"
    else
        log_error "No available port found"
        return 1
    fi
    
    # Build web application
    if ! build_web_app; then
        log_error "Web build failed"
        return 1
    fi
    
    # Start web server
    local server_pid
    if server_pid=$(start_web_server "$port"); then
        log_success "Web server started successfully"
    else
        log_error "Failed to start web server"
        return 1
    fi
    
    # Test web application
    if test_web_application "$port" "$server_pid"; then
        log_success "Web application test passed"
    else
        log_error "Web application test failed"
        stop_web_server "$server_pid"
        return 1
    fi
    
    # Launch Chrome browser
    if launch_chrome_browser "$port" "$chrome_cmd"; then
        log_success "Browser launched successfully"
    else
        log_warning "Failed to launch browser (application is still running)"
    fi
    
    # Display results
    display_test_results "$port"
    
    log_success "===================================="
    log_success "Flutter web browser testing completed!"
    log_info "Press Ctrl+C to stop the web server when done testing"
    
    # Keep server running and wait for user interrupt
    log_info "Web server is running... Press Ctrl+C to stop"
    
    # Set up trap to clean up on exit
    trap "stop_web_server '$server_pid'" EXIT INT TERM
    
    # Wait for user interrupt
    while kill -0 "$server_pid" 2>/dev/null; do
        sleep 5
    done
    
    log_info "Web server has stopped"
    return 0
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi