import 'dart:math';
import '../../../../core/error/exceptions.dart';
import '../models/match_model.dart';
import '../models/score_model.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/match_enums.dart';
import '../../domain/entities/player_entity.dart';
import '../../domain/entities/team_entity.dart';
import '../../domain/entities/score_entity.dart';

/// Mock data source for cricket data - provides realistic cricket data for testing
class CricketMockDataSource {
  final Random _random = Random();
  
  /// Generate mock matches
  List<MatchModel> generateMockMatches({int count = 10}) {
    final matches = <MatchModel>[];
    final now = DateTime.now();
    
    for (int i = 0; i < count; i++) {
      final matchId = 'match_${i + 1}';
      final team1 = _generateMockTeam('team_${i * 2 + 1}', 'Team ${String.fromCharCode(65 + i * 2)}');
      final team2 = _generateMockTeam('team_${i * 2 + 2}', 'Team ${String.fromCharCode(65 + i * 2 + 1)}');
      
      final match = MatchModel(
        id: matchId,
        title: '${team1.name} vs ${team2.name}',
        description: 'Local cricket match between ${team1.name} and ${team2.name}',
        matchType: MatchType.values[_random.nextInt(MatchType.values.length)],
        status: MatchStatus.values[_random.nextInt(MatchStatus.values.length)],
        createdAt: now.subtract(Duration(days: _random.nextInt(30))),
        updatedAt: now.subtract(Duration(hours: _random.nextInt(24))),
        team1: team1,
        team2: team2,
        venue: _generateVenueName(),
        startTime: now.add(Duration(days: _random.nextInt(7))),
        endTime: _random.nextBool() ? now.add(Duration(days: _random.nextInt(7), hours: 4)) : null,
        overs: [10, 15, 20, 25, 50][_random.nextInt(5)],
        playersPerTeam: 11,
        currentInning: _random.nextInt(2) + 1,
        battingTeamId: _random.nextBool() ? team1.id : team2.id,
        bowlingTeamId: _random.nextBool() ? team1.id : team2.id,
        inning1Id: 'inning_${matchId}_1',
        inning2Id: _random.nextBool() ? 'inning_${matchId}_2' : null,
        result: _generateMatchResult(),
        tossWinner: _random.nextBool() ? team1.id : team2.id,
        tossDecision: TossDecision.values[_random.nextInt(TossDecision.values.length)],
        weather: _generateWeather(),
        pitchCondition: _generatePitchCondition(),
        umpire1: _generatePersonName(),
        umpire2: _generatePersonName(),
        referee: _random.nextBool() ? _generatePersonName() : null,
        streamingUrl: _random.nextBool() ? 'https://stream.gullycric.com/match_$matchId' : null,
        highlights: _generateHighlights(),
        commentary: _generateCommentary(),
        statistics: _generateMatchStatistics(),
        tags: _generateTags(),
        isPublic: _random.nextBool(),
        allowSpectators: _random.nextBool(),
        maxSpectators: _random.nextBool() ? _random.nextInt(100) + 20 : null,
        entryFee: _random.nextBool() ? _random.nextDouble() * 50 : null,
        prizePool: _random.nextBool() ? _random.nextDouble() * 1000 + 100 : null,
        sponsorInfo: _random.nextBool() ? 'Sponsored by Local Business' : null,
        socialLinks: _generateSocialLinks(),
        customRules: _generateCustomRules(),
      );
      
      matches.add(match);
    }
    
    return matches;
  }
  
  /// Generate mock team
  TeamModel _generateMockTeam(String id, String name) {
    final players = <PlayerModel>[];
    
    // Generate 11 players for the team
    for (int i = 0; i < 11; i++) {
      players.add(_generateMockPlayer('${id}_player_${i + 1}', i + 1));
    }
    
    return TeamModel(
      id: id,
      name: name,
      players: players,
      captain: players[0].id, // First player is captain
      wicketKeeper: players[1].id, // Second player is wicket keeper
      coach: _generatePersonName(),
      logo: 'https://api.dicebear.com/7.x/identicon/svg?seed=$name',
      color: _generateTeamColor(),
      homeGround: _generateVenueName(),
      founded: DateTime.now().subtract(Duration(days: _random.nextInt(3650))),
      description: 'Local cricket team $name',
      socialLinks: _generateSocialLinks(),
      statistics: _generateTeamStatistics(),
      achievements: _generateAchievements(),
      isActive: true,
    );
  }
  
  /// Generate mock player
  PlayerModel _generateMockPlayer(String id, int jerseyNumber) {
    final firstName = _generateFirstName();
    final lastName = _generateLastName();
    final name = '$firstName $lastName';
    
    return PlayerModel(
      id: id,
      name: name,
      jerseyNumber: jerseyNumber,
      role: PlayerRole.values[_random.nextInt(PlayerRole.values.length)],
      battingStyle: BattingStyle.values[_random.nextInt(BattingStyle.values.length)],
      bowlingStyle: BowlingStyle.values[_random.nextInt(BowlingStyle.values.length)],
      avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=$name',
      dateOfBirth: DateTime.now().subtract(Duration(days: _random.nextInt(10950) + 6570)), // 18-48 years
      nationality: _generateNationality(),
      height: 150.0 + _random.nextDouble() * 50, // 150-200 cm
      weight: 50.0 + _random.nextDouble() * 50, // 50-100 kg
      experience: _random.nextInt(20), // 0-20 years
      statistics: _generatePlayerStatistics(),
      achievements: _generateAchievements(),
      socialLinks: _generateSocialLinks(),
      isActive: true,
      isAvailable: _random.nextBool(),
      currentForm: _random.nextDouble() * 100, // 0-100%
      fitnessLevel: _random.nextDouble() * 100, // 0-100%
      specialSkills: _generateSpecialSkills(),
      weaknesses: _generateWeaknesses(),
      preferredPosition: _generatePreferredPosition(),
      emergencyContact: '+92${_random.nextInt(900000000) + 100000000}',
      medicalInfo: _random.nextBool() ? 'No known medical conditions' : null,
      contractDetails: _generateContractDetails(),
    );
  }
  
  /// Generate mock scores for a match
  List<ScoreModel> generateMockScores(String matchId, List<String> playerIds) {
    final scores = <ScoreModel>[];
    
    for (int i = 0; i < playerIds.length; i++) {
      final playerId = playerIds[i];
      final runs = _random.nextInt(100);
      final ballsFaced = runs == 0 ? _random.nextInt(10) : _random.nextInt(80) + runs ~/ 2;
      final fours = runs ~/ 8;
      final sixes = runs ~/ 15;
      final strikeRate = ballsFaced > 0 ? (runs / ballsFaced) * 100 : 0.0;
      
      final score = ScoreModel(
        id: 'score_${matchId}_$playerId',
        matchId: matchId,
        teamId: 'team_${i < 6 ? 1 : 2}', // First 6 players team 1, rest team 2
        playerId: playerId,
        runs: runs,
        ballsFaced: ballsFaced,
        fours: fours,
        sixes: sixes,
        strikeRate: strikeRate,
        isOut: _random.nextBool(),
        dismissalType: _random.nextBool() 
            ? DismissalType.values[_random.nextInt(DismissalType.values.length)]
            : null,
        dismissedBy: _random.nextBool() ? playerIds[_random.nextInt(playerIds.length)] : null,
        fielder: _random.nextBool() ? playerIds[_random.nextInt(playerIds.length)] : null,
        overNumber: _random.nextInt(20) + 1,
        ballNumber: _random.nextInt(6) + 1,
        timestamp: DateTime.now().subtract(Duration(minutes: _random.nextInt(300))),
        extras: _generateExtras(),
        commentary: _generateBallCommentary(runs),
        isActive: true,
      );
      
      scores.add(score);
    }
    
    return scores;
  }
  
  /// Generate mock innings
  List<InningModel> generateMockInnings(String matchId, String team1Id, String team2Id) {
    final innings = <InningModel>[];
    
    // First inning
    final inning1Runs = _random.nextInt(200) + 50;
    final inning1Wickets = _random.nextInt(10);
    final inning1Overs = _random.nextDouble() * 20;
    
    final inning1 = InningModel(
      id: 'inning_${matchId}_1',
      matchId: matchId,
      inningNumber: 1,
      battingTeamId: team1Id,
      bowlingTeamId: team2Id,
      runs: inning1Runs,
      wickets: inning1Wickets,
      overs: inning1Overs,
      ballsFaced: (inning1Overs * 6).round(),
      runRate: inning1Overs > 0 ? inning1Runs / inning1Overs : 0.0,
      requiredRunRate: 0.0,
      target: null,
      result: null,
      extras: _generateExtras(),
      partnerships: _generatePartnerships(),
      fallOfWickets: _generateFallOfWickets(inning1Wickets),
      bowlingFigures: _generateBowlingFigures(),
      battingOrder: _generateBattingOrder(),
      powerplayOvers: {'powerplay1': 6, 'powerplay2': 10},
      commentary: _generateInningCommentary(),
      startTime: DateTime.now().subtract(Duration(hours: 3)),
      endTime: DateTime.now().subtract(Duration(hours: 1)),
      isCompleted: true,
    );
    
    innings.add(inning1);
    
    // Second inning (if match is advanced enough)
    if (_random.nextBool()) {
      final inning2Runs = _random.nextInt(inning1Runs + 50);
      final inning2Wickets = _random.nextInt(10);
      final inning2Overs = _random.nextDouble() * 20;
      final requiredRunRate = inning2Overs > 0 ? (inning1Runs + 1 - inning2Runs) / (20 - inning2Overs) : 0.0;
      
      final inning2 = InningModel(
        id: 'inning_${matchId}_2',
        matchId: matchId,
        inningNumber: 2,
        battingTeamId: team2Id,
        bowlingTeamId: team1Id,
        runs: inning2Runs,
        wickets: inning2Wickets,
        overs: inning2Overs,
        ballsFaced: (inning2Overs * 6).round(),
        runRate: inning2Overs > 0 ? inning2Runs / inning2Overs : 0.0,
        requiredRunRate: requiredRunRate > 0 ? requiredRunRate : 0.0,
        target: inning1Runs + 1,
        result: _generateInningResult(inning2Runs, inning1Runs),
        extras: _generateExtras(),
        partnerships: _generatePartnerships(),
        fallOfWickets: _generateFallOfWickets(inning2Wickets),
        bowlingFigures: _generateBowlingFigures(),
        battingOrder: _generateBattingOrder(),
        powerplayOvers: {'powerplay1': 6, 'powerplay2': 10},
        commentary: _generateInningCommentary(),
        startTime: DateTime.now().subtract(Duration(hours: 1)),
        endTime: inning2Runs > inning1Runs ? DateTime.now() : null,
        isCompleted: inning2Runs > inning1Runs || inning2Wickets >= 10,
      );
      
      innings.add(inning2);
    }
    
    return innings;
  }
  
  // Helper methods for generating realistic data
  
  String _generateVenueName() {
    final venues = [
      'Central Park Ground', 'City Stadium', 'Sports Complex', 'Community Ground',
      'Municipal Stadium', 'Local Cricket Club', 'School Ground', 'University Field',
      'Recreation Center', 'Town Ground', 'Village Stadium', 'District Ground'
    ];
    return venues[_random.nextInt(venues.length)];
  }
  
  String _generatePersonName() {
    final firstNames = ['Ahmed', 'Ali', 'Hassan', 'Omar', 'Usman', 'Bilal', 'Faisal', 'Tariq'];
    final lastNames = ['Khan', 'Shah', 'Ahmed', 'Ali', 'Malik', 'Sheikh', 'Qureshi', 'Butt'];
    return '${firstNames[_random.nextInt(firstNames.length)]} ${lastNames[_random.nextInt(lastNames.length)]}';
  }
  
  String _generateFirstName() {
    final names = ['Ahmed', 'Ali', 'Hassan', 'Omar', 'Usman', 'Bilal', 'Faisal', 'Tariq', 'Zain', 'Hamza'];
    return names[_random.nextInt(names.length)];
  }
  
  String _generateLastName() {
    final names = ['Khan', 'Shah', 'Ahmed', 'Ali', 'Malik', 'Sheikh', 'Qureshi', 'Butt', 'Awan', 'Chaudhry'];
    return names[_random.nextInt(names.length)];
  }
  
  String _generateNationality() {
    final nationalities = ['Pakistani', 'Indian', 'Bangladeshi', 'Sri Lankan', 'Afghan'];
    return nationalities[_random.nextInt(nationalities.length)];
  }
  
  String _generateTeamColor() {
    final colors = ['#FF0000', '#00FF00', '#0000FF', '#FFFF00', '#FF00FF', '#00FFFF', '#FFA500', '#800080'];
    return colors[_random.nextInt(colors.length)];
  }
  
  String _generateWeather() {
    final weather = ['Sunny', 'Cloudy', 'Partly Cloudy', 'Overcast', 'Light Rain', 'Clear'];
    return weather[_random.nextInt(weather.length)];
  }
  
  String _generatePitchCondition() {
    final conditions = ['Good', 'Excellent', 'Fair', 'Dry', 'Damp', 'Hard', 'Soft'];
    return conditions[_random.nextInt(conditions.length)];
  }
  
  MatchResult? _generateMatchResult() {
    if (_random.nextBool()) return null;
    
    return MatchResult(
      winner: 'team_${_random.nextInt(2) + 1}',
      margin: '${_random.nextInt(100)} runs',
      resultType: ResultType.values[_random.nextInt(ResultType.values.length)],
      manOfTheMatch: 'player_${_random.nextInt(22) + 1}',
      summary: 'Great match with excellent performance',
    );
  }
  
  List<String> _generateHighlights() {
    final highlights = [
      'Amazing six by captain',
      'Brilliant catch in the deep',
      'Hat-trick by fast bowler',
      'Century partnership',
      'Last ball finish',
    ];
    return highlights.take(_random.nextInt(3) + 1).toList();
  }
  
  List<String> _generateCommentary() {
    final commentary = [
      'What a shot! That\'s gone for six!',
      'Excellent bowling, beats the batsman',
      'Great fielding effort saves a boundary',
      'The crowd is on their feet',
      'Pressure building on the batting side',
    ];
    return commentary.take(_random.nextInt(5) + 2).toList();
  }
  
  Map<String, dynamic> _generateMatchStatistics() {
    return {
      'totalRuns': _random.nextInt(400) + 100,
      'totalWickets': _random.nextInt(20),
      'totalOvers': _random.nextDouble() * 40,
      'boundaries': _random.nextInt(30),
      'sixes': _random.nextInt(15),
      'extras': _random.nextInt(20),
    };
  }
  
  Map<String, dynamic> _generatePlayerStatistics() {
    return {
      'matches': _random.nextInt(100),
      'runs': _random.nextInt(5000),
      'wickets': _random.nextInt(200),
      'catches': _random.nextInt(50),
      'average': _random.nextDouble() * 50,
      'strikeRate': _random.nextDouble() * 150 + 50,
    };
  }
  
  Map<String, dynamic> _generateTeamStatistics() {
    return {
      'matchesPlayed': _random.nextInt(100),
      'matchesWon': _random.nextInt(60),
      'matchesLost': _random.nextInt(40),
      'totalRuns': _random.nextInt(50000),
      'totalWickets': _random.nextInt(1000),
      'winPercentage': _random.nextDouble() * 100,
    };
  }
  
  List<String> _generateTags() {
    final tags = ['local', 'friendly', 'tournament', 'league', 'practice', 'championship'];
    return tags.take(_random.nextInt(3) + 1).toList();
  }
  
  List<String> _generateAchievements() {
    final achievements = [
      'Best Player 2023',
      'Highest Score',
      'Most Wickets',
      'Best Fielder',
      'Team Captain',
    ];
    return achievements.take(_random.nextInt(3)).toList();
  }
  
  List<String> _generateSpecialSkills() {
    final skills = ['Power Hitting', 'Spin Bowling', 'Fast Bowling', 'Wicket Keeping', 'Fielding'];
    return skills.take(_random.nextInt(3) + 1).toList();
  }
  
  List<String> _generateWeaknesses() {
    final weaknesses = ['Short Ball', 'Spin Bowling', 'Pressure Situations', 'Running Between Wickets'];
    return weaknesses.take(_random.nextInt(2)).toList();
  }
  
  String _generatePreferredPosition() {
    final positions = ['Opening', 'Middle Order', 'Lower Order', 'All Rounder', 'Bowler'];
    return positions[_random.nextInt(positions.length)];
  }
  
  Map<String, String> _generateSocialLinks() {
    return {
      'instagram': '@player_${_random.nextInt(1000)}',
      'twitter': '@player_${_random.nextInt(1000)}',
    };
  }
  
  Map<String, dynamic> _generateContractDetails() {
    return {
      'salary': _random.nextInt(100000),
      'duration': '${_random.nextInt(3) + 1} years',
      'startDate': DateTime.now().toIso8601String(),
    };
  }
  
  List<String> _generateCustomRules() {
    final rules = [
      'No LBW for first 2 overs',
      'Free hit after wide ball',
      'Powerplay in first 6 overs',
      'Maximum 4 overs per bowler',
    ];
    return rules.take(_random.nextInt(2)).toList();
  }
  
  Map<String, int> _generateExtras() {
    return {
      'wides': _random.nextInt(10),
      'noBalls': _random.nextInt(5),
      'byes': _random.nextInt(8),
      'legByes': _random.nextInt(6),
    };
  }
  
  String _generateBallCommentary(int runs) {
    if (runs == 0) return 'Dot ball, good bowling';
    if (runs == 4) return 'Boundary! Great shot';
    if (runs == 6) return 'SIX! What a hit!';
    return '$runs run${runs > 1 ? 's' : ''} taken';
  }
  
  List<String> _generateInningCommentary() {
    return [
      'Good start by the batting side',
      'Bowlers are maintaining pressure',
      'Partnership building nicely',
      'Wicket falls at crucial time',
      'Excellent finish to the innings',
    ];
  }
  
  List<Map<String, dynamic>> _generatePartnerships() {
    return [
      {'player1': 'player_1', 'player2': 'player_2', 'runs': _random.nextInt(100), 'balls': _random.nextInt(60)},
      {'player1': 'player_2', 'player2': 'player_3', 'runs': _random.nextInt(80), 'balls': _random.nextInt(50)},
    ];
  }
  
  List<Map<String, dynamic>> _generateFallOfWickets(int wickets) {
    final fallOfWickets = <Map<String, dynamic>>[];
    for (int i = 0; i < wickets; i++) {
      fallOfWickets.add({
        'wicket': i + 1,
        'runs': _random.nextInt(200),
        'overs': _random.nextDouble() * 20,
        'player': 'player_${i + 1}',
      });
    }
    return fallOfWickets;
  }
  
  Map<String, Map<String, dynamic>> _generateBowlingFigures() {
    return {
      'bowler_1': {
        'overs': _random.nextDouble() * 4,
        'runs': _random.nextInt(40),
        'wickets': _random.nextInt(4),
        'economy': _random.nextDouble() * 10,
      },
      'bowler_2': {
        'overs': _random.nextDouble() * 4,
        'runs': _random.nextInt(35),
        'wickets': _random.nextInt(3),
        'economy': _random.nextDouble() * 9,
      },
    };
  }
  
  List<String> _generateBattingOrder() {
    return List.generate(11, (index) => 'player_${index + 1}');
  }
  
  String? _generateInningResult(int runs, int target) {
    if (runs > target) return 'Won by ${runs - target} runs';
    if (runs < target) return 'Lost by ${target - runs} runs';
    return 'Match tied';
  }
}