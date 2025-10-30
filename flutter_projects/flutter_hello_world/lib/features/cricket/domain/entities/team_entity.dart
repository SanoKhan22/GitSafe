import 'package:equatable/equatable.dart';
import 'player_entity.dart';

/// Cricket Team Entity
/// 
/// Represents a cricket team with players, statistics, and match state
class TeamEntity extends Equatable {
  final String id;
  final String name;
  final String? shortName;
  final String? logoUrl;
  final String? description;
  final TeamType type;
  final String? homeVenue;
  final String? city;
  final String? country;
  
  // Team Management
  final String? captainId;
  final String? viceCaptainId;
  final String? coachId;
  final String? managerId;
  final String createdBy;
  
  // Players
  final List<PlayerEntity> players;
  final List<String> playerIds;
  final int maxPlayers;
  final int minPlayers;
  
  // Team Statistics
  final TeamStats stats;
  
  // Current Match State
  final TeamMatchState? currentMatchState;
  
  // Team Settings
  final TeamSettings settings;
  
  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final List<String> tags;

  const TeamEntity({
    required this.id,
    required this.name,
    this.shortName,
    this.logoUrl,
    this.description,
    required this.type,
    this.homeVenue,
    this.city,
    this.country,
    this.captainId,
    this.viceCaptainId,
    this.coachId,
    this.managerId,
    required this.createdBy,
    required this.players,
    required this.playerIds,
    this.maxPlayers = 15,
    this.minPlayers = 11,
    required this.stats,
    this.currentMatchState,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.tags = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        players,
        stats,
        isActive,
      ];

  /// Get team captain
  PlayerEntity? get captain {
    if (captainId == null) return null;
    try {
      return players.firstWhere((player) => player.id == captainId);
    } catch (e) {
      return null;
    }
  }

  /// Get team vice captain
  PlayerEntity? get viceCaptain {
    if (viceCaptainId == null) return null;
    try {
      return players.firstWhere((player) => player.id == viceCaptainId);
    } catch (e) {
      return null;
    }
  }

  /// Get active players
  List<PlayerEntity> get activePlayers {
    return players.where((player) => player.isActive).toList();
  }

  /// Get playing XI
  List<PlayerEntity> get playingXI {
    return players.where((player) => 
        player.currentMatchState?.isOnField == true).toList();
  }

  /// Get batsmen
  List<PlayerEntity> get batsmen {
    return players.where((player) => 
        player.preferredRole == PlayerRole.batsman ||
        player.preferredRole == PlayerRole.allRounder).toList();
  }

  /// Get bowlers
  List<PlayerEntity> get bowlers {
    return players.where((player) => 
        player.preferredRole == PlayerRole.bowler ||
        player.preferredRole == PlayerRole.allRounder).toList();
  }

  /// Get wicket keepers
  List<PlayerEntity> get wicketKeepers {
    return players.where((player) => player.isWicketKeeper).toList();
  }

  /// Get all rounders
  List<PlayerEntity> get allRounders {
    return players.where((player) => 
        player.preferredRole == PlayerRole.allRounder).toList();
  }

  /// Check if team has minimum players
  bool get hasMinimumPlayers => activePlayers.length >= minPlayers;

  /// Check if team is full
  bool get isFull => players.length >= maxPlayers;

  /// Get available spots
  int get availableSpots => maxPlayers - players.length;

  /// Get team strength analysis
  TeamStrength get teamStrength {
    final batsmenCount = batsmen.length;
    final bowlersCount = bowlers.length;
    final keepersCount = wicketKeepers.length;
    final allRoundersCount = allRounders.length;

    return TeamStrength(
      batting: _calculateStrengthRating(batsmenCount + allRoundersCount, 6),
      bowling: _calculateStrengthRating(bowlersCount + allRoundersCount, 5),
      fielding: _calculateStrengthRating(players.length, 11),
      wicketKeeping: _calculateStrengthRating(keepersCount, 1),
      overall: _calculateOverallStrength(),
    );
  }

  double _calculateStrengthRating(int count, int ideal) {
    if (count >= ideal) return 5.0;
    return (count / ideal) * 5.0;
  }

  double _calculateOverallStrength() {
    final strength = teamStrength;
    return (strength.batting + strength.bowling + 
            strength.fielding + strength.wicketKeeping) / 4;
  }

  /// Copy with method for immutable updates
  TeamEntity copyWith({
    String? id,
    String? name,
    String? shortName,
    String? logoUrl,
    String? description,
    TeamType? type,
    String? homeVenue,
    String? city,
    String? country,
    String? captainId,
    String? viceCaptainId,
    String? coachId,
    String? managerId,
    String? createdBy,
    List<PlayerEntity>? players,
    List<String>? playerIds,
    int? maxPlayers,
    int? minPlayers,
    TeamStats? stats,
    TeamMatchState? currentMatchState,
    TeamSettings? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    List<String>? tags,
  }) {
    return TeamEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      logoUrl: logoUrl ?? this.logoUrl,
      description: description ?? this.description,
      type: type ?? this.type,
      homeVenue: homeVenue ?? this.homeVenue,
      city: city ?? this.city,
      country: country ?? this.country,
      captainId: captainId ?? this.captainId,
      viceCaptainId: viceCaptainId ?? this.viceCaptainId,
      coachId: coachId ?? this.coachId,
      managerId: managerId ?? this.managerId,
      createdBy: createdBy ?? this.createdBy,
      players: players ?? this.players,
      playerIds: playerIds ?? this.playerIds,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      minPlayers: minPlayers ?? this.minPlayers,
      stats: stats ?? this.stats,
      currentMatchState: currentMatchState ?? this.currentMatchState,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      tags: tags ?? this.tags,
    );
  }
}

/// Team Type Enumeration
enum TeamType {
  club,
  school,
  corporate,
  friends,
  community,
  professional,
}

/// Team Statistics Entity
class TeamStats extends Equatable {
  final int matchesPlayed;
  final int matchesWon;
  final int matchesLost;
  final int matchesDrawn;
  final int matchesTied;
  final int matchesAbandoned;
  final double winPercentage;
  final int totalRuns;
  final int totalWickets;
  final int highestScore;
  final int lowestScore;
  final double averageScore;
  final int centuriesScored;
  final int halfCenturiesScored;
  final int fiveWicketHauls;
  final int tenWicketHauls;
  final DateTime? lastMatchDate;
  final String? lastMatchResult;

  const TeamStats({
    this.matchesPlayed = 0,
    this.matchesWon = 0,
    this.matchesLost = 0,
    this.matchesDrawn = 0,
    this.matchesTied = 0,
    this.matchesAbandoned = 0,
    this.winPercentage = 0.0,
    this.totalRuns = 0,
    this.totalWickets = 0,
    this.highestScore = 0,
    this.lowestScore = 0,
    this.averageScore = 0.0,
    this.centuriesScored = 0,
    this.halfCenturiesScored = 0,
    this.fiveWicketHauls = 0,
    this.tenWicketHauls = 0,
    this.lastMatchDate,
    this.lastMatchResult,
  });

  @override
  List<Object?> get props => [
        matchesPlayed,
        matchesWon,
        matchesLost,
        winPercentage,
        totalRuns,
        totalWickets,
      ];

  /// Calculate win percentage
  double get calculatedWinPercentage {
    if (matchesPlayed == 0) return 0.0;
    return (matchesWon / matchesPlayed) * 100;
  }

  /// Calculate average score
  double get calculatedAverageScore {
    if (matchesPlayed == 0) return 0.0;
    return totalRuns / matchesPlayed;
  }

  /// Get team form (last 5 matches)
  String get recentForm {
    // This would be calculated based on recent match results
    // For now, return a placeholder
    return 'WWLWW';
  }
}

/// Team Match State Entity
class TeamMatchState extends Equatable {
  final String matchId;
  final String teamId;
  final bool isBatting;
  final bool isBowling;
  final int runs;
  final int wickets;
  final double overs;
  final int ballsFaced;
  final int ballsBowled;
  final double runRate;
  final double requiredRunRate;
  final List<String> battingOrderIds;
  final List<String> bowlingOrderIds;
  final String? currentBowlerId;
  final List<String> currentBatsmenIds;
  final DateTime lastUpdated;

  const TeamMatchState({
    required this.matchId,
    required this.teamId,
    this.isBatting = false,
    this.isBowling = false,
    this.runs = 0,
    this.wickets = 0,
    this.overs = 0.0,
    this.ballsFaced = 0,
    this.ballsBowled = 0,
    this.runRate = 0.0,
    this.requiredRunRate = 0.0,
    this.battingOrderIds = const [],
    this.bowlingOrderIds = const [],
    this.currentBowlerId,
    this.currentBatsmenIds = const [],
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        matchId,
        teamId,
        isBatting,
        runs,
        wickets,
        overs,
        lastUpdated,
      ];

  /// Calculate current run rate
  double get calculatedRunRate {
    if (overs == 0) return 0.0;
    return runs / overs;
  }

  /// Get score display (e.g., "150/3")
  String get scoreDisplay => '$runs/$wickets';

  /// Get overs display (e.g., "15.3")
  String get oversDisplay {
    final completeOvers = overs.floor();
    final balls = ((overs - completeOvers) * 10).round();
    return balls == 0 ? '$completeOvers' : '$completeOvers.$balls';
  }
}

/// Team Settings Entity
class TeamSettings extends Equatable {
  final bool isPublic;
  final bool allowJoinRequests;
  final bool requireApproval;
  final int maxSubstitutes;
  final bool allowGuestPlayers;
  final Map<String, dynamic> customRules;
  final List<String> preferredFormats;
  final String? defaultVenue;
  final Map<String, bool> notifications;

  const TeamSettings({
    this.isPublic = true,
    this.allowJoinRequests = true,
    this.requireApproval = true,
    this.maxSubstitutes = 3,
    this.allowGuestPlayers = false,
    this.customRules = const {},
    this.preferredFormats = const [],
    this.defaultVenue,
    this.notifications = const {},
  });

  @override
  List<Object?> get props => [
        isPublic,
        allowJoinRequests,
        requireApproval,
        maxSubstitutes,
        allowGuestPlayers,
      ];
}

/// Team Strength Analysis
class TeamStrength extends Equatable {
  final double batting;
  final double bowling;
  final double fielding;
  final double wicketKeeping;
  final double overall;

  const TeamStrength({
    required this.batting,
    required this.bowling,
    required this.fielding,
    required this.wicketKeeping,
    required this.overall,
  });

  @override
  List<Object?> get props => [
        batting,
        bowling,
        fielding,
        wicketKeeping,
        overall,
      ];

  /// Get strength rating as stars (1-5)
  int get battingStars => (batting).round().clamp(1, 5);
  int get bowlingStars => (bowling).round().clamp(1, 5);
  int get fieldingStars => (fielding).round().clamp(1, 5);
  int get wicketKeepingStars => (wicketKeeping).round().clamp(1, 5);
  int get overallStars => (overall).round().clamp(1, 5);

  /// Get team balance assessment
  String get balanceAssessment {
    if (overall >= 4.0) return 'Excellent';
    if (overall >= 3.5) return 'Very Good';
    if (overall >= 3.0) return 'Good';
    if (overall >= 2.5) return 'Average';
    if (overall >= 2.0) return 'Below Average';
    return 'Needs Improvement';
  }
}