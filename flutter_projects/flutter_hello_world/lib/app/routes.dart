/// GullyCric App Routes
/// 
/// Centralized route definitions for the cricket app
/// Organized by feature modules with consistent naming
class AppRoutes {
  AppRoutes._(); // Private constructor to prevent instantiation

  // Root routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // Authentication routes
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Main app routes
  static const String home = '/home';
  static const String dashboard = '/dashboard';

  // Local Cricket routes (MVP core)
  static const String localCricket = '/local-cricket';
  static const String createMatch = '/create-match';
  static const String matchDetails = '/match/:matchId';
  static const String scoreUpdate = '/match/:matchId/score';
  static const String matchHistory = '/match-history';

  // Live Cricket routes
  static const String liveMatches = '/live-matches';
  static const String liveMatchDetails = '/live-match/:matchId';
  static const String matchCommentary = '/match/:matchId/commentary';

  // Team Management routes
  static const String teams = '/teams';
  static const String teamDetails = '/team/:teamId';
  static const String createTeam = '/create-team';
  static const String editTeam = '/team/:teamId/edit';
  static const String teamPlayers = '/team/:teamId/players';

  // Player Management routes
  static const String players = '/players';
  static const String playerDetails = '/player/:playerId';
  static const String createPlayer = '/create-player';
  static const String editPlayer = '/player/:playerId/edit';
  static const String playerStats = '/player/:playerId/stats';

  // Tournament routes
  static const String tournaments = '/tournaments';
  static const String tournamentDetails = '/tournament/:tournamentId';
  static const String createTournament = '/create-tournament';
  static const String tournamentMatches = '/tournament/:tournamentId/matches';
  static const String tournamentStandings = '/tournament/:tournamentId/standings';

  // Profile routes
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String profileStats = '/profile/stats';
  static const String achievements = '/profile/achievements';

  // News and Content routes
  static const String news = '/news';
  static const String newsDetails = '/news/:newsId';
  static const String newsCategory = '/news/category/:category';

  // Social Features routes
  static const String feed = '/feed';
  static const String createPost = '/create-post';
  static const String postDetails = '/post/:postId';
  static const String userProfile = '/user/:userId';
  static const String followers = '/user/:userId/followers';
  static const String following = '/user/:userId/following';

  // Leaderboard routes
  static const String leaderboards = '/leaderboards';
  static const String globalLeaderboard = '/leaderboards/global';
  static const String localLeaderboard = '/leaderboards/local';
  static const String friendsLeaderboard = '/leaderboards/friends';

  // Settings routes
  static const String settings = '/settings';
  static const String accountSettings = '/settings/account';
  static const String privacySettings = '/settings/privacy';
  static const String notificationSettings = '/settings/notifications';
  static const String themeSettings = '/settings/theme';
  static const String languageSettings = '/settings/language';

  // Help and Support routes
  static const String help = '/help';
  static const String faq = '/help/faq';
  static const String contactSupport = '/help/contact';
  static const String reportIssue = '/help/report';
  static const String aboutApp = '/about';
  static const String termsOfService = '/terms';
  static const String privacyPolicy = '/privacy';

  // Search routes
  static const String search = '/search';
  static const String searchResults = '/search/results';
  static const String searchMatches = '/search/matches';
  static const String searchPlayers = '/search/players';
  static const String searchTeams = '/search/teams';

  // Notification routes
  static const String notifications = '/notifications';
  static const String notificationDetails = '/notification/:notificationId';

  // Utility routes
  static const String webView = '/webview';
  static const String imageViewer = '/image-viewer';
  static const String videoPlayer = '/video-player';

  // Error routes
  static const String notFound = '/404';
  static const String error = '/error';

  // Helper methods for dynamic routes

  /// Get match details route with ID
  static String getMatchDetailsRoute(String matchId) {
    return matchDetails.replaceAll(':matchId', matchId);
  }

  /// Get live match details route with ID
  static String getLiveMatchDetailsRoute(String matchId) {
    return liveMatchDetails.replaceAll(':matchId', matchId);
  }

  /// Get score update route with match ID
  static String getScoreUpdateRoute(String matchId) {
    return scoreUpdate.replaceAll(':matchId', matchId);
  }

  /// Get match commentary route with ID
  static String getMatchCommentaryRoute(String matchId) {
    return matchCommentary.replaceAll(':matchId', matchId);
  }

  /// Get team details route with ID
  static String getTeamDetailsRoute(String teamId) {
    return teamDetails.replaceAll(':teamId', teamId);
  }

  /// Get edit team route with ID
  static String getEditTeamRoute(String teamId) {
    return editTeam.replaceAll(':teamId', teamId);
  }

  /// Get team players route with ID
  static String getTeamPlayersRoute(String teamId) {
    return teamPlayers.replaceAll(':teamId', teamId);
  }

  /// Get player details route with ID
  static String getPlayerDetailsRoute(String playerId) {
    return playerDetails.replaceAll(':playerId', playerId);
  }

  /// Get edit player route with ID
  static String getEditPlayerRoute(String playerId) {
    return editPlayer.replaceAll(':playerId', playerId);
  }

  /// Get player stats route with ID
  static String getPlayerStatsRoute(String playerId) {
    return playerStats.replaceAll(':playerId', playerId);
  }

  /// Get tournament details route with ID
  static String getTournamentDetailsRoute(String tournamentId) {
    return tournamentDetails.replaceAll(':tournamentId', tournamentId);
  }

  /// Get tournament matches route with ID
  static String getTournamentMatchesRoute(String tournamentId) {
    return tournamentMatches.replaceAll(':tournamentId', tournamentId);
  }

  /// Get tournament standings route with ID
  static String getTournamentStandingsRoute(String tournamentId) {
    return tournamentStandings.replaceAll(':tournamentId', tournamentId);
  }

  /// Get news details route with ID
  static String getNewsDetailsRoute(String newsId) {
    return newsDetails.replaceAll(':newsId', newsId);
  }

  /// Get news category route with category
  static String getNewsCategoryRoute(String category) {
    return newsCategory.replaceAll(':category', category);
  }

  /// Get post details route with ID
  static String getPostDetailsRoute(String postId) {
    return postDetails.replaceAll(':postId', postId);
  }

  /// Get user profile route with ID
  static String getUserProfileRoute(String userId) {
    return userProfile.replaceAll(':userId', userId);
  }

  /// Get followers route with user ID
  static String getFollowersRoute(String userId) {
    return followers.replaceAll(':userId', userId);
  }

  /// Get following route with user ID
  static String getFollowingRoute(String userId) {
    return following.replaceAll(':userId', userId);
  }

  /// Get notification details route with ID
  static String getNotificationDetailsRoute(String notificationId) {
    return notificationDetails.replaceAll(':notificationId', notificationId);
  }

  /// Get web view route with URL
  static String getWebViewRoute(String url) {
    return '$webView?url=${Uri.encodeComponent(url)}';
  }

  /// Get image viewer route with URL
  static String getImageViewerRoute(String imageUrl) {
    return '$imageViewer?url=${Uri.encodeComponent(imageUrl)}';
  }

  /// Get video player route with URL
  static String getVideoPlayerRoute(String videoUrl) {
    return '$videoPlayer?url=${Uri.encodeComponent(videoUrl)}';
  }

  /// Get search results route with query
  static String getSearchResultsRoute(String query) {
    return '$searchResults?q=${Uri.encodeComponent(query)}';
  }

  /// Check if route requires authentication
  static bool requiresAuth(String route) {
    const publicRoutes = [
      splash,
      onboarding,
      login,
      signup,
      forgotPassword,
      resetPassword,
      news,
      help,
      faq,
      aboutApp,
      termsOfService,
      privacyPolicy,
      notFound,
      error,
    ];

    // Check if the route (without parameters) is in public routes
    for (final publicRoute in publicRoutes) {
      if (route == publicRoute || route.startsWith('$publicRoute?')) {
        return false;
      }
    }

    // Also check for news details and category routes (public)
    if (route.startsWith('/news/') || route.startsWith('/help/')) {
      return false;
    }

    return true;
  }

  /// Check if route is a main navigation route
  static bool isMainNavRoute(String route) {
    const mainNavRoutes = [
      home,
      localCricket,
      liveMatches,
      profile,
      news,
    ];

    return mainNavRoutes.contains(route);
  }

  /// Get main navigation routes
  static List<String> getMainNavRoutes() {
    return [
      home,
      localCricket,
      liveMatches,
      profile,
    ];
  }

  /// Get route name from path
  static String getRouteName(String path) {
    // Remove query parameters
    final uri = Uri.parse(path);
    String routePath = uri.path;

    // Remove parameters (anything after :)
    final segments = routePath.split('/');
    final cleanSegments = segments.map((segment) {
      if (segment.startsWith(':')) {
        return segment; // Keep parameter placeholder
      }
      return segment;
    }).toList();

    return cleanSegments.join('/');
  }

  /// Get all routes as a list
  static List<String> getAllRoutes() {
    return [
      splash,
      onboarding,
      login,
      signup,
      forgotPassword,
      resetPassword,
      home,
      dashboard,
      localCricket,
      createMatch,
      matchDetails,
      scoreUpdate,
      matchHistory,
      liveMatches,
      liveMatchDetails,
      matchCommentary,
      teams,
      teamDetails,
      createTeam,
      editTeam,
      teamPlayers,
      players,
      playerDetails,
      createPlayer,
      editPlayer,
      playerStats,
      tournaments,
      tournamentDetails,
      createTournament,
      tournamentMatches,
      tournamentStandings,
      profile,
      editProfile,
      profileStats,
      achievements,
      news,
      newsDetails,
      newsCategory,
      feed,
      createPost,
      postDetails,
      userProfile,
      followers,
      following,
      leaderboards,
      globalLeaderboard,
      localLeaderboard,
      friendsLeaderboard,
      settings,
      accountSettings,
      privacySettings,
      notificationSettings,
      themeSettings,
      languageSettings,
      help,
      faq,
      contactSupport,
      reportIssue,
      aboutApp,
      termsOfService,
      privacyPolicy,
      search,
      searchResults,
      searchMatches,
      searchPlayers,
      searchTeams,
      notifications,
      notificationDetails,
      webView,
      imageViewer,
      videoPlayer,
      notFound,
      error,
    ];
  }
}