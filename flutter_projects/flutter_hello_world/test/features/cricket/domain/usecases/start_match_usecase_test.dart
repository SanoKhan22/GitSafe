import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_hello_world/core/error/failure.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/match_entity.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/match_enums.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/team_entity.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/player_entity.dart';
import 'package:flutter_hello_world/features/cricket/domain/repositories/cricket_repository.dart';
import 'package:flutter_hello_world/features/cricket/domain/usecases/match_usecases.dart';

import 'start_match_usecase_test.mocks.dart';

@GenerateMocks([CricketRepository])
void main() {
  late StartMatchUseCase usecase;
  late MockCricketRepository mockRepository;

  setUp(() {
    mockRepository = MockCricketRepository();
    usecase = StartMatchUseCase(repository: mockRepository);
  });

  group('StartMatchUseCase', () {
    const tMatchId = 'match1';
    const tParams = StartMatchParams(matchId: tMatchId);

    final tTeam1 = TeamEntity(
      id: 'team1',
      name: 'Team A',
      type: TeamType.friends,
      createdBy: 'test_user',
      players: List.generate(11, (i) => PlayerEntity(
        id: 'player$i', 
        name: 'Player $i',
        preferredRole: PlayerRole.batsman,
        battingStyle: BattingStyle.rightHanded,
        bowlingStyle: BowlingStyle.rightArmMedium,
        careerStats: const PlayerStats(),
        seasonStats: const PlayerStats(),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      )),
      playerIds: List.generate(11, (i) => 'player$i'),
      stats: const TeamStats(),
      settings: const TeamSettings(),
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    final tTeam2 = TeamEntity(
      id: 'team2',
      name: 'Team B',
      type: TeamType.friends,
      createdBy: 'test_user',
      players: List.generate(11, (i) => PlayerEntity(
        id: 'player${i+11}', 
        name: 'Player ${i+11}',
        preferredRole: PlayerRole.batsman,
        battingStyle: BattingStyle.rightHanded,
        bowlingStyle: BowlingStyle.rightArmMedium,
        careerStats: const PlayerStats(),
        seasonStats: const PlayerStats(),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      )),
      playerIds: List.generate(11, (i) => 'player${i+11}'),
      stats: const TeamStats(),
      settings: const TeamSettings(),
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    final tScheduledMatch = MatchEntity(
      id: tMatchId,
      title: 'Test Match',
      description: 'Test Description',
      type: MatchType.friendly,
      format: MatchFormat.t20,
      status: MatchStatus.scheduled,
      createdAt: DateTime.now(),
      startTime: DateTime.now().add(Duration(hours: 1)),
      venue: 'Test Venue',
      createdBy: 'user1',
      team1: tTeam1,
      team2: tTeam2,
      totalOvers: 20,
      playersPerTeam: 11,
      rules: const MatchRules(maxOversPerBowler: 4),
    );

    final tStartedMatch = tScheduledMatch.copyWith(
      status: MatchStatus.inProgress,
    );

    test('should start match successfully when match is scheduled and valid', () async {
      // arrange
      when(mockRepository.getMatchById(tMatchId))
          .thenAnswer((_) async => Right(tScheduledMatch));
      when(mockRepository.startMatch(tMatchId))
          .thenAnswer((_) async => Right(tStartedMatch));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, Right(tStartedMatch));
      verify(mockRepository.getMatchById(tMatchId));
      verify(mockRepository.startMatch(tMatchId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when match ID is empty', () async {
      // arrange
      const invalidParams = StartMatchParams(matchId: '');

      // act
      final result = await usecase(invalidParams);

      // assert
      expect(result, Left(ValidationFailure('Match ID is required')));
      verifyZeroInteractions(mockRepository);
    });

    test('should return ValidationFailure when match ID is only whitespace', () async {
      // arrange
      const invalidParams = StartMatchParams(matchId: '   ');

      // act
      final result = await usecase(invalidParams);

      // assert
      expect(result, Left(ValidationFailure('Match ID is required')));
      verifyZeroInteractions(mockRepository);
    });

    test('should return ValidationFailure when match is not in scheduled status', () async {
      // arrange
      final inProgressMatch = tScheduledMatch.copyWith(status: MatchStatus.inProgress);
      when(mockRepository.getMatchById(tMatchId))
          .thenAnswer((_) async => Right(inProgressMatch));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, Left(ValidationFailure('Match is not in scheduled status')));
      verify(mockRepository.getMatchById(tMatchId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when match cannot be started', () async {
      // arrange
      final invalidMatch = tScheduledMatch.copyWith(
        team1: TeamEntity(
          id: 'team1',
          name: 'Team A',
          type: TeamType.friends,
          createdBy: 'test_user',
          players: [PlayerEntity(
            id: 'player1', 
            name: 'Player 1',
            preferredRole: PlayerRole.batsman,
            battingStyle: BattingStyle.rightHanded,
            bowlingStyle: BowlingStyle.rightArmMedium,
            careerStats: const PlayerStats(),
            seasonStats: const PlayerStats(),
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          )], // Not enough players
          playerIds: ['player1'],
          stats: const TeamStats(),
          settings: const TeamSettings(),
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        ),
      );
      when(mockRepository.getMatchById(tMatchId))
          .thenAnswer((_) async => Right(invalidMatch));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, Left(ValidationFailure('Match cannot be started - check team compositions')));
      verify(mockRepository.getMatchById(tMatchId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when match does not exist', () async {
      // arrange
      when(mockRepository.getMatchById(tMatchId))
          .thenAnswer((_) async => Left(NotFoundFailure('Match not found')));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, Left(NotFoundFailure('Match not found')));
      verify(mockRepository.getMatchById(tMatchId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository throws exception during get', () async {
      // arrange
      when(mockRepository.getMatchById(tMatchId))
          .thenAnswer((_) async => Left(ServerFailure('Server error')));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, Left(ServerFailure('Server error')));
      verify(mockRepository.getMatchById(tMatchId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository throws exception during start', () async {
      // arrange
      when(mockRepository.getMatchById(tMatchId))
          .thenAnswer((_) async => Right(tScheduledMatch));
      when(mockRepository.startMatch(tMatchId))
          .thenAnswer((_) async => Left(ServerFailure('Failed to start match')));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, Left(ServerFailure('Failed to start match')));
      verify(mockRepository.getMatchById(tMatchId));
      verify(mockRepository.startMatch(tMatchId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}