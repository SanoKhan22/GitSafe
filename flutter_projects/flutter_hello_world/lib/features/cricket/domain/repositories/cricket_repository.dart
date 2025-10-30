import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/match_entity.dart';
import '../entities/player_entity.dart';
import '../entities/team_entity.dart';
import '../entities/score_entity.dart';
import '../entities/match_enums.dart';

/// Cricket Repository Interface
/// 
/// Defines the contract for cricket data operations
/// Follows Clean Architecture principles with Either return types
abstract class CricketRepository {
  // Match Operations
  Future<Either<Failure, List<MatchEntity>>> getMatches({
    MatchStatus? status,
    String? userId,
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, MatchEntity>> getMatchById(String matchId);

  Future<Either<Failure, MatchEntity>> createMatch(MatchEntity match);

  Future<Either<Failure, MatchEntity>> updateMatch(MatchEntity match);

  Future<Either<Failure, void>> deleteMatch(String matchId);

  Future<Either<Failure, MatchEntity>> startMatch(String matchId);

  Future<Either<Failure, MatchEntity>> endMatch(String matchId, MatchResult result);

  Future<Either<Failure, List<MatchEntity>>> getLiveMatches();

  Future<Either<Failure, List<MatchEntity>>> getUpcomingMatches();

  Future<Either<Failure, List<MatchEntity>>> getCompletedMatches();

  // Team Operations
  Future<Either<Failure, List<TeamEntity>>> getTeams({
    String? userId,
    TeamType? type,
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, TeamEntity>> getTeamById(String teamId);

  Future<Either<Failure, TeamEntity>> createTeam(TeamEntity team);

  Future<Either<Failure, TeamEntity>> updateTeam(TeamEntity team);

  Future<Either<Failure, void>> deleteTeam(String teamId);

  Future<Either<Failure, TeamEntity>> addPlayerToTeam(String teamId, String playerId);

  Future<Either<Failure, TeamEntity>> removePlayerFromTeam(String teamId, String playerId);

  Future<Either<Failure, TeamEntity>> updateTeamCaptain(String teamId, String captainId);

  Future<Either<Failure, List<TeamEntity>>> searchTeams(String query);

  // Player Operations
  Future<Either<Failure, List<PlayerEntity>>> getPlayers({
    String? teamId,
    PlayerRole? role,
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, PlayerEntity>> getPlayerById(String playerId);

  Future<Either<Failure, PlayerEntity>> createPlayer(PlayerEntity player);

  Future<Either<Failure, PlayerEntity>> updatePlayer(PlayerEntity player);

  Future<Either<Failure, void>> deletePlayer(String playerId);

  Future<Either<Failure, PlayerEntity>> updatePlayerStats(String playerId, PlayerStats stats);

  Future<Either<Failure, List<PlayerEntity>>> searchPlayers(String query);

  Future<Either<Failure, List<PlayerEntity>>> getAvailablePlayers();

  // Score Operations
  Future<Either<Failure, ScoreEntity>> getMatchScore(String matchId);

  Future<Either<Failure, ScoreEntity>> updateScore(ScoreEntity score);

  Future<Either<Failure, ScoreEntity>> addBall(String matchId, BallEntity ball);

  Future<Either<Failure, ScoreEntity>> addWicket(String matchId, WicketEntity wicket);

  Future<Either<Failure, ScoreEntity>> completeOver(String matchId, OverEntity over);

  Future<Either<Failure, InningEntity>> getInning(String matchId, int inningNumber);

  Future<Either<Failure, InningEntity>> completeInning(String matchId, int inningNumber);

  // Statistics Operations
  Future<Either<Failure, PlayerStats>> getPlayerStats(String playerId);

  Future<Either<Failure, TeamStats>> getTeamStats(String teamId);

  Future<Either<Failure, List<PlayerEntity>>> getTopBatsmen({int limit = 10});

  Future<Either<Failure, List<PlayerEntity>>> getTopBowlers({int limit = 10});

  Future<Either<Failure, List<TeamEntity>>> getTopTeams({int limit = 10});

  Future<Either<Failure, Map<String, dynamic>>> getMatchStatistics(String matchId);

  // Live Updates
  Stream<MatchEntity> watchMatch(String matchId);

  Stream<ScoreEntity> watchScore(String matchId);

  Stream<List<MatchEntity>> watchLiveMatches();

  // Offline Support
  Future<Either<Failure, void>> syncOfflineData();

  Future<Either<Failure, List<MatchEntity>>> getOfflineMatches();

  Future<Either<Failure, void>> saveMatchOffline(MatchEntity match);
}

/// Parameters for creating a match
class CreateMatchParams {
  final String title;
  final String? description;
  final MatchType matchType;
  final TeamEntity team1;
  final TeamEntity team2;
  final String venue;
  final DateTime startTime;
  final DateTime? endTime;
  final int overs;
  final int playersPerTeam;
  final String? tossWinner;
  final TossDecision? tossDecision;
  final String? weather;
  final String? pitchCondition;
  final String? umpire1;
  final String? umpire2;
  final String? referee;
  final String? streamingUrl;
  final List<String>? tags;
  final bool? isPublic;
  final bool? allowSpectators;
  final int? maxSpectators;
  final double? entryFee;
  final double? prizePool;
  final String? sponsorInfo;
  final Map<String, String>? socialLinks;
  final List<String>? customRules;

  const CreateMatchParams({
    required this.title,
    this.description,
    required this.matchType,
    required this.team1,
    required this.team2,
    required this.venue,
    required this.startTime,
    this.endTime,
    required this.overs,
    required this.playersPerTeam,
    this.tossWinner,
    this.tossDecision,
    this.weather,
    this.pitchCondition,
    this.umpire1,
    this.umpire2,
    this.referee,
    this.streamingUrl,
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
}

/// Parameters for updating a match
class UpdateMatchParams {
  final String id;
  final String? title;
  final String? description;
  final MatchStatus? status;
  final String? venue;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? currentInning;
  final String? battingTeamId;
  final String? bowlingTeamId;
  final MatchResult? result;
  final String? weather;
  final String? pitchCondition;
  final String? streamingUrl;

  const UpdateMatchParams({
    required this.id,
    this.title,
    this.description,
    this.status,
    this.venue,
    this.startTime,
    this.endTime,
    this.currentInning,
    this.battingTeamId,
    this.bowlingTeamId,
    this.result,
    this.weather,
    this.pitchCondition,
    this.streamingUrl,
  });
}

/// Parameters for starting a match
class StartMatchParams {
  final String matchId;
  final String battingTeamId;
  final String bowlingTeamId;
  final String? tossWinner;
  final TossDecision? tossDecision;

  const StartMatchParams({
    required this.matchId,
    required this.battingTeamId,
    required this.bowlingTeamId,
    this.tossWinner,
    this.tossDecision,
  });
}

/// Parameters for ending a match
class EndMatchParams {
  final String matchId;
  final MatchResult result;

  const EndMatchParams({
    required this.matchId,
    required this.result,
  });
}

/// Parameters for updating score
class UpdateScoreParams {
  final String matchId;
  final String teamId;
  final String playerId;
  final int runs;
  final int ballsFaced;
  final int fours;
  final int sixes;
  final bool isOut;
  final String? dismissalType;
  final String? dismissedBy;
  final String? fielder;
  final int? overNumber;
  final int? ballNumber;

  const UpdateScoreParams({
    required this.matchId,
    required this.teamId,
    required this.playerId,
    required this.runs,
    required this.ballsFaced,
    required this.fours,
    required this.sixes,
    required this.isOut,
    this.dismissalType,
    this.dismissedBy,
    this.fielder,
    this.overNumber,
    this.ballNumber,
  });
}