import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/entities/team_entity.dart';
import '../../domain/entities/score_entity.dart';
import '../../domain/repositories/cricket_repository.dart';
import '../datasources/cricket_simple_datasource.dart';
import '../models/match_model.dart';
import '../models/score_model.dart';

/// Simple implementation of CricketRepository for testing
class CricketSimpleRepository implements CricketRepository {
  final List<MatchModel> _matches = [];
  final List<ScoreModel> _scores = [];
  final List<InningModel> _innings = [];

  @override
  Future<Either<Failure, List<MatchEntity>>> getMatches() async {
    try {
      // If no matches, create a sample match
      if (_matches.isEmpty) {
        final sampleMatch = CricketSimpleDataSource.generateSimpleMatch();
        _matches.add(sampleMatch);
      }
      
      return Right(_matches);
    } catch (e) {
      return Left(ServerFailure('Failed to get matches: $e'));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> getMatch(String id) async {
    try {
      final match = _matches.where((m) => m.id == id).firstOrNull;
      if (match != null) {
        return Right(match);
      }
      return Left(NotFoundFailure('Match not found'));
    } catch (e) {
      return Left(ServerFailure('Failed to get match: $e'));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> createMatch(CreateMatchParams params) async {
    try {
      final match = MatchModel(
        id: 'match_${DateTime.now().millisecondsSinceEpoch}',
        title: params.title,
        description: params.description ?? '',
        matchType: params.matchType,
        status: MatchStatus.scheduled,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        team1: params.team1 as TeamModel,
        team2: params.team2 as TeamModel,
        venue: params.venue,
        startTime: params.startTime,
        endTime: params.endTime,
        overs: params.overs,
        playersPerTeam: params.playersPerTeam,
        currentInning: 1,
        highlights: [],
        commentary: [],
        statistics: {},
        tags: params.tags ?? [],
        isPublic: params.isPublic ?? true,
        allowSpectators: params.allowSpectators ?? true,
        socialLinks: params.socialLinks ?? {},
        customRules: params.customRules ?? [],
      );

      _matches.add(match);
      return Right(match);
    } catch (e) {
      return Left(ServerFailure('Failed to create match: $e'));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> updateMatch(UpdateMatchParams params) async {
    try {
      final index = _matches.indexWhere((m) => m.id == params.id);
      if (index == -1) {
        return Left(NotFoundFailure('Match not found'));
      }

      final existingMatch = _matches[index];
      final updatedMatch = existingMatch.copyWith(
        title: params.title,
        description: params.description,
        status: params.status,
        venue: params.venue,
        startTime: params.startTime,
        endTime: params.endTime,
        currentInning: params.currentInning,
        battingTeamId: params.battingTeamId,
        bowlingTeamId: params.bowlingTeamId,
        result: params.result,
        updatedAt: DateTime.now(),
      );

      _matches[index] = updatedMatch;
      return Right(updatedMatch);
    } catch (e) {
      return Left(ServerFailure('Failed to update match: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMatch(String id) async {
    try {
      _matches.removeWhere((m) => m.id == id);
      _scores.removeWhere((s) => s.matchId == id);
      _innings.removeWhere((i) => i.matchId == id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to delete match: $e'));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> startMatch(StartMatchParams params) async {
    try {
      final index = _matches.indexWhere((m) => m.id == params.matchId);
      if (index == -1) {
        return Left(NotFoundFailure('Match not found'));
      }

      final match = _matches[index];
      if (match.status != MatchStatus.scheduled) {
        return Left(ValidationFailure('Match is not in scheduled state'));
      }

      final updatedMatch = match.copyWith(
        status: MatchStatus.inProgress,
        battingTeamId: params.battingTeamId,
        bowlingTeamId: params.bowlingTeamId,
        tossWinner: params.tossWinner,
        tossDecision: params.tossDecision,
        updatedAt: DateTime.now(),
      );

      _matches[index] = updatedMatch;

      // Create first inning
      final inning1 = InningModel(
        id: 'inning_${params.matchId}_1',
        matchId: params.matchId,
        inningNumber: 1,
        battingTeamId: params.battingTeamId,
        bowlingTeamId: params.bowlingTeamId,
        runs: 0,
        wickets: 0,
        overs: 0.0,
        ballsFaced: 0,
        runRate: 0.0,
        requiredRunRate: 0.0,
        extras: {},
        partnerships: [],
        fallOfWickets: [],
        bowlingFigures: {},
        battingOrder: [],
        powerplayOvers: {},
        commentary: [],
        startTime: DateTime.now(),
        isCompleted: false,
      );

      _innings.add(inning1);

      return Right(updatedMatch.copyWith(inning1Id: inning1.id));
    } catch (e) {
      return Left(ServerFailure('Failed to start match: $e'));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> endMatch(String matchId, MatchResult result) async {
    try {
      final index = _matches.indexWhere((m) => m.id == matchId);
      if (index == -1) {
        return Left(NotFoundFailure('Match not found'));
      }

      final match = _matches[index];
      if (match.status != MatchStatus.live) {
        return Left(ValidationFailure('Match is not in progress'));
      }

      final updatedMatch = match.copyWith(
        status: MatchStatus.completed,
        result: result,
        endTime: DateTime.now(),
      );

      _matches[index] = updatedMatch;
      return Right(updatedMatch);
    } catch (e) {
      return Left(ServerFailure('Failed to end match: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TeamEntity>>> getTeams({
    String? userId,
    TeamType? type,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final teams = <TeamEntity>[];
      for (final match in _matches) {
        if (!teams.any((t) => t.id == match.team1.id)) {
          teams.add(match.team1);
        }
        if (!teams.any((t) => t.id == match.team2.id)) {
          teams.add(match.team2);
        }
      }
      
      // If no teams, create sample teams
      if (teams.isEmpty) {
        final sampleMatch = CricketSimpleDataSource.generateSimpleMatch();
        teams.addAll([sampleMatch.team1, sampleMatch.team2]);
      }
      
      return Right(teams);
    } catch (e) {
      return Left(ServerFailure('Failed to get teams: $e'));
    }
  }

  @override
  Future<Either<Failure, TeamEntity>> getTeam(String id) async {
    try {
      final teamsResult = await getTeams();
      return teamsResult.fold(
        (failure) => Left(failure),
        (teams) {
          final team = teams.where((t) => t.id == id).firstOrNull;
          if (team != null) {
            return Right(team);
          }
          return Left(NotFoundFailure('Team not found'));
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get team: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PlayerEntity>>> getPlayers({
    String? teamId,
    String? userId,
    PlayerRole? role,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final teamsResult = await getTeams();
      return teamsResult.fold(
        (failure) => Left(failure),
        (teams) {
          final players = <PlayerEntity>[];
          for (final team in teams) {
            players.addAll(team.players);
          }
          return Right(players);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get players: $e'));
    }
  }

  @override
  Future<Either<Failure, PlayerEntity>> getPlayer(String id) async {
    try {
      final playersResult = await getPlayers();
      return playersResult.fold(
        (failure) => Left(failure),
        (players) {
          final player = players.where((p) => p.id == id).firstOrNull;
          if (player != null) {
            return Right(player);
          }
          return Left(NotFoundFailure('Player not found'));
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get player: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ScoreEntity>>> getMatchScores(String matchId) async {
    try {
      final matchScores = _scores.where((s) => s.matchId == matchId).toList();
      
      // If no scores, generate sample scores
      if (matchScores.isEmpty) {
        final sampleScores = CricketSimpleDataSource.generateSimpleScores(matchId);
        _scores.addAll(sampleScores);
        return Right(sampleScores);
      }
      
      return Right(matchScores);
    } catch (e) {
      return Left(ServerFailure('Failed to get match scores: $e'));
    }
  }

  @override
  Future<Either<Failure, ScoreEntity>> updateScore(ScoreEntity score) async {
    try {
      final existingIndex = _scores.indexWhere(
        (s) => s.id == score.id,
      );
      
      if (existingIndex != -1) {
        // Update existing score
        _scores[existingIndex] = score;
        return Right(score);
      } else {
        // Create new score
        return Right(score);
      }
    } catch (e) {
      return Left(ServerFailure('Failed to update score: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPlayerStatistics(String playerId) async {
    try {
      final playerResult = await getPlayer(playerId);
      return playerResult.fold(
        (failure) => Left(failure),
        (player) => Right({}),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get player statistics: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getTeamStatistics(String teamId) async {
    try {
      final teamResult = await getTeam(teamId);
      return teamResult.fold(
        (failure) => Left(failure),
        (team) => Right({}),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get team statistics: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMatchStatistics(String matchId) async {
    try {
      final match = _matches.where((m) => m.id == matchId).firstOrNull;
      if (match == null) {
        return Left(NotFoundFailure('Match not found'));
      }
      
      return Right({});
    } catch (e) {
      return Left(ServerFailure('Failed to get match statistics: $e'));
    }
  }
}

/// Extension to add firstOrNull method for older Dart versions
extension FirstWhereOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }
}