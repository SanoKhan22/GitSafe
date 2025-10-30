# GullyCric Application - Layer Architecture Guide

> **AI Maintenance Prompt**: This documentation should be updated whenever the overall application architecture changes. Monitor modifications to layer structure, dependency relationships, architectural patterns, and cross-cutting concerns. Update this documentation to reflect new layers, architectural decisions, dependency injection changes, and structural modifications. Keep the architecture diagrams, layer responsibilities, and integration patterns current with the actual implementation.

## Overview
Your GullyCric Flutter application follows **Clean Architecture** principles with proper separation of concerns across multiple layers. This guide explains how your application is distributed into layers and best practices for maintaining this architecture.

---

## 🏗️ Current Layer Structure

### 1. **PRESENTATION LAYER** (UI/Framework Layer)
**Location**: `lib/features/*/presentation/`

**Responsibilities**:
- User Interface (Screens, Widgets)
- State Management (Providers, BLoCs)
- User Input Handling
- Navigation Logic

**Current Structure**:
```
lib/features/
├── auth/presentation/
│   ├── screens/          # Login, Signup screens
│   ├── widgets/          # Reusable UI components
│   └── providers/        # State management
├── cricket/presentation/
│   ├── screens/          # Match screens, Score updates
│   ├── widgets/          # Cricket-specific widgets
│   └── providers/        # Cricket state management
└── home/presentation/
    └── screens/          # Home screen
```

**Key Files**:
- `login_screen.dart`, `signup_screen.dart`
- `matches_screen.dart`, `create_match_screen.dart`
- `auth_provider.dart`, `cricket_provider.dart`

---

### 2. **DOMAIN LAYER** (Business Logic Layer)
**Location**: `lib/features/*/domain/`

**Responsibilities**:
- Business Rules & Logic
- Use Cases (Application Services)
- Entity Definitions
- Repository Interfaces

**Current Structure**:
```
lib/features/
├── auth/domain/
│   ├── entities/         # User entity
│   ├── repositories/     # Auth repository interface
│   └── usecases/         # Login, Signup, Password usecases
└── cricket/domain/
    ├── entities/         # Match, Team, Player entities
    ├── repositories/     # Cricket repository interface
    └── usecases/         # Match management usecases
```

**Key Files**:
- `user_entity.dart`, `match_entity.dart`, `team_entity.dart`
- `auth_repository.dart`, `cricket_repository.dart`
- `login_usecase.dart`, `match_usecases.dart`

---

### 3. **DATA LAYER** (Infrastructure Layer)
**Location**: `lib/features/*/data/`

**Responsibilities**:
- Data Sources (API, Local Storage)
- Repository Implementations
- Data Models (JSON Serialization)
- External Service Integration

**Current Structure**:
```
lib/features/
├── auth/data/
│   ├── datasources/      # Remote, Local, Mock data sources
│   ├── models/           # User model with JSON serialization
│   └── repositories/     # Auth repository implementation
└── cricket/data/
    ├── datasources/      # Cricket data sources
    ├── models/           # Match, Team, Player models
    └── repositories/     # Cricket repository implementation
```

**Key Files**:
- `auth_remote_datasource.dart`, `cricket_simple_datasource.dart`
- `user_model.dart`, `match_model.dart`, `team_model.dart`
- `auth_repository_impl.dart`, `cricket_repository_impl.dart`

---

### 4. **CORE LAYER** (Shared Infrastructure)
**Location**: `lib/core/`

**Responsibilities**:
- Shared Utilities & Services
- Dependency Injection
- Network Configuration
- Error Handling
- Common Widgets & Themes

**Current Structure**:
```
lib/core/
├── config/              # API configuration
├── constants/           # App colors, strings, styles
├── di/                  # Dependency injection setup
├── error/               # Error handling & exceptions
├── network/             # HTTP client, API response handling
├── services/            # Mock API services
├── theme/               # App theming
├── usecases/            # Base usecase interface
├── utils/               # Validators, formatters, extensions
└── widgets/             # Reusable UI components
```

---

### 5. **APP LAYER** (Application Configuration)
**Location**: `lib/app/`

**Responsibilities**:
- App-level Configuration
- Routing & Navigation
- Environment Setup
- Global App State

**Current Structure**:
```
lib/app/
├── env/                 # Environment configurations
├── navigation/          # Route guards, bottom navigation
├── app.dart             # Main app widget
├── router.dart          # Route definitions
└── routes.dart          # Route constants
```

---

### 6. **CONFIGURATION LAYER**
**Location**: `lib/config/` & `lib/main_*.dart`

**Responsibilities**:
- Environment-specific configurations
- App initialization
- Flavor management

**Files**:
- `main_development.dart`, `main_staging.dart`, `main_production.dart`
- `app_config.dart`, `flavor_config.dart`, `secure_config.dart`

---

## 🔄 Data Flow Between Layers

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   PRESENTATION  │───▶│     DOMAIN      │───▶│      DATA       │
│                 │    │                 │    │                 │
│ • Screens       │    │ • Use Cases     │    │ • Repositories  │
│ • Widgets       │    │ • Entities      │    │ • Data Sources  │
│ • Providers     │    │ • Repositories  │    │ • Models        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         ▲                       ▲                       ▲
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │      CORE       │
                    │                 │
                    │ • DI Container  │
                    │ • Network       │
                    │ • Utils         │
                    │ • Widgets       │
                    └─────────────────┘
```

**Flow Direction**:
1. **Presentation** → **Domain**: UI calls use cases
2. **Domain** → **Data**: Use cases call repository interfaces
3. **Data** → **External**: Repositories call data sources
4. **Core**: Provides shared services to all layers

---

## 📋 Layer Responsibilities & Rules

### ✅ **PRESENTATION LAYER Rules**
- **CAN** depend on: Domain layer, Core layer
- **CANNOT** depend on: Data layer directly
- **Should**: Handle UI state, user interactions, navigation
- **Should NOT**: Contain business logic, direct API calls

### ✅ **DOMAIN LAYER Rules**
- **CAN** depend on: Nothing (pure business logic)
- **CANNOT** depend on: Presentation, Data, Core layers
- **Should**: Define business rules, entities, use cases
- **Should NOT**: Know about UI, databases, or external services

### ✅ **DATA LAYER Rules**
- **CAN** depend on: Domain layer (interfaces), Core layer
- **CANNOT** depend on: Presentation layer
- **Should**: Implement repository interfaces, handle data persistence
- **Should NOT**: Contain business logic or UI logic

### ✅ **CORE LAYER Rules**
- **CAN** depend on: External packages only
- **CANNOT** depend on: Feature layers
- **Should**: Provide shared utilities, services, configurations
- **Should NOT**: Contain feature-specific logic

---

## 🚀 Optimization Recommendations

### 1. **Enhance Dependency Injection**
Your current DI setup in `lib/core/di/` is good. Consider:

```dart
// Enhanced service locator with feature modules
abstract class DIModule {
  void configure();
}

class AuthModule extends DIModule {
  @override
  void configure() {
    // Register auth-specific dependencies
  }
}

class CricketModule extends DIModule {
  @override
  void configure() {
    // Register cricket-specific dependencies
  }
}
```

### 2. **Add Feature-Level Barrel Exports**
Create index files for cleaner imports:

```dart
// lib/features/auth/auth.dart
export 'domain/domain.dart';
export 'data/data.dart';
export 'presentation/presentation.dart';

// lib/features/cricket/cricket.dart
export 'domain/domain.dart';
export 'data/data.dart';
export 'presentation/presentation.dart';
```

### 3. **Implement Result/Either Pattern**
Enhance error handling across layers:

```dart
// Already using Either<Failure, T> - good!
// Consider adding Result<T> for simpler cases
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final String message;
  const Error(this.message);
}
```

### 4. **Add Layer-Specific Linting Rules**
Create custom lint rules to enforce layer boundaries:

```yaml
# analysis_options.yaml
analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    - no_presentation_in_domain
    - no_data_in_presentation
    - no_business_logic_in_presentation
```

### 5. **Implement Feature Flags**
Add feature toggles for better layer management:

```dart
// lib/core/config/feature_flags.dart
class FeatureFlags {
  static const bool enableNewCricketUI = true;
  static const bool enableAdvancedStats = false;
  static const bool enableOfflineMode = true;
}
```

---

## 🧪 Testing Strategy by Layer

### **Presentation Layer Testing**
- **Widget Tests**: Test UI components
- **Integration Tests**: Test user flows
- **Golden Tests**: Test visual consistency

### **Domain Layer Testing**
- **Unit Tests**: Test use cases and business logic
- **Mock Tests**: Test with mocked repositories

### **Data Layer Testing**
- **Unit Tests**: Test repository implementations
- **Mock Tests**: Test with mocked data sources
- **Integration Tests**: Test with real APIs

---

## 📁 Recommended Project Structure Enhancement

```
lib/
├── app/                 # App-level configuration
├── core/                # Shared infrastructure
├── features/            # Feature modules
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   ├── presentation/
│   │   └── auth.dart    # Barrel export
│   ├── cricket/
│   │   ├── data/
│   │   ├── domain/
│   │   ├── presentation/
│   │   └── cricket.dart # Barrel export
│   └── shared/          # Cross-feature shared code
├── config/              # Environment configurations
└── main_*.dart          # Entry points
```

---

## 🔧 Tools for Layer Management

### **1. Dependency Visualization**
```bash
# Generate dependency graph
flutter packages pub deps --style=tree
```

### **2. Architecture Validation**
```bash
# Use lakos for dependency analysis
dart pub global activate lakos
lakos
```

### **3. Code Generation**
```bash
# Generate models, repositories, etc.
flutter packages pub run build_runner build
```

---

## 📊 Layer Metrics & Health

### **Current Status**:
- ✅ **Clean Architecture**: Well implemented
- ✅ **Separation of Concerns**: Good layer boundaries
- ✅ **Dependency Direction**: Correct (inward dependencies)
- ⚠️ **Test Coverage**: Needs improvement (many test errors)
- ⚠️ **Documentation**: Could be enhanced

### **Improvement Areas**:
1. Fix test compilation errors
2. Add comprehensive unit tests for each layer
3. Implement integration tests
4. Add API documentation
5. Create architecture decision records (ADRs)

---

## 🎯 Next Steps

1. **Fix Current Issues**: Resolve compilation errors in test files
2. **Enhance Testing**: Add proper test coverage for each layer
3. **Add Documentation**: Create ADRs for architectural decisions
4. **Implement CI/CD**: Add automated architecture validation
5. **Performance Monitoring**: Add layer-specific performance metrics

---

**Your application already has excellent layer separation! The main focus should be on fixing the test issues and enhancing the existing architecture rather than restructuring.**