import 'package:flutter_hello_world/features/cricket/domain/entities/match_entity.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/team_entity.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/player_entity.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/score_entity.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/match_enums.dart';

/// Test helper class providing common test data and utilities
class CricketTestHelpers {
  // Test Players
  static final testPlayer1 = PlayerEntity(
    id: 'player1',
    name: 'John Doe',
    preferredRole: PlayerRole.batsman,
    battingStyle: BattingStyle.rightHanded,
    bowlingStyle: BowlingStyle.rightArmMedium,
    careerStats: const PlayerStats(),
    seasonStats: const PlayerStats(),
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static final testPlayer2 = PlayerEntity(
    id: 'player2',
    name: 'Jane Smith',
    preferredRole: PlayerRole.bowler,
    battingStyle: BattingStyle.leftHanded,
    bowlingStyle: BowlingStyle.leftArmSpin,
    careerStats: const PlayerStats(),
    seasonStats: const PlayerStats(),
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static final testPlayer3 = PlayerEntity(
    id: 'player3',
    name: 'Bob Johnson',
    preferredRole: PlayerRole.allRounder,
    battingStyle: BattingStyle.rightHanded,
    bowlingStyle: BowlingStyle.rightArmFast,
    careerStats: const PlayerStats(),
    seasonStats: const PlayerStats(),
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static final testPlayer4 = PlayerEntity(
    id: 'player4',
    name: 'Alice Brown',
    preferredRole: PlayerRole.wicketKeeper,
    battingStyle: BattingStyle.rightHanded,
    bowlingStyle: BowlingStyle.none,
    isWicketKeeper: true,
    careerStats: const PlayerStats(),
    seasonStats: const PlayerStats(),
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  // Test Teams
  static final testTeam1 = TeamEntity(
    id: 'team1',
    name: 'Team Alpha',
    type: TeamType.friends,
    createdBy: 'test_user',
    players: [testPlayer1, testPlayer2],
    playerIds: ['player1', 'player2'],
    stats: const TeamStats(),
    settings: const TeamSettings(),
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static final testTeam2 = TeamEntity(
    id: 'team2',
    name: 'Team Beta',
    type: TeamType.friends,
    createdBy: 'test_user',
    players: [testPlayer3, testPlayer4],
    playerIds: ['player3', 'player4'],
    stats: const TeamStats(),
    settings: const TeamSettings(),
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  static final testTeamWithFullSquad = TeamEntity(
    id: 'team_full',
    name: 'Full Squad Team',
    type: TeamType.friends,
    createdBy: 'test_user',
    players: List.generate(
      11,
      (index) => PlayerEntity(
        id: 'player_full_$index',
        name: 'Player ${index + 1}',
        preferredRole: PlayerRole.batsman,
        battingStyle: BattingStyle.rightHanded,
        bowlingStyle: BowlingStyle.rightArmMedium,
        careerStats: const PlayerStats(),
        seasonStats: const PlayerStats(),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      ),
    ),
    playerIds: List.generate(11, (index) => 'player_full_$index'),
    stats: const TeamStats(),
    settings: const TeamSettings(),
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  // Test Matches
  static final testScheduledMatch = MatchEntity(
    id: 'match_scheduled',
    title: 'Test Scheduled Match',
    description: 'A test match in scheduled state',
    type: MatchType.friendly,
    format: MatchFormat.t20,
    status: MatchStatus.scheduled,
    createdAt: DateTime(2024, 1, 1, 10, 0),
    startTime: DateTime(2024, 1, 1, 14, 0),
    venue: 'Test Cricket Ground',
    createdBy: 'test_user',
    team1: testTeam1,
    team2: testTeam2,
    totalOvers: 20,
    playersPerTeam: 11,
    rules: const MatchRules(maxOversPerBowler: 4),
  );

  static final testInProgressMatch = MatchEntity(
    id: 'match_in_progress',
    title: 'Test In Progress Match',
    description: 'A test match currently in progress',
    type: MatchType.friendly,
    format: MatchFormat.t20,
    status: MatchStatus.inProgress,
    createdAt: DateTime(2024, 1, 1, 10, 0),
    startTime: DateTime(2024, 1, 1, 14, 0),
    venue: 'Test Cricket Ground',
    createdBy: 'test_user',
    team1: testTeam1,
    team2: testTeam2,
    totalOvers: 20,
    playersPerTeam: 11,
    currentInning: 1,
    battingTeamId: 'team1',
    bowlingTeamId: 'team2',
    rules: const MatchRules(maxOversPerBowler: 4),
  );

  static final testCompletedMatch = MatchEntity(
    id: 'match_completed',
    title: 'Test Completed Match',
    description: 'A test match that has been completed',
    type: MatchType.friendly,
    format: MatchFormat.t20,
    status: MatchStatus.completed,
    createdAt: DateTime(2024, 1, 1, 10, 0),
    startTime: DateTime(2024, 1, 1, 14, 0),
    endTime: DateTime(2024, 1, 1, 18, 0),
    venue: 'Test Cricket Ground',
    createdBy: 'test_user',
    team1: testTeam1,
    team2: testTeam2,
    totalOvers: 20,
    playersPerTeam: 11,
    currentInning: 2,
    rules: const MatchRules(maxOversPerBowler: 4),
  );

  // Test Scores
  static final testScore = ScoreEntity(
    id: 'score1',
    matchId: 'match_in_progress',
    inningId: 'inning1',
    inningNumber: 1,
    battingTeamId: 'team1',
    bowlingTeamId: 'team2',
    runs: 45,
    wickets: 2,
    overs: 8.3,
    striker: 'player1',
    nonStriker: 'player2',
    bowler: 'player3',
    lastUpdated: DateTime(2024, 1, 1, 15, 30),
    lastUpdatedBy: 'test_user',
  );

  static final testBall = BallEntity(
    id: 'ball1',
    ballNumber: 1,
    overNumber: 1,
    bowlerId: 'player3',
    strikerId: 'player1',
    nonStrikerId: 'player2',
    runsScored: 4,
    ballType: BallType.normal,
    timestamp: DateTime(2024, 1, 1, 14, 15),
  );

  static final testOver = OverEntity(
    id: 'over1',
    overNumber: 1,
    bowlerId: 'player3',
    balls: [testBall],
    runs: 8,
    wickets: 0,
    extras: 0,
    startTime: DateTime(2024, 1, 1, 14, 15),
    endTime: DateTime(2024, 1, 1, 14, 18),
  );

  static final testInning = InningEntity(
    id: 'inning1',
    matchId: 'match_in_progress',
    inningNumber: 1,
    battingTeamId: 'team1',
    bowlingTeamId: 'team2',
    runs: 150,
    wickets: 3,
    overs: 18.4,
  );

  // Helper methods
  static List<MatchEntity> generateTestMatches(int count) {
    return List.generate(count, (index) {
      return MatchEntity(
        id: 'match_$index',
        title: 'Test Match ${index + 1}',
        description: 'Description for test match ${index + 1}',
        type: MatchType.friendly,
        format: index % 2 == 0 ? MatchFormat.t20 : MatchFormat.odi,
        status: _getRandomStatus(index),
        createdAt: DateTime.now().subtract(Duration(days: index)),
        startTime: DateTime.now().add(Duration(hours: index)),
        venue: 'Venue ${index + 1}',
        createdBy: 'user_$index',
        team1: testTeam1,
        team2: testTeam2,
        totalOvers: index % 2 == 0 ? 20 : 50,
        playersPerTeam: 11,
        rules: MatchRules(maxOversPerBowler: index % 2 == 0 ? 4 : 10),
      );
    });
  }

  static List<PlayerEntity> generateTestPlayers(int count) {
    return List.generate(count, (index) {
      return PlayerEntity(
        id: 'player_$index',
        name: 'Player ${index + 1}',
        preferredRole: PlayerRole.batsman,
        battingStyle: BattingStyle.rightHanded,
        bowlingStyle: BowlingStyle.rightArmMedium,
        careerStats: const PlayerStats(),
        seasonStats: const PlayerStats(),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );
    });
  }

  static List<TeamEntity> generateTestTeams(int count) {
    return List.generate(count, (index) {
      return TeamEntity(
        id: 'team_$index',
        name: 'Team ${String.fromCharCode(65 + index)}', // Team A, Team B, etc.
        type: TeamType.friends,
        createdBy: 'test_user',
        players: generateTestPlayers(11),
        playerIds: List.generate(11, (i) => 'player_${index}_$i'),
        stats: const TeamStats(),
        settings: const TeamSettings(),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );
    });
  }

  static MatchStatus _getRandomStatus(int index) {
    final statuses = [
      MatchStatus.scheduled,
      MatchStatus.inProgress,
      MatchStatus.completed,
      MatchStatus.cancelled,
    ];
    return statuses[index % statuses.length];
  }

  // Validation helpers
  static bool isValidMatch(MatchEntity match) {
    return match.title.isNotEmpty &&
        match.team1.id != match.team2.id &&
        match.totalOvers > 0 &&
        match.playersPerTeam > 0 &&
        match.playersPerTeam <= 11;
  }

  static bool isValidTeam(TeamEntity team) {
    return team.name.isNotEmpty &&
        team.players.isNotEmpty &&
        team.players.length <= 11;
  }

  static bool isValidPlayer(PlayerEntity player) {
    return player.name.isNotEmpty;
  }

  // Mock data generators for specific test scenarios
  static MatchEntity createMatchWithStatus(MatchStatus status) {
    return testScheduledMatch.copyWith(
      id: 'match_${status.toString().split('.').last}',
      status: status,
    );
  }

  static MatchEntity createMatchWithFormat(MatchFormat format) {
    return testScheduledMatch.copyWith(
      id: 'match_${format.toString().split('.').last}',
      format: format,
      totalOvers: format == MatchFormat.t20 ? 20 : 50,
    );
  }

  static TeamEntity createTeamWithPlayerCount(int playerCount) {
    return TeamEntity(
      id: 'team_${playerCount}_players',
      name: 'Team with $playerCount players',
      type: TeamType.friends,
      createdBy: 'test_user',
      players: generateTestPlayers(playerCount),
      playerIds: List.generate(playerCount, (i) => 'player_$i'),
      stats: const TeamStats(),
      settings: const TeamSettings(),
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );
  }

  // Error simulation helpers
  static Exception createNetworkException() {
    return Exception('Network connection failed');
  }

  static Exception createCacheException() {
    return Exception('Cache operation failed');
  }

  static Exception createValidationException(String message) {
    return Exception('Validation failed: $message');
  }
}