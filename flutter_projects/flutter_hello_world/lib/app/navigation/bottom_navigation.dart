import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_styles.dart';
import '../../core/theme/text_theme.dart';
import '../routes.dart';

/// GullyCric Bottom Navigation Bar
/// 
/// Material 3 bottom navigation with cricket-themed icons
/// Maximum 4 tabs for one-hand usability as per design requirements
class GullyCricBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GullyCricBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: AppDimensions.bottomNavHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingS,
            vertical: AppDimensions.spacingXS,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                index: 0,
                icon: AppIcons.home,
                activeIcon: AppIcons.homeFilled,
                label: AppStrings.home,
                route: AppRoutes.home,
              ),
              _buildNavItem(
                context,
                index: 1,
                icon: AppIcons.cricketBat,
                activeIcon: AppIcons.cricketBat,
                label: AppStrings.localCricket,
                route: AppRoutes.localCricket,
              ),
              _buildNavItem(
                context,
                index: 2,
                icon: AppIcons.live,
                activeIcon: AppIcons.live,
                label: AppStrings.live,
                route: AppRoutes.liveMatches,
              ),
              _buildNavItem(
                context,
                index: 3,
                icon: AppIcons.profile,
                activeIcon: AppIcons.profileFilled,
                label: AppStrings.profile,
                route: AppRoutes.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
  }) {
    final theme = Theme.of(context);
    final isSelected = currentIndex == index;
    
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spacingS,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with selection indicator
              Container(
                width: AppDimensions.minTouchTarget,
                height: 32,
                decoration: isSelected
                    ? BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      )
                    : null,
                child: Icon(
                  isSelected ? activeIcon : icon,
                  size: AppDimensions.iconM,
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              
              const SizedBox(height: AppDimensions.spacingXS),
              
              // Label
              Text(
                label,
                style: AppTextTheme.cricket.navigationLabel.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Navigation shell that manages bottom navigation state
class NavigationShell extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const NavigationShell({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _currentIndex = 0;

  // Define the main navigation routes
  static const List<String> _mainRoutes = [
    AppRoutes.home,
    AppRoutes.localCricket,
    AppRoutes.liveMatches,
    AppRoutes.profile,
  ];

  @override
  void initState() {
    super.initState();
    _updateCurrentIndex();
  }

  @override
  void didUpdateWidget(NavigationShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentRoute != widget.currentRoute) {
      _updateCurrentIndex();
    }
  }

  void _updateCurrentIndex() {
    // Find the current index based on the route
    for (int i = 0; i < _mainRoutes.length; i++) {
      if (widget.currentRoute.startsWith(_mainRoutes[i])) {
        if (_currentIndex != i) {
          setState(() {
            _currentIndex = i;
          });
        }
        break;
      }
    }
  }

  void _onNavItemTapped(int index) {
    if (index != _currentIndex && index < _mainRoutes.length) {
      context.go(_mainRoutes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: GullyCricBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}

/// Cricket-themed floating action button for quick actions
class CricketFAB extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? tooltip;
  final IconData icon;

  const CricketFAB({
    super.key,
    this.onPressed,
    this.tooltip,
    this.icon = AppIcons.add,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip ?? 'Quick Action',
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: AppDimensions.elevationM,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Icon(
        icon,
        size: AppDimensions.iconM,
      ),
    );
  }
}

/// Extended FAB for cricket actions
class CricketExtendedFAB extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData icon;
  final String? tooltip;

  const CricketExtendedFAB({
    super.key,
    this.onPressed,
    required this.label,
    required this.icon,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FloatingActionButton.extended(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: AppDimensions.elevationM,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      icon: Icon(
        icon,
        size: AppDimensions.iconM,
      ),
      label: Text(
        label,
        style: AppTextTheme.cricket.buttonMedium,
      ),
    );
  }
}

/// Navigation utilities
class NavigationUtils {
  NavigationUtils._();

  /// Get the current route index for bottom navigation
  static int getCurrentRouteIndex(String currentRoute) {
    const mainRoutes = [
      AppRoutes.home,
      AppRoutes.localCricket,
      AppRoutes.liveMatches,
      AppRoutes.profile,
    ];

    for (int i = 0; i < mainRoutes.length; i++) {
      if (currentRoute.startsWith(mainRoutes[i])) {
        return i;
      }
    }
    
    return 0; // Default to home
  }

  /// Check if the current route should show bottom navigation
  static bool shouldShowBottomNavigation(String currentRoute) {
    const routesWithBottomNav = [
      AppRoutes.home,
      AppRoutes.localCricket,
      AppRoutes.liveMatches,
      AppRoutes.profile,
    ];

    return routesWithBottomNav.any((route) => currentRoute.startsWith(route));
  }

  /// Check if the current route should show FAB
  static bool shouldShowFAB(String currentRoute) {
    const routesWithFAB = [
      AppRoutes.localCricket,
      AppRoutes.home,
    ];

    return routesWithFAB.any((route) => currentRoute.startsWith(route));
  }

  /// Get FAB configuration for current route
  static FABConfig? getFABConfig(String currentRoute) {
    if (currentRoute.startsWith(AppRoutes.localCricket)) {
      return FABConfig(
        icon: AppIcons.add,
        label: 'Create Match',
        tooltip: 'Create a new cricket match',
        onPressed: () {
          // Will be implemented when we have proper context
        },
      );
    }

    if (currentRoute.startsWith(AppRoutes.home)) {
      return FABConfig(
        icon: AppIcons.cricketBat,
        label: 'Quick Match',
        tooltip: 'Start a quick match',
        onPressed: () {
          // Will be implemented when we have proper context
        },
      );
    }

    return null;
  }

  /// Navigate to route with proper handling
  static void navigateTo(BuildContext context, String route) {
    try {
      context.go(route);
    } catch (e) {
      // Fallback navigation
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  /// Navigate back with proper handling
  static void navigateBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      // Navigate to home if can't pop
      context.go(AppRoutes.home);
    }
  }

  /// Show bottom sheet for navigation options
  static void showNavigationOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      builder: (context) => const NavigationOptionsSheet(),
    );
  }
}

/// FAB configuration class
class FABConfig {
  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback onPressed;

  const FABConfig({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.onPressed,
  });
}

/// Navigation options bottom sheet
class NavigationOptionsSheet extends StatelessWidget {
  const NavigationOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // Title
          Text(
            'Quick Navigation',
            style: AppTextTheme.cricket.cardTitle,
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // Navigation options
          _buildNavOption(
            context,
            icon: AppIcons.cricketBat,
            title: 'Create Match',
            subtitle: 'Start a new local cricket match',
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.createMatch);
            },
          ),
          
          _buildNavOption(
            context,
            icon: AppIcons.team,
            title: 'Manage Teams',
            subtitle: 'Create and manage cricket teams',
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.teams);
            },
          ),
          
          _buildNavOption(
            context,
            icon: AppIcons.addPlayer,
            title: 'Add Players',
            subtitle: 'Add new players to your teams',
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.players);
            },
          ),
          
          _buildNavOption(
            context,
            icon: AppIcons.settings,
            title: 'Settings',
            subtitle: 'App settings and preferences',
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.settings);
            },
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
        ],
      ),
    );
  }

  Widget _buildNavOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.onPrimaryContainer,
          size: AppDimensions.iconM,
        ),
      ),
      title: Text(
        title,
        style: AppTextTheme.cricket.listTitle,
      ),
      subtitle: Text(
        subtitle,
        style: AppTextTheme.cricket.listSubtitle,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
    );
  }
}