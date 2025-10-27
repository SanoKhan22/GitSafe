# Flutter Android Development - Troubleshooting Guide

## Common Issues and Solutions

### Flutter Issues

#### Flutter command not found
**Problem:** `flutter: command not found`

**Solutions:**
1. Check if Flutter is in PATH:
   ```bash
   echo $PATH | grep flutter
   ```
2. Add Flutter to PATH:
   ```bash
   echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
   source ~/.bashrc
   ```
3. Verify Flutter installation:
   ```bash
   ls -la ~/flutter/bin/flutter
   ```

#### Flutter doctor issues
**Problem:** Flutter doctor reports issues

**Solutions:**
1. Accept Android licenses:
   ```bash
   flutter doctor --android-licenses
   ```
2. Install missing components:
   ```bash
   flutter doctor
   # Follow the suggestions provided
   ```

### Android SDK Issues

#### Android SDK not found
**Problem:** Android toolchain issues in flutter doctor

**Solutions:**
1. Set ANDROID_HOME:
   ```bash
   export ANDROID_HOME="$HOME/Android/Sdk"
   export ANDROID_SDK_ROOT="$ANDROID_HOME"
   ```
2. Install Android SDK:
   ```bash
   flutter doctor
   # Follow Android SDK installation prompts
   ```

#### ADB not found
**Problem:** `adb: command not found`

**Solutions:**
1. Install platform-tools:
   ```bash
   sdkmanager "platform-tools"
   ```
2. Add to PATH:
   ```bash
   export PATH="$PATH:$ANDROID_HOME/platform-tools"
   ```

### Device Connection Issues

#### Device not detected
**Problem:** `flutter devices` shows no Android devices

**Solutions:**
1. Enable USB debugging on device
2. Check USB connection:
   ```bash
   adb devices
   ```
3. Restart ADB:
   ```bash
   adb kill-server
   adb start-server
   ```
4. Check device permissions:
   ```bash
   lsusb
   # Look for your device
   ```

#### Permission denied
**Problem:** Permission errors when accessing device

**Solutions:**
1. Add user to plugdev group:
   ```bash
   sudo usermod -a -G plugdev $USER
   ```
2. Create udev rules:
   ```bash
   sudo nano /etc/udev/rules.d/51-android.rules
   # Add: SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"
   sudo udevadm control --reload-rules
   ```

### Build Issues

#### Gradle build failures
**Problem:** Build fails with Gradle errors

**Solutions:**
1. Clean and rebuild:
   ```bash
   flutter clean
   flutter pub get
   flutter build apk
   ```
2. Check Java version:
   ```bash
   java -version
   # Should be Java 17
   ```
3. Clear Gradle cache:
   ```bash
   rm -rf ~/.gradle/caches/
   ```

#### Out of memory errors
**Problem:** Build fails with out of memory

**Solutions:**
1. Increase Gradle memory:
   ```bash
   echo "org.gradle.jvmargs=-Xmx4g" >> ~/.gradle/gradle.properties
   ```
2. Close other applications during build

#### Signing errors
**Problem:** App signing failures

**Solutions:**
1. Check keystore file exists:
   ```bash
   ls -la ~/.android/release-key.jks
   ```
2. Verify key.properties:
   ```bash
   cat android/key.properties
   ```
3. Regenerate keystore if needed:
   ```bash
   keytool -genkey -v -keystore ~/.android/release-key.jks -alias release -keyalg RSA -keysize 2048 -validity 10000
   ```

### Web Development Issues

#### Chrome not launching
**Problem:** Flutter web doesn't open in Chrome

**Solutions:**
1. Check Chrome installation:
   ```bash
   which google-chrome
   ```
2. Set Chrome executable:
   ```bash
   export CHROME_EXECUTABLE="/usr/bin/google-chrome"
   ```
3. Use specific port:
   ```bash
   flutter run -d chrome --web-port=8080
   ```

### Performance Issues

#### Slow builds
**Problem:** Flutter builds are very slow

**Solutions:**
1. Enable Gradle daemon:
   ```bash
   echo "org.gradle.daemon=true" >> ~/.gradle/gradle.properties
   ```
2. Use build cache:
   ```bash
   echo "org.gradle.caching=true" >> ~/.gradle/gradle.properties
   ```
3. Increase parallel builds:
   ```bash
   echo "org.gradle.parallel=true" >> ~/.gradle/gradle.properties
   ```

#### Hot reload not working
**Problem:** Hot reload doesn't update app

**Solutions:**
1. Check if running in debug mode
2. Restart Flutter:
   ```bash
   # Press 'R' in terminal for hot restart
   # Press 'r' for hot reload
   ```
3. Full restart:
   ```bash
   flutter run
   ```

## Diagnostic Commands

### System Information
```bash
# System info
uname -a
lsb_release -a

# Java info
java -version
javac -version
echo $JAVA_HOME

# Flutter info
flutter --version
flutter doctor -v
flutter devices

# Android info
adb version
adb devices
echo $ANDROID_HOME
```

### Log Collection
```bash
# Flutter logs
flutter logs

# Android device logs
adb logcat

# Gradle logs (during build)
flutter build apk --verbose
```

## Getting Additional Help

### Official Resources
- Flutter documentation: https://docs.flutter.dev/
- Flutter GitHub issues: https://github.com/flutter/flutter/issues
- Android developer docs: https://developer.android.com/

### Community Support
- Flutter community: https://flutter.dev/community
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
- Reddit: https://www.reddit.com/r/FlutterDev/

### Reporting Issues
When reporting issues, include:
1. Output of `flutter doctor -v`
2. Complete error messages
3. Steps to reproduce
4. System information (`uname -a`)
5. Flutter and Dart versions
