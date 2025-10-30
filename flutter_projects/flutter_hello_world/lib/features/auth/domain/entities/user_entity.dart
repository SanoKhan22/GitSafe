import 'package:equatable/equatable.dart';

/// GullyCric User Entity
/// 
/// Core business object representing a user in the cricket app
/// Contains all user-related information and cricket-specific data
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? phoneNumber;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final UserRole role;
  final UserStatus status;
  final CricketProfile? cricketProfile;
  final UserPreferences preferences;

  const UserEntity({
    required this.id,
    required this.email,
    this.phoneNumber,
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.role,
    required this.status,
    this.cricketProfile,
    required this.preferences,
  });

  /// Get full name
  String get fullName => '$firstName $lastName';

  /// Get display name (first name or full name)
  String get displayName => firstName.isNotEmpty ? firstName : fullName;

  /// Get initials for avatar
  String get initials {
    final first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }

  /// Check if user has completed profile
  bool get isProfileComplete {
    return firstName.isNotEmpty &&
           lastName.isNotEmpty &&
           isEmailVerified &&
           cricketProfile != null;
  }

  /// Check if user is active
  bool get isActive => status == UserStatus.active;

  /// Check if user is premium
  bool get isPremium => role == UserRole.premium || role == UserRole.admin;

  /// Check if user can create tournaments
  bool get canCreateTournaments {
    return role == UserRole.premium || 
           role == UserRole.organizer || 
           role == UserRole.admin;
  }

  /// Check if user can moderate content
  bool get canModerate {
    return role == UserRole.moderator || role == UserRole.admin;
  }

  /// Copy with method for immutable updates
  UserEntity copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    UserRole? role,
    UserStatus? status,
    CricketProfile? cricketProfile,
    UserPreferences? preferences,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      role: role ?? this.role,
      status: status ?? this.status,
      cricketProfile: cricketProfile ?? this.cricketProfile,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        phoneNumber,
        firstName,
        lastName,
        profileImageUrl,
        createdAt,
        updatedAt,
        isEmailVerified,
        isPhoneVerified,
        role,
        status,
        cricketProfile,
        preferences,
      ];

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, fullName: $fullName, role: $role, status: $status)';
  }
}

/// User role enumeration
enum UserRole {
  user,
  premium,
  organizer,
  moderator,
  admin,
}

/// User status enumeration
enum UserStatus {
  active,
  inactive,
  suspended,
  banned,
}

/// Cricket-specific user profile
class CricketProfile extends Equatable {
  final String playerId;
  final String? teamId;
  final String? teamName;
  final PlayerRole preferredRole;
  final BattingStyle battingStyle;
  final BowlingStyle bowlingStyle;
  final int matchesPlayed;
  final int runsScored;
  final int wicketsTaken;
  final double battingAverage;
  final double bowlingAverage;
  final double strikeRate;
  final double economyRate;
  final int centuries;
  final int halfCenturies;
  final int fiveWickets;
  final List<Achievement> achievements;
  final DateTime? lastMatchDate;

  const CricketProfile({
    required this.playerId,
    this.teamId,
    this.teamName,
    required this.preferredRole,
    required this.battingStyle,
    required this.bowlingStyle,
    required this.matchesPlayed,
    required this.runsScored,
    required this.wicketsTaken,
    required this.battingAverage,
    required this.bowlingAverage,
    required this.strikeRate,
    required this.economyRate,
    required this.centuries,
    required this.halfCenturies,
    required this.fiveWickets,
    required this.achievements,
    this.lastMatchDate,
  });

  /// Check if player is active (played recently)
  bool get isActivePlayer {
    if (lastMatchDate == null) return false;
    final daysSinceLastMatch = DateTime.now().difference(lastMatchDate!).inDays;
    return daysSinceLastMatch <= 90; // Active if played in last 3 months
  }

  /// Get player experience level
  PlayerExperience get experienceLevel {
    if (matchesPlayed >= 100) return PlayerExperience.expert;
    if (matchesPlayed >= 50) return PlayerExperience.experienced;
    if (matchesPlayed >= 20) return PlayerExperience.intermediate;
    if (matchesPlayed >= 5) return PlayerExperience.beginner;
    return PlayerExperience.newbie;
  }

  /// Copy with method
  CricketProfile copyWith({
    String? playerId,
    String? teamId,
    String? teamName,
    PlayerRole? preferredRole,
    BattingStyle? battingStyle,
    BowlingStyle? bowlingStyle,
    int? matchesPlayed,
    int? runsScored,
    int? wicketsTaken,
    double? battingAverage,
    double? bowlingAverage,
    double? strikeRate,
    double? economyRate,
    int? centuries,
    int? halfCenturies,
    int? fiveWickets,
    List<Achievement>? achievements,
    DateTime? lastMatchDate,
  }) {
    return CricketProfile(
      playerId: playerId ?? this.playerId,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      preferredRole: preferredRole ?? this.preferredRole,
      battingStyle: battingStyle ?? this.battingStyle,
      bowlingStyle: bowlingStyle ?? this.bowlingStyle,
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      runsScored: runsScored ?? this.runsScored,
      wicketsTaken: wicketsTaken ?? this.wicketsTaken,
      battingAverage: battingAverage ?? this.battingAverage,
      bowlingAverage: bowlingAverage ?? this.bowlingAverage,
      strikeRate: strikeRate ?? this.strikeRate,
      economyRate: economyRate ?? this.economyRate,
      centuries: centuries ?? this.centuries,
      halfCenturies: halfCenturies ?? this.halfCenturies,
      fiveWickets: fiveWickets ?? this.fiveWickets,
      achievements: achievements ?? this.achievements,
      lastMatchDate: lastMatchDate ?? this.lastMatchDate,
    );
  }

  @override
  List<Object?> get props => [
        playerId,
        teamId,
        teamName,
        preferredRole,
        battingStyle,
        bowlingStyle,
        matchesPlayed,
        runsScored,
        wicketsTaken,
        battingAverage,
        bowlingAverage,
        strikeRate,
        economyRate,
        centuries,
        halfCenturies,
        fiveWickets,
        achievements,
        lastMatchDate,
      ];
}

/// Player role in cricket
enum PlayerRole {
  batsman,
  bowler,
  allRounder,
  wicketKeeper,
  captain,
}

/// Batting style
enum BattingStyle {
  rightHanded,
  leftHanded,
}

/// Bowling style
enum BowlingStyle {
  rightArmFast,
  leftArmFast,
  rightArmMedium,
  leftArmMedium,
  rightArmSpin,
  leftArmSpin,
  rightArmOffSpin,
  leftArmOffSpin,
  none, // For non-bowlers
}

/// Player experience level
enum PlayerExperience {
  newbie,
  beginner,
  intermediate,
  experienced,
  expert,
}

/// Achievement entity
class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconUrl;
  final DateTime achievedAt;
  final AchievementType type;
  final Map<String, dynamic> metadata;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.achievedAt,
    required this.type,
    required this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        iconUrl,
        achievedAt,
        type,
        metadata,
      ];
}

/// Achievement types
enum AchievementType {
  batting,
  bowling,
  fielding,
  milestone,
  tournament,
  social,
  special,
}

/// User preferences
class UserPreferences extends Equatable {
  final bool enableNotifications;
  final bool enablePushNotifications;
  final bool enableEmailNotifications;
  final bool enableSmsNotifications;
  final bool enableSoundEffects;
  final bool enableHapticFeedback;
  final String preferredLanguage;
  final String preferredTimeZone;
  final String preferredDateFormat;
  final String preferredTimeFormat;
  final bool enableDarkMode;
  final bool enableAutoTheme;
  final NotificationSettings notificationSettings;
  final PrivacySettings privacySettings;

  const UserPreferences({
    required this.enableNotifications,
    required this.enablePushNotifications,
    required this.enableEmailNotifications,
    required this.enableSmsNotifications,
    required this.enableSoundEffects,
    required this.enableHapticFeedback,
    required this.preferredLanguage,
    required this.preferredTimeZone,
    required this.preferredDateFormat,
    required this.preferredTimeFormat,
    required this.enableDarkMode,
    required this.enableAutoTheme,
    required this.notificationSettings,
    required this.privacySettings,
  });

  /// Default preferences
  factory UserPreferences.defaultPreferences() {
    return const UserPreferences(
      enableNotifications: true,
      enablePushNotifications: true,
      enableEmailNotifications: true,
      enableSmsNotifications: false,
      enableSoundEffects: true,
      enableHapticFeedback: true,
      preferredLanguage: 'en',
      preferredTimeZone: 'UTC',
      preferredDateFormat: 'dd/MM/yyyy',
      preferredTimeFormat: '24h',
      enableDarkMode: false,
      enableAutoTheme: true,
      notificationSettings: const NotificationSettings(
        matchUpdates: true,
        tournamentUpdates: true,
        teamInvitations: true,
        friendRequests: true,
        achievements: true,
        newsUpdates: false,
        socialUpdates: true,
        marketingEmails: false,
      ),
      privacySettings: const PrivacySettings(
        profileVisibility: true,
        statsVisibility: true,
        matchHistoryVisibility: true,
        allowFriendRequests: true,
        allowTeamInvitations: true,
        showOnlineStatus: true,
        allowLocationSharing: false,
        allowDataAnalytics: true,
      ),
    );
  }

  /// Copy with method
  UserPreferences copyWith({
    bool? enableNotifications,
    bool? enablePushNotifications,
    bool? enableEmailNotifications,
    bool? enableSmsNotifications,
    bool? enableSoundEffects,
    bool? enableHapticFeedback,
    String? preferredLanguage,
    String? preferredTimeZone,
    String? preferredDateFormat,
    String? preferredTimeFormat,
    bool? enableDarkMode,
    bool? enableAutoTheme,
    NotificationSettings? notificationSettings,
    PrivacySettings? privacySettings,
  }) {
    return UserPreferences(
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enablePushNotifications: enablePushNotifications ?? this.enablePushNotifications,
      enableEmailNotifications: enableEmailNotifications ?? this.enableEmailNotifications,
      enableSmsNotifications: enableSmsNotifications ?? this.enableSmsNotifications,
      enableSoundEffects: enableSoundEffects ?? this.enableSoundEffects,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      preferredTimeZone: preferredTimeZone ?? this.preferredTimeZone,
      preferredDateFormat: preferredDateFormat ?? this.preferredDateFormat,
      preferredTimeFormat: preferredTimeFormat ?? this.preferredTimeFormat,
      enableDarkMode: enableDarkMode ?? this.enableDarkMode,
      enableAutoTheme: enableAutoTheme ?? this.enableAutoTheme,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      privacySettings: privacySettings ?? this.privacySettings,
    );
  }

  @override
  List<Object?> get props => [
        enableNotifications,
        enablePushNotifications,
        enableEmailNotifications,
        enableSmsNotifications,
        enableSoundEffects,
        enableHapticFeedback,
        preferredLanguage,
        preferredTimeZone,
        preferredDateFormat,
        preferredTimeFormat,
        enableDarkMode,
        enableAutoTheme,
        notificationSettings,
        privacySettings,
      ];
}

/// Notification settings
class NotificationSettings extends Equatable {
  final bool matchUpdates;
  final bool tournamentUpdates;
  final bool teamInvitations;
  final bool friendRequests;
  final bool achievements;
  final bool newsUpdates;
  final bool socialUpdates;
  final bool marketingEmails;

  const NotificationSettings({
    required this.matchUpdates,
    required this.tournamentUpdates,
    required this.teamInvitations,
    required this.friendRequests,
    required this.achievements,
    required this.newsUpdates,
    required this.socialUpdates,
    required this.marketingEmails,
  });

  /// Default notification settings
  factory NotificationSettings.defaultSettings() {
    return const NotificationSettings(
      matchUpdates: true,
      tournamentUpdates: true,
      teamInvitations: true,
      friendRequests: true,
      achievements: true,
      newsUpdates: false,
      socialUpdates: true,
      marketingEmails: false,
    );
  }

  @override
  List<Object?> get props => [
        matchUpdates,
        tournamentUpdates,
        teamInvitations,
        friendRequests,
        achievements,
        newsUpdates,
        socialUpdates,
        marketingEmails,
      ];
}

/// Privacy settings
class PrivacySettings extends Equatable {
  final bool profileVisibility;
  final bool statsVisibility;
  final bool matchHistoryVisibility;
  final bool allowFriendRequests;
  final bool allowTeamInvitations;
  final bool showOnlineStatus;
  final bool allowLocationSharing;
  final bool allowDataAnalytics;

  const PrivacySettings({
    required this.profileVisibility,
    required this.statsVisibility,
    required this.matchHistoryVisibility,
    required this.allowFriendRequests,
    required this.allowTeamInvitations,
    required this.showOnlineStatus,
    required this.allowLocationSharing,
    required this.allowDataAnalytics,
  });

  /// Default privacy settings
  factory PrivacySettings.defaultSettings() {
    return const PrivacySettings(
      profileVisibility: true,
      statsVisibility: true,
      matchHistoryVisibility: true,
      allowFriendRequests: true,
      allowTeamInvitations: true,
      showOnlineStatus: true,
      allowLocationSharing: false,
      allowDataAnalytics: true,
    );
  }

  @override
  List<Object?> get props => [
        profileVisibility,
        statsVisibility,
        matchHistoryVisibility,
        allowFriendRequests,
        allowTeamInvitations,
        showOnlineStatus,
        allowLocationSharing,
        allowDataAnalytics,
      ];
}
/// Authentication Tokens Entity
/// 
/// Represents access and refresh tokens with expiration information
class AuthTokens extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final DateTime expiresAt;
  final String? scope;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.expiresAt,
    this.scope,
  });

  /// Check if token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if token will expire soon (within 5 minutes)
  bool get willExpireSoon {
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return fiveMinutesFromNow.isAfter(expiresAt);
  }

  /// Get time until expiry
  Duration get timeUntilExpiry {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) {
      return Duration.zero;
    }
    return expiresAt.difference(now);
  }

  /// Get authorization header value
  String get authorizationHeader => '$tokenType $accessToken';

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        tokenType,
        expiresIn,
        expiresAt,
        scope,
      ];

  @override
  String toString() {
    return 'AuthTokens(tokenType: $tokenType, expiresAt: $expiresAt, isExpired: $isExpired)';
  }
}

/// User Session Entity
/// 
/// Represents current user session information
class UserSession extends Equatable {
  final String sessionId;
  final String userId;
  final String deviceId;
  final String ipAddress;
  final String userAgent;
  final DateTime createdAt;
  final DateTime lastActivityAt;
  final DateTime expiresAt;
  final bool isActive;
  final String? location;

  const UserSession({
    required this.sessionId,
    required this.userId,
    required this.deviceId,
    required this.ipAddress,
    required this.userAgent,
    required this.createdAt,
    required this.lastActivityAt,
    required this.expiresAt,
    this.isActive = true,
    this.location,
  });

  /// Check if session is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if session will expire soon (within 30 minutes)
  bool get willExpireSoon {
    final thirtyMinutesFromNow = DateTime.now().add(const Duration(minutes: 30));
    return thirtyMinutesFromNow.isAfter(expiresAt);
  }

  /// Get time until expiry
  Duration get timeUntilExpiry {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) {
      return Duration.zero;
    }
    return expiresAt.difference(now);
  }

  /// Get session duration
  Duration get sessionDuration => lastActivityAt.difference(createdAt);

  /// Check if session is idle (no activity for more than 30 minutes)
  bool get isIdle {
    final thirtyMinutesAgo = DateTime.now().subtract(const Duration(minutes: 30));
    return lastActivityAt.isBefore(thirtyMinutesAgo);
  }

  @override
  List<Object?> get props => [
        sessionId,
        userId,
        deviceId,
        ipAddress,
        userAgent,
        createdAt,
        lastActivityAt,
        expiresAt,
        isActive,
        location,
      ];

  @override
  String toString() {
    return 'UserSession(sessionId: $sessionId, userId: $userId, isActive: $isActive, isExpired: $isExpired)';
  }
}

/// Login History Entity
/// 
/// Represents a login history entry
class LoginHistory extends Equatable {
  final String id;
  final String userId;
  final DateTime loginAt;
  final String ipAddress;
  final String userAgent;
  final String deviceType;
  final String loginMethod;
  final String? location;
  final bool isSuccessful;
  final String? failureReason;

  const LoginHistory({
    required this.id,
    required this.userId,
    required this.loginAt,
    required this.ipAddress,
    required this.userAgent,
    required this.deviceType,
    required this.loginMethod,
    this.location,
    this.isSuccessful = true,
    this.failureReason,
  });

  /// Get device type from user agent
  String get deviceTypeFromUserAgent {
    final ua = userAgent.toLowerCase();
    if (ua.contains('mobile') || ua.contains('android') || ua.contains('iphone')) {
      return 'Mobile';
    } else if (ua.contains('tablet') || ua.contains('ipad')) {
      return 'Tablet';
    } else {
      return 'Desktop';
    }
  }

  /// Get browser from user agent
  String get browserFromUserAgent {
    final ua = userAgent.toLowerCase();
    if (ua.contains('chrome')) return 'Chrome';
    if (ua.contains('firefox')) return 'Firefox';
    if (ua.contains('safari')) return 'Safari';
    if (ua.contains('edge')) return 'Edge';
    if (ua.contains('opera')) return 'Opera';
    return 'Unknown';
  }

  /// Check if login was recent (within last 24 hours)
  bool get isRecent {
    final twentyFourHoursAgo = DateTime.now().subtract(const Duration(hours: 24));
    return loginAt.isAfter(twentyFourHoursAgo);
  }

  /// Check if login was suspicious (different location/device)
  bool get isSuspicious => !isSuccessful || failureReason != null;

  @override
  List<Object?> get props => [
        id,
        userId,
        loginAt,
        ipAddress,
        userAgent,
        deviceType,
        loginMethod,
        location,
        isSuccessful,
        failureReason,
      ];

  @override
  String toString() {
    return 'LoginHistory(id: $id, method: $loginMethod, successful: $isSuccessful, loginAt: $loginAt)';
  }
}