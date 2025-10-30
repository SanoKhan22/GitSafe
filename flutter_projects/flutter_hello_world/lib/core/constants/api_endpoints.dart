/// GullyCric API Endpoints
/// 
/// Centralized API endpoint definitions for different environments
/// and service integrations
class ApiEndpoints {
  ApiEndpoints._(); // Private constructor to prevent instantiation

  // Base URLs for different environments
  static const String baseUrlDev = 'https://dev-api.gullycric.com';
  static const String baseUrlStaging = 'https://staging-api.gullycric.com';
  static const String baseUrlProd = 'https://api.gullycric.com';

  // API Version
  static const String apiVersion = '/v1';

  // Authentication Endpoints
  static const String login = '$apiVersion/auth/login';
  static const String loginEmail = '$apiVersion/auth/login/email';
  static const String loginPhone = '$apiVersion/auth/login/phone';
  static const String loginGoogle = '$apiVersion/auth/login/google';
  static const String loginFacebook = '$apiVersion/auth/login/facebook';
  static const String loginApple = '$apiVersion/auth/login/apple';
  static const String loginBiometric = '$apiVersion/auth/login/biometric';
  
  static const String register = '$apiVersion/auth/register';
  static const String signUp = '$apiVersion/auth/signup';
  
  static const String logout = '$apiVersion/auth/logout';
  static const String refreshToken = '$apiVersion/auth/refresh';
  static const String tokenRefresh = '$apiVersion/auth/token/refresh';
  static const String tokenValidate = '$apiVersion/auth/token/validate';
  
  // OTP Endpoints
  static const String sendOtp = '$apiVersion/auth/otp/send';
  static const String verifyOtp = '$apiVersion/auth/otp/verify';
  
  // Password Management
  static const String forgotPassword = '$apiVersion/auth/forgot-password';
  static const String resetPassword = '$apiVersion/auth/reset-password';
  static const String passwordResetRequest = '$apiVersion/auth/password/reset-request';
  static const String passwordReset = '$apiVersion/auth/password/reset';
  static const String passwordChange = '$apiVersion/auth/password/change';
  
  // Email Verification
  static const String verifyEmail = '$apiVersion/auth/verify-email';
  static const String resendVerification = '$apiVersion/auth/resend-verification';
  static const String emailVerificationSend = '$apiVersion/auth/email/verification/send';
  static const String emailVerificationVerify = '$apiVersion/auth/email/verification/verify';
  
  // Session Management
  static const String userSession = '$apiVersion/auth/session';
  static const String sessionExtend = '$apiVersion/auth/session/extend';
  static const String loginHistory = '$apiVersion/auth/login-history';
  
  // Biometric Authentication
  static const String biometricAvailable = '$apiVersion/auth/biometric/available';
  static const String biometricStatus = '$apiVersion/auth/biometric/status';
  static const String biometricEnable = '$apiVersion/auth/biometric/enable';
  static const String biometricDisable = '$apiVersion/auth/biometric/disable';
  
  // User Management
  static const String users = '$apiVersion/users';
  static const String userCricketProfile = '$apiVersion/user/cricket-profile';
  static const String userPreferences = '$apiVersion/user/preferences';
  static const String userSearch = '$apiVersion/users/search';
  static const String userAccount = '$apiVersion/user/account';
  
  // Availability Checks
  static const String checkEmailAvailability = '$apiVersion/auth/check/email';
  static const String checkPhoneAvailability = '$apiVersion/auth/check/phone';
  
  // Security
  static const String reportSuspiciousActivity = '$apiVersion/auth/security/report';

  // User Management Endpoints
  static const String userProfile = '$apiVersion/user/profile';
  static const String updateProfile = '$apiVersion/user/profile';
  static const String changePassword = '$apiVersion/user/change-password';
  static const String deleteAccount = '$apiVersion/user/delete';
  static const String userStats = '$apiVersion/user/stats';
  static const String userMatches = '$apiVersion/user/matches';
  static const String userAchievements = '$apiVersion/user/achievements';

  // Match Management Endpoints
  static const String matches = '$apiVersion/matches';
  static const String createMatch = '$apiVersion/matches';
  static const String matchDetails = '$apiVersion/matches'; // + /{id}
  static const String updateMatch = '$apiVersion/matches'; // + /{id}
  static const String deleteMatch = '$apiVersion/matches'; // + /{id}
  static const String joinMatch = '$apiVersion/matches'; // + /{id}/join
  static const String leaveMatch = '$apiVersion/matches'; // + /{id}/leave
  static const String startMatch = '$apiVersion/matches'; // + /{id}/start
  static const String endMatch = '$apiVersion/matches'; // + /{id}/end

  // Live Match Endpoints
  static const String liveMatches = '$apiVersion/matches/live';
  static const String matchScore = '$apiVersion/matches'; // + /{id}/score
  static const String updateScore = '$apiVersion/matches'; // + /{id}/score
  static const String matchEvents = '$apiVersion/matches'; // + /{id}/events
  static const String addEvent = '$apiVersion/matches'; // + /{id}/events
  static const String matchCommentary = '$apiVersion/matches'; // + /{id}/commentary

  // Team Management Endpoints
  static const String teams = '$apiVersion/teams';
  static const String createTeam = '$apiVersion/teams';
  static const String teamDetails = '$apiVersion/teams'; // + /{id}
  static const String updateTeam = '$apiVersion/teams'; // + /{id}
  static const String deleteTeam = '$apiVersion/teams'; // + /{id}
  static const String teamPlayers = '$apiVersion/teams'; // + /{id}/players
  static const String addPlayer = '$apiVersion/teams'; // + /{id}/players
  static const String removePlayer = '$apiVersion/teams'; // + /{id}/players/{playerId}

  // Player Management Endpoints
  static const String players = '$apiVersion/players';
  static const String createPlayer = '$apiVersion/players';
  static const String playerDetails = '$apiVersion/players'; // + /{id}
  static const String updatePlayer = '$apiVersion/players'; // + /{id}
  static const String deletePlayer = '$apiVersion/players'; // + /{id}
  static const String playerStats = '$apiVersion/players'; // + /{id}/stats
  static const String playerMatches = '$apiVersion/players'; // + /{id}/matches

  // Tournament Endpoints
  static const String tournaments = '$apiVersion/tournaments';
  static const String createTournament = '$apiVersion/tournaments';
  static const String tournamentDetails = '$apiVersion/tournaments'; // + /{id}
  static const String tournamentMatches = '$apiVersion/tournaments'; // + /{id}/matches
  static const String tournamentStandings = '$apiVersion/tournaments'; // + /{id}/standings
  static const String joinTournament = '$apiVersion/tournaments'; // + /{id}/join

  // News and Content Endpoints
  static const String news = '$apiVersion/news';
  static const String newsDetails = '$apiVersion/news'; // + /{id}
  static const String featuredNews = '$apiVersion/news/featured';
  static const String newsCategories = '$apiVersion/news/categories';
  static const String newsByCategory = '$apiVersion/news/category'; // + /{category}

  // Social Features Endpoints
  static const String feed = '$apiVersion/social/feed';
  static const String posts = '$apiVersion/social/posts';
  static const String createPost = '$apiVersion/social/posts';
  static const String likePost = '$apiVersion/social/posts'; // + /{id}/like
  static const String commentPost = '$apiVersion/social/posts'; // + /{id}/comments
  static const String sharePost = '$apiVersion/social/posts'; // + /{id}/share
  static const String followUser = '$apiVersion/social/follow'; // + /{userId}
  static const String unfollowUser = '$apiVersion/social/unfollow'; // + /{userId}

  // Leaderboard Endpoints
  static const String leaderboards = '$apiVersion/leaderboards';
  static const String globalLeaderboard = '$apiVersion/leaderboards/global';
  static const String localLeaderboard = '$apiVersion/leaderboards/local';
  static const String friendsLeaderboard = '$apiVersion/leaderboards/friends';
  static const String weeklyLeaderboard = '$apiVersion/leaderboards/weekly';
  static const String monthlyLeaderboard = '$apiVersion/leaderboards/monthly';

  // Notification Endpoints
  static const String notifications = '$apiVersion/notifications';
  static const String markAsRead = '$apiVersion/notifications'; // + /{id}/read
  static const String markAllAsRead = '$apiVersion/notifications/read-all';
  static const String notificationSettings = '$apiVersion/notifications/settings';
  static const String updateNotificationSettings = '$apiVersion/notifications/settings';

  // Search Endpoints
  static const String search = '$apiVersion/search';
  static const String searchMatches = '$apiVersion/search/matches';
  static const String searchPlayers = '$apiVersion/search/players';
  static const String searchTeams = '$apiVersion/search/teams';
  static const String searchUsers = '$apiVersion/search/users';
  static const String searchNews = '$apiVersion/search/news';

  // Analytics Endpoints
  static const String analytics = '$apiVersion/analytics';
  static const String trackEvent = '$apiVersion/analytics/events';
  static const String userAnalytics = '$apiVersion/analytics/user';
  static const String matchAnalytics = '$apiVersion/analytics/match'; // + /{id}

  // File Upload Endpoints
  static const String uploadImage = '$apiVersion/upload/image';
  static const String uploadVideo = '$apiVersion/upload/video';
  static const String uploadDocument = '$apiVersion/upload/document';
  static const String deleteFile = '$apiVersion/upload'; // + /{fileId}

  // Settings Endpoints
  static const String appSettings = '$apiVersion/settings/app';
  static const String userSettings = '$apiVersion/settings/user';
  static const String updateSettings = '$apiVersion/settings/user';
  static const String privacySettings = '$apiVersion/settings/privacy';

  // External API Endpoints (Third-party integrations)
  static const String cricketApiBase = 'https://api.cricapi.com/v1';
  static const String weatherApiBase = 'https://api.openweathermap.org/data/2.5';
  static const String mapsApiBase = 'https://maps.googleapis.com/maps/api';

  // WebSocket Endpoints
  static const String wsBaseUrl = 'wss://ws.gullycric.com';
  static const String wsLiveMatches = '$wsBaseUrl/live-matches';
  static const String wsMatchUpdates = '$wsBaseUrl/match-updates'; // + /{matchId}
  static const String wsChat = '$wsBaseUrl/chat'; // + /{roomId}
  static const String wsNotifications = '$wsBaseUrl/notifications'; // + /{userId}

  // Helper methods for dynamic endpoints
  static String matchDetailsById(String matchId) => '$matchDetails/$matchId';
  static String teamDetailsById(String teamId) => '$teamDetails/$teamId';
  static String playerDetailsById(String playerId) => '$playerDetails/$playerId';
  static String newsDetailsById(String newsId) => '$newsDetails/$newsId';
  static String tournamentDetailsById(String tournamentId) => '$tournamentDetails/$tournamentId';
  
  static String updateScoreById(String matchId) => '$updateScore/$matchId';
  static String matchEventsById(String matchId) => '$matchEvents/$matchId';
  static String addEventById(String matchId) => '$addEvent/$matchId';
  
  static String teamPlayersById(String teamId) => '$teamPlayers/$teamId';
  static String addPlayerToTeam(String teamId) => '$addPlayer/$teamId';
  static String removePlayerFromTeam(String teamId, String playerId) => 
      '$removePlayer/$teamId/$playerId';
  
  static String playerStatsById(String playerId) => '$playerStats/$playerId';
  static String playerMatchesById(String playerId) => '$playerMatches/$playerId';
  
  static String likePostById(String postId) => '$likePost/$postId';
  static String commentPostById(String postId) => '$commentPost/$postId';
  static String sharePostById(String postId) => '$sharePost/$postId';
  
  static String followUserById(String userId) => '$followUser/$userId';
  static String unfollowUserById(String userId) => '$unfollowUser/$userId';
  
  static String markNotificationAsRead(String notificationId) => '$markAsRead/$notificationId';
  static String deleteFileById(String fileId) => '$deleteFile/$fileId';
  
  static String wsMatchUpdatesById(String matchId) => '$wsMatchUpdates/$matchId';
  static String wsChatById(String roomId) => '$wsChat/$roomId';
  static String wsNotificationsById(String userId) => '$wsNotifications/$userId';
}