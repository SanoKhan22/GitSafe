import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/match_model.dart';
import '../models/score_model.dart';

/// Abstract interface for local cricket data operations
abstract class CricketLocalDataSource {
  /// Match operations
  Future<List<MatchModel>> getMatches();
  Future<MatchModel?> getMatch(String id);
  Future<void> saveMatch(MatchModel match);
  Future<void> updateMatch(MatchModel match);
  Future<void> deleteMatch(String id);
  
  /// Score operations
  Future<List<ScoreModel>> getMatchScores(String matchId);
  Future<void> saveScore(ScoreModel score);
  Future<void> updateScore(ScoreModel score);
  Future<void> deleteScore(String id);
  
  /// Inning operations
  Future<List<InningModel>> getMatchInnings(String matchId);
  Future<InningModel?> getInning(String id);
  Future<void> saveInning(InningModel inning);
  Future<void> updateInning(InningModel inning);
  
  /// Ball operations
  Future<List<BallModel>> getInningBalls(String inningId);
  Future<void> saveBall(BallModel ball);
  Future<void> updateBall(BallModel ball);
  
  /// Over operations
  Future<List<OverModel>> getInningOvers(String inningId);
  Future<void> saveOver(OverModel over);
  Future<void> updateOver(OverModel over);
  
  /// Cache management
  Future<void> clearCache();
  Future<void> clearMatchData(String matchId);
}

/// Implementation of CricketLocalDataSource using SharedPreferences
class CricketLocalDataSourceImpl implements CricketLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  // Storage keys
  static const String _matchesKey = 'cricket_matches';
  static const String _scoresKey = 'cricket_scores';
  static const String _inningsKey = 'cricket_innings';
  static const String _ballsKey = 'cricket_balls';
  static const String _oversKey = 'cricket_overs';
  
  const CricketLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<List<MatchModel>> getMatches() async {
    try {
      final matchesJson = sharedPreferences.getString(_matchesKey);
      if (matchesJson == null) return [];
      
      final List<dynamic> matchesList = json.decode(matchesJson);
      return matchesList
          .map((json) => MatchModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get matches from local storage: $e');
    }
  }

  @override
  Future<MatchModel?> getMatch(String id) async {
    try {
      final matches = await getMatches();
      return matches.where((match) => match.id == id).firstOrNull;
    } catch (e) {
      throw CacheException('Failed to get match from local storage: $e');
    }
  }

  @override
  Future<void> saveMatch(MatchModel match) async {
    try {
      final matches = await getMatches();
      matches.add(match);
      
      final matchesJson = json.encode(
        matches.map((m) => m.toJson()).toList(),
      );
      
      await sharedPreferences.setString(_matchesKey, matchesJson);
    } catch (e) {
      throw CacheException('Failed to save match to local storage: $e');
    }
  }

  @override
  Future<void> updateMatch(MatchModel match) async {
    try {
      final matches = await getMatches();
      final index = matches.indexWhere((m) => m.id == match.id);
      
      if (index != -1) {
        matches[index] = match;
        
        final matchesJson = json.encode(
          matches.map((m) => m.toJson()).toList(),
        );
        
        await sharedPreferences.setString(_matchesKey, matchesJson);
      } else {
        throw CacheException('Match not found for update');
      }
    } catch (e) {
      throw CacheException('Failed to update match in local storage: $e');
    }
  }

  @override
  Future<void> deleteMatch(String id) async {
    try {
      final matches = await getMatches();
      matches.removeWhere((match) => match.id == id);
      
      final matchesJson = json.encode(
        matches.map((m) => m.toJson()).toList(),
      );
      
      await sharedPreferences.setString(_matchesKey, matchesJson);
      
      // Also clear related data
      await clearMatchData(id);
    } catch (e) {
      throw CacheException('Failed to delete match from local storage: $e');
    }
  }

  @override
  Future<List<ScoreModel>> getMatchScores(String matchId) async {
    try {
      final scoresJson = sharedPreferences.getString(_scoresKey);
      if (scoresJson == null) return [];
      
      final List<dynamic> scoresList = json.decode(scoresJson);
      final allScores = scoresList
          .map((json) => ScoreModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return allScores.where((score) => score.matchId == matchId).toList();
    } catch (e) {
      throw CacheException('Failed to get scores from local storage: $e');
    }
  }

  @override
  Future<void> saveScore(ScoreModel score) async {
    try {
      final scoresJson = sharedPreferences.getString(_scoresKey);
      List<ScoreModel> scores = [];
      
      if (scoresJson != null) {
        final List<dynamic> scoresList = json.decode(scoresJson);
        scores = scoresList
            .map((json) => ScoreModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      
      scores.add(score);
      
      final updatedScoresJson = json.encode(
        scores.map((s) => s.toJson()).toList(),
      );
      
      await sharedPreferences.setString(_scoresKey, updatedScoresJson);
    } catch (e) {
      throw CacheException('Failed to save score to local storage: $e');
    }
  }

  @override
  Future<void> updateScore(ScoreModel score) async {
    try {
      final scoresJson = sharedPreferences.getString(_scoresKey);
      if (scoresJson == null) {
        throw CacheException('No scores found for update');
      }
      
      final List<dynamic> scoresList = json.decode(scoresJson);
      final scores = scoresList
          .map((json) => ScoreModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      final index = scores.indexWhere((s) => s.id == score.id);
      
      if (index != -1) {
        scores[index] = score;
        
        final updatedScoresJson = json.encode(
          scores.map((s) => s.toJson()).toList(),
        );
        
        await sharedPreferences.setString(_scoresKey, updatedScoresJson);
      } else {
        throw CacheException('Score not found for update');
      }
    } catch (e) {
      throw CacheException('Failed to update score in local storage: $e');
    }
  }

  @override
  Future<void> deleteScore(String id) async {
    try {
      final scoresJson = sharedPreferences.getString(_scoresKey);
      if (scoresJson == null) return;
      
      final List<dynamic> scoresList = json.decode(scoresJson);
      final scores = scoresList
          .map((json) => ScoreModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      scores.removeWhere((score) => score.id == id);
      
      final updatedScoresJson = json.encode(
        scores.map((s) => s.toJson()).toList(),
      );
      
      await sharedPreferences.setString(_scoresKey, updatedScoresJson);
    } catch (e) {
      throw CacheException('Failed to delete score from local storage: $e');
    }
  }

  @override
  Future<List<InningModel>> getMatchInnings(String matchId) async {
    try {
      final inningsJson = sharedPreferences.getString(_inningsKey);
      if (inningsJson == null) return [];
      
      final List<dynamic> inningsList = json.decode(inningsJson);
      final allInnings = inningsList
          .map((json) => InningModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return allInnings.where((inning) => inning.matchId == matchId).toList();
    } catch (e) {
      throw CacheException('Failed to get innings from local storage: $e');
    }
  }

  @override
  Future<InningModel?> getInning(String id) async {
    try {
      final inningsJson = sharedPreferences.getString(_inningsKey);
      if (inningsJson == null) return null;
      
      final List<dynamic> inningsList = json.decode(inningsJson);
      final allInnings = inningsList
          .map((json) => InningModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return allInnings.where((inning) => inning.id == id).firstOrNull;
    } catch (e) {
      throw CacheException('Failed to get inning from local storage: $e');
    }
  }

  @override
  Future<void> saveInning(InningModel inning) async {
    try {
      final inningsJson = sharedPreferences.getString(_inningsKey);
      List<InningModel> innings = [];
      
      if (inningsJson != null) {
        final List<dynamic> inningsList = json.decode(inningsJson);
        innings = inningsList
            .map((json) => InningModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      
      innings.add(inning);
      
      final updatedInningsJson = json.encode(
        innings.map((i) => i.toJson()).toList(),
      );
      
      await sharedPreferences.setString(_inningsKey, updatedInningsJson);
    } catch (e) {
      throw CacheException('Failed to save inning to local storage: $e');
    }
  }

  @override
  Future<void> updateInning(InningModel inning) async {
    try {
      final inningsJson = sharedPreferences.getString(_inningsKey);
      if (inningsJson == null) {
        throw CacheException('No innings found for update');
      }
      
      final List<dynamic> inningsList = json.decode(inningsJson);
      final innings = inningsList
          .map((json) => InningModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      final index = innings.indexWhere((i) => i.id == inning.id);
      
      if (index != -1) {
        innings[index] = inning;
        
        final updatedInningsJson = json.encode(
          innings.map((i) => i.toJson()).toList(),
        );
        
        await sharedPreferences.setString(_inningsKey, updatedInningsJson);
      } else {
        throw CacheException('Inning not found for update');
      }
    } catch (e) {
      throw CacheException('Failed to update inning in local storage: $e');
    }
  }

  @override
  Future<List<BallModel>> getInningBalls(String inningId) async {
    try {
      final ballsJson = sharedPreferences.getString(_ballsKey);
      if (ballsJson == null) return [];
      
      final List<dynamic> ballsList = json.decode(ballsJson);
      final allBalls = ballsList
          .map((json) => BallModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return allBalls.where((ball) => ball.inningId == inningId).toList();
    } catch (e) {
      throw CacheException('Failed to get balls from local storage: $e');
    }
  }

  @override
  Future<void> saveBall(BallModel ball) async {
    try {
      final ballsJson = sharedPreferences.getString(_ballsKey);
      List<BallModel> balls = [];
      
      if (ballsJson != null) {
        final List<dynamic> ballsList = json.decode(ballsJson);
        balls = ballsList
            .map((json) => BallModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      
      balls.add(ball);
      
      final updatedBallsJson = json.encode(
        balls.map((b) => b.toJson()).toList(),
      );
      
      await sharedPreferences.setString(_ballsKey, updatedBallsJson);
    } catch (e) {
      throw CacheException('Failed to save ball to local storage: $e');
    }
  }

  @override
  Future<void> updateBall(BallModel ball) async {
    try {
      final ballsJson = sharedPreferences.getString(_ballsKey);
      if (ballsJson == null) {
        throw CacheException('No balls found for update');
      }
      
      final List<dynamic> ballsList = json.decode(ballsJson);
      final balls = ballsList
          .map((json) => BallModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      final index = balls.indexWhere((b) => b.id == ball.id);
      
      if (index != -1) {
        balls[index] = ball;
        
        final updatedBallsJson = json.encode(
          balls.map((b) => b.toJson()).toList(),
        );
        
        await sharedPreferences.setString(_ballsKey, updatedBallsJson);
      } else {
        throw CacheException('Ball not found for update');
      }
    } catch (e) {
      throw CacheException('Failed to update ball in local storage: $e');
    }
  }

  @override
  Future<List<OverModel>> getInningOvers(String inningId) async {
    try {
      final oversJson = sharedPreferences.getString(_oversKey);
      if (oversJson == null) return [];
      
      final List<dynamic> oversList = json.decode(oversJson);
      final allOvers = oversList
          .map((json) => OverModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return allOvers.where((over) => over.inningId == inningId).toList();
    } catch (e) {
      throw CacheException('Failed to get overs from local storage: $e');
    }
  }

  @override
  Future<void> saveOver(OverModel over) async {
    try {
      final oversJson = sharedPreferences.getString(_oversKey);
      List<OverModel> overs = [];
      
      if (oversJson != null) {
        final List<dynamic> oversList = json.decode(oversJson);
        overs = oversList
            .map((json) => OverModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      
      overs.add(over);
      
      final updatedOversJson = json.encode(
        overs.map((o) => o.toJson()).toList(),
      );
      
      await sharedPreferences.setString(_oversKey, updatedOversJson);
    } catch (e) {
      throw CacheException('Failed to save over to local storage: $e');
    }
  }

  @override
  Future<void> updateOver(OverModel over) async {
    try {
      final oversJson = sharedPreferences.getString(_oversKey);
      if (oversJson == null) {
        throw CacheException('No overs found for update');
      }
      
      final List<dynamic> oversList = json.decode(oversJson);
      final overs = oversList
          .map((json) => OverModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      final index = overs.indexWhere((o) => o.id == over.id);
      
      if (index != -1) {
        overs[index] = over;
        
        final updatedOversJson = json.encode(
          overs.map((o) => o.toJson()).toList(),
        );
        
        await sharedPreferences.setString(_oversKey, updatedOversJson);
      } else {
        throw CacheException('Over not found for update');
      }
    } catch (e) {
      throw CacheException('Failed to update over in local storage: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(_matchesKey);
      await sharedPreferences.remove(_scoresKey);
      await sharedPreferences.remove(_inningsKey);
      await sharedPreferences.remove(_ballsKey);
      await sharedPreferences.remove(_oversKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }

  @override
  Future<void> clearMatchData(String matchId) async {
    try {
      // Clear scores for this match
      final scoresJson = sharedPreferences.getString(_scoresKey);
      if (scoresJson != null) {
        final List<dynamic> scoresList = json.decode(scoresJson);
        final scores = scoresList
            .map((json) => ScoreModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        scores.removeWhere((score) => score.matchId == matchId);
        
        final updatedScoresJson = json.encode(
          scores.map((s) => s.toJson()).toList(),
        );
        
        await sharedPreferences.setString(_scoresKey, updatedScoresJson);
      }
      
      // Clear innings for this match
      final inningsJson = sharedPreferences.getString(_inningsKey);
      if (inningsJson != null) {
        final List<dynamic> inningsList = json.decode(inningsJson);
        final innings = inningsList
            .map((json) => InningModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        final matchInnings = innings.where((i) => i.matchId == matchId).toList();
        innings.removeWhere((inning) => inning.matchId == matchId);
        
        final updatedInningsJson = json.encode(
          innings.map((i) => i.toJson()).toList(),
        );
        
        await sharedPreferences.setString(_inningsKey, updatedInningsJson);
        
        // Clear balls and overs for each inning
        for (final inning in matchInnings) {
          await _clearInningData(inning.id);
        }
      }
    } catch (e) {
      throw CacheException('Failed to clear match data: $e');
    }
  }
  
  Future<void> _clearInningData(String inningId) async {
    // Clear balls for this inning
    final ballsJson = sharedPreferences.getString(_ballsKey);
    if (ballsJson != null) {
      final List<dynamic> ballsList = json.decode(ballsJson);
      final balls = ballsList
          .map((json) => BallModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      balls.removeWhere((ball) => ball.inningId == inningId);
      
      final updatedBallsJson = json.encode(
        balls.map((b) => b.toJson()).toList(),
      );
      
      await sharedPreferences.setString(_ballsKey, updatedBallsJson);
    }
    
    // Clear overs for this inning
    final oversJson = sharedPreferences.getString(_oversKey);
    if (oversJson != null) {
      final List<dynamic> oversList = json.decode(oversJson);
      final overs = oversList
          .map((json) => OverModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      overs.removeWhere((over) => over.inningId == inningId);
      
      final updatedOversJson = json.encode(
        overs.map((o) => o.toJson()).toList(),
      );
      
      await sharedPreferences.setString(_oversKey, updatedOversJson);
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