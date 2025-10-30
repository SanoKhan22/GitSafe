import 'package:equatable/equatable.dart';

/// Cricket Player Entity
/// 
/// Represents a cricket player with their profile, statistics, and current match state
class PlayerEntity extends Equatable {
  final String id;
  final String name;
  final String? nickname;
  final DateTime? dateOfBirth;
  final String? profileImageUrl;
  final String? email;
  final String? phoneNumber;
  
  // Cricket Profile
  final PlayerRole preferredRole;
  final BattingStyle battingStyle;
  final BowlingStyle bowlingStyle;
  final BowlingType? bowlingType;
  final bool isWicketKeeper;
  final bool isCaptain;
  final bool isViceCaptain;
  
  // Career Statistics
  final PlayerStats careerStats;
  final PlayerStats seasonStats;
  
  // Current Match State
  final PlayerMatchState? currentMatchState;
  
  // Personal Information
  final String? address;
  final String? emergencyContact;
  final List<String> achievements;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const PlayerEntity({
    required this.id,
    required this.name,
    this.nickname,
    this.dateOfBirth,
    this.profileImageUrl,
    this.email,
    this.phoneNumber,
    required this.preferredRole,
    required this.battingStyle,
    required this.bowlingStyle,
    this.bowlingType,
    this.isWicketKeeper = false,
    this.isCaptain = false,
    this.isViceCaptain = false,
    required this.careerStats,
    required this.seasonStats,
    this.currentMatchState,
    this.address,
    this.emergencyContact,
    this.achievements = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        preferredRole,
        battingStyle,
        bowlingStyle,
        isWicketKeeper,
        isCaptain,
        careerStats,
        isActive,
      ];

  /// Get player's age
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  /// Check if player is all-rounder
  bool get isAllRounder => 
      preferredRole == PlayerRole.allRounder ||
      (careerStats.battingAverage > 20 && careerStats.bowlingAverage < 35);

  /// Get player's primary skill
  String get primarySkill {
    switch (preferredRole) {
      case PlayerRole.batsman:
        return 'Batting';
      case PlayerRole.bowler:
        return 'Bowling';
      case PlayerRole.allRounder:
        return 'All-rounder';
      case PlayerRole.wicketKeeper:
        return 'Wicket Keeping';
      case PlayerRole.specialist:
        return 'Specialist';
    }
  }

  /// Get bowling type description
  String? get bowlingTypeDescription {
    if (bowlingType == null) return null;
    switch (bowlingType!) {
      case BowlingType.fast:
        return 'Fast';
      case BowlingType.medium:
        return 'Medium';
      case BowlingType.spin:
        return 'Spin';
      case BowlingType.offSpin:
        return 'Off Spin';
      case BowlingType.legSpin:
        return 'Leg Spin';
    }
  }

  /// Check if player is currently batting
  bool get isCurrentlyBatting => 
      currentMatchState?.isBatting == true;

  /// Check if player is currently bowling
  bool get isCurrentlyBowling => 
      currentMatchState?.isBowling == true;

  /// Copy with method for immutable updates
  PlayerEntity copyWith({
    String? id,
    String? name,
    String? nickname,
    DateTime? dateOfBirth,
    String? profileImageUrl,
    String? email,
    String? phoneNumber,
    PlayerRole? preferredRole,
    BattingStyle? battingStyle,
    BowlingStyle? bowlingStyle,
    BowlingType? bowlingType,
    bool? isWicketKeeper,
    bool? isCaptain,
    bool? isViceCaptain,
    PlayerStats? careerStats,
    PlayerStats? seasonStats,
    PlayerMatchState? currentMatchState,
    String? address,
    String? emergencyContact,
    List<String>? achievements,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return PlayerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      preferredRole: preferredRole ?? this.preferredRole,
      battingStyle: battingStyle ?? this.battingStyle,
      bowlingStyle: bowlingStyle ?? this.bowlingStyle,
      bowlingType: bowlingType ?? this.bowlingType,
      isWicketKeeper: isWicketKeeper ?? this.isWicketKeeper,
      isCaptain: isCaptain ?? this.isCaptain,
      isViceCaptain: isViceCaptain ?? this.isViceCaptain,
      careerStats: careerStats ?? this.careerStats,
      seasonStats: seasonStats ?? this.seasonStats,
      currentMatchState: currentMatchState ?? this.currentMatchState,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      achievements: achievements ?? this.achievements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Player Role Enumeration
enum PlayerRole {
  batsman,
  bowler,
  allRounder,
  wicketKeeper,
  specialist,
}

/// Batting Style Enumeration
enum BattingStyle {
  rightHanded,
  leftHanded,
}

/// Bowling Style Enumeration
enum BowlingStyle {
  rightArmFast,
  leftArmFast,
  rightArmMedium,
  leftArmMedium,
  rightArmSpin,
  leftArmSpin,
  none,
}

/// Bowling Type Enumeration
enum BowlingType {
  fast,
  medium,
  spin,
  offSpin,
  legSpin,
}

/// Player Statistics Entity
class PlayerStats extends Equatable {
  // Batting Statistics
  final int matchesPlayed;
  final int innings;
  final int notOuts;
  final int runsScored;
  final int highestScore;
  final double battingAverage;
  final double strikeRate;
  final int centuries;
  final int halfCenturies;
  final int fours;
  final int sixes;
  final int ballsFaced;
  
  // Bowling Statistics
  final int oversBowled;
  final int ballsBowled;
  final int wicketsTaken;
  final int runsConceded;
  final double bowlingAverage;
  final double economyRate;
  final double strikeRateBowling;
  final int bestBowlingFigures;
  final int fiveWickets;
  final int tenWickets;
  final int maidenOvers;
  
  // Fielding Statistics
  final int catches;
  final int stumpings;
  final int runOuts;
  final int directHits;
  
  // Match Statistics
  final int wins;
  final int losses;
  final int draws;
  final int manOfTheMatchAwards;
  
  const PlayerStats({
    this.matchesPlayed = 0,
    this.innings = 0,
    this.notOuts = 0,
    this.runsScored = 0,
    this.highestScore = 0,
    this.battingAverage = 0.0,
    this.strikeRate = 0.0,
    this.centuries = 0,
    this.halfCenturies = 0,
    this.fours = 0,
    this.sixes = 0,
    this.ballsFaced = 0,
    this.oversBowled = 0,
    this.ballsBowled = 0,
    this.wicketsTaken = 0,
    this.runsConceded = 0,
    this.bowlingAverage = 0.0,
    this.economyRate = 0.0,
    this.strikeRateBowling = 0.0,
    this.bestBowlingFigures = 0,
    this.fiveWickets = 0,
    this.tenWickets = 0,
    this.maidenOvers = 0,
    this.catches = 0,
    this.stumpings = 0,
    this.runOuts = 0,
    this.directHits = 0,
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
    this.manOfTheMatchAwards = 0,
  });

  @override
  List<Object?> get props => [
        matchesPlayed,
        runsScored,
        wicketsTaken,
        battingAverage,
        bowlingAverage,
        strikeRate,
        economyRate,
      ];

  /// Calculate batting average
  double get calculatedBattingAverage {
    if (innings == 0 || innings == notOuts) return 0.0;
    return runsScored / (innings - notOuts);
  }

  /// Calculate strike rate
  double get calculatedStrikeRate {
    if (ballsFaced == 0) return 0.0;
    return (runsScored / ballsFaced) * 100;
  }

  /// Calculate bowling average
  double get calculatedBowlingAverage {
    if (wicketsTaken == 0) return 0.0;
    return runsConceded / wicketsTaken;
  }

  /// Calculate economy rate
  double get calculatedEconomyRate {
    if (oversBowled == 0) return 0.0;
    return runsConceded / oversBowled;
  }

  /// Calculate bowling strike rate
  double get calculatedBowlingStrikeRate {
    if (wicketsTaken == 0) return 0.0;
    return ballsBowled / wicketsTaken;
  }

  /// Get total dismissals (for wicket keepers)
  int get totalDismissals => catches + stumpings;

  /// Copy with method for immutable updates
  PlayerStats copyWith({
    int? matchesPlayed,
    int? innings,
    int? notOuts,
    int? runsScored,
    int? highestScore,
    double? battingAverage,
    double? strikeRate,
    int? centuries,
    int? halfCenturies,
    int? fours,
    int? sixes,
    int? ballsFaced,
    int? oversBowled,
    int? ballsBowled,
    int? wicketsTaken,
    int? runsConceded,
    double? bowlingAverage,
    double? economyRate,
    double? strikeRateBowling,
    int? bestBowlingFigures,
    int? fiveWickets,
    int? tenWickets,
    int? maidenOvers,
    int? catches,
    int? stumpings,
    int? runOuts,
    int? directHits,
    int? wins,
    int? losses,
    int? draws,
    int? manOfTheMatchAwards,
  }) {
    return PlayerStats(
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      innings: innings ?? this.innings,
      notOuts: notOuts ?? this.notOuts,
      runsScored: runsScored ?? this.runsScored,
      highestScore: highestScore ?? this.highestScore,
      battingAverage: battingAverage ?? this.battingAverage,
      strikeRate: strikeRate ?? this.strikeRate,
      centuries: centuries ?? this.centuries,
      halfCenturies: halfCenturies ?? this.halfCenturies,
      fours: fours ?? this.fours,
      sixes: sixes ?? this.sixes,
      ballsFaced: ballsFaced ?? this.ballsFaced,
      oversBowled: oversBowled ?? this.oversBowled,
      ballsBowled: ballsBowled ?? this.ballsBowled,
      wicketsTaken: wicketsTaken ?? this.wicketsTaken,
      runsConceded: runsConceded ?? this.runsConceded,
      bowlingAverage: bowlingAverage ?? this.bowlingAverage,
      economyRate: economyRate ?? this.economyRate,
      strikeRateBowling: strikeRateBowling ?? this.strikeRateBowling,
      bestBowlingFigures: bestBowlingFigures ?? this.bestBowlingFigures,
      fiveWickets: fiveWickets ?? this.fiveWickets,
      tenWickets: tenWickets ?? this.tenWickets,
      maidenOvers: maidenOvers ?? this.maidenOvers,
      catches: catches ?? this.catches,
      stumpings: stumpings ?? this.stumpings,
      runOuts: runOuts ?? this.runOuts,
      directHits: directHits ?? this.directHits,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      draws: draws ?? this.draws,
      manOfTheMatchAwards: manOfTheMatchAwards ?? this.manOfTheMatchAwards,
    );
  }
}

/// Player Match State Entity
class PlayerMatchState extends Equatable {
  final String matchId;
  final String playerId;
  final bool isBatting;
  final bool isBowling;
  final bool isOnField;
  final int? battingPosition;
  final int runsScored;
  final int ballsFaced;
  final int fours;
  final int sixes;
  final bool isOut;
  final String? dismissalType;
  final String? dismissedBy;
  final int oversBowled;
  final int runsConceded;
  final int wicketsTaken;
  final int catches;
  final int runOuts;
  final DateTime lastUpdated;

  const PlayerMatchState({
    required this.matchId,
    required this.playerId,
    this.isBatting = false,
    this.isBowling = false,
    this.isOnField = true,
    this.battingPosition,
    this.runsScored = 0,
    this.ballsFaced = 0,
    this.fours = 0,
    this.sixes = 0,
    this.isOut = false,
    this.dismissalType,
    this.dismissedBy,
    this.oversBowled = 0,
    this.runsConceded = 0,
    this.wicketsTaken = 0,
    this.catches = 0,
    this.runOuts = 0,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        matchId,
        playerId,
        isBatting,
        isBowling,
        runsScored,
        ballsFaced,
        wicketsTaken,
        lastUpdated,
      ];

  /// Calculate current strike rate
  double get currentStrikeRate {
    if (ballsFaced == 0) return 0.0;
    return (runsScored / ballsFaced) * 100;
  }

  /// Calculate current economy rate
  double get currentEconomyRate {
    if (oversBowled == 0) return 0.0;
    return runsConceded / oversBowled;
  }

  /// Copy with method for immutable updates
  PlayerMatchState copyWith({
    String? matchId,
    String? playerId,
    bool? isBatting,
    bool? isBowling,
    bool? isOnField,
    int? battingPosition,
    int? runsScored,
    int? ballsFaced,
    int? fours,
    int? sixes,
    bool? isOut,
    String? dismissalType,
    String? dismissedBy,
    int? oversBowled,
    int? runsConceded,
    int? wicketsTaken,
    int? catches,
    int? runOuts,
    DateTime? lastUpdated,
  }) {
    return PlayerMatchState(
      matchId: matchId ?? this.matchId,
      playerId: playerId ?? this.playerId,
      isBatting: isBatting ?? this.isBatting,
      isBowling: isBowling ?? this.isBowling,
      isOnField: isOnField ?? this.isOnField,
      battingPosition: battingPosition ?? this.battingPosition,
      runsScored: runsScored ?? this.runsScored,
      ballsFaced: ballsFaced ?? this.ballsFaced,
      fours: fours ?? this.fours,
      sixes: sixes ?? this.sixes,
      isOut: isOut ?? this.isOut,
      dismissalType: dismissalType ?? this.dismissalType,
      dismissedBy: dismissedBy ?? this.dismissedBy,
      oversBowled: oversBowled ?? this.oversBowled,
      runsConceded: runsConceded ?? this.runsConceded,
      wicketsTaken: wicketsTaken ?? this.wicketsTaken,
      catches: catches ?? this.catches,
      runOuts: runOuts ?? this.runOuts,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}