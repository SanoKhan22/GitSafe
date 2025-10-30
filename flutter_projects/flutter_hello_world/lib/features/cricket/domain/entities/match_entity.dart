import 'package:equatable/equatable.dart';
import 'team_entity.dart';
import 'player_entity.dart';
import 'score_entity.dart';
import 'match_enums.dart';

/// Cricket Match Entity
/// 
/// Represents a cricket match with all its details, teams, and current state
class MatchEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final MatchType type;
  final MatchFormat format;
  final MatchStatus status;
  final DateTime createdAt;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? venue;
  final String? weather;
  final String createdBy;
  
  // Teams
  final TeamEntity team1;
  final TeamEntity team2;
  final String? tossWinner;
  final TossDecision? tossDecision;
  
  // Match Settings
  final int totalOvers;
  final int playersPerTeam;
  final bool isDLSEnabled;
  final bool isPowerplayEnabled;
  final MatchRules rules;
  
  // Current Match State
  final int currentInning;
  final String? battingTeamId;
  final String? bowlingTeamId;
  final InningEntity? inning1;
  final InningEntity? inning2;
  final MatchResult? result;
  
  // Statistics
  final int totalRuns;
  final int totalWickets;
  final double currentRunRate;
  final double requiredRunRate;
  final int ballsRemaining;
  final String? currentBatsman1Id;
  final String? currentBatsman2Id;
  final String? currentBowlerId;
  
  const MatchEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.format,
    required this.status,
    required this.createdAt,
    this.startTime,
    this.endTime,
    this.venue,
    this.weather,
    required this.createdBy,
    required this.team1,
    required this.team2,
    this.tossWinner,
    this.tossDecision,
    required this.totalOvers,
    required this.playersPerTeam,
    this.isDLSEnabled = false,
    this.isPowerplayEnabled = true,
    required this.rules,
    this.currentInning = 1,
    this.battingTeamId,
    this.bowlingTeamId,
    this.inning1,
    this.inning2,
    this.result,
    this.totalRuns = 0,
    this.totalWickets = 0,
    this.currentRunRate = 0.0,
    this.requiredRunRate = 0.0,
    this.ballsRemaining = 0,
    this.currentBatsman1Id,
    this.currentBatsman2Id,
    this.currentBowlerId,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        format,
        status,
        createdAt,
        team1,
        team2,
        currentInning,
        totalRuns,
        totalWickets,
      ];

  /// Check if match is live
  bool get isLive => status == MatchStatus.inProgress;

  /// Check if match is completed
  bool get isCompleted => status == MatchStatus.completed;

  /// Check if match can be started
  bool get canStart => status == MatchStatus.scheduled && 
                      team1.players.length >= playersPerTeam &&
                      team2.players.length >= playersPerTeam;

  /// Get current batting team
  TeamEntity? get currentBattingTeam {
    if (battingTeamId == null) return null;
    return battingTeamId == team1.id ? team1 : team2;
  }

  /// Get current bowling team
  TeamEntity? get currentBowlingTeam {
    if (bowlingTeamId == null) return null;
    return bowlingTeamId == team1.id ? team1 : team2;
  }

  /// Get current inning
  InningEntity? get currentInningEntity {
    return currentInning == 1 ? inning1 : inning2;
  }

  /// Get match duration
  Duration? get duration {
    if (startTime == null) return null;
    final end = endTime ?? DateTime.now();
    return end.difference(startTime!);
  }

  /// Copy with method for immutable updates
  MatchEntity copyWith({
    String? id,
    String? title,
    String? description,
    MatchType? type,
    MatchFormat? format,
    MatchStatus? status,
    DateTime? createdAt,
    DateTime? startTime,
    DateTime? endTime,
    String? venue,
    String? weather,
    String? createdBy,
    TeamEntity? team1,
    TeamEntity? team2,
    String? tossWinner,
    TossDecision? tossDecision,
    int? totalOvers,
    int? playersPerTeam,
    bool? isDLSEnabled,
    bool? isPowerplayEnabled,
    MatchRules? rules,
    int? currentInning,
    String? battingTeamId,
    String? bowlingTeamId,
    InningEntity? inning1,
    InningEntity? inning2,
    MatchResult? result,
    int? totalRuns,
    int? totalWickets,
    double? currentRunRate,
    double? requiredRunRate,
    int? ballsRemaining,
    String? currentBatsman1Id,
    String? currentBatsman2Id,
    String? currentBowlerId,
  }) {
    return MatchEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      format: format ?? this.format,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      venue: venue ?? this.venue,
      weather: weather ?? this.weather,
      createdBy: createdBy ?? this.createdBy,
      team1: team1 ?? this.team1,
      team2: team2 ?? this.team2,
      tossWinner: tossWinner ?? this.tossWinner,
      tossDecision: tossDecision ?? this.tossDecision,
      totalOvers: totalOvers ?? this.totalOvers,
      playersPerTeam: playersPerTeam ?? this.playersPerTeam,
      isDLSEnabled: isDLSEnabled ?? this.isDLSEnabled,
      isPowerplayEnabled: isPowerplayEnabled ?? this.isPowerplayEnabled,
      rules: rules ?? this.rules,
      currentInning: currentInning ?? this.currentInning,
      battingTeamId: battingTeamId ?? this.battingTeamId,
      bowlingTeamId: bowlingTeamId ?? this.bowlingTeamId,
      inning1: inning1 ?? this.inning1,
      inning2: inning2 ?? this.inning2,
      result: result ?? this.result,
      totalRuns: totalRuns ?? this.totalRuns,
      totalWickets: totalWickets ?? this.totalWickets,
      currentRunRate: currentRunRate ?? this.currentRunRate,
      requiredRunRate: requiredRunRate ?? this.requiredRunRate,
      ballsRemaining: ballsRemaining ?? this.ballsRemaining,
      currentBatsman1Id: currentBatsman1Id ?? this.currentBatsman1Id,
      currentBatsman2Id: currentBatsman2Id ?? this.currentBatsman2Id,
      currentBowlerId: currentBowlerId ?? this.currentBowlerId,
    );
  }
}

// Enums are imported from match_enums.dart

/// Match Rules Entity
class MatchRules extends Equatable {
  final int maxOversPerBowler;
  final int powerplayOvers;
  final bool allowWideDeliveries;
  final bool allowNoBalls;
  final bool allowByes;
  final bool allowLegByes;
  final int maxExtrasPerOver;
  final bool isDLSEnabled;
  final bool isTimerEnabled;
  final int? timePerOver; // in seconds
  final bool allowSubstitutions;
  final int maxSubstitutions;

  const MatchRules({
    required this.maxOversPerBowler,
    this.powerplayOvers = 6,
    this.allowWideDeliveries = true,
    this.allowNoBalls = true,
    this.allowByes = true,
    this.allowLegByes = true,
    this.maxExtrasPerOver = 10,
    this.isDLSEnabled = false,
    this.isTimerEnabled = false,
    this.timePerOver,
    this.allowSubstitutions = false,
    this.maxSubstitutions = 2,
  });

  @override
  List<Object?> get props => [
        maxOversPerBowler,
        powerplayOvers,
        allowWideDeliveries,
        allowNoBalls,
        allowByes,
        allowLegByes,
        maxExtrasPerOver,
        isDLSEnabled,
        isTimerEnabled,
        timePerOver,
        allowSubstitutions,
        maxSubstitutions,
      ];

  /// Get default rules for T20 format
  factory MatchRules.t20() {
    return const MatchRules(
      maxOversPerBowler: 4,
      powerplayOvers: 6,
      allowWideDeliveries: true,
      allowNoBalls: true,
      allowByes: true,
      allowLegByes: true,
      maxExtrasPerOver: 10,
      isDLSEnabled: false,
      isTimerEnabled: true,
      timePerOver: 90,
      allowSubstitutions: false,
      maxSubstitutions: 0,
    );
  }

  /// Get default rules for ODI format
  factory MatchRules.odi() {
    return const MatchRules(
      maxOversPerBowler: 10,
      powerplayOvers: 10,
      allowWideDeliveries: true,
      allowNoBalls: true,
      allowByes: true,
      allowLegByes: true,
      maxExtrasPerOver: 10,
      isDLSEnabled: true,
      isTimerEnabled: false,
      allowSubstitutions: true,
      maxSubstitutions: 2,
    );
  }

  /// Get default rules for custom format
  factory MatchRules.custom({
    required int maxOversPerBowler,
    int powerplayOvers = 6,
    bool allowWideDeliveries = true,
    bool allowNoBalls = true,
    bool allowByes = true,
    bool allowLegByes = true,
    int maxExtrasPerOver = 10,
    bool isDLSEnabled = false,
    bool isTimerEnabled = false,
    int? timePerOver,
    bool allowSubstitutions = false,
    int maxSubstitutions = 2,
  }) {
    return MatchRules(
      maxOversPerBowler: maxOversPerBowler,
      powerplayOvers: powerplayOvers,
      allowWideDeliveries: allowWideDeliveries,
      allowNoBalls: allowNoBalls,
      allowByes: allowByes,
      allowLegByes: allowLegByes,
      maxExtrasPerOver: maxExtrasPerOver,
      isDLSEnabled: isDLSEnabled,
      isTimerEnabled: isTimerEnabled,
      timePerOver: timePerOver,
      allowSubstitutions: allowSubstitutions,
      maxSubstitutions: maxSubstitutions,
    );
  }
}

/// Match Result Entity
class MatchResult extends Equatable {
  final String winnerTeamId;
  final ResultType resultType;
  final int? winMargin;
  final String? winMarginType; // runs, wickets, balls
  final String? manOfTheMatch;
  final String summary;
  final Map<String, dynamic>? additionalData;

  const MatchResult({
    required this.winnerTeamId,
    required this.resultType,
    this.winMargin,
    this.winMarginType,
    this.manOfTheMatch,
    required this.summary,
    this.additionalData,
  });

  @override
  List<Object?> get props => [
        winnerTeamId,
        resultType,
        winMargin,
        winMarginType,
        manOfTheMatch,
        summary,
      ];
}

// Forward declarations for related entities

