import '../../domain/entities/user_entity.dart';

/// User Data Model
/// 
/// Extends User entity and provides JSON serialization/deserialization
/// Used for API communication and local storage
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.phoneNumber,
    super.profileImageUrl,
    required super.createdAt,
    required super.updatedAt,
    required super.isEmailVerified,
    required super.isPhoneVerified,
    required super.role,
    required super.status,
    super.cricketProfile,
    required super.preferences,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
      role: _parseUserRole(json['role'] as String?),
      status: _parseUserStatus(json['status'] as String?),
      cricketProfile: json['cricketProfile'] != null
          ? CricketProfileModel.fromJson(json['cricketProfile'] as Map<String, dynamic>)
          : null,
      preferences: json['preferences'] != null
          ? UserPreferencesModel.fromJson(json['preferences'] as Map<String, dynamic>)
          : UserPreferencesModel.fromEntity(UserPreferences.defaultPreferences()),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'role': role.name,
      'status': status.name,
      'cricketProfile': cricketProfile != null
          ? (cricketProfile as CricketProfileModel).toJson()
          : null,
      'preferences': (preferences as UserPreferencesModel).toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create UserModel from UserEntity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      phoneNumber: entity.phoneNumber,
      profileImageUrl: entity.profileImageUrl,
      isEmailVerified: entity.isEmailVerified,
      isPhoneVerified: entity.isPhoneVerified,
      role: entity.role,
      status: entity.status,
      cricketProfile: entity.cricketProfile != null
          ? CricketProfileModel.fromEntity(entity.cricketProfile!)
          : null,
      preferences: UserPreferencesModel.fromEntity(entity.preferences),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Create a copy with updated fields
  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    UserRole? role,
    UserStatus? status,
    CricketProfile? cricketProfile,
    UserPreferences? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      role: role ?? this.role,
      status: status ?? this.status,
      cricketProfile: cricketProfile ?? this.cricketProfile,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Parse user role from string
  static UserRole _parseUserRole(String? roleString) {
    if (roleString == null) return UserRole.user;
    
    switch (roleString.toLowerCase()) {
      case 'premium':
        return UserRole.premium;
      case 'organizer':
        return UserRole.organizer;
      case 'moderator':
        return UserRole.moderator;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.user;
    }
  }

  /// Parse user status from string
  static UserStatus _parseUserStatus(String? statusString) {
    if (statusString == null) return UserStatus.active;
    
    switch (statusString.toLowerCase()) {
      case 'inactive':
        return UserStatus.inactive;
      case 'suspended':
        return UserStatus.suspended;
      case 'banned':
        return UserStatus.banned;
      default:
        return UserStatus.active;
    }
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $fullName, role: ${role.name})';
  }
}

/// Cricket Profile Data Model
class CricketProfileModel extends CricketProfile {
  const CricketProfileModel({
    required super.playerId,
    super.teamId,
    super.teamName,
    required super.preferredRole,
    required super.battingStyle,
    required super.bowlingStyle,
    required super.matchesPlayed,
    required super.runsScored,
    required super.wicketsTaken,
    required super.battingAverage,
    required super.bowlingAverage,
    required super.strikeRate,
    required super.economyRate,
    required super.centuries,
    required super.halfCenturies,
    required super.fiveWickets,
    required super.achievements,
    super.lastMatchDate,
  });

  /// Create CricketProfileModel from JSON
  factory CricketProfileModel.fromJson(Map<String, dynamic> json) {
    return CricketProfileModel(
      playerId: json['playerId'] as String,
      teamId: json['teamId'] as String?,
      teamName: json['teamName'] as String?,
      preferredRole: _parsePlayerRole(json['preferredRole'] as String?),
      battingStyle: _parseBattingStyle(json['battingStyle'] as String?),
      bowlingStyle: _parseBowlingStyle(json['bowlingStyle'] as String?),
      matchesPlayed: json['matchesPlayed'] as int? ?? 0,
      runsScored: json['runsScored'] as int? ?? 0,
      wicketsTaken: json['wicketsTaken'] as int? ?? 0,
      battingAverage: (json['battingAverage'] as num?)?.toDouble() ?? 0.0,
      bowlingAverage: (json['bowlingAverage'] as num?)?.toDouble() ?? 0.0,
      strikeRate: (json['strikeRate'] as num?)?.toDouble() ?? 0.0,
      economyRate: (json['economyRate'] as num?)?.toDouble() ?? 0.0,
      centuries: json['centuries'] as int? ?? 0,
      halfCenturies: json['halfCenturies'] as int? ?? 0,
      fiveWickets: json['fiveWickets'] as int? ?? 0,
      achievements: (json['achievements'] as List<dynamic>?)
          ?.map((a) => Achievement(
                id: a['id'] as String,
                title: a['title'] as String,
                description: a['description'] as String,
                iconUrl: a['iconUrl'] as String,
                achievedAt: DateTime.parse(a['achievedAt'] as String),
                type: _parseAchievementType(a['type'] as String?),
                metadata: a['metadata'] as Map<String, dynamic>? ?? {},
              ))
          .toList() ?? [],
      lastMatchDate: json['lastMatchDate'] != null
          ? DateTime.parse(json['lastMatchDate'] as String)
          : null,
    );
  }

  /// Convert CricketProfileModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'teamId': teamId,
      'teamName': teamName,
      'preferredRole': preferredRole.name,
      'battingStyle': battingStyle.name,
      'bowlingStyle': bowlingStyle.name,
      'matchesPlayed': matchesPlayed,
      'runsScored': runsScored,
      'wicketsTaken': wicketsTaken,
      'battingAverage': battingAverage,
      'bowlingAverage': bowlingAverage,
      'strikeRate': strikeRate,
      'economyRate': economyRate,
      'centuries': centuries,
      'halfCenturies': halfCenturies,
      'fiveWickets': fiveWickets,
      'achievements': achievements.map((a) => {
        'id': a.id,
        'title': a.title,
        'description': a.description,
        'iconUrl': a.iconUrl,
        'achievedAt': a.achievedAt.toIso8601String(),
        'type': a.type.name,
        'metadata': a.metadata,
      }).toList(),
      'lastMatchDate': lastMatchDate?.toIso8601String(),
    };
  }

  /// Create CricketProfileModel from CricketProfile entity
  factory CricketProfileModel.fromEntity(CricketProfile entity) {
    return CricketProfileModel(
      playerId: entity.playerId,
      teamId: entity.teamId,
      teamName: entity.teamName,
      preferredRole: entity.preferredRole,
      battingStyle: entity.battingStyle,
      bowlingStyle: entity.bowlingStyle,
      matchesPlayed: entity.matchesPlayed,
      runsScored: entity.runsScored,
      wicketsTaken: entity.wicketsTaken,
      battingAverage: entity.battingAverage,
      bowlingAverage: entity.bowlingAverage,
      strikeRate: entity.strikeRate,
      economyRate: entity.economyRate,
      centuries: entity.centuries,
      halfCenturies: entity.halfCenturies,
      fiveWickets: entity.fiveWickets,
      achievements: entity.achievements,
      lastMatchDate: entity.lastMatchDate,
    );
  }

  /// Parse player role from string
  static PlayerRole _parsePlayerRole(String? roleString) {
    if (roleString == null) return PlayerRole.batsman;
    
    switch (roleString.toLowerCase()) {
      case 'bowler':
        return PlayerRole.bowler;
      case 'allrounder':
        return PlayerRole.allRounder;
      case 'wicketkeeper':
        return PlayerRole.wicketKeeper;
      case 'captain':
        return PlayerRole.captain;
      default:
        return PlayerRole.batsman;
    }
  }

  /// Parse batting style from string
  static BattingStyle _parseBattingStyle(String? styleString) {
    if (styleString == null) return BattingStyle.rightHanded;
    
    switch (styleString.toLowerCase()) {
      case 'lefthanded':
        return BattingStyle.leftHanded;
      default:
        return BattingStyle.rightHanded;
    }
  }

  /// Parse bowling style from string
  static BowlingStyle _parseBowlingStyle(String? styleString) {
    if (styleString == null) return BowlingStyle.none;
    
    switch (styleString.toLowerCase()) {
      case 'rightarmfast':
        return BowlingStyle.rightArmFast;
      case 'leftarmfast':
        return BowlingStyle.leftArmFast;
      case 'rightarmspin':
        return BowlingStyle.rightArmSpin;
      case 'leftarmspin':
        return BowlingStyle.leftArmSpin;
      default:
        return BowlingStyle.none;
    }
  }

  /// Parse achievement type from string
  static AchievementType _parseAchievementType(String? typeString) {
    if (typeString == null) return AchievementType.milestone;
    
    switch (typeString.toLowerCase()) {
      case 'batting':
        return AchievementType.batting;
      case 'bowling':
        return AchievementType.bowling;
      case 'fielding':
        return AchievementType.fielding;
      case 'tournament':
        return AchievementType.tournament;
      case 'social':
        return AchievementType.social;
      case 'special':
        return AchievementType.special;
      default:
        return AchievementType.milestone;
    }
  }
}

/// User Preferences Data Model
class UserPreferencesModel extends UserPreferences {
  const UserPreferencesModel({
    required super.enableNotifications,
    required super.enablePushNotifications,
    required super.enableEmailNotifications,
    required super.enableSmsNotifications,
    required super.enableSoundEffects,
    required super.enableHapticFeedback,
    required super.preferredLanguage,
    required super.preferredTimeZone,
    required super.preferredDateFormat,
    required super.preferredTimeFormat,
    required super.enableDarkMode,
    required super.enableAutoTheme,
    required super.notificationSettings,
    required super.privacySettings,
  });

  /// Create UserPreferencesModel from JSON
  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      enablePushNotifications: json['enablePushNotifications'] as bool? ?? true,
      enableEmailNotifications: json['enableEmailNotifications'] as bool? ?? true,
      enableSmsNotifications: json['enableSmsNotifications'] as bool? ?? false,
      enableSoundEffects: json['enableSoundEffects'] as bool? ?? true,
      enableHapticFeedback: json['enableHapticFeedback'] as bool? ?? true,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      preferredTimeZone: json['preferredTimeZone'] as String? ?? 'UTC',
      preferredDateFormat: json['preferredDateFormat'] as String? ?? 'dd/MM/yyyy',
      preferredTimeFormat: json['preferredTimeFormat'] as String? ?? '24h',
      enableDarkMode: json['enableDarkMode'] as bool? ?? false,
      enableAutoTheme: json['enableAutoTheme'] as bool? ?? true,
      notificationSettings: json['notificationSettings'] != null
          ? NotificationSettingsModel.fromJson(json['notificationSettings'] as Map<String, dynamic>)
          : NotificationSettingsModel.fromEntity(NotificationSettings.defaultSettings()),
      privacySettings: json['privacySettings'] != null
          ? PrivacySettingsModel.fromJson(json['privacySettings'] as Map<String, dynamic>)
          : PrivacySettingsModel.fromEntity(PrivacySettings.defaultSettings()),
    );
  }

  /// Convert UserPreferencesModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'enableNotifications': enableNotifications,
      'enablePushNotifications': enablePushNotifications,
      'enableEmailNotifications': enableEmailNotifications,
      'enableSmsNotifications': enableSmsNotifications,
      'enableSoundEffects': enableSoundEffects,
      'enableHapticFeedback': enableHapticFeedback,
      'preferredLanguage': preferredLanguage,
      'preferredTimeZone': preferredTimeZone,
      'preferredDateFormat': preferredDateFormat,
      'preferredTimeFormat': preferredTimeFormat,
      'enableDarkMode': enableDarkMode,
      'enableAutoTheme': enableAutoTheme,
      'notificationSettings': (notificationSettings as NotificationSettingsModel).toJson(),
      'privacySettings': (privacySettings as PrivacySettingsModel).toJson(),
    };
  }

  /// Create UserPreferencesModel from UserPreferences entity
  factory UserPreferencesModel.fromEntity(UserPreferences entity) {
    return UserPreferencesModel(
      enableNotifications: entity.enableNotifications,
      enablePushNotifications: entity.enablePushNotifications,
      enableEmailNotifications: entity.enableEmailNotifications,
      enableSmsNotifications: entity.enableSmsNotifications,
      enableSoundEffects: entity.enableSoundEffects,
      enableHapticFeedback: entity.enableHapticFeedback,
      preferredLanguage: entity.preferredLanguage,
      preferredTimeZone: entity.preferredTimeZone,
      preferredDateFormat: entity.preferredDateFormat,
      preferredTimeFormat: entity.preferredTimeFormat,
      enableDarkMode: entity.enableDarkMode,
      enableAutoTheme: entity.enableAutoTheme,
      notificationSettings: NotificationSettingsModel.fromEntity(entity.notificationSettings),
      privacySettings: PrivacySettingsModel.fromEntity(entity.privacySettings),
    );
  }


}

/// Notification Settings Model
class NotificationSettingsModel extends NotificationSettings {
  const NotificationSettingsModel({
    required super.matchUpdates,
    required super.tournamentUpdates,
    required super.teamInvitations,
    required super.friendRequests,
    required super.achievements,
    required super.newsUpdates,
    required super.socialUpdates,
    required super.marketingEmails,
  });

  /// Create NotificationSettingsModel from JSON
  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      matchUpdates: json['matchUpdates'] as bool? ?? true,
      tournamentUpdates: json['tournamentUpdates'] as bool? ?? true,
      teamInvitations: json['teamInvitations'] as bool? ?? true,
      friendRequests: json['friendRequests'] as bool? ?? true,
      achievements: json['achievements'] as bool? ?? true,
      newsUpdates: json['newsUpdates'] as bool? ?? false,
      socialUpdates: json['socialUpdates'] as bool? ?? true,
      marketingEmails: json['marketingEmails'] as bool? ?? false,
    );
  }

  /// Convert NotificationSettingsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'matchUpdates': matchUpdates,
      'tournamentUpdates': tournamentUpdates,
      'teamInvitations': teamInvitations,
      'friendRequests': friendRequests,
      'achievements': achievements,
      'newsUpdates': newsUpdates,
      'socialUpdates': socialUpdates,
      'marketingEmails': marketingEmails,
    };
  }

  /// Create NotificationSettingsModel from NotificationSettings entity
  factory NotificationSettingsModel.fromEntity(NotificationSettings entity) {
    return NotificationSettingsModel(
      matchUpdates: entity.matchUpdates,
      tournamentUpdates: entity.tournamentUpdates,
      teamInvitations: entity.teamInvitations,
      friendRequests: entity.friendRequests,
      achievements: entity.achievements,
      newsUpdates: entity.newsUpdates,
      socialUpdates: entity.socialUpdates,
      marketingEmails: entity.marketingEmails,
    );
  }
}

/// Privacy Settings Model
class PrivacySettingsModel extends PrivacySettings {
  const PrivacySettingsModel({
    required super.profileVisibility,
    required super.statsVisibility,
    required super.matchHistoryVisibility,
    required super.allowFriendRequests,
    required super.allowTeamInvitations,
    required super.showOnlineStatus,
    required super.allowLocationSharing,
    required super.allowDataAnalytics,
  });

  /// Create PrivacySettingsModel from JSON
  factory PrivacySettingsModel.fromJson(Map<String, dynamic> json) {
    return PrivacySettingsModel(
      profileVisibility: json['profileVisibility'] as bool? ?? true,
      statsVisibility: json['statsVisibility'] as bool? ?? true,
      matchHistoryVisibility: json['matchHistoryVisibility'] as bool? ?? true,
      allowFriendRequests: json['allowFriendRequests'] as bool? ?? true,
      allowTeamInvitations: json['allowTeamInvitations'] as bool? ?? true,
      showOnlineStatus: json['showOnlineStatus'] as bool? ?? true,
      allowLocationSharing: json['allowLocationSharing'] as bool? ?? false,
      allowDataAnalytics: json['allowDataAnalytics'] as bool? ?? true,
    );
  }

  /// Convert PrivacySettingsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'profileVisibility': profileVisibility,
      'statsVisibility': statsVisibility,
      'matchHistoryVisibility': matchHistoryVisibility,
      'allowFriendRequests': allowFriendRequests,
      'allowTeamInvitations': allowTeamInvitations,
      'showOnlineStatus': showOnlineStatus,
      'allowLocationSharing': allowLocationSharing,
      'allowDataAnalytics': allowDataAnalytics,
    };
  }

  /// Create PrivacySettingsModel from PrivacySettings entity
  factory PrivacySettingsModel.fromEntity(PrivacySettings entity) {
    return PrivacySettingsModel(
      profileVisibility: entity.profileVisibility,
      statsVisibility: entity.statsVisibility,
      matchHistoryVisibility: entity.matchHistoryVisibility,
      allowFriendRequests: entity.allowFriendRequests,
      allowTeamInvitations: entity.allowTeamInvitations,
      showOnlineStatus: entity.showOnlineStatus,
      allowLocationSharing: entity.allowLocationSharing,
      allowDataAnalytics: entity.allowDataAnalytics,
    );
  }
}