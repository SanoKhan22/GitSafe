import 'package:equatable/equatable.dart';
import '../../domain/entities/score_entity.dart';

/// Data model for Score extending ScoreEntity
class ScoreModel {
  final String id;
  final String matchId;
  final String teamId;
  final String playerId;
  final int runs;
  final int ballsFaced;
  final int fours;
  final int sixes;
  final double strikeRate;
  final bool isOut;
  final WicketType? dismissalType;
  final String? dismissedBy;
  final String? fielder;
  final int? overNumber;
  final int? ballNumber;
  final DateTime? timestamp;
  final Map<String, dynamic>? extras;
  final String? commentary;
  final bool? isActive;

  const ScoreModel({
    required this.id,
    required this.matchId,
    required this.teamId,
    required this.playerId,
    required this.runs,
    required this.ballsFaced,
    required this.fours,
    required this.sixes,
    required this.strikeRate,
    required this.isOut,
    this.dismissalType,
    this.dismissedBy,
    this.fielder,
    this.overNumber,
    this.ballNumber,
    this.timestamp,
    this.extras,
    this.commentary,
    this.isActive,
  });

  /// Create ScoreModel from JSON
  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      id: json['id'] as String,
      matchId: json['matchId'] as String,
      teamId: json['teamId'] as String,
      playerId: json['playerId'] as String,
      runs: json['runs'] as int,
      ballsFaced: json['ballsFaced'] as int,
      fours: json['fours'] as int,
      sixes: json['sixes'] as int,
      strikeRate: (json['strikeRate'] as num).toDouble(),
      isOut: json['isOut'] as bool,
      dismissalType: json['dismissalType'] != null
          ? WicketType.values.firstWhere(
              (e) => e.toString().split('.').last == json['dismissalType'],
              orElse: () => WicketType.bowled,
            )
          : null,
      dismissedBy: json['dismissedBy'] as String?,
      fielder: json['fielder'] as String?,
      overNumber: json['overNumber'] as int?,
      ballNumber: json['ballNumber'] as int?,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String) 
          : null,
      extras: json['extras'] as Map<String, int>? ?? {},
      commentary: json['commentary'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Convert ScoreModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matchId': matchId,
      'teamId': teamId,
      'playerId': playerId,
      'runs': runs,
      'ballsFaced': ballsFaced,
      'fours': fours,
      'sixes': sixes,
      'strikeRate': strikeRate,
      'isOut': isOut,
      'dismissalType': dismissalType?.toString().split('.').last,
      'dismissedBy': dismissedBy,
      'fielder': fielder,
      'overNumber': overNumber,
      'ballNumber': ballNumber,
      'timestamp': timestamp?.toIso8601String(),
      'extras': extras,
      'commentary': commentary,
      'isActive': isActive,
    };
  }

  /// Create a copy with updated fields
  @override
  ScoreModel copyWith({
    String? id,
    String? matchId,
    String? teamId,
    String? playerId,
    int? runs,
    int? ballsFaced,
    int? fours,
    int? sixes,
    double? strikeRate,
    bool? isOut,
    WicketType? dismissalType,
    String? dismissedBy,
    String? fielder,
    int? overNumber,
    int? ballNumber,
    DateTime? timestamp,
    Map<String, int>? extras,
    String? commentary,
    bool? isActive,
  }) {
    return ScoreModel(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      teamId: teamId ?? this.teamId,
      playerId: playerId ?? this.playerId,
      runs: runs ?? this.runs,
      ballsFaced: ballsFaced ?? this.ballsFaced,
      fours: fours ?? this.fours,
      sixes: sixes ?? this.sixes,
      strikeRate: strikeRate ?? this.strikeRate,
      isOut: isOut ?? this.isOut,
      dismissalType: dismissalType ?? this.dismissalType,
      dismissedBy: dismissedBy ?? this.dismissedBy,
      fielder: fielder ?? this.fielder,
      overNumber: overNumber ?? this.overNumber,
      ballNumber: ballNumber ?? this.ballNumber,
      timestamp: timestamp ?? this.timestamp,
      extras: extras ?? this.extras,
      commentary: commentary ?? this.commentary,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Data model for Ball
class BallModel {
  final String id;
  final String matchId;
  final String inningId;
  final int overNumber;
  final int ballNumber;
  final String bowlerId;
  final String batsmanId;
  final int runs;
  final BallType ballType;
  final bool? isWicket;
  final WicketType? dismissalType;
  final String? fielder;
  final Map<String, dynamic>? extras;
  final String? commentary;
  final DateTime? timestamp;
  final String? videoUrl;
  final bool? isReviewed;
  final String? umpireDecision;

  const BallModel({
    required this.id,
    required this.matchId,
    required this.inningId,
    required this.overNumber,
    required this.ballNumber,
    required this.bowlerId,
    required this.batsmanId,
    required this.runs,
    required this.ballType,
    this.isWicket,
    this.dismissalType,
    this.fielder,
    this.extras,
    this.commentary,
    this.timestamp,
    this.videoUrl,
    this.isReviewed,
    this.umpireDecision,
  });

  factory BallModel.fromJson(Map<String, dynamic> json) {
    return BallModel(
      id: json['id'] as String,
      matchId: json['matchId'] as String,
      inningId: json['inningId'] as String,
      overNumber: json['overNumber'] as int,
      ballNumber: json['ballNumber'] as int,
      bowlerId: json['bowlerId'] as String,
      batsmanId: json['batsmanId'] as String,
      runs: json['runs'] as int,
      ballType: BallType.values.firstWhere(
        (e) => e.toString().split('.').last == json['ballType'],
        orElse: () => BallType.normal,
      ),
      isWicket: json['isWicket'] as bool? ?? false,
      dismissalType: json['dismissalType'] != null
          ? WicketType.values.firstWhere(
              (e) => e.toString().split('.').last == json['dismissalType'],
              orElse: () => WicketType.bowled,
            )
          : null,
      fielder: json['fielder'] as String?,
      extras: json['extras'] as Map<String, int>? ?? {},
      commentary: json['commentary'] as String?,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String) 
          : null,
      videoUrl: json['videoUrl'] as String?,
      isReviewed: json['isReviewed'] as bool? ?? false,
      umpireDecision: json['umpireDecision'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matchId': matchId,
      'inningId': inningId,
      'overNumber': overNumber,
      'ballNumber': ballNumber,
      'bowlerId': bowlerId,
      'batsmanId': batsmanId,
      'runs': runs,
      'ballType': ballType.toString().split('.').last,
      'isWicket': isWicket,
      'dismissalType': dismissalType?.toString().split('.').last,
      'fielder': fielder,
      'extras': extras,
      'commentary': commentary,
      'timestamp': timestamp?.toIso8601String(),
      'videoUrl': videoUrl,
      'isReviewed': isReviewed,
      'umpireDecision': umpireDecision,
    };
  }
}

/// Data model for Over
class OverModel {
  final String id;
  final String matchId;
  final String inningId;
  final int overNumber;
  final String bowlerId;
  final List<BallModel> balls;
  final int runs;
  final int wickets;
  final Map<String, int> extras;
  final bool? maidenOver;
  final String? commentary;
  final DateTime? timestamp;

  const OverModel({
    required this.id,
    required this.matchId,
    required this.inningId,
    required this.overNumber,
    required this.bowlerId,
    required this.balls,
    required this.runs,
    required this.wickets,
    required this.extras,
    this.maidenOver,
    this.commentary,
    this.timestamp,
  });

  factory OverModel.fromJson(Map<String, dynamic> json) {
    return OverModel(
      id: json['id'] as String,
      matchId: json['matchId'] as String,
      inningId: json['inningId'] as String,
      overNumber: json['overNumber'] as int,
      bowlerId: json['bowlerId'] as String,
      balls: (json['balls'] as List<dynamic>)
          .map((b) => BallModel.fromJson(b as Map<String, dynamic>))
          .toList(),
      runs: json['runs'] as int,
      wickets: json['wickets'] as int,
      extras: json['extras'] as Map<String, int>? ?? {},
      maidenOver: json['maidenOver'] as bool? ?? false,
      commentary: json['commentary'] as String?,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matchId': matchId,
      'inningId': inningId,
      'overNumber': overNumber,
      'bowlerId': bowlerId,
      'balls': balls.map((b) => (b as BallModel).toJson()).toList(),
      'runs': runs,
      'wickets': wickets,
      'extras': extras,
      'maidenOver': maidenOver,
      'commentary': commentary,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}

/// Data model for Inning
class InningModel {
  final String id;
  final String matchId;
  final int inningNumber;
  final String battingTeamId;
  final String bowlingTeamId;
  final int runs;
  final int wickets;
  final double overs;
  final int ballsFaced;
  final double runRate;
  final double requiredRunRate;
  final int? target;
  final String? result;
  final Map<String, int>? extras;
  final List<Map<String, dynamic>>? partnerships;
  final List<Map<String, dynamic>>? fallOfWickets;
  final Map<String, dynamic>? bowlingFigures;
  final List<String>? battingOrder;
  final Map<String, int>? powerplayOvers;
  final List<String>? commentary;
  final DateTime? startTime;
  final DateTime? endTime;
  final bool isCompleted;

  const InningModel({
    required this.id,
    required this.matchId,
    required this.inningNumber,
    required this.battingTeamId,
    required this.bowlingTeamId,
    required this.runs,
    required this.wickets,
    required this.overs,
    required this.ballsFaced,
    required this.runRate,
    required this.requiredRunRate,
    this.target,
    this.result,
    this.extras,
    this.partnerships,
    this.fallOfWickets,
    this.bowlingFigures,
    this.battingOrder,
    this.powerplayOvers,
    this.commentary,
    this.startTime,
    this.endTime,
    this.isCompleted = false,
  });

  factory InningModel.fromJson(Map<String, dynamic> json) {
    return InningModel(
      id: json['id'] as String,
      matchId: json['matchId'] as String,
      inningNumber: json['inningNumber'] as int,
      battingTeamId: json['battingTeamId'] as String,
      bowlingTeamId: json['bowlingTeamId'] as String,
      runs: json['runs'] as int,
      wickets: json['wickets'] as int,
      overs: (json['overs'] as num).toDouble(),
      ballsFaced: json['ballsFaced'] as int,
      runRate: (json['runRate'] as num).toDouble(),
      requiredRunRate: (json['requiredRunRate'] as num).toDouble(),
      target: json['target'] as int?,
      result: json['result'] as String?,
      extras: json['extras'] as Map<String, int>? ?? {},
      partnerships: json['partnerships'] as List<Map<String, dynamic>>? ?? [],
      fallOfWickets: json['fallOfWickets'] as List<Map<String, dynamic>>? ?? [],
      bowlingFigures: json['bowlingFigures'] as Map<String, Map<String, dynamic>>? ?? {},
      battingOrder: (json['battingOrder'] as List<dynamic>?)?.cast<String>() ?? [],
      powerplayOvers: json['powerplayOvers'] as Map<String, int>? ?? {},
      commentary: (json['commentary'] as List<dynamic>?)?.cast<String>() ?? [],
      startTime: json['startTime'] != null 
          ? DateTime.parse(json['startTime'] as String) 
          : null,
      endTime: json['endTime'] != null 
          ? DateTime.parse(json['endTime'] as String) 
          : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matchId': matchId,
      'inningNumber': inningNumber,
      'battingTeamId': battingTeamId,
      'bowlingTeamId': bowlingTeamId,
      'runs': runs,
      'wickets': wickets,
      'overs': overs,
      'ballsFaced': ballsFaced,
      'runRate': runRate,
      'requiredRunRate': requiredRunRate,
      'target': target,
      'result': result,
      'extras': extras,
      'partnerships': partnerships,
      'fallOfWickets': fallOfWickets,
      'bowlingFigures': bowlingFigures,
      'battingOrder': battingOrder,
      'powerplayOvers': powerplayOvers,
      'commentary': commentary,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}