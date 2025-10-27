#!/bin/bash

# Quick script to run Flutter app on connected Android device

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[PHONE]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[PHONE]${NC} $1"
}

log_error() {
    echo -e "${RED}[PHONE]${NC} $1"
}

PROJECT_DIR="./flutter_projects/flutter_hello_world"

log_info "Running Flutter app on your phone..."

# Check if project exists
if [[ ! -d "$PROJECT_DIR" ]]; then
    log_error "Flutter project not found. Run the setup first!"
    exit 1
fi

# Check if device is connected
if ! adb devices | grep -q "device$"; then
    log_error "No Android device connected. Please connect your phone with USB debugging enabled."
    exit 1
fi

# Go to project directory and run
cd "$PROJECT_DIR"

log_info "Building and installing app on your phone..."
flutter run -d android

log_success "App should now be running on your phone!"