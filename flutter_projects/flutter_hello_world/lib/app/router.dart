import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/utils/logger.dart';
import '../core/widgets/error_view.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/signup_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import 'routes.dart';
import 'navigation/route_guards.dart';
import 'navigation/bottom_navigation.dart';

/// GullyCric App Router Configuration
/// 
/// GoRouter setup with route definitions, navigation guards,
/// and error handling for the cricket app
class AppRouter {
  AppRouter._(); // Private constructor

  /// Main router configuration
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    
    // Error handling
    errorBuilder: (context, state) {
      Logger.e('Navigation error: ${state.error}', tag: 'Router');
      return ErrorView.notFound(
        title: 'Page Not Found',
        message: 'The page you\'re looking for doesn\'t exist.',
        actionText: 'Go Home',
        onAction: () => context.go(AppRoutes.home),
        isFullScreen: true,
      );
    },

    // Route definitions
    routes: [
      // Splash and Onboarding
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Authentication Routes (with guest guard)
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
        redirect: RouteGuards.guestOnlyGuard,
      ),

      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
        redirect: RouteGuards.guestOnlyGuard,
      ),

      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
        redirect: RouteGuards.guestOnlyGuard,
      ),

      // Main App Shell with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) {
          return NavigationShell(
            currentRoute: state.uri.path,
            child: child,
          );
        },
        routes: [
          // Home Tab
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),

          // Local Cricket Tab
          GoRoute(
            path: AppRoutes.localCricket,
            name: 'local-cricket',
            builder: (context, state) => const LocalCricketScreen(),
            routes: [
              GoRoute(
                path: 'create-match',
                name: 'create-match',
                builder: (context, state) => const CreateMatchScreen(),
              ),
              GoRoute(
                path: 'match/:matchId',
                name: 'match-details',
                builder: (context, state) {
                  final matchId = state.pathParameters['matchId']!;
                  return MatchDetailsScreen(matchId: matchId);
                },
                routes: [
                  GoRoute(
                    path: 'score',
                    name: 'score-update',
                    builder: (context, state) {
                      final matchId = state.pathParameters['matchId']!;
                      return ScoreUpdateScreen(matchId: matchId);
                    },
                  ),
                  GoRoute(
                    path: 'commentary',
                    name: 'match-commentary',
                    builder: (context, state) {
                      final matchId = state.pathParameters['matchId']!;
                      return MatchCommentaryScreen(matchId: matchId);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Live Matches Tab
          GoRoute(
            path: AppRoutes.liveMatches,
            name: 'live-matches',
            builder: (context, state) => const LiveMatchesScreen(),
            routes: [
              GoRoute(
                path: 'match/:matchId',
                name: 'live-match-details',
                builder: (context, state) {
                  final matchId = state.pathParameters['matchId']!;
                  return LiveMatchDetailsScreen(matchId: matchId);
                },
              ),
            ],
          ),

          // Profile Tab
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'edit-profile',
                builder: (context, state) => const EditProfileScreen(),
              ),
              GoRoute(
                path: 'stats',
                name: 'profile-stats',
                builder: (context, state) => const ProfileStatsScreen(),
              ),
              GoRoute(
                path: 'achievements',
                name: 'achievements',
                builder: (context, state) => const AchievementsScreen(),
              ),
            ],
          ),
        ],
      ),

      // Teams Management
      GoRoute(
        path: AppRoutes.teams,
        name: 'teams',
        builder: (context, state) => const TeamsScreen(),
        routes: [
          GoRoute(
            path: 'create',
            name: 'create-team',
            builder: (context, state) => const CreateTeamScreen(),
          ),
          GoRoute(
            path: ':teamId',
            name: 'team-details',
            builder: (context, state) {
              final teamId = state.pathParameters['teamId']!;
              return TeamDetailsScreen(teamId: teamId);
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: 'edit-team',
                builder: (context, state) {
                  final teamId = state.pathParameters['teamId']!;
                  return EditTeamScreen(teamId: teamId);
                },
              ),
              GoRoute(
                path: 'players',
                name: 'team-players',
                builder: (context, state) {
                  final teamId = state.pathParameters['teamId']!;
                  return TeamPlayersScreen(teamId: teamId);
                },
              ),
            ],
          ),
        ],
      ),

      // Players Management
      GoRoute(
        path: AppRoutes.players,
        name: 'players',
        builder: (context, state) => const PlayersScreen(),
        routes: [
          GoRoute(
            path: 'create',
            name: 'create-player',
            builder: (context, state) => const CreatePlayerScreen(),
          ),
          GoRoute(
            path: ':playerId',
            name: 'player-details',
            builder: (context, state) {
              final playerId = state.pathParameters['playerId']!;
              return PlayerDetailsScreen(playerId: playerId);
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: 'edit-player',
                builder: (context, state) {
                  final playerId = state.pathParameters['playerId']!;
                  return EditPlayerScreen(playerId: playerId);
                },
              ),
              GoRoute(
                path: 'stats',
                name: 'player-stats',
                builder: (context, state) {
                  final playerId = state.pathParameters['playerId']!;
                  return PlayerStatsScreen(playerId: playerId);
                },
              ),
            ],
          ),
        ],
      ),

      // News
      GoRoute(
        path: AppRoutes.news,
        name: 'news',
        builder: (context, state) => const NewsScreen(),
        routes: [
          GoRoute(
            path: ':newsId',
            name: 'news-details',
            builder: (context, state) {
              final newsId = state.pathParameters['newsId']!;
              return NewsDetailsScreen(newsId: newsId);
            },
          ),
          GoRoute(
            path: 'category/:category',
            name: 'news-category',
            builder: (context, state) {
              final category = state.pathParameters['category']!;
              return NewsCategoryScreen(category: category);
            },
          ),
        ],
      ),

      // Settings
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'account',
            name: 'account-settings',
            builder: (context, state) => const AccountSettingsScreen(),
          ),
          GoRoute(
            path: 'notifications',
            name: 'notification-settings',
            builder: (context, state) => const NotificationSettingsScreen(),
          ),
          GoRoute(
            path: 'theme',
            name: 'theme-settings',
            builder: (context, state) => const ThemeSettingsScreen(),
          ),
          GoRoute(
            path: 'language',
            name: 'language-settings',
            builder: (context, state) => const LanguageSettingsScreen(),
          ),
        ],
      ),

      // Search
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        builder: (context, state) => const SearchScreen(),
        routes: [
          GoRoute(
            path: 'results',
            name: 'search-results',
            builder: (context, state) {
              final query = state.uri.queryParameters['q'] ?? '';
              return SearchResultsScreen(query: query);
            },
          ),
        ],
      ),

      // Notifications
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
        routes: [
          GoRoute(
            path: ':notificationId',
            name: 'notification-details',
            builder: (context, state) {
              final notificationId = state.pathParameters['notificationId']!;
              return NotificationDetailsScreen(notificationId: notificationId);
            },
          ),
        ],
      ),

      // Help and Support
      GoRoute(
        path: AppRoutes.help,
        name: 'help',
        builder: (context, state) => const HelpScreen(),
        routes: [
          GoRoute(
            path: 'faq',
            name: 'faq',
            builder: (context, state) => const FAQScreen(),
          ),
          GoRoute(
            path: 'contact',
            name: 'contact-support',
            builder: (context, state) => const ContactSupportScreen(),
          ),
        ],
      ),

      // About and Legal
      GoRoute(
        path: AppRoutes.aboutApp,
        name: 'about',
        builder: (context, state) => const AboutScreen(),
      ),

      GoRoute(
        path: AppRoutes.termsOfService,
        name: 'terms',
        builder: (context, state) => const TermsOfServiceScreen(),
      ),

      GoRoute(
        path: AppRoutes.privacyPolicy,
        name: 'privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
    ],

    // Navigation observers
    observers: [
      AppNavigationObserver(),
    ],
  );
}

/// Navigation observer for logging and analytics
class AppNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logNavigation('PUSH', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logNavigation('POP', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logNavigation('REPLACE', newRoute, oldRoute);
  }

  void _logNavigation(String action, Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final routeName = route?.settings.name ?? 'Unknown';
    final previousRouteName = previousRoute?.settings.name ?? 'None';
    
    CricketLogger.screenNavigation(previousRouteName, routeName);
    Logger.d('Navigation $action: $previousRouteName -> $routeName', tag: 'Navigation');
  }
}

// Placeholder screens - these will be implemented in later tasks
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('GullyCric Splash Screen'),
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Onboarding Screen'),
      ),
    );
  }
}

// Remove placeholder screens - using actual implementations

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Forgot Password Screen'),
      ),
    );
  }
}



// More placeholder screens - these will be implemented in feature modules
// Remove placeholder home screen - using actual implementation

class LocalCricketScreen extends StatelessWidget {
  const LocalCricketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Cricket')),
      body: const Center(
        child: Text('Local Cricket Screen - Create and manage local matches'),
      ),
    );
  }
}

class LiveMatchesScreen extends StatelessWidget {
  const LiveMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Matches')),
      body: const Center(
        child: Text('Live Matches Screen - Watch live cricket matches'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(
        child: Text('Profile Screen - User profile and statistics'),
      ),
    );
  }
}

// Additional placeholder screens
class CreateMatchScreen extends StatelessWidget {
  const CreateMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Match')),
      body: const Center(child: Text('Create Match Screen')),
    );
  }
}

class MatchDetailsScreen extends StatelessWidget {
  final String matchId;

  const MatchDetailsScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Match Details')),
      body: Center(child: Text('Match Details Screen - ID: $matchId')),
    );
  }
}

class ScoreUpdateScreen extends StatelessWidget {
  final String matchId;

  const ScoreUpdateScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Score')),
      body: Center(child: Text('Score Update Screen - Match ID: $matchId')),
    );
  }
}

class MatchCommentaryScreen extends StatelessWidget {
  final String matchId;

  const MatchCommentaryScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Commentary')),
      body: Center(child: Text('Match Commentary Screen - Match ID: $matchId')),
    );
  }
}

class LiveMatchDetailsScreen extends StatelessWidget {
  final String matchId;

  const LiveMatchDetailsScreen({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Match')),
      body: Center(child: Text("Placeholder Screen")),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Edit Profile Screen')),
    );
  }
}

class ProfileStatsScreen extends StatelessWidget {
  const ProfileStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Stats')),
      body: const Center(child: Text('Profile Stats Screen')),
    );
  }
}

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: const Center(child: Text('Achievements Screen')),
    );
  }
}

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teams')),
      body: const Center(child: Text('Teams Screen')),
    );
  }
}

class CreateTeamScreen extends StatelessWidget {
  const CreateTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Team')),
      body: const Center(child: Text('Create Team Screen')),
    );
  }
}

class TeamDetailsScreen extends StatelessWidget {
  final String teamId;

  const TeamDetailsScreen({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team Details')),
      body: Center(child: Text("Placeholder Screen")),
    );
  }
}

class EditTeamScreen extends StatelessWidget {
  final String teamId;

  const EditTeamScreen({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Team')),
      body: Center(child: Text("Placeholder Screen")),
    );
  }
}

class TeamPlayersScreen extends StatelessWidget {
  final String teamId;

  const TeamPlayersScreen({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team Players')),
      body: Center(child: Text("Placeholder Screen")),
    );
  }
}

class PlayersScreen extends StatelessWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Players')),
      body: const Center(child: Text('Players Screen')),
    );
  }
}

class CreatePlayerScreen extends StatelessWidget {
  const CreatePlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Player')),
      body: const Center(child: Text('Create Player Screen')),
    );
  }
}

class PlayerDetailsScreen extends StatelessWidget {
  final String playerId;

  const PlayerDetailsScreen({super.key, required this.playerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Player Details')),
      body: Center(child: Text("Placeholder Screen")),
    );
  }
}

class EditPlayerScreen extends StatelessWidget {
  final String playerId;

  const EditPlayerScreen({super.key, required this.playerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Player')),
      body: Center(child: Text("Placeholder Screen")),
    );
  }
}

class PlayerStatsScreen extends StatelessWidget {
  final String playerId;

  const PlayerStatsScreen({super.key, required this.playerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Player Stats')),
      body: Center(child: Text("Placeholder Screen")),
    );
  }
}

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cricket News')),
      body: const Center(child: Text('News Screen')),
    );
  }
}

class NewsDetailsScreen extends StatelessWidget {
  final String newsId;

  const NewsDetailsScreen({super.key, required this.newsId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Details')),
      body: Center(child: Text("Placeholder Screen")),
    );
  }
}

class NewsCategoryScreen extends StatelessWidget {
  final String category;

  const NewsCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News - $category')),
      body: Center(child: Text("Placeholder Screen")),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen')),
    );
  }
}

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Settings')),
      body: const Center(child: Text('Account Settings Screen')),
    );
  }
}

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: const Center(child: Text('Notification Settings Screen')),
    );
  }
}

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Settings')),
      body: const Center(child: Text('Theme Settings Screen')),
    );
  }
}

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language Settings')),
      body: const Center(child: Text('Language Settings Screen')),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(child: Text('Search Screen')),
    );
  }
}

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Results')),
      body: Center(child: Text("Placeholder Screen")),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(child: Text('Notifications Screen')),
    );
  }
}

class NotificationDetailsScreen extends StatelessWidget {
  final String notificationId;

  const NotificationDetailsScreen({super.key, required this.notificationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Details')),
      body: Center(child: Text("Placeholder Screen")),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: const Center(child: Text('Help Screen')),
    );
  }
}

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: const Center(child: Text('FAQ Screen')),
    );
  }
}

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Support')),
      body: const Center(child: Text('Contact Support Screen')),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About GullyCric')),
      body: const Center(child: Text('About Screen')),
    );
  }
}

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: const Center(child: Text('Terms of Service Screen')),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const Center(child: Text('Privacy Policy Screen')),
    );
  }
}