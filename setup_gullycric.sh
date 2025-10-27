#!/bin/bash

# GullyCric Flutter Startup Project Setup Script
# This script creates a complete Flutter-based cricket application structure

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

log_header() {
    echo -e "${CYAN}================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}================================${NC}"
}

# Configuration
PROJECT_NAME="gullycric"
FLUTTER_VERSION="3.24.3"

# Function to check prerequisites
check_prerequisites() {
    log_step "Checking prerequisites..."
    
    # Check if Flutter is installed
    if ! command -v flutter >/dev/null 2>&1; then
        log_error "Flutter is not installed or not in PATH"
        log_info "Please install Flutter first: https://docs.flutter.dev/get-started/install"
        exit 1
    fi
    
    # Check Flutter version
    local flutter_version=$(flutter --version | head -n1 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -n1)
    log_success "Flutter $flutter_version detected"
    
    # Check if Git is installed
    if ! command -v git >/dev/null 2>&1; then
        log_error "Git is not installed"
        log_info "Please install Git: sudo apt install git"
        exit 1
    fi
    
    log_success "All prerequisites met"
}

# Function to create project structure
create_project_structure() {
    log_step "Creating project structure..."
    
    # Check if project directory already exists
    if [[ -d "$PROJECT_NAME" ]]; then
        log_warning "Directory '$PROJECT_NAME' already exists"
        read -p "Do you want to remove it and continue? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$PROJECT_NAME"
            log_info "Removed existing directory"
        else
            log_error "Setup cancelled"
            exit 1
        fi
    fi
    
    # Create root directory
    mkdir -p "$PROJECT_NAME"
    cd "$PROJECT_NAME"
    
    # Create directory structure
    log_info "Creating directory structure..."
    
    # Frontend structure
    mkdir -p frontend/lib/{core,models,services,views,widgets,state}
    mkdir -p frontend/assets/{images,icons,fonts}
    
    # Backend structure
    mkdir -p backend/{functions,config,models,routes}
    
    # Documentation structure
    mkdir -p docs/ui_mockups
    
    # GitHub workflows
    mkdir -p .github/workflows
    
    log_success "Project structure created"
}

# Function to initialize Git repository
initialize_git() {
    log_step "Initializing Git repository..."
    
    git init
    
    # Set default branch to main
    git branch -M main
    
    log_success "Git repository initialized"
}

# Function to create Flutter project
create_flutter_project() {
    log_step "Creating Flutter project..."
    
    cd frontend
    
    # Create Flutter project
    log_info "Running flutter create..."
    flutter create . --project-name gullycric --org com.gullycric.app
    
    # Remove default test folder (we'll add later)
    if [[ -d "test" ]]; then
        rm -rf test
        log_info "Removed default test folder"
    fi
    
    cd ..
    log_success "Flutter project created"
}

# Function to configure pubspec.yaml
configure_pubspec() {
    log_step "Configuring pubspec.yaml with required dependencies..."
    
    local pubspec_file="frontend/pubspec.yaml"
    
    # Backup original pubspec.yaml
    cp "$pubspec_file" "$pubspec_file.backup"
    
    # Create new pubspec.yaml with required dependencies
    cat > "$pubspec_file" << EOF
name: gullycric
description: "A modern cricket app focused on local cricket, player stats, and live matches."
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.1.0 <4.0.0'
  flutter: ">=3.13.0"

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  
  # HTTP & API
  http: ^1.1.0
  
  # Environment Variables
  flutter_dotenv: ^5.1.0
  
  # UI & Fonts
  google_fonts: ^6.1.0
  
  # Image Handling
  cached_network_image: ^3.3.0
  
  # Icons
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
    - assets/fonts/
    - .env

  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
EOF
    
    log_success "pubspec.yaml configured with required dependencies"
}

# Function to create .gitignore
create_gitignore() {
    log_step "Creating .gitignore..."
    
    cat > .gitignore << 'EOF'
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# The .vscode folder contains launch configuration and tasks you configure in
# VS Code which you may wish to be included in version control, so this line
# is commented out by default.
#.vscode/

# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Android Studio will place build artifacts here
/android/app/debug
/android/app/profile
/android/app/release

# Environment variables
.env
.env.local
.env.production

# Firebase
firebase_options.dart

# Keystore files
*.jks
*.keystore

# iOS
**/ios/**/*.mode1v3
**/ios/**/*.mode2v3
**/ios/**/*.moved-aside
**/ios/**/*.pbxuser
**/ios/**/*.perspectivev3
**/ios/**/UserInterfaceState.xcuserstate
**/ios/.generated/
**/ios/Flutter/App.framework
**/ios/Flutter/Flutter.framework
**/ios/Flutter/Flutter.podspec
**/ios/Flutter/Generated.xcconfig
**/ios/Flutter/ephemeral/
**/ios/Flutter/app.flx
**/ios/Flutter/app.zip
**/ios/Flutter/flutter_assets/
**/ios/ServiceDefinitions.json
**/ios/Runner/GeneratedPluginRegistrant.*

# Web
lib/generated_plugin_registrant.dart

# Coverage
coverage/

# Exceptions to above rules
!/packages/flutter_tools/test/data/dart_dependencies_test/**/.packages
EOF
    
    log_success ".gitignore created"
}

# Function to create GitHub workflow
create_github_workflow() {
    log_step "Creating GitHub workflow..."
    
    cat > .github/workflows/flutter_build.yml << EOF
name: Flutter CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '$FLUTTER_VERSION'
        channel: 'stable'
        
    - name: Get dependencies
      run: |
        cd frontend
        flutter pub get
        
    - name: Analyze code
      run: |
        cd frontend
        flutter analyze
        
    - name: Run tests
      run: |
        cd frontend
        flutter test
        
    - name: Build APK
      run: |
        cd frontend
        flutter build apk --debug
        
    - name: Upload APK artifact
      uses: actions/upload-artifact@v3
      with:
        name: debug-apk
        path: frontend/build/app/outputs/flutter-apk/app-debug.apk
EOF
    
    log_success "GitHub workflow created"
}

# Function to create documentation files
create_documentation() {
    log_step "Creating documentation files..."
    
    # Create README.md
    cat > README.md << 'EOF'
# GullyCric 🏏

A modern cricket app focused on local cricket, player stats, and live matches.

## 🌟 Features

- **Live Scores**: Real-time match updates and scorecards
- **Local Cricket**: Organize and manage local cricket games
- **Player Stats**: Track individual and team performance
- **Match Cards**: Beautiful, detailed match information
- **Community**: Connect with cricket lovers in your area
- **South Asian Focus**: Designed specifically for South Asian cricket culture

## 🚀 Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (MVP) / Node.js (Future)
- **Database**: Firestore / PostgreSQL
- **APIs**: Cricket data APIs
- **State Management**: Provider
- **CI/CD**: GitHub Actions

## 📱 Screenshots

*Coming soon...*

## 🛠️ Getting Started

### Prerequisites

- Flutter SDK (>=3.13.0)
- Dart SDK (>=3.1.0)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/SanoKhan22/GullyCric.git
   cd GullyCric
   ```

2. **Install dependencies**
   ```bash
   cd frontend
   flutter pub get
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your API keys
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
gullycric/
├── frontend/                 # Flutter mobile app
│   ├── lib/
│   │   ├── core/            # Core utilities, constants
│   │   ├── models/          # Data models
│   │   ├── services/        # API services, repositories
│   │   ├── views/           # UI screens
│   │   ├── widgets/         # Reusable UI components
│   │   └── state/           # State management
│   └── assets/              # Images, fonts, icons
├── backend/                 # Backend services
├── docs/                    # Documentation
└── .github/workflows/       # CI/CD pipelines
```

## 🎯 MVP Roadmap

- [ ] **Phase 1**: Basic UI and navigation
- [ ] **Phase 2**: Live scores integration
- [ ] **Phase 3**: User authentication
- [ ] **Phase 4**: Local match creation
- [ ] **Phase 5**: Player statistics
- [ ] **Phase 6**: Community features

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Cricket data provided by various cricket APIs
- Icons and illustrations from the Flutter community
- Inspiration from the vibrant South Asian cricket culture

---

**Made with ❤️ for cricket lovers everywhere**
EOF
    
    # Create CONTRIBUTING.md
    cat > CONTRIBUTING.md << 'EOF'
# Contributing to GullyCric 🏏

Thank you for your interest in contributing to GullyCric! This document provides guidelines and information for contributors.

## 🚀 Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/GullyCric.git`
3. Create a feature branch: `git checkout -b feature/amazing-feature`
4. Make your changes
5. Commit your changes: `git commit -m 'feat: add amazing feature'`
6. Push to the branch: `git push origin feature/amazing-feature`
7. Open a Pull Request

## 📝 Commit Convention

We use [Conventional Commits](https://www.conventionalcommits.org/) for clear and consistent commit messages:

### Format
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types
- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to the build process or auxiliary tools

### Examples
```bash
feat: add live score widget
fix: resolve match card loading issue
docs: update API documentation
style: format code according to style guide
refactor: simplify authentication logic
perf: optimize image loading performance
test: add unit tests for match service
chore: update dependencies
```

## 🏗️ Development Guidelines

### Code Style
- Follow Dart/Flutter style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Flutter Specific
- Use `const` constructors where possible
- Implement proper error handling
- Follow Material Design principles
- Ensure responsive design for different screen sizes

### Testing
- Write unit tests for business logic
- Add widget tests for UI components
- Ensure all tests pass before submitting PR

## 📁 Project Structure Guidelines

```
frontend/lib/
├── core/
│   ├── constants/          # App constants
│   ├── utils/             # Utility functions
│   ├── theme/             # App theme and styling
│   └── config/            # Configuration files
├── models/
│   ├── match.dart         # Match data model
│   ├── player.dart        # Player data model
│   └── team.dart          # Team data model
├── services/
│   ├── api/               # API service classes
│   ├── auth/              # Authentication services
│   └── storage/           # Local storage services
├── views/
│   ├── home/              # Home screen
│   ├── matches/           # Match-related screens
│   ├── profile/           # User profile screens
│   └── auth/              # Authentication screens
├── widgets/
│   ├── common/            # Common reusable widgets
│   ├── match/             # Match-specific widgets
│   └── player/            # Player-specific widgets
└── state/
    ├── providers/         # Provider classes
    └── models/            # State models
```

## 🐛 Bug Reports

When filing a bug report, please include:

1. **Description**: Clear description of the issue
2. **Steps to Reproduce**: Step-by-step instructions
3. **Expected Behavior**: What should happen
4. **Actual Behavior**: What actually happens
5. **Screenshots**: If applicable
6. **Environment**: Device, OS version, Flutter version

## 💡 Feature Requests

For feature requests, please provide:

1. **Problem Statement**: What problem does this solve?
2. **Proposed Solution**: How should it work?
3. **Alternatives**: Any alternative solutions considered?
4. **Additional Context**: Screenshots, mockups, etc.

## 📋 Pull Request Guidelines

### Before Submitting
- [ ] Code follows the style guidelines
- [ ] Self-review of the code completed
- [ ] Comments added for hard-to-understand areas
- [ ] Tests added/updated for changes
- [ ] Documentation updated if needed
- [ ] No breaking changes (or clearly documented)

### PR Description Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Widget tests pass
- [ ] Manual testing completed

## Screenshots (if applicable)
Add screenshots here

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Tests added/updated
- [ ] Documentation updated
```

## 🎯 Areas for Contribution

We especially welcome contributions in:

- **UI/UX Improvements**: Better designs and user experience
- **Performance Optimization**: Making the app faster and more efficient
- **Testing**: Adding comprehensive test coverage
- **Documentation**: Improving docs and code comments
- **Accessibility**: Making the app accessible to all users
- **Internationalization**: Adding support for multiple languages

## 🤝 Code of Conduct

Please note that this project is released with a [Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## 📞 Getting Help

- **Discord**: Join our community server (link coming soon)
- **Issues**: Create an issue for bugs or feature requests
- **Discussions**: Use GitHub Discussions for questions

Thank you for contributing to GullyCric! 🏏❤️
EOF
    
    # Create MVP Plan
    cat > docs/mvp_plan.md << 'EOF'
# GullyCric MVP Plan 🏏

## 🎯 Vision
Create a modern, user-friendly cricket app that focuses on local cricket communities, live scores, and player statistics with a special emphasis on South Asian cricket culture.

## 📱 MVP Features

### Phase 1: Core Foundation (Week 1-2)
- [ ] **App Setup & Navigation**
  - Bottom navigation with 4 main tabs
  - Splash screen with GullyCric branding
  - Basic app theme and styling
  - Responsive design for different screen sizes

- [ ] **Home Screen**
  - Featured matches carousel
  - Quick access to live matches
  - Recent match results
  - Cricket news feed (placeholder)

### Phase 2: Live Scores (Week 3-4)
- [ ] **Live Match Integration**
  - Connect to cricket API (CricAPI or similar)
  - Real-time score updates
  - Match details (teams, players, venue)
  - Ball-by-ball commentary
  - Match statistics

- [ ] **Match Cards**
  - Beautiful match card design
  - Team logos and colors
  - Score progression
  - Match status indicators

### Phase 3: User System (Week 5-6)
- [ ] **Authentication**
  - Email/password signup/login
  - Google Sign-In integration
  - User profile creation
  - Profile picture upload

- [ ] **User Profiles**
  - Personal information
  - Favorite teams
  - Match history
  - Statistics dashboard

### Phase 4: Local Cricket (Week 7-8)
- [ ] **Create Local Matches**
  - Match creation form
  - Team selection
  - Venue information
  - Date and time scheduling
  - Match format selection (T20, ODI, Test)

- [ ] **Match Management**
  - Score tracking interface
  - Player performance input
  - Match result recording
  - Photo uploads

### Phase 5: Statistics & Analytics (Week 9-10)
- [ ] **Player Statistics**
  - Batting averages
  - Bowling figures
  - Fielding statistics
  - Performance graphs
  - Career highlights

- [ ] **Team Analytics**
  - Team performance metrics
  - Win/loss ratios
  - Player contributions
  - Season summaries

### Phase 6: Community Features (Week 11-12)
- [ ] **Social Features**
  - Follow other players
  - Match comments and reactions
  - Share match highlights
  - Player ratings and reviews

- [ ] **Notifications**
  - Match start reminders
  - Score update notifications
  - Friend activity updates
  - Tournament announcements

## 🛠️ Technical Architecture

### Frontend (Flutter)
```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── api_endpoints.dart
│   │   └── colors.dart
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── validators.dart
│   │   └── helpers.dart
│   └── theme/
│       ├── app_theme.dart
│       └── text_styles.dart
├── models/
│   ├── match.dart
│   ├── team.dart
│   ├── player.dart
│   └── user.dart
├── services/
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── storage_service.dart
│   └── notification_service.dart
├── views/
│   ├── home/
│   ├── matches/
│   ├── profile/
│   └── auth/
├── widgets/
│   ├── common/
│   ├── match_cards/
│   └── forms/
└── state/
    ├── auth_provider.dart
    ├── match_provider.dart
    └── user_provider.dart
```

### Backend (Firebase MVP)
- **Authentication**: Firebase Auth
- **Database**: Firestore
- **Storage**: Firebase Storage
- **Functions**: Cloud Functions
- **Hosting**: Firebase Hosting

### External APIs
- **Cricket Data**: CricAPI, ESPN Cricinfo API
- **Maps**: Google Maps API (for venues)
- **Weather**: OpenWeatherMap API

## 📊 Success Metrics

### User Engagement
- Daily Active Users (DAU)
- Session duration
- Match views per user
- User retention rate

### Feature Usage
- Live score views
- Local matches created
- User profiles completed
- Social interactions

### Technical Metrics
- App crash rate < 1%
- API response time < 2s
- App load time < 3s
- User satisfaction > 4.0/5.0

## 🎨 Design Guidelines

### Color Scheme
- **Primary**: Cricket Green (#2E7D32)
- **Secondary**: Cricket Ball Red (#D32F2F)
- **Accent**: Golden Yellow (#FFC107)
- **Background**: Clean White (#FFFFFF)
- **Text**: Dark Gray (#212121)

### Typography
- **Primary Font**: Poppins
- **Secondary Font**: Roboto
- **Headers**: Bold, large sizes
- **Body**: Regular, readable sizes

### UI Principles
- **Clean & Modern**: Minimal clutter
- **Cricket-Themed**: Use cricket imagery and colors
- **Intuitive Navigation**: Easy to understand
- **Responsive**: Works on all screen sizes
- **Accessible**: Follows accessibility guidelines

## 🚀 Launch Strategy

### Pre-Launch (Week 13)
- [ ] Beta testing with cricket enthusiasts
- [ ] Bug fixes and performance optimization
- [ ] App store optimization (ASO)
- [ ] Marketing materials creation

### Launch (Week 14)
- [ ] Google Play Store release
- [ ] Social media announcement
- [ ] Cricket community outreach
- [ ] Influencer partnerships

### Post-Launch (Week 15+)
- [ ] User feedback collection
- [ ] Feature iterations
- [ ] Performance monitoring
- [ ] Community building

## 📈 Future Roadmap

### Version 2.0
- iOS App Store release
- Advanced analytics
- Tournament management
- Video highlights
- Fantasy cricket integration

### Version 3.0
- AI-powered insights
- Coaching modules
- Equipment marketplace
- Professional league integration

## 💰 Monetization Strategy

### Freemium Model
- **Free**: Basic features, limited matches
- **Premium**: Unlimited matches, advanced stats, ad-free

### Revenue Streams
- Premium subscriptions
- In-app advertisements
- Equipment affiliate marketing
- Tournament sponsorships

## 🎯 Target Audience

### Primary
- **Age**: 18-35 years
- **Location**: South Asia (India, Pakistan, Bangladesh, Sri Lanka)
- **Interest**: Cricket enthusiasts, local players
- **Behavior**: Active on social media, mobile-first

### Secondary
- **Age**: 35-50 years
- **Location**: Cricket-loving diaspora worldwide
- **Interest**: Following cricket, nostalgia
- **Behavior**: Casual app users, family-oriented

---

**This MVP plan is a living document and will be updated based on user feedback and market research.**
EOF
    
    # Create API Structure
    cat > docs/api_structure.md << 'EOF'
# GullyCric API Structure 📡

## 🏗️ Architecture Overview

The GullyCric API follows RESTful principles with a microservices architecture approach. For MVP, we'll use Firebase as the backend, but this document outlines the structure for future Node.js/Express implementation.

## 🔗 Base URL
```
Production: https://api.gullycric.com/v1
Development: https://dev-api.gullycric.com/v1
Local: http://localhost:3000/v1
```

## 🔐 Authentication

### JWT Token Structure
```json
{
  "header": {
    "alg": "HS256",
    "typ": "JWT"
  },
  "payload": {
    "userId": "user_123",
    "email": "user@example.com",
    "role": "player",
    "iat": 1640995200,
    "exp": 1641081600
  }
}
```

### Auth Endpoints
```
POST /auth/register
POST /auth/login
POST /auth/logout
POST /auth/refresh
POST /auth/forgot-password
POST /auth/reset-password
GET  /auth/verify-email/:token
```

## 👤 User Management

### User Model
```json
{
  "id": "user_123",
  "email": "player@example.com",
  "username": "cricket_lover",
  "profile": {
    "firstName": "John",
    "lastName": "Doe",
    "avatar": "https://cdn.gullycric.com/avatars/user_123.jpg",
    "dateOfBirth": "1995-06-15",
    "location": {
      "city": "Mumbai",
      "state": "Maharashtra",
      "country": "India"
    },
    "cricketInfo": {
      "playingRole": "All-rounder",
      "battingStyle": "Right-handed",
      "bowlingStyle": "Right-arm medium",
      "favoriteTeam": "Mumbai Indians"
    }
  },
  "stats": {
    "matchesPlayed": 45,
    "totalRuns": 1250,
    "totalWickets": 23,
    "averageScore": 27.8
  },
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-15T10:30:00Z"
}
```

### User Endpoints
```
GET    /users/profile
PUT    /users/profile
GET    /users/:userId
GET    /users/:userId/stats
GET    /users/:userId/matches
POST   /users/upload-avatar
DELETE /users/account
```

## 🏏 Match Management

### Match Model
```json
{
  "id": "match_456",
  "title": "Sunday League Final",
  "type": "local", // local, professional, international
  "format": "T20", // T20, ODI, Test
  "status": "live", // upcoming, live, completed, cancelled
  "teams": {
    "team1": {
      "id": "team_789",
      "name": "Mumbai Warriors",
      "logo": "https://cdn.gullycric.com/logos/team_789.png",
      "players": ["player_1", "player_2", "..."]
    },
    "team2": {
      "id": "team_790",
      "name": "Delhi Fighters",
      "logo": "https://cdn.gullycric.com/logos/team_790.png",
      "players": ["player_3", "player_4", "..."]
    }
  },
  "venue": {
    "name": "Local Cricket Ground",
    "city": "Mumbai",
    "coordinates": {
      "latitude": 19.0760,
      "longitude": 72.8777
    }
  },
  "schedule": {
    "startTime": "2024-01-20T14:00:00Z",
    "endTime": "2024-01-20T18:00:00Z"
  },
  "score": {
    "team1": {
      "runs": 165,
      "wickets": 4,
      "overs": 20.0,
      "runRate": 8.25
    },
    "team2": {
      "runs": 142,
      "wickets": 8,
      "overs": 18.3,
      "runRate": 7.68
    }
  },
  "result": {
    "winner": "team_789",
    "margin": "23 runs",
    "playerOfMatch": "player_5"
  },
  "createdBy": "user_123",
  "createdAt": "2024-01-15T10:00:00Z"
}
```

### Match Endpoints
```
GET    /matches                    # Get all matches with filters
POST   /matches                    # Create new match
GET    /matches/:matchId           # Get match details
PUT    /matches/:matchId           # Update match
DELETE /matches/:matchId           # Delete match
GET    /matches/:matchId/live      # Get live score updates
POST   /matches/:matchId/score     # Update match score
GET    /matches/:matchId/commentary # Get ball-by-ball commentary
POST   /matches/:matchId/commentary # Add commentary
```

### Match Filters
```
GET /matches?status=live
GET /matches?type=local
GET /matches?format=T20
GET /matches?city=Mumbai
GET /matches?date=2024-01-20
GET /matches?team=team_789
```

## 🏆 Team Management

### Team Model
```json
{
  "id": "team_789",
  "name": "Mumbai Warriors",
  "shortName": "MW",
  "logo": "https://cdn.gullycric.com/logos/team_789.png",
  "colors": {
    "primary": "#1976D2",
    "secondary": "#FFC107"
  },
  "captain": "player_1",
  "viceCaptain": "player_2",
  "players": [
    {
      "playerId": "player_1",
      "role": "captain",
      "joinedAt": "2024-01-01T00:00:00Z"
    }
  ],
  "stats": {
    "matchesPlayed": 25,
    "wins": 18,
    "losses": 6,
    "draws": 1,
    "winPercentage": 72.0
  },
  "homeGround": "Local Cricket Ground",
  "createdBy": "user_123",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### Team Endpoints
```
GET    /teams
POST   /teams
GET    /teams/:teamId
PUT    /teams/:teamId
DELETE /teams/:teamId
POST   /teams/:teamId/players
DELETE /teams/:teamId/players/:playerId
GET    /teams/:teamId/matches
GET    /teams/:teamId/stats
```

## 📊 Statistics & Analytics

### Player Statistics
```json
{
  "playerId": "player_1",
  "batting": {
    "matches": 45,
    "innings": 42,
    "runs": 1250,
    "highestScore": 89,
    "average": 29.76,
    "strikeRate": 125.5,
    "centuries": 0,
    "halfCenturies": 8,
    "fours": 145,
    "sixes": 32
  },
  "bowling": {
    "matches": 45,
    "innings": 38,
    "overs": 156.2,
    "wickets": 23,
    "bestFigures": "4/25",
    "average": 18.65,
    "economy": 6.85,
    "strikeRate": 16.3
  },
  "fielding": {
    "catches": 18,
    "runOuts": 5,
    "stumpings": 0
  }
}
```

### Statistics Endpoints
```
GET /stats/players/:playerId
GET /stats/teams/:teamId
GET /stats/matches/:matchId
GET /stats/leaderboard?type=runs&format=T20
GET /stats/compare?players=player_1,player_2
```

## 🔔 Notifications

### Notification Model
```json
{
  "id": "notif_123",
  "userId": "user_123",
  "type": "match_start", // match_start, score_update, match_result
  "title": "Match Starting Soon!",
  "message": "Mumbai Warriors vs Delhi Fighters starts in 30 minutes",
  "data": {
    "matchId": "match_456",
    "action": "view_match"
  },
  "read": false,
  "createdAt": "2024-01-20T13:30:00Z"
}
```

### Notification Endpoints
```
GET    /notifications
POST   /notifications/mark-read/:notificationId
POST   /notifications/mark-all-read
DELETE /notifications/:notificationId
POST   /notifications/subscribe
POST   /notifications/unsubscribe
```

## 🌐 External API Integrations

### Cricket Data APIs
```javascript
// CricAPI Integration
const cricketAPI = {
  baseURL: 'https://cricapi.com/api',
  endpoints: {
    matches: '/matches',
    matchDetails: '/cricketScore',
    playerStats: '/playerStats',
    teamRanking: '/ranking'
  }
}

// ESPN Cricinfo (Alternative)
const espnAPI = {
  baseURL: 'https://hs-consumer-api.espncricinfo.com/v1/pages',
  endpoints: {
    matches: '/matches',
    series: '/series',
    teams: '/teams'
  }
}
```

## 📱 Real-time Features

### WebSocket Events
```javascript
// Client subscribes to match updates
socket.emit('join_match', { matchId: 'match_456' });

// Server sends live updates
socket.emit('score_update', {
  matchId: 'match_456',
  score: { runs: 165, wickets: 4, overs: 20.0 }
});

// Commentary updates
socket.emit('commentary_update', {
  matchId: 'match_456',
  ball: '19.6',
  commentary: 'SIX! What a way to finish the innings!'
});
```

## 🔒 Security & Rate Limiting

### Rate Limits
```
Authentication: 5 requests/minute
General API: 100 requests/minute
Live Score: 10 requests/second
File Upload: 5 requests/minute
```

### Security Headers
```
X-API-Key: Required for all requests
Authorization: Bearer JWT token
Content-Type: application/json
X-Rate-Limit-Remaining: 95
X-Rate-Limit-Reset: 1640995200
```

## 📝 Error Handling

### Standard Error Response
```json
{
  "error": {
    "code": "MATCH_NOT_FOUND",
    "message": "The requested match could not be found",
    "details": {
      "matchId": "invalid_match_id",
      "timestamp": "2024-01-20T10:30:00Z"
    }
  }
}
```

### HTTP Status Codes
```
200 - OK
201 - Created
400 - Bad Request
401 - Unauthorized
403 - Forbidden
404 - Not Found
429 - Too Many Requests
500 - Internal Server Error
```

## 📚 API Documentation

### Swagger/OpenAPI
- Interactive API documentation available at `/docs`
- Postman collection available for download
- SDK generation for multiple languages

### Versioning
- URL versioning: `/v1/`, `/v2/`
- Backward compatibility maintained for at least 2 versions
- Deprecation notices provided 6 months in advance

---

**This API structure is designed to be scalable, maintainable, and developer-friendly.**
EOF
    
    log_success "Documentation files created"
}

# Function to create environment file
create_env_file() {
    log_step "Creating environment configuration..."
    
    cat > .env.example << 'EOF'
# GullyCric Environment Configuration

# Firebase Configuration (MVP Backend)
FIREBASE_API_KEY=your_firebase_api_key_here
FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_STORAGE_BUCKET=your_project.appspot.com
FIREBASE_MESSAGING_SENDER_ID=123456789
FIREBASE_APP_ID=1:123456789:web:abcdef123456

# Cricket Data API
CRICKET_API_KEY=your_cricket_api_key_here
CRICKET_API_BASE_URL=https://cricapi.com/api

# Google Services
GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here

# App Configuration
APP_NAME=GullyCric
APP_VERSION=1.0.0
DEBUG_MODE=true

# Analytics
GOOGLE_ANALYTICS_ID=GA-XXXXXXXXX

# Social Media
FACEBOOK_APP_ID=your_facebook_app_id
TWITTER_API_KEY=your_twitter_api_key

# Push Notifications
FCM_SERVER_KEY=your_fcm_server_key

# Database (Future)
DATABASE_URL=postgresql://username:password@localhost:5432/gullycric
REDIS_URL=redis://localhost:6379

# External Services
WEATHER_API_KEY=your_weather_api_key
NEWS_API_KEY=your_news_api_key
EOF
    
    log_success "Environment configuration created"
}

# Function to install Flutter dependencies
install_dependencies() {
    log_step "Installing Flutter dependencies..."
    
    cd frontend
    
    log_info "Running flutter pub get..."
    flutter pub get
    
    cd ..
    log_success "Flutter dependencies installed"
}

# Function to create initial commit
create_initial_commit() {
    log_step "Creating initial Git commit..."
    
    git add .
    git commit -m "chore: initial GullyCric project setup

- Set up Flutter project structure
- Add required dependencies (provider, http, flutter_dotenv, google_fonts, cached_network_image)
- Create comprehensive documentation (README, CONTRIBUTING, MVP plan, API structure)
- Set up GitHub workflow for CI/CD
- Add environment configuration template
- Initialize project with cricket-focused architecture"
    
    log_success "Initial commit created"
}

# Function to setup GitHub remote (optional)
setup_github_remote() {
    log_step "Setting up GitHub remote..."
    
    local github_url="https://github.com/SanoKhan22/GullyCric.git"
    
    log_info "Adding GitHub remote: $github_url"
    git remote add origin "$github_url"
    
    read -p "Do you want to push to GitHub now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Pushing to GitHub..."
        if git push -u origin main; then
            log_success "Successfully pushed to GitHub!"
            log_info "Repository: $github_url"
        else
            log_warning "Push failed. You may need to authenticate or check repository permissions."
            log_info "You can push later using: git push -u origin main"
        fi
    else
        log_info "Skipping GitHub push. You can push later using: git push -u origin main"
    fi
}

# Function to display final instructions
display_final_instructions() {
    log_header "🎉 GullyCric Setup Complete!"
    
    echo -e "${GREEN}✅ Project initialized successfully!${NC}"
    echo ""
    echo -e "${CYAN}📁 Project Structure:${NC}"
    echo "   gullycric/"
    echo "   ├── frontend/          # Flutter mobile app"
    echo "   ├── backend/           # Backend services (future)"
    echo "   ├── docs/              # Documentation"
    echo "   ├── .github/workflows/ # CI/CD pipelines"
    echo "   └── .env.example       # Environment template"
    echo ""
    echo -e "${CYAN}🚀 Next Steps:${NC}"
    echo "   1. cd $PROJECT_NAME/frontend"
    echo "   2. cp ../.env.example .env"
    echo "   3. Edit .env with your API keys"
    echo "   4. flutter run"
    echo ""
    echo -e "${CYAN}📚 Documentation:${NC}"
    echo "   • README.md           - Project overview"
    echo "   • CONTRIBUTING.md     - Contribution guidelines"
    echo "   • docs/mvp_plan.md    - MVP roadmap"
    echo "   • docs/api_structure.md - API documentation"
    echo ""
    echo -e "${CYAN}🔧 Development Commands:${NC}"
    echo "   • flutter pub get     - Install dependencies"
    echo "   • flutter run         - Run the app"
    echo "   • flutter test        - Run tests"
    echo "   • flutter build apk   - Build APK"
    echo ""
    echo -e "${CYAN}🌐 GitHub Repository:${NC}"
    echo "   https://github.com/SanoKhan22/GullyCric.git"
    echo ""
    echo -e "${GREEN}Happy coding! 🏏❤️${NC}"
}

# Main execution function
main() {
    log_header "🏏 GullyCric Project Setup"
    
    # Check prerequisites
    check_prerequisites
    
    # Create project structure
    create_project_structure
    
    # Initialize Git
    initialize_git
    
    # Create Flutter project
    create_flutter_project
    
    # Configure pubspec.yaml
    configure_pubspec
    
    # Create .gitignore
    create_gitignore
    
    # Create GitHub workflow
    create_github_workflow
    
    # Create documentation
    create_documentation
    
    # Create environment file
    create_env_file
    
    # Install dependencies
    install_dependencies
    
    # Create initial commit
    create_initial_commit
    
    # Setup GitHub remote
    setup_github_remote
    
    # Display final instructions
    display_final_instructions
}

# Run main function
main "$@"