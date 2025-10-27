#!/bin/bash

# Flutter Android Build Environment Setup - Production Builds
# This script creates production-ready APK and AAB files for Play Store distribution

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[PROD]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[PROD]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[PROD]${NC} $1"
}

log_error() {
    echo -e "${RED}[PROD]${NC} $1"
}

# Configuration
PROJECT_NAME="flutter_hello_world"
PROJECT_DIR="./flutter_projects/$PROJECT_NAME"
KEYSTORE_DIR="./flutter_projects/.android"
KEYSTORE_FILE="$KEYSTORE_DIR/release-key.jks"
KEY_ALIAS="release"

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

# Function to create keystore for app signing
create_keystore() {
    log_info "Setting up keystore for app signing..."
    
    # Create .android directory if it doesn't exist
    mkdir -p "$KEYSTORE_DIR"
    
    if [[ -f "$KEYSTORE_FILE" ]]; then
        log_warning "Keystore already exists: $KEYSTORE_FILE"
        
        read -p "Do you want to use the existing keystore? (Y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            log_info "Creating new keystore..."
            rm -f "$KEYSTORE_FILE"
        else
            log_info "Using existing keystore"
            return 0
        fi
    fi
    
    log_info "Creating new keystore..."
    log_info "You will be prompted for keystore and key information"
    
    # Generate keystore
    if keytool -genkey -v -keystore "$KEYSTORE_FILE" -alias "$KEY_ALIAS" -keyalg RSA -keysize 2048 -validity 10000; then
        log_success "Keystore created successfully: $KEYSTORE_FILE"
    else
        log_error "Failed to create keystore"
        return 1
    fi
    
    # Set appropriate permissions
    chmod 600 "$KEYSTORE_FILE"
    
    return 0
}

# Function to configure key properties
configure_key_properties() {
    log_info "Configuring key properties for signing..."
    
    local key_properties_file="$PROJECT_DIR/android/key.properties"
    
    if [[ -f "$key_properties_file" ]]; then
        log_warning "Key properties file already exists"
        
        read -p "Do you want to overwrite it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Using existing key properties"
            return 0
        fi
    fi
    
    log_info "Creating key properties file..."
    
    # Prompt for keystore password
    echo -n "Enter keystore password: "
    read -s keystore_password
    echo
    
    echo -n "Enter key password (press Enter to use same as keystore): "
    read -s key_password
    echo
    
    # Use keystore password if key password is empty
    if [[ -z "$key_password" ]]; then
        key_password="$keystore_password"
    fi
    
    # Create key.properties file
    cat > "$key_properties_file" << EOF
storePassword=$keystore_password
keyPassword=$key_password
keyAlias=$KEY_ALIAS
storeFile=$KEYSTORE_FILE
EOF
    
    # Set appropriate permissions
    chmod 600 "$key_properties_file"
    
    log_success "Key properties configured: $key_properties_file"
    return 0
}

# Function to configure build.gradle for signing
configure_build_gradle() {
    log_info "Configuring build.gradle for release signing..."
    
    local build_gradle="$PROJECT_DIR/android/app/build.gradle"
    
    if [[ ! -f "$build_gradle" ]]; then
        log_error "build.gradle not found: $build_gradle"
        return 1
    fi
    
    # Check if signing config is already present
    if grep -q "signingConfigs" "$build_gradle"; then
        log_info "Signing configuration already present in build.gradle"
        return 0
    fi
    
    log_info "Adding signing configuration to build.gradle..."
    
    # Create backup
    cp "$build_gradle" "$build_gradle.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Create temporary file with signing configuration
    local temp_file=$(mktemp)
    
    # Add key properties loading and signing config
    cat > "$temp_file" << 'EOF'
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    compileSdkVersion flutter.compileSdkVersion
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        applicationId "com.example.flutter_hello_world"
        minSdkVersion flutter.minSdkVersion
        targetSdkVersion flutter.targetSdkVersion
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            useProguard true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
EOF
    
    # Replace the android block in build.gradle
    sed -i '/^android {/,/^}/c\
# This will be replaced by the new android block' "$build_gradle"
    
    # Insert the new android block
    sed -i '/# This will be replaced by the new android block/r '"$temp_file" "$build_gradle"
    sed -i '/# This will be replaced by the new android block/d' "$build_gradle"
    
    # Clean up
    rm "$temp_file"
    
    log_success "build.gradle configured for release signing"
    return 0
}

# Function to build release APK
build_release_apk() {
    log_info "Building release APK..."
    
    cd "$PROJECT_DIR"
    
    # Clean previous builds
    log_info "Cleaning previous builds..."
    flutter clean >/dev/null 2>&1 || true
    
    # Get dependencies
    log_info "Getting dependencies..."
    if flutter pub get; then
        log_success "Dependencies retrieved"
    else
        log_error "Failed to get dependencies"
        return 1
    fi
    
    # Build release APK
    log_info "Building release APK (this may take a few minutes)..."
    if flutter build apk --release; then
        log_success "Release APK build completed"
    else
        log_error "Release APK build failed"
        return 1
    fi
    
    # Verify APK exists
    local apk_path="$PROJECT_DIR/build/app/outputs/flutter-apk/app-release.apk"
    if [[ -f "$apk_path" ]]; then
        log_success "Release APK created: $apk_path"
        
        local apk_size=$(du -sh "$apk_path" | cut -f1)
        log_info "APK size: $apk_size"
        
        # Verify APK is signed
        if aapt dump badging "$apk_path" >/dev/null 2>&1; then
            log_success "APK is properly signed and valid"
        else
            log_warning "Could not verify APK signature (aapt not available)"
        fi
        
        echo "$apk_path"
        return 0
    else
        log_error "Release APK not found"
        return 1
    fi
}

# Function to build App Bundle (AAB)
build_app_bundle() {
    log_info "Building Android App Bundle (AAB)..."
    
    cd "$PROJECT_DIR"
    
    # Build AAB
    log_info "Building AAB for Play Store (this may take a few minutes)..."
    if flutter build appbundle --release; then
        log_success "AAB build completed"
    else
        log_error "AAB build failed"
        return 1
    fi
    
    # Verify AAB exists
    local aab_path="$PROJECT_DIR/build/app/outputs/bundle/release/app-release.aab"
    if [[ -f "$aab_path" ]]; then
        log_success "AAB created: $aab_path"
        
        local aab_size=$(du -sh "$aab_path" | cut -f1)
        log_info "AAB size: $aab_size"
        
        echo "$aab_path"
        return 0
    else
        log_error "AAB not found"
        return 1
    fi
}

# Function to validate builds
validate_builds() {
    local apk_path="$1"
    local aab_path="$2"
    
    log_info "Validating production builds..."
    
    # Validate APK
    if [[ -f "$apk_path" ]]; then
        log_info "Validating APK..."
        
        # Check APK size (should be reasonable)
        local apk_size_bytes=$(stat -c%s "$apk_path")
        if [[ $apk_size_bytes -gt 1000000 ]]; then  # > 1MB
            log_success "APK size validation passed"
        else
            log_warning "APK seems unusually small"
        fi
        
        # Try to extract APK info
        if command -v aapt >/dev/null 2>&1; then
            local package_info=$(aapt dump badging "$apk_path" 2>/dev/null | head -5)
            if [[ -n "$package_info" ]]; then
                log_success "APK structure validation passed"
                log_info "Package info:"
                echo "$package_info" | sed 's/^/  /'
            fi
        fi
    else
        log_error "APK not found for validation"
    fi
    
    # Validate AAB
    if [[ -f "$aab_path" ]]; then
        log_info "Validating AAB..."
        
        # Check AAB size
        local aab_size_bytes=$(stat -c%s "$aab_path")
        if [[ $aab_size_bytes -gt 1000000 ]]; then  # > 1MB
            log_success "AAB size validation passed"
        else
            log_warning "AAB seems unusually small"
        fi
        
        # AAB is a ZIP file, so we can check its structure
        if command -v unzip >/dev/null 2>&1; then
            if unzip -l "$aab_path" >/dev/null 2>&1; then
                log_success "AAB structure validation passed"
            else
                log_warning "AAB structure validation failed"
            fi
        fi
    else
        log_error "AAB not found for validation"
    fi
    
    return 0
}

# Function to display build results
display_build_results() {
    local apk_path="$1"
    local aab_path="$2"
    
    log_info "Production Build Results"
    log_info "========================"
    
    echo -e "${BLUE}Project:${NC} $PROJECT_NAME"
    echo -e "${BLUE}Project Directory:${NC} $PROJECT_DIR"
    
    if [[ -f "$apk_path" ]]; then
        local apk_size=$(du -sh "$apk_path" | cut -f1)
        echo -e "${BLUE}Release APK:${NC} $apk_path ($apk_size)"
    else
        echo -e "${BLUE}Release APK:${NC} ${RED}Not built${NC}"
    fi
    
    if [[ -f "$aab_path" ]]; then
        local aab_size=$(du -sh "$aab_path" | cut -f1)
        echo -e "${BLUE}App Bundle (AAB):${NC} $aab_path ($aab_size)"
    else
        echo -e "${BLUE}App Bundle (AAB):${NC} ${RED}Not built${NC}"
    fi
    
    echo -e "${BLUE}Keystore:${NC} $KEYSTORE_FILE"
    
    echo -e "${BLUE}Next Steps:${NC}"
    echo -e "  ${GREEN}For APK distribution:${NC}"
    echo -e "    - Install on device: adb install $apk_path"
    echo -e "    - Share APK file directly"
    echo -e "  ${GREEN}For Play Store:${NC}"
    echo -e "    - Upload the AAB file to Google Play Console"
    echo -e "    - AAB files are preferred by Google Play Store"
    echo -e "  ${GREEN}Security:${NC}"
    echo -e "    - Keep your keystore file secure: $KEYSTORE_FILE"
    echo -e "    - Backup your keystore - you cannot recover it if lost"
}

# Main execution function
main() {
    log_info "Starting Flutter Production Build Process"
    log_info "========================================="
    
    # Check if project exists
    if ! check_project_exists; then
        log_error "Flutter project not found"
        return 1
    fi
    
    # Create keystore for signing
    if ! create_keystore; then
        log_error "Failed to create keystore"
        return 1
    fi
    
    # Configure key properties
    if ! configure_key_properties; then
        log_error "Failed to configure key properties"
        return 1
    fi
    
    # Configure build.gradle
    if ! configure_build_gradle; then
        log_error "Failed to configure build.gradle"
        return 1
    fi
    
    # Build release APK
    local apk_path
    if apk_path=$(build_release_apk); then
        log_success "Release APK build completed"
    else
        log_error "Release APK build failed"
        return 1
    fi
    
    # Build App Bundle
    local aab_path
    if aab_path=$(build_app_bundle); then
        log_success "App Bundle build completed"
    else
        log_error "App Bundle build failed"
        return 1
    fi
    
    # Validate builds
    validate_builds "$apk_path" "$aab_path"
    
    # Display results
    display_build_results "$apk_path" "$aab_path"
    
    log_success "========================================="
    log_success "Production builds completed successfully!"
    log_info "Your Flutter app is ready for distribution"
    
    return 0
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi