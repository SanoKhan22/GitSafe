import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/logger.dart';
import '../routes.dart';

/// GullyCric Route Guards
/// 
/// Authentication and permission guards for protecting routes
/// with proper redirection and state management
class RouteGuards {
  RouteGuards._();

  /// Check if user is authenticated
  static bool isAuthenticated() {
    // TODO: Implement actual authentication check
    // This will be connected to auth providers later
    return false; // For now, assume not authenticated
  }

  /// Check if user has specific permission
  static bool hasPermission(String permission) {
    // TODO: Implement actual permission check
    // This will be connected to user role/permission system later
    return true; // For now, assume all permissions granted
  }

  /// Get redirect route for unauthenticated users
  static String getAuthRedirectRoute(String intendedRoute) {
    // Store intended route for post-login redirect
    // TODO: Implement proper state management for intended route
    Logger.d('Redirecting unauthenticated user from $intendedRoute to login', tag: 'RouteGuard');
    return AppRoutes.login;
  }

  /// Get redirect route for unauthorized users
  static String getUnauthorizedRedirectRoute() {
    Logger.d('Redirecting unauthorized user to home', tag: 'RouteGuard');
    return AppRoutes.home;
  }

  /// Authentication guard for protected routes
  static String? authGuard(BuildContext context, GoRouterState state) {
    final currentRoute = state.uri.path;
    
    // Check if route requires authentication
    if (!AppRoutes.requiresAuth(currentRoute)) {
      return null; // Allow access to public routes
    }

    // Check authentication status
    if (!isAuthenticated()) {
      Logger.w('Access denied to $currentRoute - user not authenticated', tag: 'RouteGuard');
      return getAuthRedirectRoute(currentRoute);
    }

    return null; // Allow access
  }

  /// Permission guard for role-based access
  static String? permissionGuard(
    BuildContext context, 
    GoRouterState state, 
    String requiredPermission,
  ) {
    final currentRoute = state.uri.path;
    
    // Check if user has required permission
    if (!hasPermission(requiredPermission)) {
      Logger.w('Access denied to $currentRoute - missing permission: $requiredPermission', tag: 'RouteGuard');
      return getUnauthorizedRedirectRoute();
    }

    return null; // Allow access
  }

  /// Admin guard for admin-only routes
  static String? adminGuard(BuildContext context, GoRouterState state) {
    return permissionGuard(context, state, 'admin');
  }

  /// Moderator guard for moderator routes
  static String? moderatorGuard(BuildContext context, GoRouterState state) {
    return permissionGuard(context, state, 'moderator');
  }

  /// Premium user guard for premium features
  static String? premiumGuard(BuildContext context, GoRouterState state) {
    return permissionGuard(context, state, 'premium');
  }

  /// Guest guard - redirect authenticated users away from auth pages
  static String? guestGuard(BuildContext context, GoRouterState state) {
    final currentRoute = state.uri.path;
    
    // If user is authenticated and trying to access auth pages, redirect to home
    if (isAuthenticated() && _isAuthRoute(currentRoute)) {
      Logger.d('Redirecting authenticated user from $currentRoute to home', tag: 'RouteGuard');
      return AppRoutes.home;
    }

    return null; // Allow access
  }

  /// Check if route is an authentication route
  static bool _isAuthRoute(String route) {
    const authRoutes = [
      AppRoutes.login,
      AppRoutes.signup,
      AppRoutes.forgotPassword,
      AppRoutes.resetPassword,
    ];
    
    return authRoutes.contains(route);
  }

  /// Onboarding guard - redirect completed users
  static String? onboardingGuard(BuildContext context, GoRouterState state) {
    // TODO: Check if user has completed onboarding
    final hasCompletedOnboarding = true; // Placeholder
    
    if (hasCompletedOnboarding && state.uri.path == AppRoutes.onboarding) {
      Logger.d('Redirecting user who completed onboarding to home', tag: 'RouteGuard');
      return AppRoutes.home;
    }

    return null; // Allow access
  }

  /// Feature flag guard for experimental features
  static String? featureFlagGuard(
    BuildContext context, 
    GoRouterState state, 
    String featureFlag,
  ) {
    // TODO: Implement feature flag checking
    final isFeatureEnabled = true; // Placeholder
    
    if (!isFeatureEnabled) {
      Logger.w('Access denied to ${state.uri.path} - feature flag $featureFlag disabled', tag: 'RouteGuard');
      return AppRoutes.home;
    }

    return null; // Allow access
  }

  /// Network guard for routes requiring internet
  static String? networkGuard(BuildContext context, GoRouterState state) {
    // TODO: Check network connectivity
    final hasNetwork = true; // Placeholder
    
    if (!hasNetwork && _requiresNetwork(state.uri.path)) {
      Logger.w('Access denied to ${state.uri.path} - no network connection', tag: 'RouteGuard');
      // Could show offline page instead
      return AppRoutes.home;
    }

    return null; // Allow access
  }

  /// Check if route requires network connection
  static bool _requiresNetwork(String route) {
    const networkRoutes = [
      AppRoutes.liveMatches,
      AppRoutes.news,
      AppRoutes.feed,
    ];
    
    return networkRoutes.any((networkRoute) => route.startsWith(networkRoute));
  }

  /// Combine multiple guards
  static String? combineGuards(
    BuildContext context,
    GoRouterState state,
    List<String? Function(BuildContext, GoRouterState)> guards,
  ) {
    for (final guard in guards) {
      final redirect = guard(context, state);
      if (redirect != null) {
        return redirect; // Return first redirect found
      }
    }
    return null; // All guards passed
  }

  /// Common guard combinations
  static String? protectedRouteGuard(BuildContext context, GoRouterState state) {
    return combineGuards(context, state, [
      authGuard,
      networkGuard,
    ]);
  }

  static String? adminRouteGuard(BuildContext context, GoRouterState state) {
    return combineGuards(context, state, [
      authGuard,
      adminGuard,
      networkGuard,
    ]);
  }

  static String? premiumRouteGuard(BuildContext context, GoRouterState state) {
    return combineGuards(context, state, [
      authGuard,
      premiumGuard,
      networkGuard,
    ]);
  }

  static String? guestOnlyGuard(BuildContext context, GoRouterState state) {
    return combineGuards(context, state, [
      guestGuard,
      onboardingGuard,
    ]);
  }
}

/// Route guard middleware for specific permissions
class PermissionGuard {
  final String permission;
  final String? redirectRoute;

  const PermissionGuard({
    required this.permission,
    this.redirectRoute,
  });

  String? call(BuildContext context, GoRouterState state) {
    if (!RouteGuards.hasPermission(permission)) {
      Logger.w(
        'Access denied to ${state.uri.path} - missing permission: $permission',
        tag: 'PermissionGuard',
      );
      return redirectRoute ?? RouteGuards.getUnauthorizedRedirectRoute();
    }
    return null;
  }
}

/// Route guard for cricket-specific permissions
class CricketPermissionGuards {
  CricketPermissionGuards._();

  /// Guard for match management permissions
  static String? matchManagementGuard(BuildContext context, GoRouterState state) {
    return PermissionGuard(permission: 'manage_matches').call(context, state);
  }

  /// Guard for team management permissions
  static String? teamManagementGuard(BuildContext context, GoRouterState state) {
    return PermissionGuard(permission: 'manage_teams').call(context, state);
  }

  /// Guard for player management permissions
  static String? playerManagementGuard(BuildContext context, GoRouterState state) {
    return PermissionGuard(permission: 'manage_players').call(context, state);
  }

  /// Guard for tournament management permissions
  static String? tournamentManagementGuard(BuildContext context, GoRouterState state) {
    return PermissionGuard(permission: 'manage_tournaments').call(context, state);
  }

  /// Guard for score update permissions
  static String? scoreUpdateGuard(BuildContext context, GoRouterState state) {
    return PermissionGuard(permission: 'update_scores').call(context, state);
  }

  /// Guard for content moderation permissions
  static String? moderationGuard(BuildContext context, GoRouterState state) {
    return PermissionGuard(permission: 'moderate_content').call(context, state);
  }
}

/// Route guard utilities
class RouteGuardUtils {
  RouteGuardUtils._();

  /// Log route access attempt
  static void logRouteAccess(String route, bool allowed, String? reason) {
    if (allowed) {
      Logger.d('Route access granted: $route', tag: 'RouteGuard');
    } else {
      Logger.w('Route access denied: $route - Reason: ${reason ?? "Unknown"}', tag: 'RouteGuard');
    }
  }

  /// Get user-friendly error message for route access denial
  static String getAccessDeniedMessage(String route, String? reason) {
    switch (reason) {
      case 'authentication':
        return 'Please log in to access this feature.';
      case 'permission':
        return 'You don\'t have permission to access this feature.';
      case 'network':
        return 'This feature requires an internet connection.';
      case 'premium':
        return 'This is a premium feature. Please upgrade your account.';
      case 'maintenance':
        return 'This feature is temporarily unavailable for maintenance.';
      default:
        return 'Access to this feature is currently restricted.';
    }
  }

  /// Show access denied dialog
  static void showAccessDeniedDialog(
    BuildContext context, 
    String route, 
    String? reason,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Access Denied'),
        content: Text(getAccessDeniedMessage(route, reason)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          if (reason == 'authentication')
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go(AppRoutes.login);
              },
              child: const Text('Login'),
            ),
        ],
      ),
    );
  }

  /// Check if route should be cached for offline access
  static bool shouldCacheRoute(String route) {
    const cacheableRoutes = [
      AppRoutes.profile,
      AppRoutes.settings,
      AppRoutes.help,
    ];
    
    return cacheableRoutes.any((cacheableRoute) => route.startsWith(cacheableRoute));
  }

  /// Get route priority for preloading
  static int getRoutePriority(String route) {
    // Higher numbers = higher priority
    if (route.startsWith(AppRoutes.home)) return 10;
    if (route.startsWith(AppRoutes.localCricket)) return 9;
    if (route.startsWith(AppRoutes.liveMatches)) return 8;
    if (route.startsWith(AppRoutes.profile)) return 7;
    if (route.startsWith(AppRoutes.news)) return 6;
    return 1; // Default priority
  }
}

/// Route guard configuration
class RouteGuardConfig {
  final bool requiresAuth;
  final List<String> requiredPermissions;
  final bool requiresNetwork;
  final bool requiresPremium;
  final String? featureFlag;
  final String? customRedirect;

  const RouteGuardConfig({
    this.requiresAuth = false,
    this.requiredPermissions = const [],
    this.requiresNetwork = false,
    this.requiresPremium = false,
    this.featureFlag,
    this.customRedirect,
  });

  /// Apply all configured guards
  String? applyGuards(BuildContext context, GoRouterState state) {
    final guards = <String? Function(BuildContext, GoRouterState)>[];

    if (requiresAuth) {
      guards.add(RouteGuards.authGuard);
    }

    for (final permission in requiredPermissions) {
      guards.add((context, state) => 
          RouteGuards.permissionGuard(context, state, permission));
    }

    if (requiresNetwork) {
      guards.add(RouteGuards.networkGuard);
    }

    if (requiresPremium) {
      guards.add(RouteGuards.premiumGuard);
    }

    if (featureFlag != null) {
      guards.add((context, state) => 
          RouteGuards.featureFlagGuard(context, state, featureFlag!));
    }

    final redirect = RouteGuards.combineGuards(context, state, guards);
    return redirect ?? customRedirect;
  }
}