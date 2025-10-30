import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/entities/team_entity.dart';
import '../../domain/entities/score_entity.dart';
import '../../domain/repositories/cricket_repository.dart';
import '../datasources/cricket_local_datasource.dart';
import '../datasources/cricket_mock_datasource.dart';
import '../models/match_model.dart';
import '../models/score_model.dart';

/// Implementation of CricketRepository
class CricketRepositoryImpl implements CricketRepository {
  final CricketLocalDataSource localDataSource;
  final CricketMockDataSource mockDataSource;
  final NetworkInfo networkInfo;

  const CricketRepositoryImpl({
    required this.localDataSource,
    required this.mockDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MatchEntity>>> getMatches() async {
    try {
      // Try to get matches from local storage first
      final localMatches = await localDataSource.getMatches();
      
      if (localMatches.isNotEmpty) {
        return Right(localMatches);
      }
      
      // If no local matches, generate mock data
      final mockMatches = mockDataSource.generateMockMatches(count: 5);
      
      // Save mock matches to local storage for future use
      for (final match in mockMatches) {
        await localDataSource.saveMatch(match);
      }
      
      return Right(mockMatches);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get matches: $e'));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> getMatch(String id) async {
    try {
      final match = await localDataSource.getMatch(id);
      
      if (match != null) {
        return Right(match);
      }
      
      return Left(NotFoundFailure('Match not found'));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get match: $e'));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> createMatch(CreateMatchParams params) async {
    try {
      // Validate input parameters
      final validationResult = _validateCreateMatchParams(params);
      if (validationResult != null) {
        return Left(ValidationFailure(validationResult));
      }

      // Create match model
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
        battingTeamId: null,
        bowlingTeamId: null,
        inning1Id: null,
        inning2Id: null,
        result: null,
        tossWinner: params.tossWinner,
        tossDecision: params.tossDecision,
        weather: params.weather,
        pitchCondition: params.pitchCondition,
        umpire1: params.umpire1,
        umpire2: params.umpire2,
        referee: params.referee,
        streamingUrl: params.streamingUrl,
        highlights: [],
        commentary: [],
        statistics: {},
        tags: params.tags ?? [],
        isPublic: params.isPublic ?? true,
        allowSpectators: params.allowSpectators ?? true,
        maxSpectators: params.maxSpectators,
        entryFee: params.entryFee,
        prizePool: params.prizePool,
        sponsorInfo: params.sponsorInfo,
        socialLinks: params.socialLinks ?? {},
        customRules: params.customRules ?? [],
      );

      // Save to local storage
      await localDataSource.saveMatch(match);

      return Right(match);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to create match: $e'));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> updateMatch(UpdateMatchParams params) async {
    try {
      // Get existing match
      final existingMatch = await localDataSource.getMatch(params.id);
      if (existingMatch == null) {
        return Left(NotFoundFailure('Match not found'));
      }

      // Update match with new data
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
        weather: params.weather,
        pitchCondition: params.pitchCondition,
        streamingUrl: params.streamingUrl,
        updatedAt: DateTime.now(),
      );

      // Save updated match
      await localDataSource.updateMatch(updatedMatch);

      return Right(updatedMatch);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update match: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMatch(String id) async {
    try {
      await localDataSource.deleteMatch(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to delete match: $e'));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> startMatch(StartMatchParams params) async {
    try {
      final match = await localDataSource.getMatch(params.matchId);
      if (match == null) {
        return Left(NotFoundFailure('Match not found'));
      }

      if (match.status != MatchStatus.scheduled) {
        return Left(ValidationFailure('Match is not in scheduled state'));
      }

      // Update match to in progress
      final updatedMatch = match.copyWith(
        status: MatchStatus.inProgress,
        battingTeamId: params.battingTeamId,
        bowlingTeamId: params.bowlingTeamId,
        tossWinner: params.tossWinner,
        tossDecision: params.tossDecision,
        updatedAt: DateTime.now(),
      );

      await localDataSource.updateMatch(updatedMatch);

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
        target: null,
        result: null,
        extras: {},
        partnerships: [],
        fallOfWickets: [],
        bowlingFigures: {},
        battingOrder: [],
        powerplayOvers: {},
        commentary: [],
        startTime: DateTime.now(),
        endTime: null,
        isCompleted: false,
      );

      await localDataSource.saveInning(inning1);

      return Right(updatedMatch.copyWith(inning1Id: inning1.id));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to start match: $e'));
    }
  }

  @override
  Future<Either<Failure, MatchEntity>> endMatch(EndMatchParams params) async {
    try {
      final match = await localDataSource.getMatch(params.matchId);
      if (match == null) {
        return Left(NotFoundFailure('Match not found'));
      }

      if (match.status != MatchStatus.inProgress) {
        return Left(ValidationFailure('Match is not in progress'));
      }

      final updatedMatch = match.copyWith(
        status: MatchStatus.completed,
        result: params.result,
        endTime: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await localDataSource.updateMatch(updatedMatch);

      return Right(updatedMatch);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to end match: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TeamEntity>>> getTeams() async {
    try {
      // Get teams from matches
      final matches = await localDataSource.getMatches();
      final teams = <TeamEntity>[];
      
      for (final match in matches) {
        if (!teams.any((t) => t.id == match.team1.id)) {
          teams.add(match.team1);
        }
        if (!teams.any((t) => t.id == match.team2.id)) {
          teams.add(match.team2);
        }
      }
      
      // If no teams found, generate mock teams
      if (teams.isEmpty) {
        final mockMatches = mockDataSource.generateMockMatches(count: 2);
        teams.addAll([mockMatches[0].team1, mockMatches[0].team2]);
      }
      
      return Right(teams);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get teams: $e'));
    }
  }

  @override
  Future<Either<Failure, TeamEntity>> getTeam(String id) async {
    try {
      final teams = await getTeams();
      return teams.fold(
        (failure) => Left(failure),
        (teamsList) {
          final team = teamsList.where((t) => t.id == id).firstOrNull;
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
  Future<Either<Failure, List<PlayerEntity>>> getPlayers() async {
    try {
      final teams = await getTeams();
      return teams.fold(
        (failure) => Left(failure),
        (teamsList) {
          final players = <PlayerEntity>[];
          for (final team in teamsList) {
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
      final players = await getPlayers();
      return players.fold(
        (failure) => Left(failure),
        (playersList) {
          final player = playersList.where((p) => p.id == id).firstOrNull;
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
      final scores = await localDataSource.getMatchScores(matchId);
      
      if (scores.isNotEmpty) {
        return Right(scores);
      }
      
      // Generate mock scores if none exist
      final match = await localDataSource.getMatch(matchId);
      if (match != null) {
        final allPlayers = [...match.team1.players, ...match.team2.players];
        final playerIds = allPlayers.map((p) => p.id).toList();
        final mockScores = mockDataSource.generateMockScores(matchId, playerIds);
        
        // Save mock scores
        for (final score in mockScores) {
          await localDataSource.saveScore(score);
        }
        
        return Right(mockScores);
      }
      
      return const Right([]);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get match scores: $e'));
    }
  }

  @override
  Future<Either<Failure, ScoreEntity>> updateScore(UpdateScoreParams params) async {
    try {
      final existingScores = await localDataSource.getMatchScores(params.matchId);
      final existingScore = existingScores.where((s) => s.playerId == params.playerId).firstOrNull;
      
      if (existingScore != null) {
        // Update existing score
        final updatedScore = existingScore.copyWith(
          runs: params.runs,
          ballsFaced: params.ballsFaced,
          fours: params.fours,
          sixes: params.sixes,
          strikeRate: params.ballsFaced > 0 ? (params.runs / params.ballsFaced) * 100 : 0.0,
          isOut: params.isOut,
          dismissalType: params.dismissalType,
          dismissedBy: params.dismissedBy,
          fielder: params.fielder,
          timestamp: DateTime.now(),
        );
        
        await localDataSource.updateScore(updatedScore);
        return Right(updatedScore);
      } else {
        // Create new score
        final newScore = ScoreModel(
          id: 'score_${params.matchId}_${params.playerId}',
          matchId: params.matchId,
          teamId: params.teamId,
          playerId: params.playerId,
          runs: params.runs,
          ballsFaced: params.ballsFaced,
          fours: params.fours,
          sixes: params.sixes,
          strikeRate: params.ballsFaced > 0 ? (params.runs / params.ballsFaced) * 100 : 0.0,
          isOut: params.isOut,
          dismissalType: params.dismissalType,
          dismissedBy: params.dismissedBy,
          fielder: params.fielder,
          overNumber: params.overNumber,
          ballNumber: params.ballNumber,
          timestamp: DateTime.now(),
          extras: {},
          commentary: null,
          isActive: true,
        );
        
        await localDataSource.saveScore(newScore);
        return Right(newScore);
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update score: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPlayerStatistics(String playerId) async {
    try {
      final player = await getPlayer(playerId);
      return player.fold(
        (failure) => Left(failure),
        (playerEntity) => Right(playerEntity.statistics),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get player statistics: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getTeamStatistics(String teamId) async {
    try {
      final team = await getTeam(teamId);
      return team.fold(
        (failure) => Left(failure),
        (teamEntity) => Right(teamEntity.statistics),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get team statistics: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMatchStatistics(String matchId) async {
    try {
      final match = await localDataSource.getMatch(matchId);
      if (match == null) {
        return Left(NotFoundFailure('Match not found'));
      }
      
      return Right(match.statistics);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get match statistics: $e'));
    }
  }

  /// Validate create match parameters
  String? _validateCreateMatchParams(CreateMatchParams params) {
    if (params.title.trim().isEmpty) {
      return 'Match title cannot be empty';
    }
    
    if (params.venue.trim().isEmpty) {
      return 'Venue cannot be empty';
    }
    
    if (params.overs <= 0) {
      return 'Overs must be greater than 0';
    }
    
    if (params.playersPerTeam <= 0 || params.playersPerTeam > 11) {
      return 'Players per team must be between 1 and 11';
    }
    
    if (params.team1.id == params.team2.id) {
      return 'Teams must be different';
    }
    
    if (params.startTime.isBefore(DateTime.now())) {
      return 'Start time cannot be in the past';
    }
    
    if (params.endTime != null && params.endTime!.isBefore(params.startTime)) {
      return 'End time cannot be before start time';
    }
    
    return null;
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