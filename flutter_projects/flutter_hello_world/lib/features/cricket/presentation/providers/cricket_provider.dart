import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/team_entity.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/entities/score_entity.dart';
import '../../data/repositories/cricket_simple_repository.dart';

/// Provider for cricket repository
final cricketRepositoryProvider = Provider<CricketSimpleRepository>((ref) {
  return CricketSimpleRepository();
});

/// Provider for matches list
final matchesProvider = FutureProvider<List<MatchEntity>>((ref) async {
  final repository = ref.read(cricketRepositoryProvider);
  final result = await repository.getMatches();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (matches) => matches,
  );
});

/// Provider for a specific match
final matchProvider = FutureProvider.family<MatchEntity, String>((ref, matchId) async {
  final repository = ref.read(cricketRepositoryProvider);
  final result = await repository.getMatch(matchId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (match) => match,
  );
});

/// Provider for teams
final teamsProvider = FutureProvider<List<TeamEntity>>((ref) async {
  final repository = ref.read(cricketRepositoryProvider);
  final result = await repository.getTeams();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (teams) => teams,
  );
});

/// Provider for players
final playersProvider = FutureProvider<List<PlayerEntity>>((ref) async {
  final repository = ref.read(cricketRepositoryProvider);
  final result = await repository.getPlayers();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (players) => players,
  );
});

/// Provider for match scores
final matchScoresProvider = FutureProvider.family<List<ScoreEntity>, String>((ref, matchId) async {
  final repository = ref.read(cricketRepositoryProvider);
  final result = await repository.getMatchScores(matchId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (scores) => scores,
  );
});

/// State notifier for match creation
class MatchCreationNotifier extends StateNotifier<AsyncValue<MatchEntity?>> {
  final CricketSimpleRepository _repository;

  MatchCreationNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> createMatch({
    required String title,
    required String description,
    required TeamEntity team1,
    required TeamEntity team2,
    required String venue,
    required DateTime startTime,
    required int overs,
    required int playersPerTeam,
    MatchType matchType = MatchType.local,
  }) async {
    state = const AsyncValue.loading();
    
    final params = CreateMatchParams(
      title: title,
      description: description,
      matchType: matchType,
      team1: team1,
      team2: team2,
      venue: venue,
      startTime: startTime,
      overs: overs,
      playersPerTeam: playersPerTeam,
    );

    final result = await _repository.createMatch(params);
    
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (match) => AsyncValue.data(match),
    );
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// Provider for match creation
final matchCreationProvider = StateNotifierProvider<MatchCreationNotifier, AsyncValue<MatchEntity?>>((ref) {
  final repository = ref.read(cricketRepositoryProvider);
  return MatchCreationNotifier(repository);
});

/// State notifier for score updates
class ScoreUpdateNotifier extends StateNotifier<AsyncValue<ScoreEntity?>> {
  final CricketSimpleRepository _repository;

  ScoreUpdateNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> updateScore({
    required String matchId,
    required String teamId,
    required String playerId,
    required int runs,
    required int ballsFaced,
    required int fours,
    required int sixes,
    required bool isOut,
    String? dismissalType,
    String? dismissedBy,
    String? fielder,
    int? overNumber,
    int? ballNumber,
  }) async {
    state = const AsyncValue.loading();
    
    final params = UpdateScoreParams(
      matchId: matchId,
      teamId: teamId,
      playerId: playerId,
      runs: runs,
      ballsFaced: ballsFaced,
      fours: fours,
      sixes: sixes,
      isOut: isOut,
      overNumber: overNumber,
      ballNumber: ballNumber,
    );

    final result = await _repository.updateScore(params);
    
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (score) => AsyncValue.data(score),
    );
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// Provider for score updates
final scoreUpdateProvider = StateNotifierProvider<ScoreUpdateNotifier, AsyncValue<ScoreEntity?>>((ref) {
  final repository = ref.read(cricketRepositoryProvider);
  return ScoreUpdateNotifier(repository);
});