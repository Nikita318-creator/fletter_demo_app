import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fletter_demo_app/core/network/network_exception.dart';
import 'package:fletter_demo_app/core/result/result.dart';
import 'package:fletter_demo_app/data/datasources/posts_local_datasource.dart';
import 'package:fletter_demo_app/data/datasources/posts_remote_datasource.dart';
import 'package:fletter_demo_app/data/mappers/post_mapper.dart';
import 'package:fletter_demo_app/data/models/post_dto.dart';
import 'package:fletter_demo_app/data/repositories/posts_repository_impl.dart';
import 'package:fletter_demo_app/domain/entities/post_entity.dart';

class MockPostsRemoteDataSource extends Mock implements PostsRemoteDataSource {}

class MockPostsLocalDataSource extends Mock implements PostsLocalDataSource {}

void main() {
  late PostsRepositoryImpl repository;
  late MockPostsRemoteDataSource mockRemoteDataSource;
  late MockPostsLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockPostsRemoteDataSource();
    mockLocalDataSource = MockPostsLocalDataSource();
    repository = PostsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tPostDto = PostDto(
    id: 1,
    userId: 1,
    title: 'Test Title',
    body: 'Test Body',
  );

  const tPostDtoList = [tPostDto];

  group('getPosts', () {
    test(
      'должен возвращать Success<List<PostEntity>> с корректным маппингом (включая isFavorite) при успешном запросе из сети',
      () async {
        // Arrange (Подготовка)
        when(
          () => mockRemoteDataSource.getPosts(),
        ).thenAnswer((_) async => tPostDtoList);
        when(
          () => mockLocalDataSource.getFavoriteIds(),
        ).thenAnswer((_) async => {1}); // ID=1 находится в избранном
        when(
          () => mockLocalDataSource.cachePosts(any()),
        ).thenAnswer((_) async {});

        // Act (Действие)
        final result = await repository.getPosts();

        // Assert (Проверка результатов)
        expect(result, isA<Success<List<PostEntity>>>());

        final entities = (result as Success<List<PostEntity>>).data;
        expect(entities.length, 1);
        expect(entities.first.id, tPostDto.id);
        expect(entities.first.title, tPostDto.title);
        expect(
          entities.first.isFavorite,
          isTrue,
        ); // Проверяем, что маппинг мапит isFavorite=true

        // Проверяем, что вызовы были совершены в нужном порядке
        verify(() => mockRemoteDataSource.getPosts()).called(1);
        verify(() => mockLocalDataSource.getFavoriteIds()).called(1);
        verify(() => mockLocalDataSource.cachePosts(tPostDtoList)).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'должен возвращать данные из кэша, если сеть выбросила NoInternetException, а кэш не пуст',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getPosts(),
        ).thenThrow(const NoInternetException());
        when(
          () => mockLocalDataSource.getCachedPosts(),
        ).thenAnswer((_) async => tPostDtoList);
        when(
          () => mockLocalDataSource.getFavoriteIds(),
        ).thenAnswer((_) async => <int>{}); // Нет избранных

        // Act
        final result = await repository.getPosts();

        // Assert
        expect(result, isA<Success<List<PostEntity>>>());

        final entities = (result as Success<List<PostEntity>>).data;
        expect(entities.length, 1);
        expect(entities.first.isFavorite, isFalse);

        verify(() => mockRemoteDataSource.getPosts()).called(1);
        verify(() => mockLocalDataSource.getCachedPosts()).called(1);
        verify(() => mockLocalDataSource.getFavoriteIds()).called(1);
        verifyNever(() => mockLocalDataSource.cachePosts(any()));
      },
    );

    test(
      'должен возвращать Failure(NetworkFailure), если сеть выбросила NoInternetException и кэш пуст',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getPosts(),
        ).thenThrow(const NoInternetException());
        when(
          () => mockLocalDataSource.getCachedPosts(),
        ).thenAnswer((_) async => []);

        // Act
        final result = await repository.getPosts();

        // Assert
        expect(result, isA<Failure<List<PostEntity>>>());

        final failure = (result as Failure<List<PostEntity>>).failure;
        expect(failure, isA<NetworkFailure>());

        verify(() => mockRemoteDataSource.getPosts()).called(1);
        verify(() => mockLocalDataSource.getCachedPosts()).called(1);
      },
    );
  });

  group('PostMapper Unit Test', () {
    test('PostDto.toEntity() должен верно переносить поля DTO в Entity', () {
      // Act
      final entity = tPostDto.toEntity(authorName: 'Nikita', isFavorite: true);

      // Assert
      expect(entity.id, tPostDto.id);
      expect(entity.userId, tPostDto.userId);
      expect(entity.title, tPostDto.title);
      expect(entity.body, tPostDto.body);
      expect(entity.authorName, 'Nikita');
      expect(entity.isFavorite, isTrue);
    });

    test(
      'PostEntity.toDto() должен верно конвертировать Entity обратно в DTO',
      () {
        // Arrange
        const entity = PostEntity(
          id: 10,
          userId: 2,
          title: 'Title',
          body: 'Body',
          authorName: 'Author',
          isFavorite: true,
        );

        // Act
        final dto = entity.toDto();

        // Assert
        expect(dto.id, entity.id);
        expect(dto.userId, entity.userId);
        expect(dto.title, entity.title);
        expect(dto.body, entity.body);
      },
    );
  });
}
