# Flutter Android Development Environment

This directory contains the exported configuration for a complete Flutter Android development environment.

## Generated Files

- `environment_variables.sh` - Environment variables to source in your shell
- `versions.txt` - Version information for all installed tools
- `flutter_doctor.txt` - Complete Flutter doctor output
- `setup_instructions.md` - Step-by-step setup instructions
- `troubleshooting.md` - Common issues and solutions

## Quick Setup

1. Source the environment variables:
   ```bash
   source environment_variables.sh
   ```

2. Verify the setup:
   ```bash
   flutter doctor -v
   ```

## Requirements

- Pop!_OS 22.04 LTS (or compatible Ubuntu-based system)
- Git, Curl, Unzip, Zip utilities
- OpenJDK 17
- Android SDK with platform-tools and build-tools
- Chrome browser for web development

## Project Structure

```
flutter_projects/
└── flutter_hello_world/          # Test application
    ├── android/                   # Android-specific code
    ├── lib/                       # Flutter/Dart source code
    ├── web/                       # Web-specific code
    └── build/                     # Build outputs
        ├── app/outputs/flutter-apk/app-release.apk    # Release APK
        └── app/outputs/bundle/release/app-release.aab  # App Bundle
```

## Build Commands

### Development
```bash
# Run on connected Android device
flutter run -d android

# Run in Chrome browser
flutter run -d chrome

# Hot reload (during development)
# Press 'r' in the terminal while flutter run is active
```

### Production Builds
```bash
# Build release APK
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle --release
```

## Device Testing

### Android Device
1. Enable Developer Options on your Android device
2. Enable USB Debugging
3. Connect device via USB
4. Run: `flutter devices` to verify detection
5. Run: `flutter run -d android` to deploy and test

### Web Browser
1. Run: `flutter run -d chrome`
2. App will open automatically in Chrome
3. Test functionality in browser developer tools

## Security Notes

- Keep your keystore file secure: `~/.android/release-key.jks`
- Backup your keystore - it cannot be recovered if lost
- Never commit keystore files or passwords to version control

## Support

For issues and troubleshooting, see `troubleshooting.md` or refer to:
- Flutter documentation: https://docs.flutter.dev/
- Android developer documentation: https://developer.android.com/
