import 'package:dio/dio.dart';

import 'package:fletter_demo_app/core/network/network_exception.dart';
import 'package:fletter_demo_app/core/result/result.dart';
import 'package:fletter_demo_app/data/datasources/posts_local_datasource.dart';
import 'package:fletter_demo_app/data/datasources/posts_remote_datasource.dart';
import 'package:fletter_demo_app/data/mappers/post_mapper.dart';
import 'package:fletter_demo_app/domain/entities/post_entity.dart';
import 'package:fletter_demo_app/domain/repositories/posts_repository.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;
  final PostsLocalDataSource localDataSource;

  PostsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<List<PostEntity>>> getPosts() async {
    try {
      final remotePosts = await remoteDataSource.getPosts();
      final favoriteIds = await localDataSource.getFavoriteIds();

      final entities = remotePosts
          .map((dto) => dto.toEntity(isFavorite: favoriteIds.contains(dto.id)))
          .toList();

      await localDataSource.cachePosts(remotePosts);
      return Success(entities);
    } catch (e) {
      try {
        final cachedPosts = await localDataSource.getCachedPosts();
        if (cachedPosts.isNotEmpty) {
          final favoriteIds = await localDataSource.getFavoriteIds();
          final entities = cachedPosts
              .map(
                (dto) => dto.toEntity(isFavorite: favoriteIds.contains(dto.id)),
              )
              .toList();
          return Success(entities);
        }
        return Failure(_mapExceptionToFailure(e));
      } catch (_) {
        return Failure(_mapExceptionToFailure(e));
      }
    }
  }

  @override
  Future<Result<PostEntity>> getPostDetails(int id) async {
    try {
      final postDto = await remoteDataSource.getPost(id);
      final userDto = await remoteDataSource.getUser(postDto.userId);
      final favoriteIds = await localDataSource.getFavoriteIds();

      final entity = postDto.toEntity(
        authorName: userDto.name,
        isFavorite: favoriteIds.contains(postDto.id),
      );

      return Success(entity);
    } catch (e) {
      try {
        final cachedPosts = await localDataSource.getCachedPosts();
        final cachedPost = cachedPosts.firstWhere((dto) => dto.id == id);
        final favoriteIds = await localDataSource.getFavoriteIds();

        final entity = cachedPost.toEntity(
          authorName: null,
          isFavorite: favoriteIds.contains(cachedPost.id),
        );

        return Success(entity);
      } catch (_) {
        return Failure(_mapExceptionToFailure(e));
      }
    }
  }

  @override
  Future<Result<List<PostEntity>>> getFavoritePosts() async {
    try {
      final favoriteDtos = await localDataSource.getFavorites();

      final entities = favoriteDtos
          .map((dto) => dto.toEntity(isFavorite: true))
          .toList();

      return Success(entities);
    } catch (_) {
      return const Failure(CacheFailure());
    }
  }

  @override
  Future<Result<void>> toggleFavorite(PostEntity post) async {
    try {
      await localDataSource.toggleFavorite(post.toDto());
      return const Success(null);
    } catch (_) {
      return const Failure(CacheFailure());
    }
  }

  AppFailure _mapExceptionToFailure(Object e) {
    final exception = e is DioException ? e.error : e;

    if (exception is NoInternetException || exception is TimeoutException) {
      return const NetworkFailure();
    }
    return const ServerFailure();
  }
}
