import '../../domain/entities/team_entity.dart';
import '../../domain/entities/player_entity.dart';
import 'player_model.dart';

/// Data model for Team
class TeamModel extends TeamEntity {
  const TeamModel({
    required super.id,
    required super.name,
    super.shortName,
    super.logoUrl,
    super.captainId,
    required super.players,
    required super.createdAt,
    required super.createdBy,
    required super.playerIds,
    required super.settings,
    required super.stats,
    required super.type,
    required super.updatedAt,
  });

  /// Create TeamModel from JSON
  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['shortName'] as String?,
      logoUrl: json['logo'] as String?,
      captainId: json['captainId'] as String?,
      players: (json['players'] as List<dynamic>?)
          ?.map((player) => PlayerModel.fromJson(player as Map<String, dynamic>))
          .toList() ?? [],
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      createdBy: json['createdBy'] as String? ?? 'system',
      playerIds: (json['playerIds'] as List<dynamic>?)?.cast<String>() ?? [],
      settings: const TeamSettings(
        allowGuestPlayers: true,
        requireApproval: false,
        isPublic: true,
        allowJoinRequests: true,
      ),
      stats: const TeamStats(
        matchesPlayed: 0,
        matchesWon: 0,
        matchesLost: 0,
        matchesDrawn: 0,
        totalRuns: 0,
        totalWickets: 0,
        highestScore: 0,
        lowestScore: 0,
        averageScore: 0.0,
        winPercentage: 0.0,
      ),
      type: TeamType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => TeamType.friends,
      ),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  /// Convert TeamModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'logo': logoUrl,
      'captainId': captainId,
      'players': players.map((player) => {
        'id': player.id,
        'name': player.name,
        'role': player.preferredRole.toString().split('.').last,
      }).toList(),
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'playerIds': playerIds,
      'type': type.toString().split('.').last,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}