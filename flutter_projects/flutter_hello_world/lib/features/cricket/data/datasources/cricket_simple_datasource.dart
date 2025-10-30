import '../models/match_model.dart';
import '../models/score_model.dart';
import '../models/team_model.dart';
import '../models/player_model.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/entities/team_entity.dart';
import '../../domain/entities/score_entity.dart';
import '../../domain/entities/match_enums.dart';

/// Simple cricket data source for testing without complex dependencies
class CricketSimpleDataSource {
  
  /// Generate a simple mock match for testing
  static MatchModel generateSimpleMatch() {
    // Create simple players
    final team1Players = List.generate(11, (index) => PlayerModel(
      id: 'team1_player_${index + 1}',
      name: 'Player ${index + 1}',
      preferredRole: PlayerRole.allRounder,
      battingStyle: BattingStyle.rightHanded,
      bowlingStyle: BowlingStyle.rightArmMedium,
      careerStats: const PlayerStats(),
      seasonStats: const PlayerStats(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));

    final team2Players = List.generate(11, (index) => PlayerModel(
      id: 'team2_player_${index + 1}',
      name: 'Player ${index + 12}',
      preferredRole: PlayerRole.allRounder,
      battingStyle: BattingStyle.rightHanded,
      bowlingStyle: BowlingStyle.rightArmMedium,
      careerStats: const PlayerStats(),
      seasonStats: const PlayerStats(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));

    // Create teams
    final team1 = TeamModel(
      id: 'team_1',
      name: 'Team Alpha',
      players: team1Players,
      captainId: team1Players[0].id,
      createdAt: DateTime.now(),
      createdBy: 'system',
      playerIds: team1Players.map((p) => p.id).toList(),
      settings: const TeamSettings(),
      stats: const TeamStats(),
      type: TeamType.friends,
      updatedAt: DateTime.now(),
    );

    final team2 = TeamModel(
      id: 'team_2',
      name: 'Team Beta',
      players: team2Players,
      captainId: team2Players[0].id,
      createdAt: DateTime.now(),
      createdBy: 'system',
      playerIds: team2Players.map((p) => p.id).toList(),
      settings: const TeamSettings(),
      stats: const TeamStats(),
      type: TeamType.friends,
      updatedAt: DateTime.now(),
    );

    // Create match
    final now = DateTime.now();
    return MatchModel(
      id: 'match_1',
      title: 'Team Alpha vs Team Beta',
      description: 'Local cricket match',
      matchType: MatchType.local,
      status: MatchStatus.scheduled,
      createdAt: now,
      updatedAt: now,
      team1: team1,
      team2: team2,
      venue: 'Local Ground',
      startTime: now.add(const Duration(hours: 1)),
      overs: 20,
      playersPerTeam: 11,
      currentInning: 1,
      highlights: [],
      commentary: [],
      statistics: {},
      tags: ['local', 'friendly'],
      isPublic: true,
      allowSpectators: true,
      socialLinks: {},
      customRules: [],
    );
  }

  /// Generate simple scores for a match
  static List<ScoreModel> generateSimpleScores(String matchId) {
    return [
      ScoreModel(
        id: 'score_1',
        matchId: matchId,
        teamId: 'team_1',
        playerId: 'team1_player_1',
        runs: 45,
        ballsFaced: 30,
        fours: 6,
        sixes: 1,
        strikeRate: 150.0,
        isOut: false,
        timestamp: DateTime.now(),
        extras: {},
        isActive: true,
      ),
      ScoreModel(
        id: 'score_2',
        matchId: matchId,
        teamId: 'team_1',
        playerId: 'team1_player_2',
        runs: 23,
        ballsFaced: 18,
        fours: 3,
        sixes: 0,
        strikeRate: 127.8,
        isOut: true,
        dismissalType: WicketType.bowled,
        timestamp: DateTime.now(),
        extras: {},
        isActive: true,
      ),
    ];
  }

  /// Generate simple innings
  static List<InningModel> generateSimpleInnings(String matchId) {
    return [
      InningModel(
        id: 'inning_1',
        matchId: matchId,
        inningNumber: 1,
        battingTeamId: 'team_1',
        bowlingTeamId: 'team_2',
        runs: 150,
        wickets: 3,
        overs: 15.4,
        ballsFaced: 94,
        runRate: 9.68,
        requiredRunRate: 0.0,
        extras: {'wides': 5, 'noBalls': 2, 'byes': 3, 'legByes': 1},
        partnerships: [],
        fallOfWickets: [],
        bowlingFigures: {},
        battingOrder: [],
        powerplayOvers: {},
        commentary: [],
        startTime: DateTime.now().subtract(const Duration(hours: 2)),
        endTime: DateTime.now().subtract(const Duration(hours: 1)),
        isCompleted: true,
      ),
    ];
  }
}