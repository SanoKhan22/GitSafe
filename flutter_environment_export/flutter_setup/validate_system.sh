#!/bin/bash

# Quick validation script to check current system state
# This can be run safely without making any changes

source flutter_setup/01_system_preparation.sh

# Only run validation functions
log_info "Running system validation check..."
check_system
validate_installation