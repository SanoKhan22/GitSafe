import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_hello_world/core/error/exceptions.dart';
import 'package:flutter_hello_world/core/error/failure.dart';
import 'package:flutter_hello_world/core/network/network_info.dart';
import 'package:flutter_hello_world/features/cricket/data/datasources/cricket_local_datasource.dart';
import 'package:flutter_hello_world/features/cricket/data/datasources/cricket_mock_datasource.dart';
import 'package:flutter_hello_world/features/cricket/data/repositories/cricket_repository_impl.dart';
import 'package:flutter_hello_world/features/cricket/data/models/match_model.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/match_entity.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/match_enums.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/team_entity.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/player_entity.dart';

import 'cricket_repository_impl_test.mocks.dart';

@GenerateMocks([
  CricketLocalDataSource,
  CricketMockDataSource,
  NetworkInfo,
])
void main() {
  late CricketRepositoryImpl repository;
  late MockCricketLocalDataSource mockLocalDataSource;
  late MockCricketMockDataSource mockMockDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockCricketLocalDataSource();
    mockMockDataSource = MockCricketMockDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CricketRepositoryImpl(
      localDataSource: mockLocalDataSource,
      mockDataSource: mockMockDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getMatches', () {
    final tTeam1 = TeamEntity(
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
      )],
      playerIds: ['player1'],
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
      players: [PlayerEntity(
        id: 'player2', 
        name: 'Player 2',
        preferredRole: PlayerRole.batsman,
        battingStyle: BattingStyle.rightHanded,
        bowlingStyle: BowlingStyle.rightArmMedium,
        careerStats: const PlayerStats(),
        seasonStats: const PlayerStats(),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      )],
      playerIds: ['player2'],
      stats: const TeamStats(),
      settings: const TeamSettings(),
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    final tMatchModel = MatchModel(
      id: 'match1',
      title: 'Test Match',
      description: 'Test Description',
      matchType: MatchType.local,
      status: MatchStatus.scheduled,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      team1: tTeam1,
      team2: tTeam2,
      venue: 'Test Venue',
      startTime: DateTime.now().add(Duration(hours: 1)),
      endTime: null,
      overs: 20,
      playersPerTeam: 11,
      currentInning: 1,
      battingTeamId: null,
      bowlingTeamId: null,
      inning1Id: null,
      inning2Id: null,
      result: null,
    );

    final tMatchList = [tMatchModel];

    test('should return local matches when available', () async {
      // arrange
      when(mockLocalDataSource.getMatches())
          .thenAnswer((_) async => tMatchList);

      // act
      final result = await repository.getMatches();

      // assert
      expect(result, Right(tMatchList));
      verify(mockLocalDataSource.getMatches());
      verifyZeroInteractions(mockMockDataSource);
    });

    test('should return mock matches when no local matches available', () async {
      // arrange
      when(mockLocalDataSource.getMatches())
          .thenAnswer((_) async => []);
      when(mockMockDataSource.generateMockMatches(count: 5))
          .thenReturn(tMatchList);
      when(mockLocalDataSource.saveMatch(any))
          .thenAnswer((_) async => {});

      // act
      final result = await repository.getMatches();

      // assert
      expect(result, Right(tMatchList));
      verify(mockLocalDataSource.getMatches());
      verify(mockMockDataSource.generateMockMatches(count: 5));
      verify(mockLocalDataSource.saveMatch(any));
    });

    test('should return CacheFailure when local data source throws CacheException', () async {
      // arrange
      when(mockLocalDataSource.getMatches())
          .thenThrow(CacheException('Cache error'));

      // act
      final result = await repository.getMatches();

      // assert
      expect(result, Left(CacheFailure('Cache error')));
      verify(mockLocalDataSource.getMatches());
      verifyZeroInteractions(mockMockDataSource);
    });

    test('should return ServerFailure when unexpected exception occurs', () async {
      // arrange
      when(mockLocalDataSource.getMatches())
          .thenThrow(Exception('Unexpected error'));

      // act
      final result = await repository.getMatches();

      // assert
      expect(result, isA<Left<Failure, List<MatchEntity>>>());
      final failure = (result as Left).value;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, contains('Failed to get matches'));
      verify(mockLocalDataSource.getMatches());
    });
  });

  group('getMatch', () {
    const tMatchId = 'match1';
    final tMatchModel = MatchModel(
      id: tMatchId,
      title: 'Test Match',
      description: 'Test Description',
      matchType: MatchType.local,
      status: MatchStatus.scheduled,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
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
        )],
        playerIds: ['player1'],
        stats: const TeamStats(),
        settings: const TeamSettings(),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      ),
      team2: TeamEntity(
        id: 'team2',
        name: 'Team B',
        type: TeamType.friends,
        createdBy: 'test_user',
        players: [PlayerEntity(
          id: 'player2', 
          name: 'Player 2',
          preferredRole: PlayerRole.batsman,
          battingStyle: BattingStyle.rightHanded,
          bowlingStyle: BowlingStyle.rightArmMedium,
          careerStats: const PlayerStats(),
          seasonStats: const PlayerStats(),
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        )],
        playerIds: ['player2'],
        stats: const TeamStats(),
        settings: const TeamSettings(),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      ),
      venue: 'Test Venue',
      startTime: DateTime.now().add(Duration(hours: 1)),
      endTime: null,
      overs: 20,
      playersPerTeam: 11,
      currentInning: 1,
      battingTeamId: null,
      bowlingTeamId: null,
      inning1Id: null,
      inning2Id: null,
      result: null,
    );

    test('should return match when found in local storage', () async {
      // arrange
      when(mockLocalDataSource.getMatch(tMatchId))
          .thenAnswer((_) async => tMatchModel);

      // act
      final result = await repository.getMatch(tMatchId);

      // assert
      expect(result, Right(tMatchModel));
      verify(mockLocalDataSource.getMatch(tMatchId));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return NotFoundFailure when match not found', () async {
      // arrange
      when(mockLocalDataSource.getMatch(tMatchId))
          .thenAnswer((_) async => null);

      // act
      final result = await repository.getMatch(tMatchId);

      // assert
      expect(result, Left(NotFoundFailure('Match not found')));
      verify(mockLocalDataSource.getMatch(tMatchId));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return CacheFailure when local data source throws CacheException', () async {
      // arrange
      when(mockLocalDataSource.getMatch(tMatchId))
          .thenThrow(CacheException('Cache error'));

      // act
      final result = await repository.getMatch(tMatchId);

      // assert
      expect(result, Left(CacheFailure('Cache error')));
      verify(mockLocalDataSource.getMatch(tMatchId));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return ServerFailure when unexpected exception occurs', () async {
      // arrange
      when(mockLocalDataSource.getMatch(tMatchId))
          .thenThrow(Exception('Unexpected error'));

      // act
      final result = await repository.getMatch(tMatchId);

      // assert
      expect(result, isA<Left<Failure, MatchEntity>>());
      final failure = (result as Left).value;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, contains('Failed to get match'));
      verify(mockLocalDataSource.getMatch(tMatchId));
    });
  });

  group('createMatch', () {
    final tTeam1 = TeamEntity(
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
      )],
      playerIds: ['player1'],
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
      players: [PlayerEntity(
        id: 'player2', 
        name: 'Player 2',
        preferredRole: PlayerRole.batsman,
        battingStyle: BattingStyle.rightHanded,
        bowlingStyle: BowlingStyle.rightArmMedium,
        careerStats: const PlayerStats(),
        seasonStats: const PlayerStats(),
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      )],
      playerIds: ['player2'],
      stats: const TeamStats(),
      settings: const TeamSettings(),
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    final tCreateMatchParams = CreateMatchParams(
      title: 'Test Match',
      description: 'Test Description',
      matchType: MatchType.local,
      team1: tTeam1,
      team2: tTeam2,
      venue: 'Test Venue',
      startTime: DateTime.now().add(Duration(hours: 1)),
      overs: 20,
      playersPerTeam: 11,
    );

    test('should create match successfully with valid parameters', () async {
      // arrange
      when(mockLocalDataSource.saveMatch(any))
          .thenAnswer((_) async => {});

      // act
      final result = await repository.createMatch(tCreateMatchParams);

      // assert
      expect(result, isA<Right<Failure, MatchEntity>>());
      final match = (result as Right).value;
      expect(match.title, tCreateMatchParams.title);
      expect(match.status, MatchStatus.scheduled);
      verify(mockLocalDataSource.saveMatch(any));
    });

    test('should return ValidationFailure when title is empty', () async {
      // arrange
      final invalidParams = CreateMatchParams(
        title: '',
        description: 'Test Description',
        matchType: MatchType.local,
        team1: tTeam1,
        team2: tTeam2,
        venue: 'Test Venue',
        startTime: DateTime.now().add(Duration(hours: 1)),
        overs: 20,
        playersPerTeam: 11,
      );

      // act
      final result = await repository.createMatch(invalidParams);

      // assert
      expect(result, Left(ValidationFailure('Match title is required')));
      verifyZeroInteractions(mockLocalDataSource);
    });

    test('should return ValidationFailure when teams are the same', () async {
      // arrange
      final invalidParams = CreateMatchParams(
        title: 'Test Match',
        description: 'Test Description',
        matchType: MatchType.local,
        team1: tTeam1,
        team2: tTeam1, // Same team
        venue: 'Test Venue',
        startTime: DateTime.now().add(Duration(hours: 1)),
        overs: 20,
        playersPerTeam: 11,
      );

      // act
      final result = await repository.createMatch(invalidParams);

      // assert
      expect(result, Left(ValidationFailure('Teams must be different')));
      verifyZeroInteractions(mockLocalDataSource);
    });

    test('should return CacheFailure when local data source throws CacheException', () async {
      // arrange
      when(mockLocalDataSource.saveMatch(any))
          .thenThrow(CacheException('Cache error'));

      // act
      final result = await repository.createMatch(tCreateMatchParams);

      // assert
      expect(result, Left(CacheFailure('Cache error')));
      verify(mockLocalDataSource.saveMatch(any));
    });
  });
}