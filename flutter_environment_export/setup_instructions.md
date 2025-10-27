# Flutter Android Development Environment Setup Instructions

## System Preparation

### 1. Update System
```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Install Core Dependencies
```bash
sudo apt install git curl unzip zip openjdk-17-jdk -y
```

### 3. Configure Java
```bash
# Set Java 17 as default
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-17-openjdk-amd64/bin/java 1700
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-17-openjdk-amd64/bin/javac 1700

# Set JAVA_HOME
echo 'export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"' >> ~/.bashrc
```

## Flutter SDK Installation

### 1. Download Flutter
```bash
# Create installation directory
mkdir -p ~/flutter

# Download Flutter (replace URL with latest stable)
curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz -o flutter.tar.xz

# Extract Flutter
tar -xf flutter.tar.xz -C ~/
```

### 2. Configure Flutter PATH
```bash
# Add to shell configuration
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc

# Reload shell configuration
source ~/.bashrc
```

### 3. Initialize Flutter
```bash
# Run Flutter doctor
flutter doctor

# Accept Android licenses (if Android SDK is available)
flutter doctor --android-licenses
```

## Android SDK Setup

### Option 1: Using Flutter (Recommended)
```bash
# Flutter will prompt to install Android SDK
flutter doctor

# Follow prompts to install Android SDK
```

### Option 2: Manual Installation
```bash
# Download Android command line tools
mkdir -p ~/Android/Sdk/cmdline-tools
cd ~/Android/Sdk/cmdline-tools

# Download and extract command line tools
curl -L https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -o cmdline-tools.zip
unzip cmdline-tools.zip
mv cmdline-tools latest

# Set environment variables
echo 'export ANDROID_HOME="$HOME/Android/Sdk"' >> ~/.bashrc
echo 'export ANDROID_SDK_ROOT="$ANDROID_HOME"' >> ~/.bashrc
echo 'export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"' >> ~/.bashrc
echo 'export PATH="$PATH:$ANDROID_HOME/platform-tools"' >> ~/.bashrc

# Reload shell
source ~/.bashrc

# Install SDK components
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.1"

# Accept licenses
yes | sdkmanager --licenses
```

## Chrome Installation

### Install Google Chrome
```bash
# Download and install Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install google-chrome-stable -y
```

## Verification

### 1. Run Flutter Doctor
```bash
flutter doctor -v
```

### 2. Create Test Project
```bash
# Create new Flutter project
flutter create hello_world
cd hello_world

# Test web build
flutter run -d chrome

# Test Android build (with device connected)
flutter run -d android
```

### 3. Build Production Packages
```bash
# Build release APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

## Android Device Setup

### 1. Enable Developer Options
1. Go to Settings > About Phone
2. Tap "Build Number" 7 times
3. Developer Options will appear in Settings

### 2. Enable USB Debugging
1. Go to Settings > Developer Options
2. Enable "USB Debugging"
3. Connect device via USB
4. Accept debugging prompt on device

### 3. Verify Device Connection
```bash
# Check ADB connection
adb devices

# Check Flutter device detection
flutter devices
```

## Troubleshooting

### Common Issues

1. **Flutter not found in PATH**
   - Restart terminal or run `source ~/.bashrc`
   - Verify PATH contains Flutter bin directory

2. **Android licenses not accepted**
   - Run `flutter doctor --android-licenses`
   - Accept all license agreements

3. **Device not detected**
   - Check USB debugging is enabled
   - Try different USB cable/port
   - Run `adb kill-server && adb start-server`

4. **Build failures**
   - Run `flutter clean && flutter pub get`
   - Check Java version: `java -version`
   - Verify Android SDK installation

### Getting Help

- Flutter documentation: https://docs.flutter.dev/
- Flutter community: https://flutter.dev/community
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
