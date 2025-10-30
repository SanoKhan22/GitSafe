import '../../domain/entities/player_entity.dart';

/// Data model for Player
class PlayerModel extends PlayerEntity {
  const PlayerModel({
    required super.id,
    required super.name,
    required super.preferredRole,
    required super.battingStyle,
    required super.bowlingStyle,
    required super.careerStats,
    required super.seasonStats,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create PlayerModel from JSON
  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      preferredRole: PlayerRole.values.firstWhere(
        (e) => e.toString().split('.').last == (json['role'] ?? json['preferredRole']),
        orElse: () => PlayerRole.allRounder,
      ),
      battingStyle: BattingStyle.values.firstWhere(
        (e) => e.toString().split('.').last == json['battingStyle'],
        orElse: () => BattingStyle.rightHanded,
      ),
      bowlingStyle: BowlingStyle.values.firstWhere(
        (e) => e.toString().split('.').last == json['bowlingStyle'],
        orElse: () => BowlingStyle.rightArmMedium,
      ),
      careerStats: PlayerStats(
        matchesPlayed: json['careerStats']?['matchesPlayed'] as int? ?? 0,
        runsScored: json['careerStats']?['runsScored'] as int? ?? 0,
        ballsFaced: json['careerStats']?['ballsFaced'] as int? ?? 0,
        wicketsTaken: json['careerStats']?['wicketsTaken'] as int? ?? 0,
        ballsBowled: json['careerStats']?['ballsBowled'] as int? ?? 0,
        catches: json['careerStats']?['catches'] as int? ?? 0,
        stumpings: json['careerStats']?['stumpings'] as int? ?? 0,
        runOuts: json['careerStats']?['runOuts'] as int? ?? 0,
      ),
      seasonStats: PlayerStats(
        matchesPlayed: json['seasonStats']?['matchesPlayed'] as int? ?? 0,
        runsScored: json['seasonStats']?['runsScored'] as int? ?? 0,
        ballsFaced: json['seasonStats']?['ballsFaced'] as int? ?? 0,
        wicketsTaken: json['seasonStats']?['wicketsTaken'] as int? ?? 0,
        ballsBowled: json['seasonStats']?['ballsBowled'] as int? ?? 0,
        catches: json['seasonStats']?['catches'] as int? ?? 0,
        stumpings: json['seasonStats']?['stumpings'] as int? ?? 0,
        runOuts: json['seasonStats']?['runOuts'] as int? ?? 0,
      ),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  /// Convert PlayerModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': preferredRole.toString().split('.').last,
      'battingStyle': battingStyle.toString().split('.').last,
      'bowlingStyle': bowlingStyle.toString().split('.').last,
      'preferredRole': preferredRole.toString().split('.').last,
      'careerStats': {
        'matchesPlayed': careerStats.matchesPlayed,
        'runsScored': careerStats.runsScored,
        'ballsFaced': careerStats.ballsFaced,
        'wicketsTaken': careerStats.wicketsTaken,
        'ballsBowled': careerStats.ballsBowled,
        'catches': careerStats.catches,
        'stumpings': careerStats.stumpings,
        'runOuts': careerStats.runOuts,
      },
      'seasonStats': {
        'matchesPlayed': seasonStats.matchesPlayed,
        'runsScored': seasonStats.runsScored,
        'ballsFaced': seasonStats.ballsFaced,
        'wicketsTaken': seasonStats.wicketsTaken,
        'ballsBowled': seasonStats.ballsBowled,
        'catches': seasonStats.catches,
        'stumpings': seasonStats.stumpings,
        'runOuts': seasonStats.runOuts,
      },
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}