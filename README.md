# GullyCric - Cricket Game Development Project

A Flutter-based cricket game development project with integrated Git workflow management using GitSafe.

## Features

- **Cricket Game Development**: Flutter-based mobile cricket game
- **GitSafe Integration**: Safe Git branch operations with intelligent conflict resolution
- **Flutter Development Environment**: Complete setup scripts for Flutter development
- **Phone Testing**: Easy deployment to Android devices for testing
- **Automated Workflows**: Streamlined development and deployment processes

## Quick Start

### 1. Run GitSafe for branch management:
```bash
./gitsafe.sh
```

### 2. Set up Flutter environment:
```bash
cd flutter_setup
./setup_flutter_environment.sh
```

### 3. Run Flutter app on your phone:
```bash
./run_on_phone.sh
```

## Project Structure

- `gitsafe.sh` - Git branch management script
- `flutter_setup/` - Flutter environment setup scripts
- `flutter_projects/` - Flutter application projects
- `run_on_phone.sh` - Quick script to deploy to Android device
- `push_to_github.sh` - GitHub integration script

## Requirements

- Git
- Flutter SDK (for mobile development)
- Android SDK (for Android deployment)
- USB debugging enabled on Android device

## Configuration

GitSafe creates configuration files in `~/.config/gitsafe/` for personalized Git workflow settings.

## Version

Current version: 1.0.0