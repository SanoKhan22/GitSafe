import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/error_view.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/signup_screen.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/home/presentation/screens/home_screen.dart';
import 'routes.dart';

/// Simple Auth-aware Router for GullyCric
/// 
/// Handles authentication routing with redirect logic
class AuthRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.login,
      redirect: (context, state) {
        final isAuthenticated = ref.read(isAuthenticatedProvider);
        final isLoggingIn = state.fullPath == AppRoutes.login;
        final isSigningUp = state.fullPath == AppRoutes.signup;

        // If not authenticated and not on auth pages, redirect to login
        if (!isAuthenticated && !isLoggingIn && !isSigningUp) {
          return AppRoutes.login;
        }

        // If authenticated and on auth pages, redirect to home
        if (isAuthenticated && (isLoggingIn || isSigningUp)) {
          return AppRoutes.home;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.signup,
          name: 'signup',
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
      errorBuilder: (context, state) => ErrorView.notFound(
        message: 'Page not found: ${state.fullPath}',
        onAction: () => context.go(AppRoutes.login),
      ),
    );
  }
}