import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_hello_world/core/error/failure.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/match_entity.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/team_entity.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/player_entity.dart';
import 'package:flutter_hello_world/features/cricket/domain/entities/match_enums.dart';
import 'package:flutter_hello_world/features/cricket/domain/repositories/cricket_repository.dart';
import 'package:flutter_hello_world/features/cricket/domain/usecases/match_usecases.dart';
import '../../helpers/test_helpers.dart';

import 'get_matches_usecase_test.mocks.dart';

@GenerateMocks([CricketRepository])
void main() {
  late GetMatchesUseCase usecase;
  late MockCricketRepository mockRepository;

  setUp(() {
    mockRepository = MockCricketRepository();
    usecase = GetMatchesUseCase(repository: mockRepository);
  });

  group('GetMatchesUseCase', () {
    final tMatchList = [
      CricketTestHelpers.testScheduledMatch,
      CricketTestHelpers.testInProgressMatch,
    ];

    test('should get matches from repository successfully', () async {
      // arrange
      const tParams = GetMatchesParams();
      when(mockRepository.getMatches(
        status: null,
        userId: null,
        limit: 20,
        offset: 0,
      )).thenAnswer((_) async => Right(tMatchList));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, Right(tMatchList));
      verify(mockRepository.getMatches(
        status: null,
        userId: null,
        limit: 20,
        offset: 0,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get matches with specific status filter', () async {
      // arrange
      const tParams = GetMatchesParams(status: MatchStatus.scheduled);
      final filteredMatches = [tMatchList.first];
      
      when(mockRepository.getMatches(
        status: MatchStatus.scheduled,
        userId: null,
        limit: 20,
        offset: 0,
      )).thenAnswer((_) async => Right(filteredMatches));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, Right(filteredMatches));
      verify(mockRepository.getMatches(
        status: MatchStatus.scheduled,
        userId: null,
        limit: 20,
        offset: 0,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get matches with user filter', () async {
      // arrange
      const tParams = GetMatchesParams(userId: 'user1');
      final userMatches = [tMatchList.first];
      
      when(mockRepository.getMatches(
        status: null,
        userId: 'user1',
        limit: 20,
        offset: 0,
      )).thenAnswer((_) async => Right(userMatches));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, Right(userMatches));
      verify(mockRepository.getMatches(
        status: null,
        userId: 'user1',
        limit: 20,
        offset: 0,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get matches with custom limit and offset', () async {
      // arrange
      const tParams = GetMatchesParams(limit: 10, offset: 5);
      
      when(mockRepository.getMatches(
        status: null,
        userId: null,
        limit: 10,
        offset: 5,
      )).thenAnswer((_) async => Right(tMatchList));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, Right(tMatchList));
      verify(mockRepository.getMatches(
        status: null,
        userId: null,
        limit: 10,
        offset: 5,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no matches found', () async {
      // arrange
      const tParams = GetMatchesParams();
      when(mockRepository.getMatches(
        status: null,
        userId: null,
        limit: 20,
        offset: 0,
      )).thenAnswer((_) async => Right([]));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, Right([]));
      verify(mockRepository.getMatches(
        status: null,
        userId: null,
        limit: 20,
        offset: 0,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository throws exception', () async {
      // arrange
      const tParams = GetMatchesParams();
      when(mockRepository.getMatches(
        status: null,
        userId: null,
        limit: 20,
        offset: 0,
      )).thenAnswer((_) async => Left(ServerFailure('Server error')));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, Left(ServerFailure('Server error')));
      verify(mockRepository.getMatches(
        status: null,
        userId: null,
        limit: 20,
        offset: 0,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when cache error occurs', () async {
      // arrange
      const tParams = GetMatchesParams();
      when(mockRepository.getMatches(
        status: null,
        userId: null,
        limit: 20,
        offset: 0,
      )).thenAnswer((_) async => Left(CacheFailure('Cache error')));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, Left(CacheFailure('Cache error')));
      verify(mockRepository.getMatches(
        status: null,
        userId: null,
        limit: 20,
        offset: 0,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}