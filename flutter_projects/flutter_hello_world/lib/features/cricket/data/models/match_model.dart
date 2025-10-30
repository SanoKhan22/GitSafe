import 'package:equatable/equatable.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/team_entity.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/entities/match_enums.dart' as enums;
import 'team_model.dart';
import 'player_model.dart';

/// Data model for Match
class MatchModel {
  final String id;
  final String title;
  final String description;
  final enums.MatchType matchType;
  final enums.MatchStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TeamEntity team1;
  final TeamEntity team2;
  final String venue;
  final DateTime startTime;
  final DateTime? endTime;
  final int overs;
  final int playersPerTeam;
  final int currentInning;
  final String? battingTeamId;
  final String? bowlingTeamId;
  final String? inning1Id;
  final String? inning2Id;
  final enums.MatchResult? result;
  final String? tossWinner;
  final enums.TossDecision? tossDecision;
  final String? weather;
  final String? pitchCondition;
  final String? umpire1;
  final String? umpire2;
  final String? referee;
  final String? streamingUrl;
  final List<String>? highlights;
  final List<String>? commentary;
  final Map<String, dynamic>? statistics;
  final List<String>? tags;
  final bool? isPublic;
  final bool? allowSpectators;
  final int? maxSpectators;
  final double? entryFee;
  final double? prizePool;
  final String? sponsorInfo;
  final Map<String, String>? socialLinks;
  final List<String>? customRules;

  const MatchModel({
    required this.id,
    required this.title,
    required this.description,
    required this.matchType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.team1,
    required this.team2,
    required this.venue,
    required this.startTime,
    this.endTime,
    required this.overs,
    required this.playersPerTeam,
    required this.currentInning,
    this.battingTeamId,
    this.bowlingTeamId,
    this.inning1Id,
    this.inning2Id,
    this.result,
    this.tossWinner,
    this.tossDecision,
    this.weather,
    this.pitchCondition,
    this.umpire1,
    this.umpire2,
    this.referee,
    this.streamingUrl,
    this.highlights,
    this.commentary,
    this.statistics,
    this.tags,
    this.isPublic,
    this.allowSpectators,
    this.maxSpectators,
    this.entryFee,
    this.prizePool,
    this.sponsorInfo,
    this.socialLinks,
    this.customRules,
  });

  /// Create MatchModel from JSON
  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      matchType: enums.MatchType.values.firstWhere(
        (e) => e.toString().split('.').last == json['matchType'],
        orElse: () => enums.MatchType.local,
      ),
      status: enums.MatchStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => enums.MatchStatus.scheduled,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      team1: TeamModel.fromJson(json['team1'] as Map<String, dynamic>),
      team2: TeamModel.fromJson(json['team2'] as Map<String, dynamic>),
      venue: json['venue'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      overs: json['overs'] as int,
      playersPerTeam: json['playersPerTeam'] as int,
      currentInning: json['currentInning'] as int,
      battingTeamId: json['battingTeamId'] as String?,
      bowlingTeamId: json['bowlingTeamId'] as String?,
      inning1Id: json['inning1Id'] as String?,
      inning2Id: json['inning2Id'] as String?,
      result: json['result'] != null
          ? enums.MatchResult.values.firstWhere(
              (e) => e.toString().split('.').last == json['result'],
              orElse: () => enums.MatchResult.noResult,
            )
          : null,
      tossWinner: json['tossWinner'] as String?,
      tossDecision: json['tossDecision'] != null
          ? enums.TossDecision.values.firstWhere(
              (e) => e.toString().split('.').last == json['tossDecision'],
              orElse: () => enums.TossDecision.bat,
            )
          : null,
      weather: json['weather'] as String?,
      pitchCondition: json['pitchCondition'] as String?,
      umpire1: json['umpire1'] as String?,
      umpire2: json['umpire2'] as String?,
      referee: json['referee'] as String?,
      streamingUrl: json['streamingUrl'] as String?,
      highlights: (json['highlights'] as List<dynamic>?)?.cast<String>() ?? [],
      commentary: (json['commentary'] as List<dynamic>?)?.cast<String>() ?? [],
      statistics: json['statistics'] as Map<String, dynamic>? ?? {},
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      isPublic: json['isPublic'] as bool? ?? true,
      allowSpectators: json['allowSpectators'] as bool? ?? true,
      maxSpectators: json['maxSpectators'] as int?,
      entryFee: json['entryFee'] as double?,
      prizePool: json['prizePool'] as double?,
      sponsorInfo: json['sponsorInfo'] as String?,
      socialLinks: json['socialLinks'] as Map<String, String>? ?? {},
      customRules: (json['customRules'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  /// Convert MatchModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'matchType': matchType.toString().split('.').last,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'team1': (team1 as TeamModel).toJson(),
      'team2': (team2 as TeamModel).toJson(),
      'venue': venue,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'overs': overs,
      'playersPerTeam': playersPerTeam,
      'currentInning': currentInning,
      'battingTeamId': battingTeamId,
      'bowlingTeamId': bowlingTeamId,
      'inning1Id': inning1Id,
      'inning2Id': inning2Id,
      'result': result?.toString().split('.').last,
      'tossWinner': tossWinner,
      'tossDecision': tossDecision?.toString().split('.').last,
      'weather': weather,
      'pitchCondition': pitchCondition,
      'umpire1': umpire1,
      'umpire2': umpire2,
      'referee': referee,
      'streamingUrl': streamingUrl,
      'highlights': highlights,
      'commentary': commentary,
      'statistics': statistics,
      'tags': tags,
      'isPublic': isPublic,
      'allowSpectators': allowSpectators,
      'maxSpectators': maxSpectators,
      'entryFee': entryFee,
      'prizePool': prizePool,
      'sponsorInfo': sponsorInfo,
      'socialLinks': socialLinks,
      'customRules': customRules,
    };
  }

  /// Create a copy with updated fields
  @override
  MatchModel copyWith({
    String? id,
    String? title,
    String? description,
    enums.MatchType? matchType,
    enums.MatchStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    TeamEntity? team1,
    TeamEntity? team2,
    String? venue,
    DateTime? startTime,
    DateTime? endTime,
    int? overs,
    int? playersPerTeam,
    int? currentInning,
    String? battingTeamId,
    String? bowlingTeamId,
    String? inning1Id,
    String? inning2Id,
    enums.MatchResult? result,
    String? tossWinner,
    enums.TossDecision? tossDecision,
    String? weather,
    String? pitchCondition,
    String? umpire1,
    String? umpire2,
    String? referee,
    String? streamingUrl,
    List<String>? highlights,
    List<String>? commentary,
    Map<String, dynamic>? statistics,
    List<String>? tags,
    bool? isPublic,
    bool? allowSpectators,
    int? maxSpectators,
    double? entryFee,
    double? prizePool,
    String? sponsorInfo,
    Map<String, String>? socialLinks,
    List<String>? customRules,
    int? ballsRemaining,
  }) {
    return MatchModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      matchType: matchType ?? this.matchType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      team1: team1 ?? this.team1,
      team2: team2 ?? this.team2,
      venue: venue ?? this.venue,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      overs: overs ?? this.overs,
      playersPerTeam: playersPerTeam ?? this.playersPerTeam,
      currentInning: currentInning ?? this.currentInning,
      battingTeamId: battingTeamId ?? this.battingTeamId,
      bowlingTeamId: bowlingTeamId ?? this.bowlingTeamId,
      inning1Id: inning1Id ?? this.inning1Id,
      inning2Id: inning2Id ?? this.inning2Id,
      result: result ?? this.result,
      tossWinner: tossWinner ?? this.tossWinner,
      tossDecision: tossDecision ?? this.tossDecision,
      weather: weather ?? this.weather,
      pitchCondition: pitchCondition ?? this.pitchCondition,
      umpire1: umpire1 ?? this.umpire1,
      umpire2: umpire2 ?? this.umpire2,
      referee: referee ?? this.referee,
      streamingUrl: streamingUrl ?? this.streamingUrl,
      highlights: highlights ?? this.highlights,
      commentary: commentary ?? this.commentary,
      statistics: statistics ?? this.statistics,
      tags: tags ?? this.tags,
      isPublic: isPublic ?? this.isPublic,
      allowSpectators: allowSpectators ?? this.allowSpectators,
      maxSpectators: maxSpectators ?? this.maxSpectators,
      entryFee: entryFee ?? this.entryFee,
      prizePool: prizePool ?? this.prizePool,
      sponsorInfo: sponsorInfo ?? this.sponsorInfo,
      socialLinks: socialLinks ?? this.socialLinks,
      customRules: customRules ?? this.customRules,
    );
  }
}

// TeamModel and PlayerModel are defined in separate files