import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_hello_world/core/error/failure.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/match_entity.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/match_enums.dart';
import 'package:flutter_hello_world/features/cricket/domain/repositories/cricket_repository.dart';
import 'package:flutter_hello_world/features/cricket/domain/usecases/match_usecases.dart';
import '../../helpers/test_helpers.dart';

import 'create_match_usecase_test.mocks.dart';

@GenerateMocks([CricketRepository])
void main() {
  late CreateMatchUseCase usecase;
  late MockCricketRepository mockRepository;

  setUp(() {
    mockRepository = MockCricketRepository();
    usecase = CreateMatchUseCase(repository: mockRepository);
  });

  group('CreateMatchUseCase', () {
    final tTeam1 = CricketTestHelpers.testTeam1;
    final tTeam2 = CricketTestHelpers.testTeam2;

    final tCreateMatchParams = CreateMatchParams(
      title: 'Test Match',
      description: 'Test Description',
      type: MatchType.friendly,
      format: MatchFormat.t20,
      startTime: DateTime.now().add(Duration(hours: 1)),
      venue: 'Test Venue',
      createdBy: 'user1',
      team1: tTeam1,
      team2: tTeam2,
      totalOvers: 20,
      playersPerTeam: 11,
      rules: const MatchRules(maxOversPerBowler: 4),
    );

    final tMatchEntity = MatchEntity(
      id: 'match1',
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

    test('should create match successfully when data is valid', () async {
      // arrange
      when(mockRepository.createMatch(any))
          .thenAnswer((_) async => Right(tMatchEntity));

      // act
      final result = await usecase(tCreateMatchParams);

      // assert
      expect(result, Right(tMatchEntity));
      verify(mockRepository.createMatch(any));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when title is empty', () async {
      // arrange
      final invalidParams = CreateMatchParams(
        title: '',
        description: 'Test Description',
        type: MatchType.friendly,
        format: MatchFormat.t20,
        startTime: DateTime.now().add(Duration(hours: 1)),
        venue: 'Test Venue',
        createdBy: 'user1',
        team1: tTeam1,
        team2: tTeam2,
        totalOvers: 20,
        playersPerTeam: 11,
        rules: const MatchRules(maxOversPerBowler: 4),
      );

      // act
      final result = await usecase(invalidParams);

      // assert
      expect(result, isA<Left>());
      verifyZeroInteractions(mockRepository);
    });

    test('should return ValidationFailure when teams are the same', () async {
      // arrange
      final invalidParams = CreateMatchParams(
        title: 'Test Match',
        description: 'Test Description',
        type: MatchType.friendly,
        format: MatchFormat.t20,
        startTime: DateTime.now().add(Duration(hours: 1)),
        venue: 'Test Venue',
        createdBy: 'user1',
        team1: tTeam1,
        team2: tTeam1, // Same team
        totalOvers: 20,
        playersPerTeam: 11,
        rules: const MatchRules(maxOversPerBowler: 4),
      );

      // act
      final result = await usecase(invalidParams);

      // assert
      expect(result, isA<Left>());
      verifyZeroInteractions(mockRepository);
    });

    test('should return ValidationFailure when total overs is zero or negative', () async {
      // arrange
      final invalidParams = CreateMatchParams(
        title: 'Test Match',
        description: 'Test Description',
        type: MatchType.friendly,
        format: MatchFormat.t20,
        startTime: DateTime.now().add(Duration(hours: 1)),
        venue: 'Test Venue',
        createdBy: 'user1',
        team1: tTeam1,
        team2: tTeam2,
        totalOvers: 0,
        playersPerTeam: 11,
        rules: const MatchRules(maxOversPerBowler: 4),
      );

      // act
      final result = await usecase(invalidParams);

      // assert
      expect(result, isA<Left>());
      verifyZeroInteractions(mockRepository);
    });

    test('should return ValidationFailure when players per team is invalid', () async {
      // arrange
      final invalidParams = CreateMatchParams(
        title: 'Test Match',
        description: 'Test Description',
        type: MatchType.friendly,
        format: MatchFormat.t20,
        startTime: DateTime.now().add(Duration(hours: 1)),
        venue: 'Test Venue',
        createdBy: 'user1',
        team1: tTeam1,
        team2: tTeam2,
        totalOvers: 20,
        playersPerTeam: 0,
        rules: const MatchRules(maxOversPerBowler: 4),
      );

      // act
      final result = await usecase(invalidParams);

      // assert
      expect(result, isA<Left>());
      verifyZeroInteractions(mockRepository);
    });

    test('should return ValidationFailure when start time is in the past', () async {
      // arrange
      final invalidParams = CreateMatchParams(
        title: 'Test Match',
        description: 'Test Description',
        type: MatchType.friendly,
        format: MatchFormat.t20,
        startTime: DateTime.now().subtract(Duration(hours: 1)),
        venue: 'Test Venue',
        createdBy: 'user1',
        team1: tTeam1,
        team2: tTeam2,
        totalOvers: 20,
        playersPerTeam: 11,
        rules: const MatchRules(maxOversPerBowler: 4),
      );

      // act
      final result = await usecase(invalidParams);

      // assert
      expect(result, isA<Left>());
      verifyZeroInteractions(mockRepository);
    });

    test('should return ServerFailure when repository throws exception', () async {
      // arrange
      when(mockRepository.createMatch(any))
          .thenAnswer((_) async => Left(ServerFailure('Server error')));

      // act
      final result = await usecase(tCreateMatchParams);

      // assert
      expect(result, Left(ServerFailure('Server error')));
      verify(mockRepository.createMatch(any));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}