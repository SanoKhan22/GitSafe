import 'package:equatable/equatable.dart';

/// Cricket Score Entity
/// 
/// Represents the scoring system for cricket matches including balls, overs, and innings
class ScoreEntity extends Equatable {
  final String id;
  final String matchId;
  final String inningId;
  final int inningNumber;
  final String battingTeamId;
  final String bowlingTeamId;
  
  // Current Score
  final int runs;
  final int wickets;
  final double overs;
  final int balls;
  final int extras;
  final int wides;
  final int noBalls;
  final int byes;
  final int legByes;
  final int penalties;
  
  // Current Players
  final String? striker;
  final String? nonStriker;
  final String? bowler;
  final String? wicketKeeper;
  
  // Over Details
  final List<BallEntity> currentOver;
  final List<OverEntity> completedOvers;
  final int ballsInCurrentOver;
  
  // Match State
  final bool isInningComplete;
  final bool isMatchComplete;
  final DateTime lastUpdated;
  final String lastUpdatedBy;
  
  // Statistics
  final double runRate;
  final double requiredRunRate;
  final int ballsRemaining;
  final int runsRequired;
  final String? projectedScore;

  const ScoreEntity({
    required this.id,
    required this.matchId,
    required this.inningId,
    required this.inningNumber,
    required this.battingTeamId,
    required this.bowlingTeamId,
    this.runs = 0,
    this.wickets = 0,
    this.overs = 0.0,
    this.balls = 0,
    this.extras = 0,
    this.wides = 0,
    this.noBalls = 0,
    this.byes = 0,
    this.legByes = 0,
    this.penalties = 0,
    this.striker,
    this.nonStriker,
    this.bowler,
    this.wicketKeeper,
    this.currentOver = const [],
    this.completedOvers = const [],
    this.ballsInCurrentOver = 0,
    this.isInningComplete = false,
    this.isMatchComplete = false,
    required this.lastUpdated,
    required this.lastUpdatedBy,
    this.runRate = 0.0,
    this.requiredRunRate = 0.0,
    this.ballsRemaining = 0,
    this.runsRequired = 0,
    this.projectedScore,
  });

  @override
  List<Object?> get props => [
        id,
        matchId,
        inningNumber,
        runs,
        wickets,
        overs,
        balls,
        lastUpdated,
      ];

  /// Get score display (e.g., "150/3")
  String get scoreDisplay => '$runs/$wickets';

  /// Get overs display (e.g., "15.3")
  String get oversDisplay {
    final completeOvers = overs.floor();
    final ballsInOver = ((overs - completeOvers) * 10).round();
    return ballsInOver == 0 ? '$completeOvers' : '$completeOvers.$ballsInOver';
  }

  /// Calculate current run rate
  double get calculatedRunRate {
    if (overs == 0) return 0.0;
    return runs / overs;
  }

  /// Get total balls faced
  int get totalBallsFaced => (overs.floor() * 6) + ballsInCurrentOver;

  /// Get legitimate balls (excluding wides and no balls)
  int get legitimateBalls => totalBallsFaced - wides - noBalls;

  /// Get runs from bat (excluding extras)
  int get runsFromBat => runs - extras;

  /// Check if over is complete
  bool get isOverComplete => ballsInCurrentOver >= 6;

  /// Get current over summary
  String get currentOverSummary {
    if (currentOver.isEmpty) return '';
    return currentOver.map((ball) => ball.runsScored.toString()).join(' ');
  }

  /// Get last ball details
  BallEntity? get lastBall {
    if (currentOver.isEmpty) return null;
    return currentOver.last;
  }

  /// Get partnership runs (if tracking partnerships)
  int get currentPartnership {
    // This would be calculated based on when the last wicket fell
    // For now, return a placeholder
    return 0;
  }

  /// Copy with method for immutable updates
  ScoreEntity copyWith({
    String? id,
    String? matchId,
    String? inningId,
    int? inningNumber,
    String? battingTeamId,
    String? bowlingTeamId,
    int? runs,
    int? wickets,
    double? overs,
    int? balls,
    int? extras,
    int? wides,
    int? noBalls,
    int? byes,
    int? legByes,
    int? penalties,
    String? striker,
    String? nonStriker,
    String? bowler,
    String? wicketKeeper,
    List<BallEntity>? currentOver,
    List<OverEntity>? completedOvers,
    int? ballsInCurrentOver,
    bool? isInningComplete,
    bool? isMatchComplete,
    DateTime? lastUpdated,
    String? lastUpdatedBy,
    double? runRate,
    double? requiredRunRate,
    int? ballsRemaining,
    int? runsRequired,
    String? projectedScore,
  }) {
    return ScoreEntity(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      inningId: inningId ?? this.inningId,
      inningNumber: inningNumber ?? this.inningNumber,
      battingTeamId: battingTeamId ?? this.battingTeamId,
      bowlingTeamId: bowlingTeamId ?? this.bowlingTeamId,
      runs: runs ?? this.runs,
      wickets: wickets ?? this.wickets,
      overs: overs ?? this.overs,
      balls: balls ?? this.balls,
      extras: extras ?? this.extras,
      wides: wides ?? this.wides,
      noBalls: noBalls ?? this.noBalls,
      byes: byes ?? this.byes,
      legByes: legByes ?? this.legByes,
      penalties: penalties ?? this.penalties,
      striker: striker ?? this.striker,
      nonStriker: nonStriker ?? this.nonStriker,
      bowler: bowler ?? this.bowler,
      wicketKeeper: wicketKeeper ?? this.wicketKeeper,
      currentOver: currentOver ?? this.currentOver,
      completedOvers: completedOvers ?? this.completedOvers,
      ballsInCurrentOver: ballsInCurrentOver ?? this.ballsInCurrentOver,
      isInningComplete: isInningComplete ?? this.isInningComplete,
      isMatchComplete: isMatchComplete ?? this.isMatchComplete,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
      runRate: runRate ?? this.runRate,
      requiredRunRate: requiredRunRate ?? this.requiredRunRate,
      ballsRemaining: ballsRemaining ?? this.ballsRemaining,
      runsRequired: runsRequired ?? this.runsRequired,
      projectedScore: projectedScore ?? this.projectedScore,
    );
  }
}

/// Ball Entity - Represents a single ball in cricket
class BallEntity extends Equatable {
  final String id;
  final int ballNumber;
  final int overNumber;
  final String bowlerId;
  final String strikerId;
  final String nonStrikerId;
  final int runsScored;
  final BallType ballType;
  final bool isWicket;
  final WicketType? wicketType;
  final String? wicketTakerId;
  final String? fielderId;
  final bool isExtra;
  final ExtraType? extraType;
  final String? commentary;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  const BallEntity({
    required this.id,
    required this.ballNumber,
    required this.overNumber,
    required this.bowlerId,
    required this.strikerId,
    required this.nonStrikerId,
    this.runsScored = 0,
    this.ballType = BallType.normal,
    this.isWicket = false,
    this.wicketType,
    this.wicketTakerId,
    this.fielderId,
    this.isExtra = false,
    this.extraType,
    this.commentary,
    required this.timestamp,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        ballNumber,
        overNumber,
        bowlerId,
        strikerId,
        runsScored,
        ballType,
        isWicket,
        timestamp,
      ];

  /// Check if ball is a dot ball
  bool get isDotBall => runsScored == 0 && !isExtra && !isWicket;

  /// Check if ball is a boundary
  bool get isBoundary => runsScored == 4 || runsScored == 6;

  /// Check if ball is a four
  bool get isFour => runsScored == 4;

  /// Check if ball is a six
  bool get isSix => runsScored == 6;

  /// Get ball description
  String get description {
    if (isWicket) return 'W';
    if (isSix) return '6';
    if (isFour) return '4';
    if (isExtra) return extraType?.name.toUpperCase() ?? 'E';
    return runsScored.toString();
  }
}

/// Over Entity - Represents a complete over in cricket
class OverEntity extends Equatable {
  final String id;
  final int overNumber;
  final String bowlerId;
  final List<BallEntity> balls;
  final int runs;
  final int wickets;
  final int extras;
  final bool isMaiden;
  final DateTime startTime;
  final DateTime endTime;
  final String? commentary;

  const OverEntity({
    required this.id,
    required this.overNumber,
    required this.bowlerId,
    required this.balls,
    this.runs = 0,
    this.wickets = 0,
    this.extras = 0,
    this.isMaiden = false,
    required this.startTime,
    required this.endTime,
    this.commentary,
  });

  @override
  List<Object?> get props => [
        id,
        overNumber,
        bowlerId,
        balls,
        runs,
        wickets,
        startTime,
      ];

  /// Get over summary
  String get summary {
    return balls.map((ball) => ball.description).join(' ');
  }

  /// Get over duration
  Duration get duration => endTime.difference(startTime);

  /// Calculate economy rate for this over
  double get economyRate => runs.toDouble();

  /// Check if over has wickets
  bool get hasWickets => wickets > 0;

  /// Check if over has boundaries
  bool get hasBoundaries => balls.any((ball) => ball.isBoundary);
}

/// Inning Entity - Represents a complete inning
class InningEntity extends Equatable {
  final String id;
  final String matchId;
  final int inningNumber;
  final String battingTeamId;
  final String bowlingTeamId;
  final int runs;
  final int wickets;
  final double overs;
  final int extras;
  final List<OverEntity> completedOvers;
  final List<BatsmanInningEntity> batsmenStats;
  final List<BowlerInningEntity> bowlersStats;
  final List<WicketEntity> wickets_fallen;
  final bool isComplete;
  final DateTime? startTime;
  final DateTime? endTime;
  final InningStatus status;

  const InningEntity({
    required this.id,
    required this.matchId,
    required this.inningNumber,
    required this.battingTeamId,
    required this.bowlingTeamId,
    this.runs = 0,
    this.wickets = 0,
    this.overs = 0.0,
    this.extras = 0,
    this.completedOvers = const [],
    this.batsmenStats = const [],
    this.bowlersStats = const [],
    this.wickets_fallen = const [],
    this.isComplete = false,
    this.startTime,
    this.endTime,
    this.status = InningStatus.notStarted,
  });

  @override
  List<Object?> get props => [
        id,
        matchId,
        inningNumber,
        battingTeamId,
        runs,
        wickets,
        overs,
        isComplete,
      ];

  /// Get run rate
  double get runRate {
    if (overs == 0) return 0.0;
    return runs / overs;
  }

  /// Get inning duration
  Duration? get duration {
    if (startTime == null || endTime == null) return null;
    return endTime!.difference(startTime!);
  }
}

/// Enumerations for cricket scoring

enum BallType {
  normal,
  wide,
  noBall,
  bye,
  legBye,
}

enum ExtraType {
  wide,
  noBall,
  bye,
  legBye,
  penalty,
}

enum WicketType {
  bowled,
  caught,
  lbw,
  runOut,
  stumped,
  hitWicket,
  handledBall,
  obstructingField,
  timedOut,
  retired,
}

enum InningStatus {
  notStarted,
  inProgress,
  completed,
  interrupted,
}

/// Supporting entities for detailed statistics

class BatsmanInningEntity extends Equatable {
  final String playerId;
  final int runs;
  final int ballsFaced;
  final int fours;
  final int sixes;
  final bool isOut;
  final WicketType? dismissalType;
  final String? dismissedBy;
  final double strikeRate;

  const BatsmanInningEntity({
    required this.playerId,
    this.runs = 0,
    this.ballsFaced = 0,
    this.fours = 0,
    this.sixes = 0,
    this.isOut = false,
    this.dismissalType,
    this.dismissedBy,
    this.strikeRate = 0.0,
  });

  @override
  List<Object?> get props => [playerId, runs, ballsFaced, isOut];
}

class BowlerInningEntity extends Equatable {
  final String playerId;
  final double overs;
  final int runs;
  final int wickets;
  final int maidens;
  final double economyRate;

  const BowlerInningEntity({
    required this.playerId,
    this.overs = 0.0,
    this.runs = 0,
    this.wickets = 0,
    this.maidens = 0,
    this.economyRate = 0.0,
  });

  @override
  List<Object?> get props => [playerId, overs, runs, wickets];
}

class WicketEntity extends Equatable {
  final String id;
  final String batsmanId;
  final WicketType wicketType;
  final String? bowlerId;
  final String? fielderId;
  final int runs;
  final double overs;
  final DateTime timestamp;

  const WicketEntity({
    required this.id,
    required this.batsmanId,
    required this.wicketType,
    this.bowlerId,
    this.fielderId,
    required this.runs,
    required this.overs,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, batsmanId, wicketType, runs, overs];
}